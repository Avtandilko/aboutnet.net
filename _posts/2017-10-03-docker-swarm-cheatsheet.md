---
layout: post
title: Docker Swarm CheatSheet
categories: Containers
subcategories: docker
permalink: /docker-swarm-cheatsheet
---

## Содержание
   * [Установка](/docker-swarm-cheatsheet#Установка)
   * [Использование](/docker-swarm-cheatsheet#Использование)
      * [Использование docker config](/docker-swarm-cheatsheet#Использование-docker-config)

## Установка <a name="Установка"></a>
```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
sudo yum install docker-ce -y

sudo systemctl enable docker
sudo systemctl start docker
```
<!---excerpt-break-->
## Использование <a name="Использование"></a>

### Инициализация кластера
```bash
sudo docker swarm init --advertise-addr 10.10.10.101
Swarm initialized: current node (siubj077zvc6bbxb9l2alr0up) is now a manager.
To add a worker to this swarm, run the following command:
   docker swarm join --token SWMTKN-1-0lx3v80ql0bqy508rxaqo0x6sseokwzgd9brj902bif0ylbv6y-47on62zw39p154yfeu5ihfs3g 10.10.10.101:2377
To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

sudo docker node ls
ID HOSTNAME STATUS AVAILABILITY MANAGER STATUS
ad3rwed27xksrkhpmlktf4aco vm3.home Ready Active 
ka75127cw1pc1t6gnxm1cffs9 vm2.home Ready Active 
siubj077zvc6bbxb9l2alr0up * vm1.home Ready Active Leader
```
#### Разворачивание сервиса:
```
sudo docker service create --replicas 3 --name helloworld alpine ping docker.com
```
Если параметр replicas больше, чем количество нод в кластере swarm  - на некоторых нодах будет создан более чем один контейнер.
#### Удаление сервиса:
```
sudo docker service rm helloworld
```
При создании кластера swarm автоматически создается оверлейная vxlan сеть для связи контейнеров внутри нод.
#### Увеличение количества запущенных контейнеров для сервиса:
```
sudo docker service scale helloworld=10
```
#### Информация о контейнерах сервиса:
```
sudo docker service ps helloworld
```
#### Перевод ноды в режим обслуживания (активные контейнеры будут развернуты на других нодах):
```
sudo docker node update --availability drain vm2.home
```
Также реплика контейнера будет создана в случае каких-то проблем с нодой (например, ее перезагрузка).
#### Возврат ноды из режима обслуживания (контейнеры не возвращаются на ноду автоматически):
```
sudo docker node update --availability active vm2.home
```
#### Перебалансировка контейнеров по всем активным нодам (пересоздает контейнеры, ведет к прерыванию связи):
```
sudo docker service update helloworld --force
```
#### Задание лимита на хранение выключенных копий контейнеров вида \_helloworld:
```
sudo docker swarm update --task-history-limit 1
```
### Использование docker config <a name="Использование-docker-config"></a>
```bash
cat my.conf 
 server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:80/;
    }
}
```
#### Создание файла конфигурации:
```
sudo docker config create my_nginx_conf my.conf
```
#### Создание сервиса с файлом конфигурации:
```
sudo docker service create --name nginx_with_my_conf --replicas 3 --config source=my_nginx_conf,target=/etc/nginx/conf.d/my.conf nginx
```
#### Проверка на одном из worker:
```bash
sudo docker exec -ti c7317bf582bf cat /etc/nginx/conf.d/my.conf
 server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:80/;
    }
}
```
