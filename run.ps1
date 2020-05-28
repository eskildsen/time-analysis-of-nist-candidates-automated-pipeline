# RED='\033[0;31m'
# NC='\033[0m'

function help {
    Write-Output "Usage:"
    Write-Output "Run using prebuild docker image:"
    Write-Output "   ./run.sh source_dir out_dir"
    Write-Output "Manually build the docker image and run it:"
    Write-Output "   ./run.sh -b source_dir out_dir"
    exit 0
}

function check_path {
    param ([string]$path, [string]$number)
    if (-not (Test-Path -Path $path -PathType Container )) { Write-Output "${RED}The $number argument is not a directory${NC}"; help }
    if (-not ([System.IO.Path]::IsPathRooted($path))) {Write-Output "${RED}The $number argument is not an absolute path${NC}"; help }
}

# if (-not [ ! -x "$(command -v docker)" ]; Write-Output "${RED}Could not find docker, make sure that you have docker installed${NC}" && exit 0

function has_tools {
    docker images | Select-String "time-analysis-tools" | measure-object -line
}

if (($args[0] -match "-b") -and ($args.Count -eq  3)) {
    check_path $args[1] "second"
    check_path $args[2] "third"

    # has_tools=$(docker images | grep time-analysis-tools | wc -l)
    if (has_tools -eq 0) { docker build -t time-analysis-tools -f Dockerfile .}
    docker run --rm -it -v ${2}:/root/source -v ${3}:/root/out time-analysis-tools
}
elseif ($args.Count -eq 2 ){
    check_path $args[0] "first"
    check_path $args[1] "second"
    docker run --rm -it -v ${1}:/root/source -v ${2}:/root/out eskehoy/ct-analysis-tools:latest
}
else {help}

