#!/bin/bash
set -eu
#set -x
##      Original: https://github.com/jorgedlcruz/cloudflare-grafana/blob/master/cloudflare-analytics.sh
##      Modified by: M Moncrieffe for Atom Supplies.

##      .SYNOPSIS
##      Grafana Dashboard for Cloudflare - Using RestAPI to InfluxDB Script
## 
##      .DESCRIPTION
##      This Script will query Cloudflare RestAPI and send the data directly to InfluxDB, which can be used to present it to Grafana. 
##      The Script and the Grafana Dashboard it is provided as it is, and bear in mind you can not open support Tickets regarding this project. It is a Community Project
##
##      .Notes
##      NAME:  cloudflare-analytics.sh
##      LASTEDIT: 23/04/2020
##      VERSION: 1.0
##      KEYWORDS: Cloudflare, InfluxDB, Grafana
   
##      .Link
##      https://jorgedelacruz.es/
##      https://jorgedelacruz.uk/

##
# Configurations
##
# Endpoint URL for InfluxDB
InfluxDBURL="${INFLUXDB_URL:="http://localhost"}" #Your InfluxDB Server, http://FQDN or https://FQDN if using SSL
InfluxDBPort="${INFLUXDB_PORT:="8086"}" #Default Port
InfluxDB="${INFLUXDB_DB:="telegraf"}" #Default Database
InfluxDBUser="${INFLUXDB_USER:="telegraf"}" #User for Database
InfluxDBPassword="${INFLUXDB_PASSWORD:="password"}" #Password for Database

# Endpoint URL for login action
cloudflareapikey="${CLOUDFLARE_API_TOKEN:="dummy_api_key"}"
cloudflarezoneid="${CLOUDFLARE_ZONE_ID:="dummy_zone_id"}"
cloudflarezone="${CLOUDFLARE_ZONE_NAME:="dummy_zone_name"}"

TMP_DIR="${TMP_DIR:="/tmp/cloudflare-analytics"}"
TMP_FILE_LASTRUN_TIME="${TMP_DIR}/${cloudflarezone}_lastrun.tmp"
TMP_FILE_DATA_TEMPLATE="${cloudflarezone}_data.tmp.XXXXX"
TMP_FILE_LOCK="${TMP_DIR}/${cloudflarezone}.lock"

CF_GQL_RESULTS_LIMIT=10000
CF_GQL_SINCE_MINS="-720"
CF_GQL_MIN_PERIOD=60 # Grab additional overlapping data to cover lag CF data availability and outtages

CF_DEFAULT_SINCE_MIN="-10080"
CF_DEFAULT_UNTIL_MIN="0"

# Threshold in bytes
INFLUXDB_POST_DATA_SIZE_THRESHOLD=16348

######################################
# Define this to be "echo" in ENV to switch off non-observer operations.
: "${ECHO:=""}"

#####################################################
# Processing Analytics API results.
function process_requests_api {
    local output="$1"

    local count=$(echo "$output" | jq length)
    for i in $(seq -s ' ' 0 $((count-1)))
    do
      local values=$(echo "$output" | jq --compact-output .[$i])
      process_request_api "$values"
    done
}

