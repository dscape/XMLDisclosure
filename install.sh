#!/bin/sh
################################################################################
##                                                                            ##
##  Script: install.sh                                                        ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################

#####################################################################~ CONFIG ##
## Please modify these values only if necessary. log can remain the same.     ##
##                                                                            ##
## Some predefined values for ubuntu + optim development studio and mac os x  ##
## leopard can be found in this section. Please use only one of the values    ##
## and comment the other one. Change them to fit your environment.            ##
##                                                                            ##
## Change the db if you want to use with another database.                    ##
################################################################################
log=log/run_$(date -u +%m-%d-%Y-%H.%M).log

# ubuntu #######################################################################
jdk=/opt/IBM/ODS2.2/jdk/bin
db2=/opt/ibm/db2/V9.7/java
fn=/home/$(whoami)/sqllib/function

# mac ##########################################################################
#jdk=/usr/bin/
#db2=/Volumes/Users/dscape/sqllib/java/

# database name ################################################################
db=sample

###################################################################~ CLEAN UP ##
clear

# remove classes, to force fail if recompile fails
rm -r class/* > /dev/null 2>&1
mkdir class > /dev/null 2>&1

# remove jar, to force fail if recompile fails
rm -r jar/* > /dev/null 2>&1
mkdir jar > /dev/null 2>&1

# create the log directory. Do not erase previous logs
mkdir log > /dev/null 2>&1

# set file permissions
sudo chmod -R 777 jar/ class/ log/

######################################################################~ START ##
echo "Installing XML Disclosure"

####################################################################~ COMPILE ##
echo "  . Compiling class from source (PrivacyFunctions)"
$jdk/javac \
  -classpath .:"$db2/db2jcc.jar:$db2/db2jcc_license_cu.jar" \
  -d class \
  -Xlint \
  src/PrivacyFunctions.java \
  >> $log 2>&1

####################################################################~ PACKAGE ##
echo "  . Packaging the jar file (xmldisclosure.jar)"

$jdk/jar \
  cf \
  jar/xmldisclosure.jar \
  class/XMLDISCLOSURE/PrivacyFunctions.class \
  >> $log 2>&1

###################################################################~ DB2START ##
echo "  . Ensuring DB2 is started"
db2start \
  >> $log

db2 \
  connect reset \
  > /dev/null

###################################################################~ DB2SAMPL ##
echo "  . Creating the $db XML database"
db2sampl \
  -xml \
  >> $log 2>&1

####################################################################~ CONNECT ##
echo "  . Connecting to database ($db)"
db2 \
  connect to $db \
  >> $log

##################################################~ REGISTER PrivacyFunctions ##
echo "  . Registering the privacy functions with db2"
cp \
  -r \
  class/* \
  $fn \
  >> $log 2>&1

###############################################################~ REGISTER SPs ##
echo "  . Registering the stored procedures"
db2 \
  -td@ \
  -vf \
  ddl/register_procedures.db2 \
  >> $log
  
##############################################################~ CONNECT RESET ##
echo "  . Disconnecting"
db2 \
  connect reset \
  >> $log

########################################################################~ EOF ##
echo "XMLDisclosure processing COMPLETE"
echo "Please refer to $log for a detailed log file"
