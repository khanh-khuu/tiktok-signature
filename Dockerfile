#tiktok-signature
FROM ubuntu:bionic AS tiktok_signature.build

WORKDIR /usr

# 1. Install node12
RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl

ARG NODE_VERSION=16.20.2
ARG NODE_PACKAGE=node-v$NODE_VERSION-linux-x64
ARG NODE_HOME=/opt/$NODE_PACKAGE

ENV NODE_PATH $NODE_HOME/lib/node_modules
ENV PATH $NODE_HOME/bin:$PATH

RUN curl https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.gz | tar -xzC /opt/

RUN npm install -g pm2

# 2. Install WebKit dependencies
RUN apt-get install -y libwoff1 \
    libopus0 \
    libwebp6 \
    libwebpdemux2 \
    libenchant1c2a \
    libgudev-1.0-0 \
    libsecret-1-0 \
    libhyphen0 \
    libgdk-pixbuf2.0-0 \
    libegl1 \
    libnotify4 \
    libxslt1.1 \
    libevent-2.1-6 \
    libgles2 \
    libgl1 \
    libvpx5 \
    libgstreamer1.0-0 \
    libgstreamer-gl1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer-plugins-bad1.0-0 \
    libharfbuzz-icu0 \
    libopenjp2-7

# 3. Install Chromium dependencies

RUN apt-get install -y libnss3 \
    libxss1 \
    libasound2

# 4. Install Firefox dependencies

RUN apt-get install -y libdbus-glib-1-2 \
    libxt6

# 5. Copying required files

ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm i
ADD . .

EXPOSE 8080
CMD [ "pm2-runtime", "listen.js" ]
