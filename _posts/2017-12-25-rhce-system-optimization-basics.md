---
layout: post
title: RHCE System Optimization Basics
categories: Linux
subcategories: RHCE
permalink: /rhce-system-optimization-basics
---

## Contents
   * [procfs](/rhce-system-optimization-basics#procfs)
   * [sysfs](/rhce-system-optimization-basics#sysfs)
   * [Tuned](/rhce-system-optimization-basics#Tuned)    

## procfs <a name="procfs"></a>

```procfs```is a virtual filesystem, usually mounted on```/proc```. Contains generic kernel parameters.
```bash
mount | grep proc
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
```

<!---excerpt-break-->

Utilities for displaing information like system processes (```top```,```ps```, etc...) takes data from the```/proc```directory, for example,```lscpu```use```/proc/cpuinfo```file as one of the source. 

Wherein data that```/proc```contains may not be in human-readable format. 

It is worth noting that```/proc```contains directories of the form```/proc/<PID>```in which there are files with the information about the currently running processes. 

For example, output of the```/proc/<PID>/cmdline```shows command, by whitch the process was started:
```bash
ps aux | grep -v grep | grep nginx
root      1449  0.0  0.0  46308  1148 ?        Ss   Dec16   0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
nginx     1451  0.0  0.1  46824  2176 ?        S    Dec16   0:00 nginx: worker process

cat /proc/1449/cmdline 
nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf%  
```

Usually, user can't change files in the```/proc```directory, permissions of this files are read-only even for root. 

One of the exceptions is the```/proc/sys```directory. Manual tuning of the kernel parameters is carried out by changing the contents of files in this directory.
For example,```/proc/sys/net```contains settings related to network traffic management.

Example of disabling ipv6 on a running system using```echo```command:
```bash
ip addr | grep inet6 | wc -l
2

echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

ip addr | grep inet6 | wc -l                      
0
```
It's important, that this way of changing kernel parameters works only while the system is running. Settings won't be saved after reboot of the system, because```/proc```files are computed on request.

Note that it's not recommended to change kernel optins in the```/proc/sys```using text editors. This action may violate the integrity of the file.

Another way to change kernel parameters is the```sysctl```utility. An example```sysctl```output of all parameters that can be changed:
```bash
sysctl -a 
```
Example of enabling ipv6 on a running system using```sysctl```:
```bash
ip addr | grep inet6 | wc -l
0

sysctl -w net.ipv6.conf.all.disable_ipv6=0  
net.ipv6.conf.all.disable_ipv6 = 0

ip addr | grep inet6 | wc -l
2
```
For a permanent effect, it need to specify parameters to be changed in```/etc/sysctl.conf```(symlink to```/etc/sysctl.d/99-sysctl.conf```) or in one of the following directories:
```bash
/etc/sysctl.d/
/usr/lib/sysctl.d/
/run/sysctl.d/
```
The```sysctl```command with```-p```key can be used to immediately apply the contents of all listed files. 

## sysfs <a name="sysfs"></a>

```sysfs```is a virtual filesystem, usually mounted on```/sys```. Contains symbolic links to hardware related parameters. Doesn't have it's own```sysctl```. Sub filesystems are also mounted on```/sys/*```.  
```bash
mount | grep sys 
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_prio,net_cls)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
configfs on /sys/kernel/config type configfs (rw,relatime)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=30,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11284)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
```
Example of tuning hardware related parameters through```/sys```(disabling CPU):
```bash
lscpu | grep 'CPU(s)'
CPU(s):                8
On-line CPU(s) list:   0-7

ls /sys/devices/system/cpu/ | grep cpu
cpu0
cpu1
cpu2
cpu3
cpu4
cpu5
cpu6
cpu7

echo 0 > /sys/devices/system/cpu/cpu1/online

dmesg | grep 'CPU 1'
[764966.775449] smpboot: CPU 1 is now offline

lscpu | grep 'CPU(s)'
CPU(s):                8
On-line CPU(s) list:   0,2-7
Off-line CPU(s) list:  1
NUMA node0 CPU(s):     0,2-7
```

## Tuned <a name="Tuned"></a>

The simplest way to set recommended parameters for a particular usage profile is the```Tuned```utility.
To list all profiles:
```bash
tuned-adm list
```
All profile settings are in the```/usr/lib/tuned/```directory. For example, a desktop```Tuned```profile:
```bash
cat /usr/lib/tuned/descktop/tuned.conf
#
# tuned configuration
#

[main]
summary=Optimize for the desktop use-case
include=balanced

[sysctl]
kernel.sched_autogroup_enabled=1
```
