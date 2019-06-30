---
layout: post
title: Prometheus interfaces exporter 
categories: Linux
permalink: /prom-interfaces-exporter 
---

Для обучающих и тестовых целей я написал exporter для Prometheus, который возвращает состояние сетевых интерфейсов хоста.
Данный exporter может быть запущен как в Docker контейнере, так и непосредственно на самом хосте.

Исходный код на [GitHub][1]

<!---excerpt-break-->

Краткое описание работы Python скрипта, лежащего в основе exporter:
 1. На порту 9425 (порт взят [отсюда][2]) запускается экземпляр класса ```CustomHttpProcessor```, который при каждом обращении к нему вызывает функцию ```write_interface_status```;
 2. Функция ```write_interface_status```, в свою очередь, вызывает еще несколько функций, которые: 
 - получают список имен интерфейсов в системе;
 - проверяют текущее состояние (```operstate```) каждого из полученных интерфейсов;
 - записывают состояние в файл ```metrics```, который отдается по http.

Необходимое условие для работы в Docker контейнере - директория ```/sys``` должна быть подмонтирована в контейнер в ```/host/sys``` для того, чтобы скрипт в контейнере мог считать метрики хоста.  

Пример команды для запуска exporter в Docker контейнере:
```
docker run -d -p 9425:9425 -v /sys:/host/sys:ro --name prom-interfaces-exporter avtandilko/prom-interfaces-exporter
```

Пример вывода exporter:
```
curl 172.31.0.11:9425/metrics
# HELP interface_status down = 0, up = 1, any other states (unknown) = 2
# TYPE interface_status untyped
interface_status{interface="br-af9ffbaf4aff"} 0
interface_status{interface="dm-8295e7c648f8"} 2
interface_status{interface="dm-b880f00a8833"} 2
interface_status{interface="docker0"} 1
interface_status{interface="dummy0"} 0
interface_status{interface="eth0"} 1
interface_status{interface="eth1"} 1
interface_status{interface="lo"} 2
interface_status{interface="veth1f58e81"} 1
interface_status{interface="vethb244e2b"} 1
```
 [1]: https://github.com/Avtandilko/prom-interfaces-exporter
 [2]: https://github.com/prometheus/prometheus/wiki/Default-port-allocations