function process_request_api {
    local output="$1"
    local data_tmp="$(mktemp -p "${TMP_DIR}" -t "api_${TMP_FILE_DATA_TEMPLATE}")"

    ## Requests
    cfRequestsAll=$(echo "$output" | jq --raw-output ".requests.all")
    cfRequestsCached=$(echo "$output" | jq --raw-output ".requests.cached")
    cfRequestsUncached=$(echo "$output" | jq --raw-output ".requests.uncached")

    ## Bandwidth
    cfBandwidthAll=$(echo "$output" | jq --raw-output ".bandwidth.all")
    cfBandwidthCached=$(echo "$output" | jq --raw-output ".bandwidth.cached")
    cfBandwidthUncached=$(echo "$output" | jq --raw-output ".bandwidth.uncached")

    ## Threats
    cfThreatsAll=$(echo "$output" | jq --raw-output ".threats.all")

    ## Pageviews
    cfPageviewsAll=$(echo "$output" | jq --raw-output ".pageviews.all")

    ## Unique visits
    cfUniquesAll=$(echo "$output" | jq --raw-output ".uniques.all")

    ## Timestamp
    date=$(echo "$output" | jq --raw-output ".until")
    cfTimeStamp=$(date -d "${date}" '+%s')

# The alignment here is important (DO NOT INDENT)
    series_name="cloudflare_analytics"
    tags="\
cfZone=$cloudflarezone,\
cfZoneId=$cloudflarezoneid"
    data_points="\
cfRequestsAll=$cfRequestsAll,\
cfRequestsCached=$cfRequestsCached,\
cfRequestsUncached=$cfRequestsUncached,\
cfBandwidthAll=$cfBandwidthAll,\
cfBandwidthCached=$cfBandwidthCached,\
cfBandwidthUncached=$cfBandwidthUncached,\
cfThreatsAll=$cfThreatsAll,\
cfPageviewsAll=$cfPageviewsAll,\
cfUniquesAll=$cfUniquesAll"
    echo "$series_name,$tags $data_points $cfTimeStamp" >> "$data_tmp"

    ## Per Country
    local countries=$(echo "$output" | jq --raw-output ".requests.country" | jq keys[] | tr -d '"')
    for country in $countries
    do
      visits=$(echo "$output" | jq --raw-output ".requests.country.$country // \"0\"")
      threats=$(echo "$output" | jq --raw-output ".threats.country.$country // \"0\"")
      bandwidth=$(echo "$output" | jq --raw-output ".bandwidth.country.$country // \"0\"")

# The alignment here is important (DO NOT INDENT)
      series_name="cloudflare_analytics_country"
      tags="\
cfZone=$cloudflarezone,\
country=$country"
      data_points="\
visits=$visits,\
threats=$threats,\
bandwidth=$bandwidth"
      echo "$series_name,$tags $data_points $cfTimeStamp" >> "$data_tmp"
    done

    post_influxdb_data_file "$data_tmp"

    rm -vf "$data_tmp"
}

#####################################################
# Processing GraphQL results.
function process_results_graphql {
    local output="$1"
    local data_tmp="$(mktemp -p "${TMP_DIR}" -t "req_${TMP_FILE_DATA_TEMPLATE}")"

    local keys=$(echo "$output" | jq keys[] | tr -d '"')
    for k in $keys
    do
      local count=$(echo "$output" | jq ."$k" | jq length)
      for i in $(seq -s ' ' 0 $((count-1)))
      do
        local values=$(echo "$output" | jq --compact-output ."$k"["$i"])
        case $k in
          httpRequests1mGroups)
            process_request_graphql "$values" "$data_tmp"
            ;;
          firewallEventsAdaptive)
            process_firewall_graphql "$values" "$data_tmp"
            ;;
          loadBalancingRequestsAdaptive)
            ;;
          *)
            echo "process_requests: Unknown key: $k"
            ;;
        esac
      done
    done

    # Let's post any tail end data.
    post_influxdb_data_file "$data_tmp" 0
    # Clean up tmp file
    rm -vf "$data_tmp"
}

