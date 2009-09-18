#!/bin/sh
################################################################################
##                                                                            ##
##  Script: config.sh                                                         ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################

#####################################################################~ CONFIG ##
## Please modify these values only if necessary. log can remain the same.     ##
## Change the db if you want to use with another database.                    ##
################################################################################
log_i=log/install_$(date -u +%m-%d-%Y-%H.%M).log    # installation log
log_u=log/uninstall_$(date -u +%m-%d-%Y-%H.%M).log  # uninstallation log
log_t=log/test_$(date -u +%m-%d-%Y-%H.%M).log       # test log

# jdk ##########################################################################
jdk=/usr/bin # jdk location (bin folder), whereis javac, whereis jar

# db2 ##########################################################################
db2=/opt/ibm/db2/V9.7              # db2 location
database=sample                    # database to be used
fn=/home/$(whoami)/sqllib/function # the instance's function folder

################################################################~ /END CONFIG ##
## End of necessary changes. Please don't edit bellow this line               ##
## Unless you really want to.. In that case go nuts!                          ##
################################################################################

# environment ##################################################################
instance=`whoami`                               # the current instance
db2l=`db2level | \
      sed 's/.*\(DB2 v[1-9].[0-9]\).*/\1/' | \
      grep "DB2 v" | \
      sed "s/DB2 v//g"`                         # DB2level

# create dirs ##################################################################
# only if they still don't exist!
mkdir class > /dev/null 2>&1 # for .class
mkdir jar > /dev/null 2>&1   # for .jar
mkdir log > /dev/null 2>&1   # for .log

# permissions ##################################################################
sudo chmod -R 777 jar/ class/ log/ 
sudo find . -type f -name \*.sh -exec chmod 755 {} \;
sudo find . -type f -name \*.rb -exec chmod 755 {} \;
sudo find . -type f -name \*.out -exec chmod 644 {} \;
sudo find . -type f -name \*.log -exec chmod 666 {} \;

####################################################################~ EXPORTS ##
export XD_INST_LOG=$log_i
export XD_UNST_LOG=$log_u
export XD_TEST_LOG=$log_t
export XD_JDK=$jdk
export XD_DB2_LVL="$db2l"
export XD_DB2_INST=$instance
export XD_DB2_DB=$database
export XD_DB2_FN=$fn
export XD_DB2=$db2

##################################################################~ PRINT ENV ##
echo "    DB:             $database"
echo "    DB2 Instance:   $instance"
echo "    DB2 Version:    $db2l"
echo "    DB2 Path:       $db2"
echo "    DB2Fn Path:     $fn"
echo "    JDK Path:       $jdk"
