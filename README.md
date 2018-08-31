# **datastage2docker**
Docker resources to build IBM DataStage image for CI purpose.

# How to use this repository
## Setup the `docker-machine`
- Ensure that the host operating system has at least 5 GB memory. (Increase VirtualBox VM memory)
- Ensure that the host has at least 60 Gb to hold the docker images you build

Example for virtualbox driver:

    docker-machine create -d virtualbox -virtualbox-memory "5120" --virtualbox-disk-size "61440" --virtualbox-cpu-count "2" default

## Network setup
Create a user-defined network, it's necessary at build time to access the DB2 container and the service tier.

    docker network create infosphere

## Download files :
- `IS_V11.7_LINUX_X86_64_MULTILING.tar.gz` (CNR06ML)
- `IIS_ENTERPRISE_EDITION_V11.7_BUND.zip` or any valid licence file (update the ENV $INSTALL_FILE_SPEC)

Copy them into the `iis-installer` directory

## Build the installer image
`cd` into the `iis-installer` directory.  
Edit the `build.sh` script and change the tag name (the tag is for my own use...)

Create the iis-installer volume

    docker volume create iis-installer

## Build the `db2express-c` image
Download the db2express-c v11.1 package for linux from IBM website(**v11.1_linuxx64_expc.tar.gz**) and copy it into the `db2express-c` directory

Create the db2data volume that hold the data for the db2inst1 instance :

    docker volume create db2data

`cd` into `db2express-c` directory

Launch the image build, take a look at the [Dockerfile](./db2express-c/Dockerfile):

    ./build.sh 

Once the build is done and no major error happens, you can run the container

>At Build time, there is actually no way to set the IPC option with the `docker build` command so at the end of the installation db2start do nothing and end with a SQL Error but the installation ends with a exit code 0

    ./run-db2.sh

Now you can create database and do want you want, DB2 is alive, ALIVE !

To install XMETA database :

    su - db2inst1
    cd /install
    ./create_xmeta_db.sh
    ./configure_staging_area.sh
    @TODO Flow Designe USER PREF!!

To drop DROP XMETA database if necessary :

    # ./entrypoint.sh run db2 DROP DATABASE XMETA

Check the logs, it come from the tail -F db2diag.log into the [entrypoint.sh](./db2express-c/entrypoint.sh)

    docker logs -f db2


@TODO docker network connect --alias db2box iis-network db2

### Références
- https://www.ibm.com/developerworks/data/library/techarticle/dm-1602-db2-docker-trs/index.html
# References
## https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.install.doc/tasks/tiginstall_db2docker.htm
## 