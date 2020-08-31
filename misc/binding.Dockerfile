ARG NVIDIA_VERSION=cuda:10.1-cudnn7-devel-ubuntu18.04

FROM nvidia/${NVIDIA_VERSION}

RUN apt-get update && \
    apt-get install -y wget git llvm-dev libclang-dev clang && \
    apt-get clean

# install rust, bindgen
ENV PATH="/root/.cargo/bin:$PATH"
RUN wget https://sh.rustup.rs -O rustup.sh && \
        sh rustup.sh -y && \
        cargo install bindgen