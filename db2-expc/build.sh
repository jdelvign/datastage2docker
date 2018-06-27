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


# IIS Database Image Name
IMAGE_NAME="jdelvign/db2-expc:11.1"

docker build --force-rm=true -t $IMAGE_NAME . || {
  echo ""
  echo "ERROR: DB2 Express-C v11.1 Docker Image was NOT successfully created."
  echo "ERROR: Check the output and correct any reported problems with the docker build operation."
  exit 1
}
echo ""
