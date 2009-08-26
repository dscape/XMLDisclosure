#!/bin/sh
################################################################################
##                                                                            ##
##  Unit Test                                                                 ##
##    Author: Nuno Job  ( nunojobpinto at gmail )                             ##
##    Date: August 2009                                                       ##
##    License: creativecommons.org/licenses/by/3.0                            ##
##                                                                            ##
################################################################################
db2 connect to $1 > /dev/null
db2 "call xmldisclosure.filter('', 'contact')"
