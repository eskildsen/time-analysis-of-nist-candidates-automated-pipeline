#!/bin/bash

help () {
    printf "Run using prebuild docker image:\n"
    printf "\t./run.sh source_dir out_dir\n\n"
    printf "Manually build the docker image and run it:\n"
    printf "\t./run.sh -b source_dir out_dir\n"
    exit 0
}

[ ! -x "$(command -v docker)" ] && printf "Could not find docker, make sure that you have docker installed" && exit 0

if [ "$1" == "-b" ] && [ $# -eq 3 ]; then
    [ ! -d $2 ] && printf "Second argument is not a directory\n\n" && help
    [ ! -d $3 ] && printf "Third argument is not a directory\n\n" && help

    docker build -t time-analysis-tools -f Dockerfile .
    docker run --rm -it -v ${2}:/root/source -v ${3}:/root/out time-analysis-tools

elif [ $# -eq 2 ]; then
    [ ! -d "$1" ] && printf "First argument is not a directory\n\n" && help
    [ ! -d "$2" ] && printf "Second argument is not a directory\n\n" && help

    docker run --rm -it -v ${1}:/root/source -v ${2}:/root/out eskildsen/time-analysis

else
    help
fi
