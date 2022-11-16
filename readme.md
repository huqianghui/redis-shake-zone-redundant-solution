# 基于redis-shake，在azure上构建多活方案

步骤：

1. 安装三台vm和一个internal Loadbalancer，（external Load balacer可选）
2. 选择redis，以及redis-shake对应的版本
3. 配置redis-shake
4. 安装xinetd服务，对外提供redis-shake的进程健康检查



## 安装三台vm和一个internal Loadbalancer，（external Load balacer可选）

这个可以参照terraform 文件来安装

## 选择redis，以及redis-shake对应的版本


1. 三台vm上选择安装了redis-5.0.9 from source

    a. 安装make等编译工具 
     ```bash 
     apt update
     apt install build-essential tcl 
     ```
   b. 下载redis对应版本并编译安装
   （ wget http://download.redis.io/releases/redis-5.0.9.tar.gz）
     ```bash
    tar -xzvf redis-5.0.9.tar.gz
    cd redis-5.0.9
    make        # 编译源文件
    make test   # 测试
    make install #把二进制文件copy到usr/local/bin/目录下
    mkdir /etc/redis # create config dir
    cp ./redis.conf /etc/redis # add config file
    nano /etc/redis/redis.conf # modify config and change supervised to systemd and bind all NIC(0.0.0.0)
     ```
     ```config
        If you run Redis from upstart or systemd, Redis can interact with your
        #supervision tree. Options:
        #supervised no - no supervision interaction
        #supervised upstart - signal upstart by putting Redis into SIGSTOP mode3
        #supervised systemd - signal systemd by writing READY=1 to $NOTIFY_SOCKET
        #supervised auto - detect upstart or systemd method based on
        #UPSTART_JOB or NOTIFY_SOCKET environment variables
        #Note: these supervision methods only signal "process is ready."
        #They do not enable continuous liveness pings back to your supervisor.
        supervised systemd

        bind 0.0.0.0
     ```
    
    ```bash
    nano /etc/systemd/system/redis.service # Create and open the file
    ```

    ```config
    [Unit]
    Description=Redis In-Memory Data Store
    After=network.target

    [Service]
    User=redis
    Group=redis
    ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
    ExecStop=/usr/local/bin/redis-cli shutdown
    Restart=always

    [Install]
    WantedBy=multi-user.target
    ```
     
     ```bash
     adduser --system --group --no-create-home redis #create the redis user and group
     mkdir /var/lib/redis # create the /var/lib/redis directory
     chown redis:redis /var/lib/redis # Give the redis user and group ownership over this directory
     chmod 770 /var/lib/redis # adjust the permissions so that regular users cannot access this location
     ```

     ```bash
    systemctl start redis # Start the systemd service 
    systemctl status redis # Check that the service has no errors 
    redis-cli # default to 127.0.0.1:6379 
    127.0.0.1:6379> ping # PONG will return
     ```

    ```bash
    systemctl enable redis #  to start Redis automatically when your server boots, enable the systemd service
    ```

2. 两台作为target vm上安装redis-shake

    a. 下载redis-shake
    wget https://github.com/alibaba/RedisShake/releases/download/v3.1.7/redis-shake-linux-amd64.tar.gz

    b. 编辑sync.toml
    
    c. 启动redis-shake
    ```bash
    ./bin/redis-shake sync.toml 
    ```

3. 两台作为target vm上安装xinetd.d来对redis-shake 和redis做健康检查

    ```bash
    apt install xinetd # xinetd服务的主配置文件： /etc/xinetd.conf     --保持默认即可 用于存放被托管的服务的目录：/etc/xinetd.d/

    systemctl  enable  xinetd.service   # 开机启用xinetd服务
    ```
    
    config redis shake and redis check
    
    ```bash 
    nano /etc/xinetd.d/redisshakechk
    ```

    ```config
    # default: on
    # description: redisshakechk
    service redisshakechk
    {
            flags           = REUSE
            socket_type     = stream
            port            = 6380
            wait            = no
            user            = nobody
            server          = /opt/redisshakechk
            bind		= 0.0.0.0
        log_on_failure  += USERID
            disable         = no
            only_from       =0.0.0.0/0
            per_source      = UNLIMITED
    }
    ```

    config redisshake check logic

    ```bash
    nano /opt/redisshakechk
    ```

    ```config
    #
    process=`ps aux | grep redis-shake | grep -v grep`
    #
    # Check the output. If it is not empty then everything is fine and we return
    # something. Else, we just do not return anything.
    #
    if [ "$process" != "" ]
    then
        # redis-shake is fine, return http 
        /bin/echo "HTTP/1.1 200 OK"
        /bin/echo "Content-Type: text/plain"
        /bin/echo "Connection: close"
        /bin/echo "Content-Length: 3"
        /bin/echo ""
        /bin/echo "OK"
    else
        # redis-shake is not fine, return http 503
        /bin/echo "HTTP/1.1 503 Service Unavailable"
        /bin/echo "Content-Type: text/plain"
        /bin/echo "Connection: close"
        /bin/echo "Content-Length: 3"
        /bin/echo ""
        /bin/echo "NG"
        systemctl stop  xinetd.service
    fi
    ```

    ```bash
   systemctl  restart  xinetd.service    # 重新启动xinetd服务 
    ```

    4. 创建配置internal Load balacer

    默认服务端口redis：6379
    监控检查端口：6380
    
    *** 这里用http服务检查的时候，一直有问题，改成tcp检查，所以如果redis shake或 redis 失败的时候，需要关掉xinet服务，实现健康检查。***