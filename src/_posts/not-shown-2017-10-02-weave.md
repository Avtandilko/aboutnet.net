---
layout: post
title: Weave
categories: Containers
subcategories: Kubernetes
permalink: /weave
---

## Содержание
   * [Установка](/weave#Установка)
      * [Weave Scope](/weave#Weave-Scope)
   * [Описание](/weave#Описание)
   * [Network Policy](/weave#Network-Policy)	  
   
## Установка <a name="Установка"></a>

Для версии 1.7.5:
```bash
wget https://cloud.weave.works/k8s/net?k8s-version=1.7.5
cp net\?k8s-version\=1.7.5 weave-conf-1.7.5.yaml
weave-conf-1.7.5.yaml
      containers:
        - name: weave
          env:
            - name: IPALLOC_RANGE
              value: 10.0.0.0/16 -> 172.25.64.0/18
kubectl apply -f weave-conf-1.7.5.yaml
```
### Weave Scope <a name="Weave-Scope"></a>

Графическая среда мониторинга для сетевого модуля Weave. Может работать как в облаке cloud.weave.works так и в локальном k8s.

Установка на локальный k8s:
```bash
wget https://cloud.weave.works/k8s/scope.yaml?k8s-version=1.7.5
cp scope.yaml?k8s-version=1.7.5 weave-scope-conf-1.7.5.yaml
    spec:
      externalIPs:
        - 10.200.33.12                
      ports:
        - name: app  
          port: 4040

kubectl apply --namespace kube-system -f weave-scope-conf-1.7.5.yaml
```
<!---excerpt-break-->

## Описание <a name="Описание"></a>
По умолчанию контейнеры на всех хостах находятся в плоской сети (в примере 172.25.64.0/18). При этом на каждый хост выделяется свой диапазон адресов:
```bash
[root@k8s-vm1 ~]# ip addr | grep 172.25
    inet 172.25.96.0/18 scope global weave
[root@k8s-vm2 ~]# ip addr | grep 172.25
    inet 172.25.120.0/18 scope global weave
[root@k8s-vm3 ~]# ip addr | grep 172.25
    inet 172.25.64.1/18 scope global weave
[root@k8s-vm4 ~]# ip addr | grep 172.25
    inet 172.25.88.0/18 scope global weave
```
## Network Policy <a name="Network-Policy"></a>

Управление доступом в weave осуществляется с использованием iptables.

### Пример настройки сетевых политик

Запрет доступа в pod'ы, находящиеся в namespace prod с использованием аннотаций (implicit deny), аннотация в том числе запрещает доступ между pod в одном namespace:

#### До применения аннотации
```bash
Chain WEAVE-NPC-DEFAULT (1 references)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere             match-set weave-z~y01unAQHA]WxHG!ALB)5]}s dst /* DefaultAllow isolation for namespace: prod */
```
#### Запрет с использованием аннотации
```
kubectl annotate ns prod net.beta.kubernetes.io/network-policy='{"ingress":{"isolation":"DefaultDeny"}}'
```
#### Удаление запрета
```
kubectl annotate ns prod net.beta.kubernetes.io/network-policy-
```
Открытие internal доступа для определенного pod в namespace prod с определенного pod в namespace prod (пример для iperf-prod-1):
```yaml
cat prod-net-policy.yaml
apiVersion: extensions/v1beta1
kind: NetworkPolicy
metadata:
  name: iperf-prod-1-internal-access
  namespace: prod
spec:
  podSelector:
    matchLabels:
      run: iperf-prod-1
  ingress:
    - from:
        - podSelector:
            matchLabels:
              run: iperf-prod-1

kubectl create -f prod-net-policy.yaml
```
Новая цепочка в iptables на всех нодах:
```bash
Chain WEAVE-NPC-INGRESS (1 references)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             match-set weave-KD98A9:Wl|emmgZ=GX^J2yD;M src match-set weave-KD98A9:Wl|emmgZ=GX^J2yD;M dst /* pods: namespace: prod, selector: run=iperf-prod-1 -> pods: namespace: prod, selector: run=iperf-prod-1 */
```
