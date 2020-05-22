#!/bin/bash
SRC_DIR="/usr/share/sources"
COMMON_DIR="${SRC_DIR}/common"
FLOWTRACKER_DIR="${SRC_DIR}/flowtracker"
SETTINGS="${COMMON_DIR}/settings.h"
FLOWTRACKER_XML="${FLOWTRACKER_DIR}/encrypt_key.xml"

# Verify that required files are in /root/source/
[ ! -d "/root/source" ] && printf "Error: No source directory mounted\n" && exit 1
[ ! -f "/root/source/encrypt.c" ] && printf "Error: Could not find the encrypt.c in source folder\n" && exit 1
[ ! -f "/root/source/api.h" ] && printf "Error: Could not find the encrypt.c in source api.h\n" && exit 1

# Check if user provided settings.h and load settings
[ ! -f "/root/source/settings.h" ] && SETTINGS="/root/source/settings.h"
while read -r def var val; do
    printf -v $var "$val"
    echo $var
done < <(cat $SETTINGS | grep -E '^#define[ \t]+[a-zA-Z_][0-9a-zA-Z_]+')

[ ${ANALYSE_ENCRYPT} -ne 1 ] && FLOWTRACKER_XML="${FLOWTRACKER_DIR}/decrypt_key.xml"


# Compile encrypt.c with dudect


# Compile encrypt.c with ctgrind


# Compile encrypt.c with flowtracker


# Execute


# Write summary

