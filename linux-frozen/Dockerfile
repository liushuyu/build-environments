FROM ubuntu:20.04
LABEL maintainer="citraemu"
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /tmp/pkgs
COPY install_package.py /tmp/pkgs
RUN apt-get update && apt-get install -y p7zip-full build-essential wget git python3-launchpadlib ccache ninja-build
RUN cd /tmp/pkgs && python3 install_package.py \
    libsdl2-dev 2.0.10+dfsg1-3 focal          \
    qtbase5-dev 5.12.8+dfsg-0ubuntu1 focal           \
    libqt5opengl5-dev 5.12.8+dfsg-0ubuntu1 focal     \
    qt5-qmltooling-plugins 5.12.8-0ubuntu1 focal     \
    qtdeclarative5-dev 5.12.8-0ubuntu1 focal         \
    qtmultimedia5-dev 5.12.8-0ubuntu1 focal          \
    libicu66 66.1-2ubuntu2 focal                  \
    cmake 3.16.3-1ubuntu1 focal                     \
    libavcodec-dev 7:4.2.4-1ubuntu0.1 focal   \
    libavformat-dev 7:4.2.4-1ubuntu0.1 focal  \
    libswscale-dev 7:4.2.4-1ubuntu0.1 focal
RUN rm -rf /tmp/pkgs
