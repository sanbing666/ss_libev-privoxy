docker images：docker pull sanbing666/ss_libev-privoxy:latest

### docker-compose.yml配置
服务端
```shell
version: '3'

services:
  ss_libev-privoxy:
    container_name: ss_libev-privoxy
    image: sanbing666/ss_libev-privoxy:latest
    volumes:
      - './config:/etc/shadowsocks-libev'
    ports:
      - '9000:9000/tcp'
      - '9000:9000/udp'
    environment:
      - SERVICE_MODE=1
    restart: unless-stopped
```

本地端
```shell
version: '3'

services:
  ss_libev-privoxy:
    container_name: ss_libev-privoxy
    image: sanbing666/ss_libev-privoxy:latest
    volumes:
      - './config:/etc/shadowsocks-libev'
    ports:
      - '9000:9000/tcp'
      - '9000:9000/udp'
    environment:
      - SERVICE_MODE=2
    restart: unless-stopped
```

本地端带privoxy代理
```shell
version: '3'

services:
  ss_libev-privoxy:
    container_name: ss_libev-privoxy
    image: sanbing666/ss_libev-privoxy:latest
    volumes:
      - './config:/etc/shadowsocks-libev'
    ports:
      - '9000:9000/tcp'
      - '9000:9000/udp'
      - '8118:8118/tcp'
      - '8118:8118/udp'
    environment:
      - SERVICE_MODE=3
    restart: unless-stopped
```

### config.json配置文件
服务端
```shell
{
    "server":"0.0.0.0",
    "server_port":2096,
    "password":"password",
    "timeout":300,
    "user":"nobody",
    "method":"aes-256-gcm",
    "fast_open":false,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp"
}
```

本地端
```shell
{
    "server":"server",
    "server_port":9000,
    "password":"password",
    "timeout":300,
    "user":"nobody",
    "method":"aes-256-gcm",
    "fast_open":false,
    "local_address": "0.0.0.0",
    "local_port": "1080",
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp"
}
```
