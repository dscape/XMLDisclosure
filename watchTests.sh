#!/bin/sh
################################################################################
##                                                                            ##
##  Script: watchTests.sh                                                     ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################

######################################################################~ START ##
sudo clear
echo "Testing XML Disclosure"

################################################################~ READ CONFIG ##
. ./config.sh

###################################################################~ DB2START ##
echo "  . Ensuring DB2 is started"
db2start \
  >> $XD_TEST_LOG

db2 \
  connect reset \
  > /dev/null

####################################################################~ CONNECT ##
echo "  . Connecting to database ($XD_DB2_DB)"
db2 \
  connect to $XD_DB2_DB \
  >> $XD_TEST_LOG

#######################################################################~ READ ##
echo "Press a key to watch tests. Ctrl+C to end"
echo "Please refer to $XD_TEST_LOG for a detailed log file"
read c
clear

######################################################################~ WATCH ##
watch --interval 2 ./runTests.rb $XD_DB2_DB
