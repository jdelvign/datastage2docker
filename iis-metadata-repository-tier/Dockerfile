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
ENV RESPONSE_FILE_DB2="db2-response.txt" \
    INSTALL_DIR="/install"

# Set the working directory to $INSTALL_DIR
# -----------------------------------------
WORKDIR $INSTALL_DIR

# Copy response file
# ------------------
COPY $RESPONSE_FILE_DB2 ./

# Add Users and Groups needed by the Repository Tier
RUN /usr/sbin/groupadd db2iadm1 && \
    /usr/sbin/useradd -g db2iadm1 -d /home/db2inst1 -m -s /bin/sh db2inst1 && \
    echo -e "db2inst1\ndb2inst1\n" | passwd db2inst1 && \
    /usr/sbin/groupadd db2fadm1 && \
    /usr/sbin/useradd -g db2fadm1 -d /home/db2fenc1 -m -s /bin/sh db2fenc1 && \
    echo -e "db2fenc1\ndb2fenc1\n" | passwd db2fenc1 && \
    /usr/sbin/groupadd xmeta && \
    /usr/sbin/useradd -g xmeta -d /home/xmeta -m -s /bin/sh xmeta && \
    echo -e "xmeta\nxmeta\n" | passwd xmeta && \
    /usr/sbin/groupadd xmetasr && \
    /usr/sbin/useradd -g xmetasr -d /home/xmetasr -m -s /bin/sh xmetasr && \
    echo -e "xmetasr\nxmetasr\n" | passwd xmetasr && \
    /usr/sbin/groupadd dsodb && \
    /usr/sbin/useradd -g dsodb -d /home/dsodb -m -s /bin/sh dsodb && \
    echo -e "dsodb\ndsodb\n" | passwd dsodb

#RUN $INSTALL_DIR/is-suite/setup -rsp $INSTALL_DIR/$RESPONSE_FILE_DB2 -verbose

# DB2 instance port 
EXPOSE 50000

#ENTRYPOINT [ "/bin/bash", "-c", "su -c 'db2start' - db2inst1"]
