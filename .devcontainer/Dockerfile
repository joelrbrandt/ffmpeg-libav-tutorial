# ffmpeg - http://ffmpeg.org/download.html
#
# From https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
#
# https://hub.docker.com/r/jrottenberg/ffmpeg/
#
#
FROM ubuntu:22.04

ARG FFMPEG_VERSION="6.0"
ARG X264_SHA="a8b68ebfaa68621b5ac8907610d3335971839d52"
ARG LD_LIBRARY_PATH="/opt/ffmpeg/lib"
ARG MAKEFLAGS="-j6"
ARG PKG_CONFIG_PATH="/opt/ffmpeg/share/pkgconfig:/opt/ffmpeg/lib/pkgconfig:/opt/ffmpeg/lib64/pkgconfig"
ARG PREFIX="/opt/ffmpeg"
ARG LD_LIBRARY_PATH="/opt/ffmpeg/lib:/opt/ffmpeg/lib64"

RUN apt update -y && \
    apt install -y \
    less \
    curl \
    bzip2 \
    build-essential \
    pkg-config

WORKDIR /build/x264

RUN curl -o x264.tar.bz2 "https://code.videolan.org/videolan/x264/-/archive/${X264_SHA}/x264-${X264_SHA}.tar.bz2"

RUN tar -jx --strip-components=1 -f x264.tar.bz2

WORKDIR /build/ffmpeg

RUN curl -L -o ffmpeg.tar.bz2 "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"

RUN tar -jx --strip-components=1 -f ffmpeg.tar.bz2

WORKDIR /build/x264

RUN ./configure \
  --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
  make && \
  make install

WORKDIR /build/ffmpeg

RUN ./configure \
  --enable-gpl \
  --enable-shared \
  --disable-programs \
  --enable-ffmpeg \
  --disable-doc \
  --disable-avdevice \
  --disable-network \
  --enable-pthreads \
  --enable-ffmpeg \
  --disable-avdevice \
  --enable-avcodec \
  --enable-avformat \
  --enable-swresample \
  --enable-swscale \
  --enable-postproc \
  --enable-avfilter \
  --disable-encoders \
  --enable-encoder=libx264 \
  --enable-encoder=mjpeg \
  --enable-encoder=pcm_s16le \
  --disable-decoders \
  --enable-decoder=aac \
  --enable-decoder=h264 \
  --disable-protocols \
  --enable-protocol=file \
  --disable-devices \
  --enable-libx264 \
  --disable-debug \
  --extra-libs=-ldl \
  --prefix="${PREFIX}" \
  --extra-libs=-lpthread \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" && \
  make && \
  make install

ENV LD_LIBRARY_PATH /opt/ffmpeg/lib:/usr/local/lib

RUN apt update -y && apt install -y cmake gdb
