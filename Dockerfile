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

# RUN buildDeps="autoconf \
#                automake \
#                cmake \
#                curl \
#                bzip2 \
#                libexpat1-dev \
#                g++ \
#                gcc \
#                git \
#                gperf \
#                libtool \
#                make \
#                meson \
#                nasm \
#                perl \
#                pkg-config \
#                python3 \
#                libssl-dev \
#                yasm \
#                zlib1g-dev" && \
#    apt-get -yqq update && \
#    apt-get install -yq --no-install-recommends ${buildDeps}

# RUN apt install -y ca-certificates

RUN apt update -y && \
    apt install -y \
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
  # --disable-doc \
  # --disable-ffplay \
  # --enable-static \
  # --enable-avresample \
  # --enable-libopencore-amrnb \
  # --enable-libopencore-amrwb \
  # --enable-libass \
  # --enable-fontconfig \
  # --enable-libfreetype \
  # --enable-libvidstab \
  # --enable-libmp3lame \
  # --enable-libopus \
  # --enable-libtheora \
  # --enable-libvorbis \
  # --enable-libvpx \
  # --enable-libwebp \
  # --enable-libxcb \
  # --enable-libx265 \
  # --enable-libxvid \
  # --enable-nonfree \
  # --enable-openssl \
  # --enable-libfdk_aac \
  # --enable-postproc \
  # --enable-small \
  # --enable-version3 \
  # --enable-libbluray \
  # --enable-libzmq \
  --extra-libs=-ldl \
  --prefix="${PREFIX}" \
  # --enable-libopenjpeg \
  # --enable-libkvazaar \
  # --enable-libaom \
  --extra-libs=-lpthread \
  # --enable-libsrt \
  # --enable-libaribb24 \
  # --enable-libvmaf \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" && \
  make && \
  make install

ENV LD_LIBRARY_PATH /opt/ffmpeg/lib:/usr/local/lib
