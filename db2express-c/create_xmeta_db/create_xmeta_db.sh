#!/bin/sh
# ==============================================================================
# IBM Information Server metadata repository database creation for DB2
# Version 11.1
#
# Copyright (C) 2009-2017 IBM Corporation. All rights reserved.
# ==============================================================================
if [ ! -f  $HOME/sqllib/db2profile ]; then
   echo $HOME/sqllib/db2profile not found. Please log in as the DB2 instance owner.
   exit 1
fi

. $HOME/sqllib/db2profile

if [ "`echo -n`" = "-n" ]; then
    n=""; c="\c"
else
    n="-n"; c=""
fi

if [ "$1" = "-batch" ]; then
    IS_BATCH=TRUE
    shift
else
    IS_BATCH=FALSE
fi

SCRIPT_DIR=`dirname $0`

echo
echo The IBM Information Server metadata repository database will be created.
echo Ensure that the following parameters are replaced in the
echo create_xmeta_db.sql script:
echo
echo   Database : @DATABASE_NAME@
echo   Install location : @INSTALL_ROOT@
echo   Database alias  : @DATABASE_ALIAS@
echo   Database user name : @DATABASE_USERNAME@
echo

if [ "$IS_BATCH" != "TRUE" ]; then
    echo $n 'Press [CTRL/C]; to abort or [ENTER] to continue' $c; read ans
fi

echo Creating Database ...

db2set DB2_INLIST_TO_NLJN=YES
db2set DB2_USE_ALTERNATE_PAGE_CLEANING=ON
db2set DB2_REDUCED_OPTIMIZATION=YES

db2 connect reset > /dev/null
db2 terminate > /dev/null

if [ "$1" = "" ]
then
    db2 -stf $SCRIPT_DIR/create_xmeta_db.sql
else
    if [ -f "$1" ]
    then
        rm "$1"
    fi
    db2 -l "$1" -stf $SCRIPT_DIR/create_xmeta_db.sql
fi

if [ "$?" = "4" ];
then
    echo DB INITIALIZATION FAILED
    if [ "$1" != "" ]
    then
        echo See "$1" for more details.
    fi
    exit 1
fi

echo DB INITIALIZATION WAS SUCCESSFUL
exit 0

