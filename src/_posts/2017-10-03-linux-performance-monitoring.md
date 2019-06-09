---
layout: post
title: Linux Performance Monitoring
categories: Linux
permalink: /linux-performance-monitoring
---

## Содержание
   * [CPU & Memory Usage](/linux-performance-monitoring#cpu-memory-usage)
   * [Disk IO](/linux-performance-monitoring#disk-io)
   * [Network IO](/linux-performance-monitoring#network-io) 
   
## CPU & Memory Usage <a name="cpu-memory-usage"></a>

**stress** - утилита для эмуляции нагрузки.

### Утилиты для мониторинга производительности
  
**vmstat** - краткая информация по утилизации системных ресурсов;
  
**free** - краткая информация по использованию памяти;
  
**top** - сводная таблица по использованию памяти/процессора.

<!---excerpt-break-->

### Расшифровка состояний процессора 

**us, user** : time running un-niced user processes;

**sy, system** : time running kernel processes;

**ni, nice** : time running niced user processes;

**id, idle** : time spent in the kernel idle handler ;

**wa, IO-wait** : time waiting for I/O completion;

**hi** : time spent servicing hardware interrupts;

**si** : time spent servicing software interrupts.
  
**st** : time stolen from this vm by the hypervisor

## Disk IO <a name="disk-io"></a>

### Утилиты для мониторинга обращений к диску
  
**iotop** - топ процессов по IO;
  
**iostat** (поставляется в пакете sysstat) - статистика по IO на различных носителях;
  
**sar** (поставляется в пакете sysstat) - сбор статистики по различным параметрам системы с заданным интервалом;
  
**lsof** (list open files) - список файлов, к которым обращается определенный процесс.

## Network IO <a name="network-io"></a>

### Утилиты для мониторинга сетевой активности
  
**ifconfig** (поставляется в пакете net-tools) - статистика по сетевым интерфейсам;
  
**netstat** (поставляется в пакете net-tools) - различная статистика по сетевым параметрам (заменено ss);
  
**ss** (поставляется в пакете iproute2) - статистика по текущим сетевым соединениям и открытым портам;
  
**iftop** - статистика по сетевым соединениям в реальном времени;
  
**nload** - статистика по загрузке интерфейсов в реальном времени.
