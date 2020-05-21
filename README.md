# cryptanalysis-of-nist-candidates-automated-pipeline
This is a collection of tools to help evaluate NIST crypto implementations for constant-time behaviour and memory safety.

## Installation
### Docker
Everything is packed in a Docker image. Thus, you will need to install Docker, if not already present on your system. For any Linux variant Docker can be installed with:
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

For other operating systems and manuel installation take a look at [https://docs.docker.com/install/](https://docs.docker.com/install/).

### Use ready-built image
You can use a container with all the tools already compiled by issuing the command below. This will give you a shell within the container with the tools ready to use. To run on your source code, you will need to take a look at the section **Running Analysis** below.
```
sudo docker run eskildsen/time-analysis
```


### Manually building the image
Run the following commands to build the container itself. Due to Flowtracker this might take 30+ minutes.
```
sudo docker build -t time-analysis -f Dockerfile .
sudo docker run --rm -it time-analysis
```


## Running Analysis
To mount a directory e.g. `~/source` with the binaries you want to test, you use the `-v` argument as below. Please note, that your local path must be absolute and might need to be located under your $HOME.

If you manually built the container use:
```
sudo docker run --rm -it -v ~/source:/root/source time-analysis
```
If you use our pre-build container:

```
sudo docker run --rm -it -v ~/source:/root/source eskildsen/time-analysis
```

Running a sample can be done using the commands below. See more details at [https://github.com/dfaranha/FlowTracker](https://github.com/dfaranha/FlowTracker). The `in.xml` file specifies the input parameters.

In the container, assuming your code is in the path `/tmp/flowtracker/donnabad/curve25519-donnabad.c`:
```
cd /tmp/flowtracker/donnabad
clang -emit-llvm -c -g curve25519-donnabad.c -o curve25519-donnabad.bc
opt -instnamer -mem2reg curve25519-donnabad.bc > curve25519-donnabad.rbc
opt -basicaa -load AliasSets.so -load DepGraph.so -load bSSA2.so -bssa2 -xmlfile in.xml curve25519-donnabad.rbc
```
