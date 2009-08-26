#!/bin/sh
################################################################################
##                                                                            ##
##  Script: install.sh                                                        ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################

######################################################################~ START ##
sudo clear
echo "Installing XML Disclosure"

################################################################~ READ CONFIG ##
echo "  . Reading configuration file"
. ./config.sh

####################################################################~ COMPILE ##
echo "  . Compiling class from source (PrivacyFunctions)"
$jdk/javac \
  -classpath .:"$XD_DB2/java/db2jcc.jar:$XD_DB2/java/db2jcc_license_cu.jar" \
  -d class \
  -Xlint \
  src/PrivacyFunctions.java \
  > $XD_INST_LOG 2>&1

####################################################################~ PACKAGE ##
echo "  . Packaging the jar file (xmldisclosure.jar)"

$XD_JDK/jar \
  cf \
  jar/xmldisclosure.jar \
  class/XMLDISCLOSURE/PrivacyFunctions.class \
  >> $XD_INST_LOG 2>&1

###################################################################~ DB2START ##
echo "  . Ensuring DB2 is started"
db2start \
  >> $XD_INST_LOG

db2 \
  connect reset \
  > /dev/null

###################################################################~ DB2SAMPL ##
echo "  . Checking for $XD_DB2_DB XML database (creates if applicable)"
db2sampl \
  -xml \
  -name $XD_DB2_DB \
  >> $XD_INST_LOG 2>&1

####################################################################~ CONNECT ##
echo "  . Connecting to database ($XD_DB2_DB)"
db2 \
  connect to $XD_DB2_DB \
  >> $XD_INST_LOG

##################################################~ REGISTER PrivacyFunctions ##
echo "  . Registering the privacy functions with db2"
cp \
  -r \
  class/* \
  $XD_DB2_FN \
  >> $XD_INST_LOG 2>&1

###############################################################~ REGISTER SPs ##
echo "  . Registering the stored procedures"
db2 \
  -td@ \
  -vf \
  ddl/register_procedures.db2 \
  >> $XD_INST_LOG
  
##############################################################~ CONNECT RESET ##
echo "  . Disconnecting"
db2 \
  connect reset \
  >> $XD_INST_LOG

########################################################################~ EOF ##
echo "XMLDisclosure processing COMPLETE"
echo "Please refer to $XD_INST_LOG for a detailed log file"
