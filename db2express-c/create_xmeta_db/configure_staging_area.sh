#!/bin/sh

# ==============================================================================
# IBM Information Server Staging Area Creation for DB2
#
# Copyright (C) 2011 IBM Corporation. All rights reserved.
# ==============================================================================

if [ "'echo -n'" = "-n" ]; then
    n=""; c="\c"
else
    n="-n"; c=""
fi

echo
echo The IBM Information Server staging area will be configured.
echo Ensure that the following parameters are replaced in the
echo db2_grant_Permissions.sql script:
echo
echo   Database : @DATABASE_NAME@
echo   Staging Area user name : @DATABASE_USERNAME@
echo   Log file name : $1
echo
#echo $n 'Press [CTRL/C]; to abort or [ENTER] to continue' $c; read ans

echo Granting required permissions to staging area user .....

if [ "$1" = "" ]
then
    db2 -stf  db2_grant_Permissions.sql
else
    if [ -f "$1" ]
    then
        rm "$1"
    fi
    db2 -l "$1" -stf db2_grant_Permissions.sql
fi

if [ "$?" = "4" ];
then
    echo STAGING AREA CONFIGURATION FAILED
    if [ "$1" != "" ]
    then
        echo See "$1" for more details.
    fi
    exit 1
fi

echo STAGING AREA CONFIGURATION WAS SUCCESSFUL
exit 0


