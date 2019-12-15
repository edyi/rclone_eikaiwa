#!/bin/bash
# ログをSlackに送る
webhook="https://hooks.slack.com/services/***/***/***"

payload=$(cat /tmp/rclone.log)

slack(){
    status=report
    mention="<!here>"
    data="\`\`\`$payload\`\`\`"
    message="{\"text\":\"${data}\"}"
    head="Content-type: application/json"
    curl -X POST -H '${head}' --data "${message}" ${webhook}
}

slack