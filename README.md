### Usage

#### Run `redis-server`

    docker run -d --name redis -p 6379:6379 dockbuilds/redis

#### Run `redis-server` with persistent data directory. (creates `dump.rdb`)

    docker run -d -p 6379:6379 -v <data-dir>:/data --name redis dockbuilds/redis redis-server /data/redis.conf

#### Run `redis-cli`

    docker run -it --rm --link redis:redis dockbuilds/redis bash -c 'redis-cli -h redis'
