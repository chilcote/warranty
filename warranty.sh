#!/bin/bash
# warranty.sh
# Description: looks up Apple warranty info for 
# this computer, or one specified by serial number 

# Based on a script by Scott Russell, IT Support Engineer, 
# University of Notre Dame
# http://www.nd.edu/~srussel2/macintosh/bash/warranty.txt
# Edited to add the ASD Versions by Joseph Chilcote
# Last Modified: 09/16/2010

###############
##  GLOBALS  ##
###############

WarrantyTempFile="/tmp/warranty.txt"
AsdCheck="/tmp/asdcheck.txt"

if [[ $# == 0 ]] ; then
	SerialNumber=`system_profiler SPHardwareDataType | grep "Serial Number" | awk -F ': ' {'print $2'} 2>/dev/null`
else
	SerialNumber="${1}"
fi

[[ -n "${SerialNumber}" ]] && WarrantyInfo=`curl -k -s "https://selfsolve.apple.com/Warranty.do?serialNumber=${SerialNumber}&country=USA&fullCountryName=United%20States" | awk '{gsub(/\",\"/,"\n");print}' | awk '{gsub(/\":\"/,":");print}' > ${WarrantyTempFile}`

curl https://github.com/chilcote/warranty/raw/master/asdcheck -o ${AsdCheck} > /dev/null 2>&1

#################
##  FUNCTIONS  ##
#################

GetWarrantyValue()
{
	grep ^"${1}" ${WarrantyTempFile} | awk -F ':' {'print $2'}
}
GetWarrantyStatus()
{
	grep ^"${1}" ${WarrantyTempFile} | awk -F ':' {'print $2'}
}
GetModelValue()
{
	grep "${1}" ${WarrantyTempFile} | awk -F ':' {'print $2'}
}
GetAsdVers()
{
	#echo "${AsdCheck}" | grep -w "${1}:" | awk {'print $1'}
	grep "${1}:" ${AsdCheck} | awk {'print $1'}
}


###################
##  APPLICATION  ##
###################

echo "$(date) ... Checking warranty status"
InvalidSerial=`grep "serial number provided is invalid" "${WarrantyTempFile}"`

if [[ -e "${WarrantyTempFile}" && -z "${InvalidSerial}" ]] ; then
	echo "Serial Number    ==  ${SerialNumber}"

	PurchaseDate=`GetWarrantyValue PURCHASE_DATE`
	echo "PurchaseDate     ==  ${PurchaseDate}"
	
	WarrantyExpires=`GetWarrantyValue COVERAGE_DATE`
	echo "WarrantyExpires  ==  ${WarrantyExpires}"

	WarrantyStatus=`GetWarrantyStatus COVERAGE_DESC`
	echo "WarrantyStatus   ==  ${WarrantyStatus}"

	ModelType=`GetModelValue PROD_DESC`
	echo "ModelType        ==  ${ModelType}"

	AsdVers=`GetAsdVers "${ModelType}"`
	echo "ASD              ==  ${AsdVers}"
else
	[[ -z "${SerialNumber}" ]] && echo "     No serial number was found."
	[[ -n "${InvalidSerial}" ]] && echo "     Warranty information was not found for ${SerialNumber}."
fi

exit 0
