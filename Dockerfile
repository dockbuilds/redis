FROM debian:jessie

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redis && useradd -r -g redis redis

ENV REDIS_VERSION 2.8.13
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-2.8.13.tar.gz
ENV REDIS_DOWNLOAD_SHA1 a72925a35849eb2d38a1ea076a3db82072d4ee43

RUN buildDeps='gcc libc6-dev make ca-certificates'; \
  set -x; \
  apt-get update && apt-get install -y $buildDeps curl --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/src/redis \
  && curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
  && echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
  && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
  && rm redis.tar.gz \
  && make -C /usr/src/redis \
  && make -C /usr/src/redis install \
  && rm -r /usr/src/redis \
  && curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
  && chmod +x /usr/local/bin/gosu \
  && apt-get purge -y $buildDeps curl \
  && apt-get autoremove -y

VOLUME /data
WORKDIR /data

ADD ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 6379

CMD ["redis-server"]