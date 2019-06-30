---
layout: post
title: Kubernetes notes
categories: Containers
permalink: /kubernetes-notes
---
## Термины

### POD

Наименьшая сущность, которую можно создать в k8s. Может содержать один или несколько контейнеров. В случае использования нескольких контейнеров network и volume разделяются между ними. Внутри pod контейнеры могут взаимодействовать между собой через localhost.

<!---excerpt-break-->

#### Пример pod с несколькими контейнерами:
```
[root@k8s-vm1 ~]# kubectl get pods --all-namespaces | grep flannel
kube-system kube-flannel-3fk2m 2/2 Running 0 11h
kube-system kube-flannel-p1vn4 2/2 Running 0 11h
kube-system kube-flannel-pnfkr 2/2 Running 0 11h

[root@k8s-vm1 ~]# kubectl describe pod kube-flannel-p1vn4 --namespace=kube-system | grep ID
 Container ID: docker://885a18a9e96e9d56f04eb2613b5a4378f660152db9a24b5a12af7b009ef30d37
 Image ID: docker-pullable://quay.io/coreos/flannel@sha256:5fa9435c1e95be2ec4daa53a35c39d5e3cc99fce33ed4983f4bb707bc9fc175f
 Container ID: docker://e4680b90a2d5d9385770249a39f86f7852d120e9dd8b4d1631932914c49f9828
 Image ID: docker-pullable://quay.io/coreos/flannel-cni@sha256:77bf1017845afb65e2603d8573e9a2d649eb645a4f7fe4843f17e276b8126968
```
### Replication controller

Сущность, отвечающая за поддержание заданного количества реплик pod в рабочем состоянии. Также обеспечивает функционал rolling updates. При отклонении от заданного количества pod, реплики терминируются, либо создаются недостающие. 

Пример конфигурации replication controller в формате yaml:
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 4
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
### Service

Основная роль service - обеспечение доступности логической группы pod для внешних подключений. Пример конфигурации сервиса для replication controller приведенного выше в формате yaml (доступность на двух внешних IP 10.200.33.12 и 10.200.33.13, порт 8001):
```
kind: Service
apiVersion: v1
metadata:
   name: nginx
spec:
   externalIPs:
     - 10.200.33.12
     - 10.200.33.13
   selector:
     app: nginx
   ports:
   - protocol: TCP
     port: 8001
     targetPort: 80
```
