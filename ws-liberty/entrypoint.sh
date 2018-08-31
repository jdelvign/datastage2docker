#!/bin/bash 
# ---------------------------------------------------------------------------
#   Copyright 2018 Jerome Delvigne
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# ---------------------------------------------------------------------------

set -x

SERVER="/opt/IBM/InformationServer/ASBServer/bin/MetadataServer.sh"

function start { 
    trap stop SIGTERM 
    echo "Attempting to stop WAS server" 
    ${SERVER} stop 
    echo "Attempting to start WAS server" 
    ${SERVER} run
    echo WAS started on `date` 
    tail -F /opt/IBM/InformationServer/wlp/usr/servers/iis/logs/messages.log & LOG_PID=$!
    wait $LOG_PID 
} 
    
function stop {
    echo "Attempting to stop WAS server" 
    ${SERVER} stop 
    echo IIS stopped on `date` 
    exit 
} 

"$@"
