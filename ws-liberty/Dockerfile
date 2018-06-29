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

# Pull base image
# ---------------
FROM jdelvign/iis-installer:11.7

# Environment variables required for this build (empty)
# -------------------------------------------------------------
ENV RESPONSE_FILE="was-response.txt" \
    INSTALL_DIR="/install"

# install "service package"

# Copy response file
# ------------------
COPY $RESPONSE_FILE $INSTALL_DIR/

# Add Users and Groups needed by the Repository Tier

RUN $INSTALL_DIR/is-suite/setup -rsp $INSTALL_DIR/$RESPONSE_FILE -verbose

# WebSphere Liberty instance port 
EXPOSE 9080 9446

ENTRYPOINT [ "/opt/IBM/InformationServer/ASBServer/bin/MetadataServer.sh", "run"]
