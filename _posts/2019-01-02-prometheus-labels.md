---
layout: post
title: Prometheus Labels
categories: Containers
subcategories: Kubernetes
permalink: /prometheus-kubernetes
---

## Содержание

В этой статье я хочу разобрать механизм работы Service Discovery в Prometheus для Kubernetes и пройти путь от создания pod в Kubernetes до его появления в Prometheus.

### Service Discovery. Метки в Kubernetes и Prometheus

Общий механизм работы следующий:
* В файле конфигурации Prometheus указываются параметры для подключения к API Kubernetes. В простейшем примере это адрес API, CA сертификат и Bearer token.
* В файле конфигурации Prometheus создается Job с ключевым словом kubernetes_sd_configs и указанием на роль объектов (о них далее) с которых Prometheus будет собирать метрики.
* В описании Job указываются параметры relabeling, или, проще говоря, создаются правила фильтрации, определяющие, с каких именно объектов Prometheus будет собирать метрики (например, в кластере 10 разных сервисов, но метрики в данной Job необходимо собирать только с одного из них).

Посмотрим, как это происходит на примере кастомного приложения ui, которое отдает свои метрики по URL [http://IP_ADDRESS:9292/metrics](it's not a true link).

Развернем приложение в кластере с использованием манифеста:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui
  labels:
    component: ui
  namespace: ui
spec:
  replicas: 1
  selector:
    matchLabels:
      component: ui
  template:
    metadata:
      name: ui-pod
      labels:
        component: ui
    spec:
      containers:
      - image: avtandilko/ui:7
        name: ui
        ports:
        - containerPort: 9292
```

Далее развернем в кластере Prometheus с использованием helm-чарта stable/prometheus. В файле prometheus-values.yml будем переопределять параметры установки Prometheus, в том числе его конфигурацию.

```
helm install --name prometheus stable/prometheus -f prometheus-values.yml
```

Теперь попробуем организовать мониторинг нашего приложения. Для начала приведем примерный алгоритм работы Service Discovery в Prometheus:

* Указываем в конфигурации, что хотим мониторить некие объекты кластера, например - pod.
* Prometheus идет в API кластера, получает список всех созданных pod (адрес может быть примерно таким [https://API_ADDRESS/api/v1/pods](it's not a true link)) и описание каждого пода в следующем формате (оставлен только вывод который будет использован в дальнейшем):

```json
{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "ui-cd4566764-lz8n7",
    "generateName": "ui-cd4566764-",
    "namespace": "ui",
    "selfLink": "/api/v1/namespaces/ui/pods/ui-cd4566764-lz8n7",
    "uid": "7b567e9a-0eb1-11e9-a168-42010a9a012a",
    "labels": {
      "component": "ui",
      "pod-template-hash": "780122320"
    },
    "annotations": {
      "cni.projectcalico.org/podIP": "10.0.1.17/32"
    },
    "ownerReferences": [
      {
        "apiVersion": "apps/v1",
        "kind": "ReplicaSet",
        "name": "ui-cd4566764",
        "controller": true
      }
    ]
  },
  "spec": {
    "containers": [
      {
        "name": "ui",
        "image": "avtandilko/ui:7",
        "ports": [
          {
            "containerPort": 9292,
            "protocol": "TCP"
          }
        ],
  "status": {
    "phase": "Running",
    "conditions": [
      {
        "type": "Ready"
      }
    ],
    "hostIP": "10.154.0.3",
    "podIP": "10.0.1.17"
  }
}
```

* Полученное описение из json будет представлено в UI Prometheus в собственном формате. Для pods будут созданы [следующие meta labels](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#pod);
* Итого в секции Status/Service Discovery в Prometheus будут видны все найденные поды и их метки, полученные из Kubernetes. ![prometheus-status-sd](public/prometheus-status-sd.png){:width="100%"}

В дальнейшем по меткам при помощи механизма relabeling можно фильтровать с каких именно объектов необходимо снимать метрики.

### Roles

Немного подробнее о том, для каких объектов у Prometheus работает механизм Service Discovery. Эта секция практически полностью является переводом [документации Prometheus](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config)

Существует 5 типов объектов, информацию о которых Prometheus может выгрузить из Kubernetes:

* Nodes - подходит для сущностей, у которых на каждой физической ноде кластера находится по одному экземпляру (kubelet, etc...). Kubernetes отдает список нод с определенными метками (при помощи relabeling можно изменить, например, порт с которого будут собираться метрики, по умолчанию это порт kubelet);
* Pod - Kubernetes отдает список всех подов, для каждого слушаемого контейнером порта (указанного при этом в конфигурации) будет создаваться отдельный target;
* Endpoints - Kubernetes будет возвращать список всех Endpoint, созданных каким либо сервисом (либо вручную). Помимо меток непосредственно Endpoint, также собираются метки, характерные для сервисов (если Endpoint создан сервисом) и метки характерные для подов (если Endpoint "смотрит" на pod);
* Service и Ingress - соответственно отдается список Service и Ingress в кластере, с характерными для них метками. Могут использоваться для BlackBox мониторинга (например, для оценки - работает ли приложение в целом, не заостряя внимание на метриках конкретных pod данного приложения).

### Relabeling
TBD
1. Итого в web-интерфейсе Prometheus будет отображен найденный pod и все его метки в формате Prometheus:
![prometheus-target](public/prometheus-target.png){:width="100%"}