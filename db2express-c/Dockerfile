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

# Prerequisite
# Download files : v11.1_linuxx64_expc.tar.gz :: $INSTALL_FILE_PAYLOAD
# Copy them into the "db2-expc" directory

# References
# ----------
# https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.install.doc/tasks/tiginstall_db2docker.htm
# https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance
# https://www.ibm.com/developerworks/data/library/techarticle/dm-1602-db2-docker-trs/index.html
# https://www.ibm.com/support/knowledgecenter/SSZJPZ_11.7.0/com.ibm.swg.im.iis.productization.iisinfsv.install.doc/topics/wsisinst_pre_using_db2_manual_linuxunix.html
#

# Pull base image
# ---------------
FROM centos:7

# Maintainer
#-----------
LABEL maintainer="jerome.henri.delvigne@gmail.com"

# docker-machine prerequisite
# ---------------------------
# Ensure that the host operating system has at least 4 GB memory. (Increase VirtualBox VM memory)
# Ensure that the host has at least 40 Gb to hold the docker image you build
# docker-machine rm default
# docker-machine create -d virtualbox -virtualbox-memory "5120" --virtualbox-disk-size "61440" --virtualbox-cpu-count "2" default

# launch docker run with
# ----------------------
#   DB2 requirement

# Environment variables required for this build (empty)
# -------------------------------------------------------------
ENV HOME="/root" \
    INSTALL_FILE_PAYLOAD="v11.1_linuxx64_expc.tar.gz" \
    DB2_REPONSE_FILE="db2_install.rsp" \
    INSTALL_DIR="/install"

# Update and install required tools and libraries
# -----------------------------------------------
RUN yum install -y \
    file \
    net-tools \
    which \
    bc \
    numactl-libs \
    pam \
    pam.i686 \
    libXp \
    libXmu \
    libXrender \
    libXtst \
    libXft \
    libaio && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir -p ${INSTALL_DIR} && \
    mkdir -p ${INSTALL_DIR}/logs

# Fix Warning about libpam.so* (Pluggable Authentication Module) during DB2 installation or db2prereqcheck
# http://www-01.ibm.com/support/docview.wss?uid=swg21612536
# -----------------------------------------------
RUN cd /lib && \
    ln -s libpam.so.0.83.1 libpam.so

# Add Users and Groups needed by DB2 and the IIS Repository Tier
RUN /usr/sbin/groupadd db2iadm1 && \
    /usr/sbin/useradd -g db2iadm1 -d /home/db2inst1 -m -s /bin/bash db2inst1 && \
    echo -e "db2inst1\ndb2inst1\n" | passwd db2inst1 && \
    /usr/sbin/groupadd db2fadm1 && \
    /usr/sbin/useradd -g db2fadm1 -d /home/db2fenc1 -m -s /bin/bash db2fenc1 && \
    echo -e "db2fenc1\ndb2fenc1\n" | passwd db2fenc1 && \
    /usr/sbin/groupadd xmeta && \
    /usr/sbin/useradd -g xmeta -d /home/xmeta -m -s /bin/bash xmeta && \
    echo -e "xmeta\nxmeta\n" | passwd xmeta && \
    /usr/sbin/groupadd xmetasr && \
    /usr/sbin/useradd -g xmetasr -d /home/xmetasr -m -s /bin/bash xmetasr && \
    echo -e "xmetasr\nxmetasr\n" | passwd xmetasr && \
    /usr/sbin/groupadd dsodb && \
    /usr/sbin/useradd -g dsodb -d /home/dsodb -m -s /bin/bash dsodb && \
    echo -e "dsodb\ndsodb\n" | passwd dsodb

# Copy binaries and all install stuff
# ----------------------------------
COPY create_xmeta_db ${INSTALL_FILE_PAYLOAD} ${DB2_REPONSE_FILE} ${INSTALL_DIR}/

# Unpacking $INSTALL_FILE_PAYLOAD it creates a "expc" dir
# Finally we create the dir that will contains the response files
# ---------------------------------------------------------------
RUN cd ${INSTALL_DIR} && \
    tar -xzf ${INSTALL_FILE_PAYLOAD} && \
    rm ${INSTALL_FILE_PAYLOAD}

# Install DB2 with the response file
# ----------------------------------
RUN ${INSTALL_DIR}/expc/db2setup \
    -r ${INSTALL_DIR}/${DB2_REPONSE_FILE} \
    -l ${INSTALL_DIR}/logs/db2setup.log \
    -t ${INSTALL_DIR}/logs/db2setup.trc

# Copy entrypoint script
# ----------------------
COPY entrypoint.sh ${HOME}/

# DB2 instance port
# -----------------
EXPOSE 50000

# This image launch the installation program
# ------------------------------------------
ENTRYPOINT [ "/root/entrypoint.sh", "start" ]
