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
InfluxDBPassword="${INFLUXDB_PASSWORD:="PASSWORD"}" #Password for Database

# Endpoint URL for login action
cloudflareapikey="${CLOUDFLARE_API_TOKEN:="dummy_api_key"}"
cloudflarezoneid="${CLOUDFLARE_ZONE_ID:="dummy_zone_id"}"
cloudflarezone="${CLOUDFLARE_ZONE_NAME:="dummy_zone_name"}"

######################################
# Define this to be "echo" in ENV to switch off non-observer operations.
: "${ECHO:=""}"
#ECHO=echo

function process_results {
    local output="$1"
    local count=$(echo "$output" | jq --raw-output ".result.timeseries" | jq length)

    for i in $(seq -s ' ' 0 $((count-1)))
    do
      process_result "$output" "$i"
    done
}

function process_result {
    local output="$1"
    local index=${2:0}
    local data_tmp="${cloudflarezone}_data.$$.tmp"

    ## Requests
    cfRequestsAll=$(echo "$output" | jq --raw-output ".result.timeseries[$index].requests.all")
    cfRequestsCached=$(echo "$output" | jq --raw-output ".result.timeseries[$index].requests.cached")
    cfRequestsUncached=$(echo "$output" | jq --raw-output ".result.timeseries[$index].requests.uncached")

    ## Bandwidth
    cfBandwidthAll=$(echo "$output" | jq --raw-output ".result.timeseries[$index].bandwidth.all")
    cfBandwidthCached=$(echo "$output" | jq --raw-output ".result.timeseries[$index].bandwidth.cached")
    cfBandwidthUncached=$(echo "$output" | jq --raw-output ".result.timeseries[$index].bandwidth.uncached")

    ## Threats
    cfThreatsAll=$(echo "$output" | jq --raw-output ".result.timeseries[$index].threats.all")

    ## Pageviews
    cfPageviewsAll=$(echo "$output" | jq --raw-output ".result.timeseries[$index].pageviews.all")

    ## Unique visits
    cfUniquesAll=$(echo "$output" | jq --raw-output ".result.timeseries[$index].uniques.all")

    ## Timestamp
    date=$(echo "$output" | jq --raw-output ".result.timeseries[$index].until")
    cfTimeStamp=$(date -d "${date}" '+%s')

# The alignement here is important (DO NOT INDENT)
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
    local countries=$(echo "$output" | jq --raw-output ".result.timeseries[$index].requests.country" | jq keys[] | tr -d '"')
    for country in $countries
    do
      visits=$(echo "$output" | jq --raw-output ".result.timeseries[$index].requests.country.$country // "0"")
      threats=$(echo "$output" | jq --raw-output ".result.timeseries[$index].threats.country.$country // "0"")
      bandwidth=$(echo "$output" | jq --raw-output ".result.timeseries[$index].bandwidth.country.$country // "0"")

# The alignement here is important (DO NOT INDENT)
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

    ${ECHO} curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary @"$data_tmp"

    # Clean up tmp file
    rm -vf "${data_tmp}"
}

function fetch_data {
    local since=${1:-10080}
    local until=${2:0}

    cloudflareRestURL="https://api.cloudflare.com/client/v4/zones/$cloudflarezoneid/analytics/dashboard?since=$since&until=$until&continuous=false"
    output=$(curl -X GET "$cloudflareRestURL" \
                            --header "Accept:application/json" \
                            --header "Authorization:Bearer $cloudflareapikey" \
                            2>&1 -k --silent)
    process_results "$output"
}

# The above API will be deprecated. This is an, as yet untested, replacement call using the new API.
function fetch_data_graphiQL {
    local since=${1:-10080}
    local sincedate=$(date -d "$since mins ago")
    local until=${2:0}
    local untildate=$(date -d "$until mins ago")

    local payload="{
                      viewer {
                        zones(filter: {zoneTag: $cloudflarezoneid}) {
                          httpRequests1mGroups(orderBy: [datetimeMinute_ASC],
                                               limit: 100,
                                               filter: { datetime_geq: "$sincedate", datetime_lt: "$untildate"}
                                               )
                          {
                            dimensions {
                              datetimeMinute
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
                    }"

    cloudflareRestURL="https://api.cloudflare.com/client/v4/graphql/"
    output=$(curl -X GET "$cloudflareRestURL" \
                            --header "Accept:application/json" \
                            --header "Authorization:Bearer $cloudflareapikey" \
                            --data "$payload" \
                            2>&1 -k --silent)
    process_results "$output"
}

###################
# MAIN FUNCTION
#
# This part will check on your Cloudflare Analytics, extracting the data from the configured period...
#
# Ranges that the Cloudflare web application provides will provide the following period length for each point:
# - Last 60 minutes (from -59 to -1): 1 minute resolution
# - Last 7 hours (from -419 to -60): 15 minutes resolution
# - Last 15 hours (from -899 to -420): 30 minutes resolution
# - Last 72 hours (from -4320 to -900): 1 hour resolution
# - Older than 3 days (-525600 to -4320): 1 day resolution
##
fetch_data "-59" "0"
fetch_data "-419" "-60"
fetch_data "-899" "-420"
fetch_data "-1440" "-900"

