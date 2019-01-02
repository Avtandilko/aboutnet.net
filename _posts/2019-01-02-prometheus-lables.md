---
layout: post
title: Prometheus Labels
categories: Containers
subcategories: Kubernetes
permalink: /prometheus-kubernetes
---

## Содержание

В этой статье я хочу разобрать механизм работы service discovery в Prometheus для Kubernetes.

### Какие метки отдает Kubernetes
### Как работает Service Discovery в Prometheus
### Манипуляции над метками

Концепция - Prometheus идет в API Kubernetes. Адрес API и необходимые реквизиты указываются в конфигурации. Посмотрим, как это происходит на примере кастомного приложения ui, которое задеплоено в кластер манифестом:

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


Алгоритм работы (на примере pods):

1. Создаем job с типом pods, указываем Prometheus конфигурацию кластера (адрес API, реквизиты)
2. Prometheus идет в кластер примерно по такому адресу https://<API_address>/api/v1/namespaces/<namespace_name>/pods/<pod_name> и получает метаданные каждого пода в следующем формате (оставлен только вывод который будет преобразован в формат Prometheus):

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

1. Преобразует полученные метаданные (те, которые приведены выше в json) в собственный формат меток. Для pods возможно создание следующих meta labels (выдержка из документации Prometheus):
```
__meta_kubernetes_namespace: The namespace of the pod object.
__meta_kubernetes_pod_name: The name of the pod object.
__meta_kubernetes_pod_ip: The pod IP of the pod object.
__meta_kubernetes_pod_label_<labelname>: The label of the pod object.
__meta_kubernetes_pod_annotation_<annotationname>: The annotation of the pod object.
__meta_kubernetes_pod_container_name: Name of the container the target address points to.
__meta_kubernetes_pod_container_port_name: Name of the container port.
__meta_kubernetes_pod_container_port_number: Number of the container port.
__meta_kubernetes_pod_container_port_protocol: Protocol of the container port.
__meta_kubernetes_pod_ready: Set to true or false for the pod's ready state.
__meta_kubernetes_pod_phase: Set to Pending, Running, Succeeded, Failed or Unknown in the lifecycle.
__meta_kubernetes_pod_node_name: The name of the node the pod is scheduled onto.
__meta_kubernetes_pod_host_ip: The current host IP of the pod object.
__meta_kubernetes_pod_uid: The UID of the pod object.
__meta_kubernetes_pod_controller_kind: Object kind of the pod controller.
__meta_kubernetes_pod_controller_name: Name of the pod controller.
```

5. Итого в web-интерфейсе Prometheus будет отображен найденный pod и все его метки в преобразованном формате:
![prometheus-target](public/prometheus-target.png){:width="70%"}