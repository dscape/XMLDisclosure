#!/bin/sh
################################################################################
##                                                                            ##
##  Script: uninstall.sh                                                      ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################

######################################################################~ START ##
sudo clear
echo "Uninstalling XML Disclosure"

################################################################~ READ CONFIG ##
echo "  . Reading configuration file"
. ./config.sh

#####################################################################~ REMOVE ##
echo "  . Removing unnecessary folders"
rm -r class/* > $XD_UNST_LOG 2>&1
rm -r jar/* >> $XD_UNST_LOG 2>&1
rm -r log/* >> $XD_UNST_LOG 2>&1
rm -r $XD_DB2_FN/XMLDisclosure >> $XD_UNST_LOG 2>&1

########################################################################~ DB2 ##
if [ "$1" = "all" ]; then
  echo "  . Restarting DB2"
  db2stop force >> $XD_UNST_LOG
  db2start >> $XD_UNST_LOG
  
  echo "  . Dropping the $XD_DB2_DB database"
  db2 \
    drop database $XD_DB2_DB \
    >> $XD_UNST_LOG 2>&1
fi
########################################################################~ EOF ##
echo "XMLDisclosure processing COMPLETE"
echo "Please refer to $XD_UNST_LOG for a detailed log file"
