# RED='\033[0;31m'
# NC='\033[0m'

function help () {
    Write-Output "Usage:\n"
    Write-Output "Run using prebuild docker image:\n"
    Write-Output "\t./run.sh source_dir out_dir\n\n"
    Write-Output "Manually build the docker image and run it:\n"
    Write-Output "\t./run.sh -b source_dir out_dir\n"
    exit 0
}

function check_path () {
    local path=$1
    local number=$2
    if (-not (Test-Path -Path $path -PathType Container )) { Write-Output "${RED}The ${number} argument is not a directory${NC}\n\n"; help }
    if (-not ([System.IO.Path]::IsPathRooted($path))) {Write-Output "${RED}The ${number} argument is not an absolute path${NC}\n\n"; help }
}

# if (-not [ ! -x "$(command -v docker)" ]; Write-Output "${RED}Could not find docker, make sure that you have docker installed${NC}" && exit 0

if (("$1" -eq "-b") -and ($args.Count -eq  3)) {
    check_path $2 "second"
    check_path $3 "third"

    has_tools=$(docker images | grep time-analysis-tools | wc -l)
    if ($has_tools -eq 0) { docker build -t time-analysis-tools -f Dockerfile .}
    docker run --rm -it -v ${2}:/root/source -v ${3}:/root/out time-analysis-tools
}
elseif ($args.Count -eq 2 ){
    check_path $1 "first"
    check_path $2 "second"
    docker run --rm -it -v ${1}:/root/source -v ${2}:/root/out eskehoy/ct-analysis-tools:latest
}
else {help}

