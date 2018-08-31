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
#   Setup the "iis-installer" image and docker volume

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
# Ensure that the host operating system has at least 5 GB memory. (Increase VirtualBox VM memory)
# Ensure that the host has at least 60 Gb to hold the docker image you build
# docker-machine rm default
# docker-machine create -d virtualbox -virtualbox-memory "5120" --virtualbox-disk-size "61440" --virtualbox-cpu-count "2" default


# launch docker run with
# ----------------------
#   DB2 requirement
#   --sysctl kernel.msgmax=65536
#   --sysctl kernel.msgmnb=65536

# Environment variables required for this build
# ---------------------------------------------
ENV HOME="/root" \
    INSTALL_DIR="/install"

# Update and install required tools and libraries
# -----------------------------------------------
RUN yum install -y \
    unzip \
    net-tools \
    which \
    bc \
    ed \
    gcc \
    libXp \
    libXmu \
    libaio && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir /responsefiles

# Create group dstage
# Create user dsadm
# /usr/sbin/useradd -g dstage -d /home/dsadm -m -s /bin/sh dsadm

# ASB agent port : 31531
# Job Monitor port 1: 13401
# Job Monitor port 1: 13402
# RPC port :31538
# -------------------------
EXPOSE 31531 13401 13402 31538

# This image laucnch the installation program
# -------------------------------------------
ENTRYPOINT [ "/root/entrypoint.sh", "start"]
