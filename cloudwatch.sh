#!/bin/sh
#EXAMPLE
#./cloudwatch.sh xxxxxxxxxx xxxxxxxxxxxx ap-northeast-1 AWS/RDS CPUUtilization DBInstanceIdentifier test-db
 
#FIELD
#======================================================================
AWS_PATH='/bin/aws'
STARTTIME=`/bin/date -u -d '5 minutes ago' +%Y-%m-%dT%TZ`
ENDTIME=`/bin/date -u +%Y-%m-%dT%TZ`
export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
REGION=$3
NAMESPACE=$4
DIMENSIONS=$5
HOST=$6
METRICS=$7
STATISTICS=$8
PERIOD=$9
#======================================================================

$AWS_PATH cloudwatch get-metric-statistics \
--output json \
--start-time $STARTTIME \
--end-time $ENDTIME \
--region $REGION \
--namespace $NAMESPACE \
--dimensions Name=$DIMENSIONS,Value=$HOST \
--metric-name $METRICS \
--statistics $STATISTICS \
--period 60 | jq -r '.Datapoints[] | [.Timestamp, .Average] | @csv' | sort -r | awk -F, '{print $2}' | awk 'NR==1'