function process_request_graphql {
    local output="$1"
    local data_tmp="$2"
    local output_sum=$(echo "$output" | jq --compact-output ".sum")

    ## Requests
    cfRequestsAll=$(echo "$output_sum" | jq --raw-output ".requests")
    cfRequestsCached=$(echo "$output_sum" | jq --raw-output ".cachedRequests")
    cfRequestsUncached=$((cfRequestsAll-cfRequestsCached))
    cfRequestsEncrypt=$(echo "$output_sum" | jq --raw-output ".encryptedRequests")

    ## Bandwidth
    cfBandwidthAll=$(echo "$output_sum" | jq --raw-output ".bytes")
    cfBandwidthCached=$(echo "$output_sum" | jq --raw-output ".cachedBytes")
    cfBandwidthUncached=$((cfBandwidthAll-cfBandwidthCached))
    cfbandwidthEncrypt=$(echo "$output_sum" | jq --raw-output ".encryptedBytes")

    ## Threats
    cfThreatsAll=$(echo "$output_sum" | jq --raw-output ".threats")

    ## Pageviews
    cfPageviewsAll=$(echo "$output_sum" | jq --raw-output ".pageViews")

    ## Unique visits
    cfUniquesAll=$(echo "$output" | jq --raw-output ".uniq.uniques")

    ## Timestamp
    date=$(echo "$output" | jq --raw-output ".dimensions.datetime")
    cfTimeStamp=$(date -d "${date}" '+%s')

# The alignment here is important (DO NOT INDENT)
    series_name="cloudflare_analytics"
    tags="\
cfZone=$cloudflarezone,\
cfZoneId=$cloudflarezoneid"
    data_points="\
cfRequestsAll=$cfRequestsAll,\
cfRequestsCached=$cfRequestsCached,\
cfRequestsUncached=$cfRequestsUncached,\
cfRequestsEncrypt=$cfRequestsEncrypt,\
cfBandwidthAll=$cfBandwidthAll,\
cfBandwidthCached=$cfBandwidthCached,\
cfBandwidthUncached=$cfBandwidthUncached,\
cfbandwidthEncrypt=$cfbandwidthEncrypt,\
cfThreatsAll=$cfThreatsAll,\
cfPageviewsAll=$cfPageviewsAll,\
cfUniquesAll=$cfUniquesAll"
    echo "$series_name,$tags $data_points $cfTimeStamp" >> "$data_tmp"

    ## Per Country
    local count=$(echo "$output_sum" | jq --raw-output '".countryMap" | length')
    for c in $(seq -s ' ' 0 $((count-1)))
    do
      local output_sum_country=$(echo "$output_sum" | jq --compact-output ".countryMap[$c]")
      country=$(echo "$output_sum_country" | jq --raw-output ".clientCountryName // \"0\"")
      visits=$(echo "$output_sum_country" | jq --raw-output ".requests // \"0\"")
      threats=$(echo "$output_sum_country" | jq --raw-output ".threats // \"0\"")
      bandwidth=$(echo "$output_sum_country" | jq --raw-output ".bytes // \"0\"")

# The alignment here is important (DO NOT INDENT)
      series_name="cloudflare_analytics_country"
      tags="\
cfZone=$cloudflarezone,\
country=$country"
      data_points="\
visits=$visits,\
threats=$threats,\
bandwidth=$bandwidth"
      echo "$series_name,$tags $data_points $cfTimeStamp" >> "$data_tmp"
    done

    post_influxdb_data_file "$data_tmp"
}

function process_firewall_graphql {
    local output="$1"
    local data_tmp="$2"

    cfAction=$(echo "$output" | jq --raw-output ".action")
    cfClientAsn=$(echo "$output" | jq --raw-output ".clientAsn")
    cfClientCountryName=$(echo "$output" | jq --raw-output ".clientCountryName")
    cfClientIP=$(echo "$output" | jq --raw-output ".clientIP")
    cfClientRequestPath=$(echo "$output" | jq --raw-output ".clientRequestPath")
    cfClientRequestQuery=$(echo "$output" | jq --raw-output ".clientRequestQuery")
    cfSource=$(echo "$output" | jq --raw-output ".source")
    cfUserAgent=$(echo "$output" | jq --raw-output ".userAgent")

    ## Timestamp
    date=$(echo "$output" | jq --raw-output ".datetime")
    cfTimeStamp=$(date -d "${date}" '+%s')

# The alignment here is important (DO NOT INDENT)
    series_name="cloudflare_firewall"
    tags="\
cfZone=$cloudflarezone,\
cfZoneId=$cloudflarezoneid,\
cfAction=$cfAction,\
cfClientCountryName=$cfClientCountryName"
    data_points="\
cfClientAsn=${cfClientAsn}i,\
cfClientIP=\"$cfClientIP\",\
cfClientRequestPath=\"$cfClientRequestPath\",\
cfClientRequestQuery=\"$cfClientRequestQuery\",\
cfSource=\"$cfSource\",\
cfUserAgent=\"$cfUserAgent\""
    echo "$series_name,$tags $data_points $cfTimeStamp" >> "$data_tmp"

    post_influxdb_data_file "$data_tmp"
}

function check_file_size {
    local file=$1
    local min_size=$2
    local act_size=$(wc -c <"$file")

    if [ $act_size -ge $min_size ]; then
        return 1
    fi
}

