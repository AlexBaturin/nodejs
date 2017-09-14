FROM alpine:latest

MAINTAINER Alexander Baturin <alex.baturin1987@gmail.com>

# ENVs
ENV VERSION=v6.11.2 
ENV NPM_VERSION=3
ENV CONFIG_FLAGS="--fully-static"
ENV PKGS="curl make gcc g++ python linux-headers binutils-gold gnupg libstdc++ tar xz"

WORKDIR /tmp

# Install Nodejs
RUN apk add --no-cache ${PKGS} mysql-client && \
curl -sSLO https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.xz && \
tar -xf node-${VERSION}.tar.xz && \
cd node-${VERSION} && \
./configure --prefix=/usr ${CONFIG_FLAGS} && \
make -j$(getconf _NPROCESSORS_ONLN) && \
make install && \
npm install -g npm@${NPM_VERSION} mysql && \
npm cache clean && apk del ${PKGS} && \
find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf && \
rm -rf /usr/include /node-${VERSION}* /usr/share/man /tmp/* /var/cache/apk/* \
/root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
/usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts
