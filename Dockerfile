FROM ubuntu:16.04

ARG NUM_PROCESSORS=8

RUN apt-get update -y && \
    apt-get -y install gcc g++ git make wget xz-utils python

# Dudect
RUN git clone https://github.com/oreparaz/dudect.git /usr/share/dudect
RUN cd /usr/share/dudect && make

# Flow Tracker
RUN wget -O /tmp/llvm.src.tar.xz "https://www.llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz"
RUN tar -xf /tmp/llvm.src.tar.xz -C $HOME

RUN wget -O /tmp/cfe-3.7.1.src.tar.xz "http://www.llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz"
RUN tar -xf /tmp/cfe-3.7.1.src.tar.xz -C $HOME/llvm-3.7.1.src/tools/
RUN mv $HOME/llvm-3.7.1.src/tools/cfe-3.7.1.src $HOME/llvm-3.7.1.src/tools/clang
RUN mkdir -p $HOME/llvm-3.7.1.src/build/lib/Transforms

RUN git clone https://github.com/dfaranha/FlowTracker.git /tmp/flowtracker && \
    cp -r /tmp/flowtracker/AliasSets $HOME/llvm-3.7.1.src/lib/Transforms && \
    cp -r /tmp/flowtracker/DepGraph $HOME/llvm-3.7.1.src/lib/Transforms && \
    cp -r /tmp/flowtracker/bSSA2 $HOME/llvm-3.7.1.src/lib/Transforms && \
    \
    cp -r /tmp/flowtracker/AliasSets $HOME/llvm-3.7.1.src/build/lib/Transforms && \
    cp -r /tmp/flowtracker/DepGraph $HOME/llvm-3.7.1.src/build/lib/Transforms && \
    cp -r /tmp/flowtracker/bSSA2 $HOME/llvm-3.7.1.src/build/lib/Transforms

RUN sed -i "s#bool hasMD() const { return MDMap; }#bool hasMD() const { return bool(MDMap); }#g" $HOME/llvm-3.7.1.src/include/llvm/IR/ValueMap.h

RUN cd $HOME/llvm-3.7.1.src/build && \
    ../configure --disable-bindings && \
    make -j${NUM_PROCESSORS}

ENV PATH="$PATH:/root/llv-3.7.1.src/build/Release+Asserts/bin"

#RUN cd $HOME/llvm-3.7.1.src/lib/Transforms/AliasSets && \
#    make -j4
#RUN cd $HOME/llvm-3.7.1.src/lib/Transforms/DepGraph && \
#    make -j4
#RUN cd $HOME/llvm-3.7.1.src/lib/Transforms/bSSA2 && \
#    make -j4
#RUN cd $HOME/llvm-3.7.1.src/lib/Transforms/bSSA2 && \
#    g++ -shared -o parserXML.so -fPIC parserXML.cpp tinyxml2.cpp

CMD ["bash"]