#####################################################
# Post to influxDB
function post_influxdb_data_file {
    local data_file=$1
    local threshold=${2:-$INFLUXDB_POST_DATA_SIZE_THRESHOLD}

    check_file_size "$data_file" "$threshold" && return 0

    ${ECHO} curl -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" \
        --user "$InfluxDBUser:$InfluxDBPassword" \
        --data-binary @"$data_file" \
        2>&1 --silent

    # Clean up tmp file
    echo -n "" > "$data_file"
}

#####################################################
# Query Analytics API
#
# This API will be deprecated in 2021.
#
# Check Cloudflare Analytics, extracting the data from the configured period...
#
# Ranges that the Cloudflare web application provides will provide the following period length for each point:
# - Last 60 minutes (from -59 to -1): 1 minute resolution
# - Last 7 hours (from -419 to -60): 15 minutes resolution
# - Last 15 hours (from -899 to -420): 30 minutes resolution
# - Last 72 hours (from -4320 to -900): 1 hour resolution
# - Older than 3 days (-525600 to -4320): 1 day resolution
function fetch_request_data_api {
    local since=${1:-$CF_DEFAULT_SINCE_MIN}
    local until=${2:0}

    cloudflareRestURL="https://api.cloudflare.com/client/v4/zones/$cloudflarezoneid/analytics/dashboard?since=$since&until=$until&continuous=false"
    output=$(curl -X GET "$cloudflareRestURL" \
          --header "Accept:application/json" \
          --header "Authorization:Bearer $cloudflareapikey" \
          --insecure \
          2>&1 --silent | jq --compact-output ".result.timeseries" )
    process_requests_api "$output"
}

#####################################################
# Query GraphQL API
#
# Unlike the Analytics API above, this will query at 1 min resolution for all period lengths.
# However, it is limited to a maximum of $CF_GQL_RESULTS_LIMIT results.
function fetch_request_data_graphql {
    local since=${1:-$CF_DEFAULT_SINCE_MIN}
    local sincedate=$(date --utc +%FT%TZ -d "$since mins")
    local until=${2:-$CF_DEFAULT_UNTIL_MIN}
    local untildate=$(date --utc +%FT%TZ -d "$until mins")
    local result_limit=${3:-$CF_GQL_RESULTS_LIMIT}

    local gql_variables="{
        \"zoneTag\": \"$cloudflarezoneid\",
        \"limit\": $result_limit,
        \"filter\": {
          \"datetime_geq\": \"$sincedate\",
          \"datetime_leq\": \"$untildate\"
          }
        }"
    local payload="{
      \"query\": \"{
        viewer {
          zones(filter: { zoneTag: \$zoneTag }) {
            httpRequests1mGroups(
               limit: \$limit
               filter: \$filter
               orderBy: [datetime_ASC]
            ) {
              dimensions {
                datetime
              }
              sum {
                browserMap {
                  pageViews
                  uaBrowserFamily
                }
                bytes
                cachedBytes
                cachedRequests
                contentTypeMap {
                  bytes
                  requests
                  edgeResponseContentTypeName
                }
                clientSSLMap {
                  requests
                  clientSSLProtocol
                }
                countryMap {
                  bytes
                  requests
                  threats
                  clientCountryName
                }
                encryptedBytes
                encryptedRequests
                ipClassMap {
                  requests
                  ipType
                }
                pageViews
                requests
                responseStatusMap {
                  requests
                  edgeResponseStatus
                }
                threats
                threatPathingMap {
                  requests
                  threatPathingName
                }
              }
              uniq {
                uniques
              }
            }
          }
        }
      }\",
      \"variables\": $gql_variables
    }"
    make_graphql_post "$payload"
}

