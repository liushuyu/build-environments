FROM ubuntu:20.04
LABEL maintainer="citraemu"
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /tmp/pkgs
RUN apt-get update && apt-get install -y qt5-default qttools5-dev-tools gpg wget git python3-pip ccache p7zip-full g++-mingw-w64-x86-64 gcc-mingw-w64-x86-64 mingw-w64-tools cmake ninja-build
COPY mingw-setup.sh /tmp/pkgs
RUN cd /tmp/pkgs && bash -e mingw-setup.sh
