# Домашнее задание к занятию "`Кластеризация и балансировка нагрузки`" - `Александр М.`


### Задание 1

- Запустите два simple python сервера на своей виртуальной машине на разных портах
- Установите и настройте HAProxy, воспользуйтесь материалами к лекции по [ссылке](2/)
- Настройте балансировку Round-robin на 4 уровне.
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

### Решение

```
mkdir http1 && cd http1 && echo "port 8001" > index.html
mkdir http2 && cd http2 && echo "port 8002" > index.html
python3 -m http.server 8001
python3 -m http.server 8002
```
```
$ cat /etc/haproxy/haproxy.cfg

global
    log /dev/log local0
    log /dev/log local1 notice
    daemon
    maxconn 2048

defaults
    log     global
    mode    tcp
    option  dontlognull
    timeout connect 5s
    timeout client  50s
    timeout server  50s

frontend fe_http_l4
    bind *:80
    mode tcp
    default_backend be_http_l4

backend be_http_l4
    mode tcp
    balance roundrobin
    server srv1 127.0.0.1:8001 check
    server srv2 127.0.0.1:8002 check

listen stats
    bind *:9000
    mode http
    stats enable
    stats uri /stats
    stats refresh 10s
    stats realm HAProxy\ Statistics
    stats auth admin:strongpassword
```
![8001](img/port8001.png)
![8002](img/port8002.png)
![stats](img/stats1.png)

---

### Задание 2

- Запустите три simple python сервера на своей виртуальной машине на разных портах
- Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
- HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

### Решение

```
mkdir http3 && cd http3 && echo "port 8003" > index.html
python3 -m http.server 8003
```

```
$ cat /etc/haproxy/haproxy.cfg

global
    log /dev/log local0
    log /dev/log local1 notice
    daemon
    maxconn 2048

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5s
    timeout client  50s
    timeout server  50s

frontend fe_http_l7
    bind *:80
    mode http

    acl host_example hdr_dom(host) -i example.local
    use_backend be_example if host_example

backend be_example
    mode http
    balance roundrobin
    server srv1 127.0.0.1:8001 weight 2 check
    server srv2 127.0.0.1:8002 weight 3 check
    server srv3 127.0.0.1:8003 weight 4 check

listen stats
    bind *:9000
    mode http
    stats enable
    stats uri /stats
    stats refresh 10s
    stats realm HAProxy\ Statistics
    stats auth admin:strongpassword


```
![stats2](img/stats2.png)
![curl](img/curl.png)

---

