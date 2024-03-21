#!/bin/sh

case $SERVICE_MODE in
    "1")
        echo "启动 Shadowsocks-libev 服务端..."
        ss-server -c /etc/shadowsocks-libev/config.json
        ;;
    "2")
        echo "启动 Shadowsocks-libev 本地端..."
        ss-local -c /etc/shadowsocks-libev/config.json
        ;;
    "3")
        echo "启动 Privoxy..."
        /usr/sbin/privoxy /etc/privoxy/config &
        privoxy_pid=$!  # 获取 Privoxy 进程 ID
        sleep 1  # 等待一秒钟以确保进程启动完全
        if pidof privoxy > /dev/null; then
            echo "监听 Privoxy 程序http/s代理端口8118成功..."
        else
            echo "监听 Privoxy 程序http/s代理端口8118失败..."
            # 在此添加处理启动失败的逻辑，例如退出脚本或者执行其他操作
        fi
        echo "启动 Shadowsocks-libev 本地端..."
        ss-local -c /etc/shadowsocks-libev/config.json
        ;;
    *)
        echo "无效的选项，请设置正确的 SERVICE_MODE 环境变量。"
        ;;
esac

