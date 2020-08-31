ARG NVIDIA_VERSION=cuda:10.1-cudnn7-devel-ubuntu18.04

FROM nvidia/${NVIDIA_VERSION}

RUN apt-get update && \
    apt-get install -y libopenblas-dev python-numpy python-dev libpcre3 libpcre3-dev wget unzip && \
    apt-get clean

# install rust
ENV PATH="/root/.cargo/bin:$PATH"
RUN wget https://sh.rustup.rs -O rustup.sh && \
        sh rustup.sh -y

ARG FAISS_REPO=https://github.com/Enet4/faiss
ARG FAISS_SHA=2ac91ad79d9b82800804e073b13a64223cdd6727
ENV FAISS_REPO ${FAISS_REPO}
ENV FAISS_SHA ${FAISS_SHA}

# build and install faiss
RUN cd /tmp && \
    wget ${FAISS_REPO}/archive/${FAISS_SHA}.zip && \
    unzip ${FAISS_SHA}.zip && \
    mv faiss-* /faiss && \
    cd /faiss && \
    ./configure --with-cuda=/usr/local/cuda && \
    make && make install && \
    cd c_api && \
    make && \
    cp libfaiss_c.so /usr/local/lib/ && \
    cp libfaiss_c.a /usr/local/lib/ && \
    cd gpu && \
    make && \
    make libgpufaiss_c.a && \
    cp libgpufaiss_c.a /usr/local/lib/ && \
    cp libgpufaiss_c.so /usr/local/lib/ && \
    make clean && \
    cd .. && make clean && \
    cd .. && make clean

# headers /usr/local/include/faiss
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH