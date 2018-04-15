---
layout: post
title: Сборка deb пакета из программы на Python
categories: Linux
subcategories:
permalink: /making-deb-packet-from-Python-file
---

Дано - примитивный демон на python, который:
 1. Слушает 80 порт;
 2. Возвращает строку "It Works";
 3. Читает из конфигурационного файла расположение log файла;
 4. Пишет в указанный log файл о соединении;
 5. Закрывает соединение.
 
<!---excerpt-break-->

Исходный код демона:
```python 
import socket

server = socket.socket()
server.bind(('', 80))
server.listen(1)

with open('/etc/python-listener/default.conf', 'r') as conf_file:
    for line in conf_file:
        if 'LOG:' in line:
            log_file_path = line.split('\'')[1]
conf_file.close()

while True:
    with open(log_file_path, 'a') as log_file:
        conn, address = server.accept()
        log_file.write('{} connected\n'.format(address))
        conn.send(str('It Works\n'))
        conn.close()
        log_file.write('{} disconnected\n'.format(address))
    log_file.close()
```
	
Запакуем программу в единый бинарный файл со всеми зависимостями с использованием pyinstaller:
```bash
 pyinstaller --onefile /opt/python-listener/python-listener.py
```

Существует опция запаковки зависимостей отдельно (без использования ключа ```onefile```), которая позволяет существенно сократить размер бинарного файла за счет вынесения из него зависимостей, но в данной статье мы ей не воспользуемся. 

Начнем готовить среду для создания deb пакета:
```bash
cd /opt/python-listener/
mkdir DEBIAN
cd DEBIAN 
```

Опишем основные свойства пакета (обязательный файл):
```bash
cat <<EOF > control
Package:      python-listener
Version:      1.0-2017.12.17
Maintainer:   Maintainer <maintainer-mail@mail.com>
Architecture: all
Section:      web
Description:  Simple Python Listener Daemon
Depends:      python2.7
EOF
```

Подготовим остальные используемые файлы: 
 * Созданный ранее бинарный файл python-listener в директории ```/opt/python-listener/usr/bin/```;
 * Файл конфигурации ```default.conf``` в директории ```/opt/python-listener/etc/python-listener/``` с единственной строкой:
```bash 
LOG: '/var/log/python-listener.log'
```
 * Юнит systemd ```python-listener.service``` в директории ```/opt/python-listener/lib/systemd/system/``` следующего содержания:
 
```bash
[Unit]
Description=Simple Python Listener Daemon
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/bin/python-listener

[Install]
WantedBy=multi-user.target
```

После подготовки имеется следующая иерархия файлов и директорий:
```bash
/opt/python-listener# tree 
.
├── DEBIAN
│   └── control
├── etc
│   └── python-listener
│       └── default.conf
├── lib
│   └── systemd
│       └── system
│           └── python-listener.service
└── usr
    └── bin
        └── python-listener
```
		
Соберем пакет:
```bash
dpkg-deb -b /opt/python-listener/
```

В итоге на выходе получим пакет ```python-listener.deb```, который может быть установлен в систему с использованием команды 
```bash
dpkg -i python-listener.deb
```
