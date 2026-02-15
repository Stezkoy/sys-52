# Домашнее задание к занятию "`Репликация и масштабирование. Часть 1`" - `Александр М.`

### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Ответить в свободной форме.*



```
Master - принимает записи от всех,  Slave - только копирует, сами писать не может

```

```
Master-Master - оба и пишут, и копируют друг у друга

```



---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

master.sql
```
CREATE USER 'repl'@'%' IDENTIFIED BY 'replpass';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
```
```
SHOW MASTER STATUS;
```
slave.sql
```
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='mysql_master',
  SOURCE_USER='repl',
  SOURCE_PASSWORD='replpass',
  SOURCE_LOG_FILE='mysql-bin.000001',
  SOURCE_LOG_POS=156,
  SOURCE_SSL=1;
START REPLICA;
```
```
SHOW REPLICA STATUS\G;
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота 2](ссылка на скриншот 2)`


---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

masterone.sql
```
CREATE USER 'repl_1'@'%' IDENTIFIED BY 'pass';
GRANT REPLICATION SLAVE ON *.* TO 'repl_1'@'%';
CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='master-2',
    SOURCE_USER='repl_2',
    SOURCE_PASSWORD='pass',
    SOURCE_SSL=1;
START REPLICA;

```
mastertwo.sql
```
CREATE USER 'repl_1'@'%' IDENTIFIED BY 'pass';
GRANT REPLICATION SLAVE ON *.* TO 'repl_1'@'%';
CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='master-2',
    SOURCE_USER='repl_2',
    SOURCE_PASSWORD='pass',
    SOURCE_SSL=1;
START REPLICA;
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота](ссылка на скриншот)`

