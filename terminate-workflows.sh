#!/bin/bash
#
# author: mike lee
# date  : 2018.11.14
#
# terminate-workflow.sh
# usage: terminates all open workflow executions in SWF

DOMAIN='ws-integration-domain'

list_open_workflow_executions() {
  aws swf list-open-workflow-executions --domain "$DOMAIN" --start-time-filter oldestDate=0,latestDate=$(date +%s) | jq -r '.executionInfos[].execution.workflowId'
}

terminate_workflow_executions() {
  for wid in $(list_open_workflow_executions)
  do
    aws swf terminate-workflow-execution --domain "$DOMAIN" --workflow-id "$wid"
    echo "Terminating: $wid"
  done
}

trap "echo Exited!; exit;" SIGINT SIGTERM

terminate_workflow_executions
exit 0
