# Домашнее задание к занятию "`Система мониторинга Zabbix`" - `Александр М.`

---

### Задание 1

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите PostgreSQL. Для установки достаточна та версия, что есть в системном репозитороии Debian 11.
3. Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
4. Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.

#### Требования к результатам 
1. Прикрепите в файл README.md скриншот авторизации в админке.
2. Приложите в файл README.md текст использованных команд в GitHub.

### Решение 1

```
# wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian12_all.deb
# sudo dpkg -i zabbix-release_latest_7.0+debian12_all.deb
# sudo apt update
# sudo apt install zabbix-server-pgsql zabbix-frontend-php php8.2-pgsql # zabbix-apache-conf zabbix-sql-scripts
# sudo apt install postgressql
# sudo -u postgres createuser --pwprompt zabbix
# sudo -u postgres createdb -O zabbix zabbix
# zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
# sudo nano /etc/zabbix/zabbix_server.conf
                        > DBPassword=password
# sudo systemctl restart zabbix-server apache2
# sudo systemctl enable --now zabbix-server apache2

```

![login zabbix](img/zabbix1.png)


---

### Задание 2

Установите Zabbix Agent на два хоста.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите Zabbix Agent на 2 вирт.машины, одной из них может быть ваш Zabbix Server.
3. Добавьте Zabbix Server в список разрешенных серверов ваших Zabbix Agentов.
4. Добавьте Zabbix Agentов в раздел Configuration > Hosts вашего Zabbix Servera.
5. Проверьте, что в разделе Latest Data начали появляться данные с добавленных агентов.

#### Требования к результатам
1. Приложите в файл README.md скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу
2. Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером
3. Приложите в файл README.md скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные.
4. Приложите в файл README.md текст использованных команд в GitHub

### Решение 2

```
# sudo apt install zabbix-agent
# sudo nano /etc/zabbix/zabbix_agentd.conf
                        > Server=127.0.0.1
# sudo systemctl restart zabbix-agent
# sudo systemctl enable --now zabbix-agent
```

![zabbix_agentd.log](img/agent3.png)
![hosts](img/agent1.png)
![latest data](img/agent2.png)

---

### Задание 3 со звёздочкой*
Установите Zabbix Agent на Windows (компьютер) и подключите его к серверу Zabbix.

#### Требования к результатам
1. Приложите в файл README.md скриншот раздела Latest Data, где видно свободное место на диске C:

### Задание 3

`При необходимости прикрепитe сюда скриншоты
![Название скриншота](ссылка на скриншот)`
