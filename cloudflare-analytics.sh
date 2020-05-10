#!/bin/bash
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
InfluxDBURL="YOURINFLUXSERVERIP" #Your InfluxDB Server, http://FQDN or https://FQDN if using SSL
InfluxDBPort="8086" #Default Port
InfluxDB="telegraf" #Default Database
InfluxDBUser="USER" #User for Database
InfluxDBPassword="PASSWORD" #Password for Database

# Endpoint URL for login action
cloudflareapikey="YOURAPIKEY"
cloudflarezone="YOURZONEID"

##
# Cloudflare Analytics. This part will check on your Cloudflare Analytics, extracting the data from the last 24 hours
##
cloudflareRestURL="https://api.cloudflare.com/client/v4/zones/$cloudflarezone/analytics/dashboard?since=-1440&continuous=false"
cloudflareUrl=$(curl -X GET --header "Accept:application/json" --header "Authorization:Bearer $cloudflareapikey" "$cloudflareRestURL" 2>&1 -k --silent)

    ## Requests
    cfRequestsAll=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.all")
    cfRequestsCached=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.cached")
    cfRequestsUncached=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.uncached")
    
    ## Requestes per Country
    cfRequestsAF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AF // "0"")
    cfRequestsAL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AL // "0"")
    cfRequestsDZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.DZ // "0"")
    cfRequestsAS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AS // "0"")
    cfRequestsAD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AD // "0"")
    cfRequestsAO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AO // "0"")
    cfRequestsAI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AI // "0"")
    cfRequestsAQ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AQ // "0"")
    cfRequestsAG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AG // "0"")
    cfRequestsAR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AR // "0"")
    cfRequestsAM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AM // "0"")
    cfRequestsAW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AW // "0"")
    cfRequestsAU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AU // "0"")
    cfRequestsAT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AT // "0"")
    cfRequestsAZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AZ // "0"")
    cfRequestsBS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BS // "0"")
    cfRequestsBH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BH // "0"")
    cfRequestsBD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BD // "0"")
    cfRequestsBB=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BB // "0"")
    cfRequestsBY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BY // "0"")
    cfRequestsBE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BE // "0"")
    cfRequestsBZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BZ // "0"")
    cfRequestsBJ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BJ // "0"")
    cfRequestsBM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BM // "0"")
    cfRequestsBT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BT // "0"")
    cfRequestsBO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BO // "0"")
    cfRequestsBQ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BQ // "0"")
    cfRequestsBA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BA // "0"")
    cfRequestsBW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BW // "0"")
    cfRequestsBV=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BV // "0"")
    cfRequestsBR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BR // "0"")
    cfRequestsIO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IO // "0"")
    cfRequestsBN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BN // "0"")
    cfRequestsBG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BG // "0"")
    cfRequestsBF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BF // "0"")
    cfRequestsBI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BI // "0"")
    cfRequestsCV=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CV // "0"")
    cfRequestsKH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KH // "0"")
    cfRequestsCM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CM // "0"")
    cfRequestsCA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CA // "0"")
    cfRequestsKY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KY // "0"")
    cfRequestsCF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CF // "0"")
    cfRequestsTD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TD // "0"")
    cfRequestsCL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CL // "0"")
    cfRequestsCN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CN // "0"")
    cfRequestsCX=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CX // "0"")
    cfRequestsCC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CC // "0"")
    cfRequestsCO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CO // "0"")
    cfRequestsKM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KM // "0"")
    cfRequestsCD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CD // "0"")
    cfRequestsCG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CG // "0"")
    cfRequestsCK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CK // "0"")
    cfRequestsCR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CR // "0"")
    cfRequestsHR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.HR // "0"")
    cfRequestsCU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CU // "0"")
    cfRequestsCW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CW // "0"")
    cfRequestsCY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CY // "0"")
    cfRequestsCZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CZ // "0"")
    cfRequestsCI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CI // "0"")
    cfRequestsDK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.DK // "0"")
    cfRequestsDJ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.DJ // "0"")
    cfRequestsDM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.DM // "0"")
    cfRequestsDO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.DO // "0"")
    cfRequestsEC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.EC // "0"")
    cfRequestsEG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.EG // "0"")
    cfRequestsSV=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SV // "0"")
    cfRequestsGQ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GQ // "0"")
    cfRequestsER=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ER // "0"")
    cfRequestsEE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.EE // "0"")
    cfRequestsSZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SZ // "0"")
    cfRequestsET=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ET // "0"")
    cfRequestsFK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.FK // "0"")
    cfRequestsFO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.FO // "0"")
    cfRequestsFJ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.FJ // "0"")
    cfRequestsFI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.FI // "0"")
    cfRequestsFR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.FR // "0"")
    cfRequestsGF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GF // "0"")
    cfRequestsPF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PF // "0"")
    cfRequestsTF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TF // "0"")
    cfRequestsGA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GA // "0"")
    cfRequestsGM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GM // "0"")
    cfRequestsGE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GE // "0"")
    cfRequestsDE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.DE // "0"")
    cfRequestsGH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GH // "0"")
    cfRequestsGI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GI // "0"")
    cfRequestsGR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GR // "0"")
    cfRequestsGL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GL // "0"")
    cfRequestsGD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GD // "0"")
    cfRequestsGP=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GP // "0"")
    cfRequestsGU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GU // "0"")
    cfRequestsGT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GT // "0"")
    cfRequestsGG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GG // "0"")
    cfRequestsGN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GN // "0"")
    cfRequestsGW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GW // "0"")
    cfRequestsGY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GY // "0"")
    cfRequestsHT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.HT // "0"")
    cfRequestsHM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.HM // "0"")
    cfRequestsVA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VA // "0"")
    cfRequestsHN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.HN // "0"")
    cfRequestsHK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.HK // "0"")
    cfRequestsHU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.HU // "0"")
    cfRequestsIS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IS // "0"")
    cfRequestsIN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IN // "0"")
    cfRequestsID=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ID // "0"")
    cfRequestsIR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IR // "0"")
    cfRequestsIQ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IQ // "0"")
    cfRequestsIE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IE // "0"")
    cfRequestsIM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IM // "0"")
    cfRequestsIL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IL // "0"")
    cfRequestsIT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.IT // "0"")
    cfRequestsJM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.JM // "0"")
    cfRequestsJP=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.JP // "0"")
    cfRequestsJE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.JE // "0"")
    cfRequestsJO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.JO // "0"")
    cfRequestsKZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KZ // "0"")
    cfRequestsKE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KE // "0"")
    cfRequestsKI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KI // "0"")
    cfRequestsKP=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KP // "0"")
    cfRequestsKR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KR // "0"")
    cfRequestsKW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KW // "0"")
    cfRequestsKG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KG // "0"")
    cfRequestsLA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LA // "0"")
    cfRequestsLV=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LV // "0"")
    cfRequestsLB=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LB // "0"")
    cfRequestsLS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LS // "0"")
    cfRequestsLR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LR // "0"")
    cfRequestsLY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LY // "0"")
    cfRequestsLI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LI // "0"")
    cfRequestsLT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LT // "0"")
    cfRequestsLU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LU // "0"")
    cfRequestsMO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MO // "0"")
    cfRequestsMG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MG // "0"")
    cfRequestsMW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MW // "0"")
    cfRequestsMY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MY // "0"")
    cfRequestsMV=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MV // "0"")
    cfRequestsML=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ML // "0"")
    cfRequestsMT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MT // "0"")
    cfRequestsMH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MH // "0"")
    cfRequestsMQ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MQ // "0"")
    cfRequestsMR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MR // "0"")
    cfRequestsMU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MU // "0"")
    cfRequestsYT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.YT // "0"")
    cfRequestsMX=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MX // "0"")
    cfRequestsFM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.FM // "0"")
    cfRequestsMD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MD // "0"")
    cfRequestsMC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MC // "0"")
    cfRequestsMN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MN // "0"")
    cfRequestsME=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ME // "0"")
    cfRequestsMS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MS // "0"")
    cfRequestsMA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MA // "0"")
    cfRequestsMZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MZ // "0"")
    cfRequestsMM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MM // "0"")
    cfRequestsNA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NA // "0"")
    cfRequestsNR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NR // "0"")
    cfRequestsNP=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NP // "0"")
    cfRequestsNL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NL // "0"")
    cfRequestsNC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NC // "0"")
    cfRequestsNZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NZ // "0"")
    cfRequestsNI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NI // "0"")
    cfRequestsNE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NE // "0"")
    cfRequestsNG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NG // "0"")
    cfRequestsNU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NU // "0"")
    cfRequestsNF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NF // "0"")
    cfRequestsMP=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MP // "0"")
    cfRequestsNO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.NO // "0"")
    cfRequestsOM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.OM // "0"")
    cfRequestsPK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PK // "0"")
    cfRequestsPW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PW // "0"")
    cfRequestsPS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PS // "0"")
    cfRequestsPA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PA // "0"")
    cfRequestsPG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PG // "0"")
    cfRequestsPY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PY // "0"")
    cfRequestsPE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PE // "0"")
    cfRequestsPH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PH // "0"")
    cfRequestsPN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PN // "0"")
    cfRequestsPL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PL // "0"")
    cfRequestsPT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PT // "0"")
    cfRequestsPR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PR // "0"")
    cfRequestsQA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.QA // "0"")
    cfRequestsMK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MK // "0"")
    cfRequestsRO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.RO // "0"")
    cfRequestsRU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.RU // "0"")
    cfRequestsRW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.RW // "0"")
    cfRequestsRE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.RE // "0"")
    cfRequestsBL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.BL // "0"")
    cfRequestsSH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SH // "0"")
    cfRequestsKN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.KN // "0"")
    cfRequestsLC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LC // "0"")
    cfRequestsMF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.MF // "0"")
    cfRequestsPM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.PM // "0"")
    cfRequestsVC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VC // "0"")
    cfRequestsWS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.WS // "0"")
    cfRequestsSM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SM // "0"")
    cfRequestsST=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ST // "0"")
    cfRequestsSA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SA // "0"")
    cfRequestsSN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SN // "0"")
    cfRequestsRS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.RS // "0"")
    cfRequestsSC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SC // "0"")
    cfRequestsSL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SL // "0"")
    cfRequestsSG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SG // "0"")
    cfRequestsSX=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SX // "0"")
    cfRequestsSK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SK // "0"")
    cfRequestsSI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SI // "0"")
    cfRequestsSB=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SB // "0"")
    cfRequestsSO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SO // "0"")
    cfRequestsZA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ZA // "0"")
    cfRequestsGS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GS // "0"")
    cfRequestsSS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SS // "0"")
    cfRequestsES=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ES // "0"")
    cfRequestsLK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.LK // "0"")
    cfRequestsSD=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SD // "0"")
    cfRequestsSR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SR // "0"")
    cfRequestsSJ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SJ // "0"")
    cfRequestsSE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SE // "0"")
    cfRequestsCH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.CH // "0"")
    cfRequestsSY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.SY // "0"")
    cfRequestsTW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TW // "0"")
    cfRequestsTJ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TJ // "0"")
    cfRequestsTZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TZ // "0"")
    cfRequestsTH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TH // "0"")
    cfRequestsTL=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TL // "0"")
    cfRequestsTG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TG // "0"")
    cfRequestsTK=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TK // "0"")
    cfRequestsTO=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TO // "0"")
    cfRequestsTT=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TT // "0"")
    cfRequestsTN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TN // "0"")
    cfRequestsTR=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TR // "0"")
    cfRequestsTM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TM // "0"")
    cfRequestsTC=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TC // "0"")
    cfRequestsTV=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.TV // "0"")
    cfRequestsUG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.UG // "0"")
    cfRequestsUA=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.UA // "0"")
    cfRequestsAE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AE // "0"")
    cfRequestsGB=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.GB // "0"")
    cfRequestsUM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.UM // "0"")
    cfRequestsUS=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.US // "0"")
    cfRequestsUY=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.UY // "0"")
    cfRequestsUZ=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.UZ // "0"")
    cfRequestsVU=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VU // "0"")
    cfRequestsVE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VE // "0"")
    cfRequestsVN=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VN // "0"")
    cfRequestsVG=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VG // "0"")
    cfRequestsVI=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.VI // "0"")
    cfRequestsWF=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.WF // "0"")
    cfRequestsEH=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.EH // "0"")
    cfRequestsYE=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.YE // "0"")
    cfRequestsZM=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ZM // "0"")
    cfRequestsZW=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.ZW // "0"")
    cfRequestsAX=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].requests.country.AX // "0"")

    ## Bandwidth
    cfBandwidthAll=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].bandwidth.all")
    cfBandwidthCached=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].bandwidth.cached")
    cfBandwidthUncached=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].bandwidth.uncached")

    ## Threats
    cfThreatsAll=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].threats.all")

    ## Pageviews
    cfPageviewsAll=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].pageviews.all")
    
    ## Unique visits
    cfUniquesAll=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].uniques.all")
    
    ## Timestamp
    date=$(echo "$cloudflareUrl" | jq --raw-output ".result.timeseries[0].until")
    cfTimeStamp=`date -d "${date}" '+%s'`

    #echo "cloudflare_analytics,cfZone=$cloudflarezone cfRequestsAll=$cfRequestsAll,cfRequestsCached=$cfRequestsCached,cfRequestsUncached=$cfRequestsUncached,cfBandwidthAll=$cfBandwidthAll,cfBandwidthCached=$cfBandwidthCached,cfBandwidthUncached=$cfBandwidthUncached,cfThreatsAll=$cfThreatsAll,cfPageviewsAll=$cfPageviewsAll,cfUniquesAll=$cfUniquesAll $$cfTimeStamp"
    
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics,cfZone=$cloudflarezone cfRequestsAll=$cfRequestsAll,cfRequestsCached=$cfRequestsCached,cfRequestsUncached=$cfRequestsUncached,cfBandwidthAll=$cfBandwidthAll,cfBandwidthCached=$cfBandwidthCached,cfBandwidthUncached=$cfBandwidthUncached,cfThreatsAll=$cfThreatsAll,cfPageviewsAll=$cfPageviewsAll,cfUniquesAll=$cfUniquesAll $cfTimeStamp"
    
    #echo "cloudflare_analytics_country,cfZone=$cloudflarezone AF=$cfRequestsAF,AL=$cfRequestsAL,DZ=$cfRequestsDZ,AS=$cfRequestsAS,AD=$cfRequestsAD,AO=$cfRequestsAO,AI=$cfRequestsAI,AQ=$cfRequestsAQ,AG=$cfRequestsAG,AR=$cfRequestsAR,AM=$cfRequestsAM,AW=$cfRequestsAW,AU=$cfRequestsAU,AT=$cfRequestsAT,AZ=$cfRequestsAZ,BS=$cfRequestsBS,BH=$cfRequestsBH,BD=$cfRequestsBD,BB=$cfRequestsBB,BY=$cfRequestsBY,BE=$cfRequestsBE,BZ=$cfRequestsBZ,BJ=$cfRequestsBJ,BM=$cfRequestsBM,BT=$cfRequestsBT,BO=$cfRequestsBO,BQ=$cfRequestsBQ,BA=$cfRequestsBA,BW=$cfRequestsBW,BV=$cfRequestsBV,BR=$cfRequestsBR,IO=$cfRequestsIO,BN=$cfRequestsBN,BG=$cfRequestsBG,BF=$cfRequestsBF,BI=$cfRequestsBI,CV=$cfRequestsCV,KH=$cfRequestsKH,CM=$cfRequestsCM,CA=$cfRequestsCA,KY=$cfRequestsKY,CF=$cfRequestsCF,TD=$cfRequestsTD,CL=$cfRequestsCL,CN=$cfRequestsCN,CX=$cfRequestsCX,CC=$cfRequestsCC,CO=$cfRequestsCO,KM=$cfRequestsKM,CD=$cfRequestsCD,CG=$cfRequestsCG,CK=$cfRequestsCK,CR=$cfRequestsCR,HR=$cfRequestsHR,CU=$cfRequestsCU,CW=$cfRequestsCW,CY=$cfRequestsCY,CZ=$cfRequestsCZ,CI=$cfRequestsCI,DK=$cfRequestsDK,DJ=$cfRequestsDJ,DM=$cfRequestsDM,DO=$cfRequestsDO,EC=$cfRequestsEC,EG=$cfRequestsEG,SV=$cfRequestsSV,GQ=$cfRequestsGQ,ER=$cfRequestsER,EE=$cfRequestsEE,SZ=$cfRequestsSZ,ET=$cfRequestsET,FK=$cfRequestsFK,FO=$cfRequestsFO,FJ=$cfRequestsFJ,FI=$cfRequestsFI,FR=$cfRequestsFR,GF=$cfRequestsGF,PF=$cfRequestsPF,TF=$cfRequestsTF,GA=$cfRequestsGA,GM=$cfRequestsGM,GE=$cfRequestsGE,DE=$cfRequestsDE,GH=$cfRequestsGH,GI=$cfRequestsGI,GR=$cfRequestsGR,GL=$cfRequestsGL,GD=$cfRequestsGD,GP=$cfRequestsGP,GU=$cfRequestsGU,GT=$cfRequestsGT,GG=$cfRequestsGG,GN=$cfRequestsGN,GW=$cfRequestsGW,GY=$cfRequestsGY,HT=$cfRequestsHT,HM=$cfRequestsHM,VA=$cfRequestsVA,HN=$cfRequestsHN,HK=$cfRequestsHK,HU=$cfRequestsHU,IS=$cfRequestsIS,IN=$cfRequestsIN,ID=$cfRequestsID,IR=$cfRequestsIR,IQ=$cfRequestsIQ,IE=$cfRequestsIE,IM=$cfRequestsIM,IL=$cfRequestsIL,IT=$cfRequestsIT,JM=$cfRequestsJM,JP=$cfRequestsJP,JE=$cfRequestsJE,JO=$cfRequestsJO,KZ=$cfRequestsKZ,KE=$cfRequestsKE,KI=$cfRequestsKI,KP=$cfRequestsKP,KR=$cfRequestsKR,KW=$cfRequestsKW,KG=$cfRequestsKG,LA=$cfRequestsLA,LV=$cfRequestsLV,LB=$cfRequestsLB,LS=$cfRequestsLS,LR=$cfRequestsLR,LY=$cfRequestsLY,LI=$cfRequestsLI,LT=$cfRequestsLT,LU=$cfRequestsLU,MO=$cfRequestsMO,MG=$cfRequestsMG,MW=$cfRequestsMW,MY=$cfRequestsMY,MV=$cfRequestsMV,ML=$cfRequestsML,MT=$cfRequestsMT,MH=$cfRequestsMH,MQ=$cfRequestsMQ,MR=$cfRequestsMR,MU=$cfRequestsMU,YT=$cfRequestsYT,MX=$cfRequestsMX,FM=$cfRequestsFM,MD=$cfRequestsMD,MC=$cfRequestsMC,MN=$cfRequestsMN,ME=$cfRequestsME,MS=$cfRequestsMS,MA=$cfRequestsMA,MZ=$cfRequestsMZ,MM=$cfRequestsMM,NA=$cfRequestsNA,NR=$cfRequestsNR,NP=$cfRequestsNP,NL=$cfRequestsNL,NC=$cfRequestsNC,NZ=$cfRequestsNZ,NI=$cfRequestsNI,NE=$cfRequestsNE,NG=$cfRequestsNG,NU=$cfRequestsNU,NF=$cfRequestsNF,MP=$cfRequestsMP,NO=$cfRequestsNO,OM=$cfRequestsOM,PK=$cfRequestsPK,PW=$cfRequestsPW,PS=$cfRequestsPS,PA=$cfRequestsPA,PG=$cfRequestsPG,PY=$cfRequestsPY,PE=$cfRequestsPE,PH=$cfRequestsPH,PN=$cfRequestsPN,PL=$cfRequestsPL,PT=$cfRequestsPT,PR=$cfRequestsPR,QA=$cfRequestsQA,MK=$cfRequestsMK,RO=$cfRequestsRO,RU=$cfRequestsRU,RW=$cfRequestsRW,RE=$cfRequestsRE,BL=$cfRequestsBL,SH=$cfRequestsSH,KN=$cfRequestsKN,LC=$cfRequestsLC,MF=$cfRequestsMF,PM=$cfRequestsPM,VC=$cfRequestsVC,WS=$cfRequestsWS,SM=$cfRequestsSM,ST=$cfRequestsST,SA=$cfRequestsSA,SN=$cfRequestsSN,RS=$cfRequestsRS,SC=$cfRequestsSC,SL=$cfRequestsSL,SG=$cfRequestsSG,SX=$cfRequestsSX,SK=$cfRequestsSK,SI=$cfRequestsSI,SB=$cfRequestsSB,SO=$cfRequestsSO,ZA=$cfRequestsZA,GS=$cfRequestsGS,SS=$cfRequestsSS,ES=$cfRequestsES,LK=$cfRequestsLK,SD=$cfRequestsSD,SR=$cfRequestsSR,SJ=$cfRequestsSJ,SE=$cfRequestsSE,CH=$cfRequestsCH,SY=$cfRequestsSY,TW=$cfRequestsTW,TJ=$cfRequestsTJ,TZ=$cfRequestsTZ,TH=$cfRequestsTH,TL=$cfRequestsTL,TG=$cfRequestsTG,TK=$cfRequestsTK,TO=$cfRequestsTO,TT=$cfRequestsTT,TN=$cfRequestsTN,TR=$cfRequestsTR,TM=$cfRequestsTM,TC=$cfRequestsTC,TV=$cfRequestsTV,UG=$cfRequestsUG,UA=$cfRequestsUA,AE=$cfRequestsAE,GB=$cfRequestsGB,UM=$cfRequestsUM,US=$cfRequestsUS,UY=$cfRequestsUY,UZ=$cfRequestsUZ,VU=$cfRequestsVU,VE=$cfRequestsVE,VN=$cfRequestsVN,VG=$cfRequestsVG,VI=$cfRequestsVI,WF=$cfRequestsWF,EH=$cfRequestsEH,YE=$cfRequestsYE,ZM=$cfRequestsZM,ZW=$cfRequestsZW,AX=$cfRequestsAX $$cfTimeStamp"   
    
  
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AF visits=$cfRequestsAF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AL visits=$cfRequestsAL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=DZ visits=$cfRequestsDZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AS visits=$cfRequestsAS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AD visits=$cfRequestsAD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AO visits=$cfRequestsAO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AI visits=$cfRequestsAI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AQ visits=$cfRequestsAQ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AG visits=$cfRequestsAG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AR visits=$cfRequestsAR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AM visits=$cfRequestsAM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AW visits=$cfRequestsAW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AU visits=$cfRequestsAU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AT visits=$cfRequestsAT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AZ visits=$cfRequestsAZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BS visits=$cfRequestsBS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BH visits=$cfRequestsBH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BD visits=$cfRequestsBD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BB visits=$cfRequestsBB $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BY visits=$cfRequestsBY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BE visits=$cfRequestsBE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BZ visits=$cfRequestsBZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BJ visits=$cfRequestsBJ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BM visits=$cfRequestsBM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BT visits=$cfRequestsBT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BO visits=$cfRequestsBO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BQ visits=$cfRequestsBQ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BA visits=$cfRequestsBA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BW visits=$cfRequestsBW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BV visits=$cfRequestsBV $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BR visits=$cfRequestsBR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IO visits=$cfRequestsIO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BN visits=$cfRequestsBN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BG visits=$cfRequestsBG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BF visits=$cfRequestsBF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BI visits=$cfRequestsBI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CV visits=$cfRequestsCV $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KH visits=$cfRequestsKH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CM visits=$cfRequestsCM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CA visits=$cfRequestsCA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KY visits=$cfRequestsKY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CF visits=$cfRequestsCF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TD visits=$cfRequestsTD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CL visits=$cfRequestsCL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CN visits=$cfRequestsCN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CX visits=$cfRequestsCX $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CC visits=$cfRequestsCC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CO visits=$cfRequestsCO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KM visits=$cfRequestsKM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CD visits=$cfRequestsCD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CG visits=$cfRequestsCG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CK visits=$cfRequestsCK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CR visits=$cfRequestsCR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=HR visits=$cfRequestsHR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CU visits=$cfRequestsCU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CW visits=$cfRequestsCW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CY visits=$cfRequestsCY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CZ visits=$cfRequestsCZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CI visits=$cfRequestsCI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=DK visits=$cfRequestsDK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=DJ visits=$cfRequestsDJ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=DM visits=$cfRequestsDM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=DO visits=$cfRequestsDO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=EC visits=$cfRequestsEC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=EG visits=$cfRequestsEG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SV visits=$cfRequestsSV $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GQ visits=$cfRequestsGQ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ER visits=$cfRequestsER $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=EE visits=$cfRequestsEE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SZ visits=$cfRequestsSZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ET visits=$cfRequestsET $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=FK visits=$cfRequestsFK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=FO visits=$cfRequestsFO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=FJ visits=$cfRequestsFJ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=FI visits=$cfRequestsFI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=FR visits=$cfRequestsFR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GF visits=$cfRequestsGF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PF visits=$cfRequestsPF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TF visits=$cfRequestsTF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GA visits=$cfRequestsGA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GM visits=$cfRequestsGM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GE visits=$cfRequestsGE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=DE visits=$cfRequestsDE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GH visits=$cfRequestsGH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GI visits=$cfRequestsGI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GR visits=$cfRequestsGR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GL visits=$cfRequestsGL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GD visits=$cfRequestsGD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GP visits=$cfRequestsGP $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GU visits=$cfRequestsGU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GT visits=$cfRequestsGT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GG visits=$cfRequestsGG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GN visits=$cfRequestsGN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GW visits=$cfRequestsGW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GY visits=$cfRequestsGY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=HT visits=$cfRequestsHT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=HM visits=$cfRequestsHM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VA visits=$cfRequestsVA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=HN visits=$cfRequestsHN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=HK visits=$cfRequestsHK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=HU visits=$cfRequestsHU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IS visits=$cfRequestsIS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IN visits=$cfRequestsIN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ID visits=$cfRequestsID $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IR visits=$cfRequestsIR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IQ visits=$cfRequestsIQ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IE visits=$cfRequestsIE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IM visits=$cfRequestsIM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IL visits=$cfRequestsIL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=IT visits=$cfRequestsIT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=JM visits=$cfRequestsJM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=JP visits=$cfRequestsJP $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=JE visits=$cfRequestsJE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=JO visits=$cfRequestsJO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KZ visits=$cfRequestsKZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KE visits=$cfRequestsKE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KI visits=$cfRequestsKI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KP visits=$cfRequestsKP $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KR visits=$cfRequestsKR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KW visits=$cfRequestsKW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KG visits=$cfRequestsKG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LA visits=$cfRequestsLA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LV visits=$cfRequestsLV $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LB visits=$cfRequestsLB $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LS visits=$cfRequestsLS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LR visits=$cfRequestsLR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LY visits=$cfRequestsLY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LI visits=$cfRequestsLI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LT visits=$cfRequestsLT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LU visits=$cfRequestsLU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MO visits=$cfRequestsMO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MG visits=$cfRequestsMG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MW visits=$cfRequestsMW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MY visits=$cfRequestsMY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MV visits=$cfRequestsMV $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ML visits=$cfRequestsML $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MT visits=$cfRequestsMT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MH visits=$cfRequestsMH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MQ visits=$cfRequestsMQ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MR visits=$cfRequestsMR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MU visits=$cfRequestsMU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=YT visits=$cfRequestsYT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MX visits=$cfRequestsMX $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=FM visits=$cfRequestsFM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MD visits=$cfRequestsMD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MC visits=$cfRequestsMC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MN visits=$cfRequestsMN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ME visits=$cfRequestsME $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MS visits=$cfRequestsMS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MA visits=$cfRequestsMA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MZ visits=$cfRequestsMZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MM visits=$cfRequestsMM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NA visits=$cfRequestsNA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NR visits=$cfRequestsNR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NP visits=$cfRequestsNP $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NL visits=$cfRequestsNL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NC visits=$cfRequestsNC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NZ visits=$cfRequestsNZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NI visits=$cfRequestsNI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NE visits=$cfRequestsNE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NG visits=$cfRequestsNG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NU visits=$cfRequestsNU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NF visits=$cfRequestsNF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MP visits=$cfRequestsMP $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=NO visits=$cfRequestsNO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=OM visits=$cfRequestsOM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PK visits=$cfRequestsPK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PW visits=$cfRequestsPW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PS visits=$cfRequestsPS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PA visits=$cfRequestsPA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PG visits=$cfRequestsPG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PY visits=$cfRequestsPY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PE visits=$cfRequestsPE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PH visits=$cfRequestsPH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PN visits=$cfRequestsPN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PL visits=$cfRequestsPL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PT visits=$cfRequestsPT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PR visits=$cfRequestsPR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=QA visits=$cfRequestsQA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MK visits=$cfRequestsMK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=RO visits=$cfRequestsRO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=RU visits=$cfRequestsRU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=RW visits=$cfRequestsRW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=RE visits=$cfRequestsRE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=BL visits=$cfRequestsBL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SH visits=$cfRequestsSH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=KN visits=$cfRequestsKN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LC visits=$cfRequestsLC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=MF visits=$cfRequestsMF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=PM visits=$cfRequestsPM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VC visits=$cfRequestsVC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=WS visits=$cfRequestsWS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SM visits=$cfRequestsSM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ST visits=$cfRequestsST $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SA visits=$cfRequestsSA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SN visits=$cfRequestsSN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=RS visits=$cfRequestsRS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SC visits=$cfRequestsSC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SL visits=$cfRequestsSL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SG visits=$cfRequestsSG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SX visits=$cfRequestsSX $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SK visits=$cfRequestsSK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SI visits=$cfRequestsSI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SB visits=$cfRequestsSB $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SO visits=$cfRequestsSO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ZA visits=$cfRequestsZA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GS visits=$cfRequestsGS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SS visits=$cfRequestsSS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ES visits=$cfRequestsES $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=LK visits=$cfRequestsLK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SD visits=$cfRequestsSD $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SR visits=$cfRequestsSR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SJ visits=$cfRequestsSJ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SE visits=$cfRequestsSE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=CH visits=$cfRequestsCH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=SY visits=$cfRequestsSY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TW visits=$cfRequestsTW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TJ visits=$cfRequestsTJ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TZ visits=$cfRequestsTZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TH visits=$cfRequestsTH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TL visits=$cfRequestsTL $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TG visits=$cfRequestsTG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TK visits=$cfRequestsTK $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TO visits=$cfRequestsTO $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TT visits=$cfRequestsTT $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TN visits=$cfRequestsTN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TR visits=$cfRequestsTR $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TM visits=$cfRequestsTM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TC visits=$cfRequestsTC $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=TV visits=$cfRequestsTV $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=UG visits=$cfRequestsUG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=UA visits=$cfRequestsUA $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AE visits=$cfRequestsAE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=GB visits=$cfRequestsGB $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=UM visits=$cfRequestsUM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=US visits=$cfRequestsUS $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=UY visits=$cfRequestsUY $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=UZ visits=$cfRequestsUZ $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VU visits=$cfRequestsVU $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VE visits=$cfRequestsVE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VN visits=$cfRequestsVN $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VG visits=$cfRequestsVG $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=VI visits=$cfRequestsVI $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=WF visits=$cfRequestsWF $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=EH visits=$cfRequestsEH $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=YE visits=$cfRequestsYE $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ZM visits=$cfRequestsZM $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=ZW visits=$cfRequestsZW $cfTimeStamp"
    curl -i -XPOST "$InfluxDBURL:$InfluxDBPort/write?precision=s&db=$InfluxDB" -u "$InfluxDBUser:$InfluxDBPassword" --data-binary "cloudflare_analytics_country,country=AX visits=$cfRequestsAX $cfTimeStamp"


    