function fetch_fw_data_graphql {
    local since=${1:-$CF_DEFAULT_SINCE_MIN}
    local sincedate=$(date --utc +%FT%TZ -d "$since mins")
    local until=${2:-$CF_DEFAULT_UNTIL_MIN}
    local untildate=$(date --utc +%FT%TZ -d "$until mins")
    local result_limit=${3:-$CF_GQL_RESULTS_LIMIT}

    local gql_variables="{
        \"zoneTag\": \"$cloudflarezoneid\",
        \"limit\": $result_limit,
        \"filter\": {
          \"datetime_geq\": \"$sincedate\",
          \"datetime_leq\": \"$untildate\"
          }
        }"
    local payload="{
      \"query\": \"query ListFirewallEvents(\$zoneTag: string, \$filter: FirewallEventsAdaptiveFilter_InputObject) {
        viewer {
          zones(filter: { zoneTag: \$zoneTag }) {
            firewallEventsAdaptive(
              filter: \$filter
              limit: \$limit
              orderBy: [datetime_DESC]
            ) {
              action
              clientAsn
              clientCountryName
              clientIP
              clientRequestPath
              clientRequestQuery
              datetime
              source
              userAgent
            }
          }
        }
      }\",
      \"variables\": $gql_variables
    }"
    make_graphql_post "$payload"
}

# TODO: explore the Loadbalancer analytics.
#function fetch_lb_data_graphql {
#    local since=${1:-$CF_DEFAULT_SINCE_MIN}
#    local sincedate=$(date --utc +%FT%TZ -d "$since mins")
#    local until=${2:-$CF_DEFAULT_UNTIL_MIN}
#    local untildate=$(date --utc +%FT%TZ -d "$until mins")
#    local result_limit=${3:-$CF_GQL_RESULTS_LIMIT}
#
#    local gql_variables="{
#        \"zoneTag\": \"$cloudflarezoneid\",
#        \"limit\": $result_limit,
#        \"filter\": {
#          \"datetime_geq\": \"$sincedate\",
#          \"datetime_leq\": \"$untildate\"
#          }
#        }"
#    local payload="{
#      \"query\": \" {
#        viewer {
#          zones(filter: { zoneTag: \$zoneTag }) {
#            loadBalancingRequestsAdaptive(
#              filter: \$filter
#              limit: \$limit
#              orderBy: [datetime_DESC]
#            ) {
#              datetime
#              lbName
#              proxied
#              region
#              sessionAffinity
#              sessionAffinityStatus
#              steeringPolicy
#            }
#          }
#        }
#      }\",
#      \"variables\": $gql_variables
#    }"
#    make_graphql_post "$payload"
#}

function make_graphql_post {
    local payload="$1"

    cloudflareRestURL="https://api.cloudflare.com/client/v4/graphql/"
    output=$(curl -X POST "$cloudflareRestURL" \
         --header "Accept:application/json" \
         --header "Authorization:Bearer $cloudflareapikey" \
         --insecure \
         --data "$(echo $payload)" \
        2>&1 --silent | jq --compact-output .data.viewer.zones[0])
    process_results_graphql "$output"
}

function get_last_mins {
    local last_mins="$CF_GQL_SINCE_MINS"
    local min_period="$CF_GQL_MIN_PERIOD"

    # Find out when we last ran so that we can collect only the require period
    if [ -e $TMP_FILE_LASTRUN_TIME ]
    then
      last_run=$(cat $TMP_FILE_LASTRUN_TIME)
      last_secs=$(($(date +%s -d "$last_run") - $(date +%s)))
      last_mins=$(((last_secs/60)-min_period))
    fi

    # Reset the time last run
    date --utc +%FT%TZ > $TMP_FILE_LASTRUN_TIME

    echo $last_mins
}

function check_running {
  if [ -e "${TMP_FILE_LOCK}" ]; then
    echo "Already running"
    return 1
  fi
  echo "$$" > "${TMP_FILE_LOCK}"
}

#####################################################
# MAIN FUNCTION
#
mkdir -p "${TMP_DIR}"

check_running || exit 1
echo "Running"

#fetch_request_data_api "-59" "0"
#fetch_request_data_api "-419" "-60"
#fetch_request_data_api "-899" "-420"
#fetch_request_data_api "-1440" "-900"

since_mins="$(get_last_mins)"
fetch_request_data_graphql "$since_mins"
fetch_fw_data_graphql "$since_mins"
#fetch_lb_data_graphql "$since_mins"

# Clear the lock file
rm -v "${TMP_FILE_LOCK}"
exit 0
