#!/bin/bash 

# Original script from https://github.com/gregvw/amd_sdk/
# Original modification from https://gist.github.com/vchuravy/1faa40c2df51e3a9ee55#file-amd_sdk-sh

# Location from which get nonce and file name from
URL="http://developer.amd.com/tools-and-sdks/opencl-zone/opencl-tools-sdks/amd-accelerated-parallel-processing-app-sdk/"
URLDOWN="http://developer.amd.com/amd-license-agreement-appsdk/"

NONCE1_STRING='name="amd_developer_central_downloads_page_nonce"'
FILE_STRING='name="f"'
POSTID_STRING='name="post_id"'
NONCE2_STRING='name="amd_developer_central_nonce"'

FORM=`wget -qO - $URL | sed -n '/download-5/,/64-bit/p'`

# Get nonce from form
NONCE1=`echo $FORM | awk -F ${NONCE1_STRING} '{print $2}'`
NONCE1=`echo $NONCE1 | awk -F'"' '{print $2}'`
echo $NONCE1

# get the postid
POSTID=`echo $FORM | awk -F ${POSTID_STRING} '{print $2}'`
POSTID=`echo $POSTID | awk -F'"' '{print $2}'`
echo $POSTID

# get file name
FILE=`echo $FORM | awk -F ${FILE_STRING} '{print $2}'`
FILE=`echo $FILE | awk -F'"' '{print $2}'`
echo $FILE

FORM=`wget -qO - $URLDOWN --post-data "amd_developer_central_downloads_page_nonce=${NONCE1}&f=${FILE}&post_id=${POSTID}"`

NONCE2=`echo $FORM | awk -F ${NONCE2_STRING} '{print $2}'`
NONCE2=`echo $NONCE2 | awk -F'"' '{print $2}'`
echo $NONCE2

wget -c --content-disposition --trust-server-names $URLDOWN --post-data "amd_developer_central_nonce=${NONCE2}&f=${FILE}" -O AMD-SDK.tar.bz2;

tar xjf AMD-SDK.tar.bz2

mkdir AMD_SDK
sh AMD*.sh --noexec --target AMD_SDK

cd AMD_SDK && ./install.sh -s y -a y

