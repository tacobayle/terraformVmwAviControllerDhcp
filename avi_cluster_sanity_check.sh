#!/bin/bash
retry=20
pause=30
attempt=0
#
sleep 120
#
until $(curl --output /dev/null --silent --head -k https://$(jq -r .avi_controller_ips[0] controllers.json)); do echo 'Waiting for Avi Controllers to be ready'; sleep 10 ; done
curl -s -k -X POST -H "Content-Type: application/json" -d '{"username": "admin", "password": '$(jq .avi_password .password.json)'}' -c avi_cookie.txt https://$(jq -r .avi_controller_ips[0] controllers.json)/login
#
attempt=0
while [ $attempt -ne $retry ]; do
  echo "############################################################################################"
  IFS=$'\n'
  nodes_ready=0
  for status_nodes in $(curl -s -k -X GET -H "Content-Type: application/json" -b avi_cookie.txt  https://$(jq -r .avi_controller_ips[0] controllers.json)/api/cluster/status | jq -c .node_states)
    do
      for status_node in $(echo $status_nodes | jq  -r -c .[].state)
        do
          if [[ $status_node == "CLUSTER_ACTIVE" ]] ; then
            ((nodes_ready++))
          else
            echo "One of the Node is not ready"
          fi
        done
    done
  if [ $nodes_ready -eq "3" ] ; then
    echo "Amount of nodes READY: 3 - PASSED"
    exit
  else
    echo "Amount of nodes READY: $nodes_ready, expected: 3 - RETRY"
    ((attempt++))
    sleep $pause
  fi
done
exit 255