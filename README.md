# datastage2docker
Docker resources to build IBM DataStage image for CI purpose.

# How to use this repository
## Setup the `docker-machine`
- Ensure that the host operating system has at least 5 GB memory. (Increase VirtualBox VM memory)
- Ensure that the host has at least 60 Gb to hold the docker image you build
```
docker-machine create -d virtualbox -virtualbox-memory "5120" --virtualbox-disk-size "61440" --virtualbox-cpu-count "2" default
```
## Download files :
- `IS_V11.7_LINUX_X86_64_MULTILING.tar.gz` (CNR06ML)
- `IIS_ENTERPRISE_EDITION_V11.7_BUND.zip` or any valid licence file (update the ENV $INSTALL_FILE_SPEC)

Copy them into the `iis-installer` directory

## Build the installer image
`cd` into the `iis-installer` directory.  
Edit the `build.sh` script and change the tag name (the tag is for my own use...)

# References
## https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.install.doc/tasks/tiginstall_db2docker.htm
## https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance
