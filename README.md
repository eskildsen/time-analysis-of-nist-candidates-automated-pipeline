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

### Flowtracker
This downloads precompiled binaries to the docker image. It will only be slow when building it for the first time. Notice the trailing dot:
```
sudo docker build -t flowtracker -f flowtracker.docker .
```
You only have to build once. To mount a directory e.g. `~/source` with the binaries you want to test, you use the `-v` argument as below. Please note, that your local path must be absolute and might need to be located under your $HOME.
```
sudo docker run --rm -it -v ~/source:/root/source flowtracker
```

Running a sample can be done using the commands below. See more details at [https://github.com/dfaranha/FlowTracker](https://github.com/dfaranha/FlowTracker). The `in.xml` file specifies the input parameters.
```
cd /root/flowtracker/donnabad
clang -emit-llvm -c -g curve25519-donnabad.c -o curve25519-donnabad.bc
opt -instnamer -mem2reg curve25519-donnabad.bc > curve25519-donnabad.rbc
opt -basicaa -load AliasSets.so -load DepGraph.so -load bSSA2.so -bssa2 -xmlfile in.xml curve25519-donnabad.rbc

```
