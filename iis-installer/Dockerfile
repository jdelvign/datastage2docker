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
# Download files :
# - IS_V11.7_LINUX_X86_64_MULTILING.tar.gz (CNR06ML) :: $INSTALL_FILE_PAYLOAD
# - IIS_ENTERPRISE_EDITION_V11.7_BUND.zip (??) Or any valid licence file :: $INSTALL_FILE_SPEC
# Copy them into iis-installer directory

# References
# ----------
# https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.install.doc/tasks/tiginstall_db2docker.htm
# https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance
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

# launch docker run with
# ----------------------
#   DB2 requirement
#   --sysctl kernel.msgmax=65536
#   --sysctl kernel.msgmnb=65536

# Environment variables required for this build (empty)
# -------------------------------------------------------------
ENV INSTALL_FILE_PAYLOAD="IS_V11.7_LINUX_X86_64_MULTILING.tar.gz" \
    INSTALL_FILE_SPEC="IIS_ENTERPRISE_EDITION_V11.7_BUND.zip" \
    INSTALL_DIR="/install"

# Update and install required tools and libraries
# -----------------------------------------------
RUN yum install -y \
    unzip \
    net-tools \
    which \
    bc \
    pam \
    pam.i686 \
    libXp \
    libXmu \
    libaio && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir -p ${INSTALL_DIR}

# Copy binaries and licence file
# ------------------------------
COPY ${INSTALL_FILE_PAYLOAD} ${INSTALL_FILE_SPEC} ${INSTALL_DIR}/

# Unpacking $INSTALL_FILE_PAYLOAD it creates a "is-suite" dir
# Unpacking $INSTALL_FILE_SPEC into is-suite dir
# Finally we create the dir that will contains the response files
# ---------------------------------------------------------------
WORKDIR ${INSTALL_DIR}

RUN tar -xzf ${INSTALL_FILE_PAYLOAD} && \
    rm ${INSTALL_FILE_PAYLOAD} && \
    unzip ${INSTALL_FILE_SPEC} -d is-suite && \
    rm ${INSTALL_FILE_SPEC} && \
    mkdir /responsefiles

# Volume on it 
# ---------------------------------------------------
VOLUME ["/responsefiles"]

# The installation program listen to 8446
# ---------------------------------------
EXPOSE 8446

# Set the working directory to ${INSTALL_DIR}/is-suite
# --------------------------------------------------
WORKDIR ${INSTALL_DIR}/is-suite

# This image laucnch the installation program
# -------------------------------------------
ENTRYPOINT [ "/bin/bash", "-c", "./setup", "-verbose" ]
