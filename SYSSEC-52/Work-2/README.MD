# Домашнее задание к занятию "`Защита хоста`" - `Александр М.`

### Задание 1

1. Установите **eCryptfs**.
2. Добавьте пользователя cryptouser.
3. Зашифруйте домашний каталог пользователя с помощью eCryptfs.


*В качестве ответа  пришлите снимки экрана домашнего каталога пользователя с исходными и зашифрованными данными.*  

### Решение 1

1. `sudo apt update`
2. `sudo apt install ecryptfs-utils`
3. `sudo adduser --encrypt-home cryptouser`
4. `sudo ls -la /home/cryptouser/`

![user ls](img/user2.png)

1. `su - cryptouser`
2. `touch hellonetology`
3. `ls -la ~`
4. `exit`
5. `sudo ls -la /home/cryptouser/`

![user ls](img/user1.png)

---

### Задание 2

1. Установите поддержку **LUKS**.
2. Создайте небольшой раздел, например, 100 Мб.
3. Зашифруйте созданный раздел с помощью LUKS.

*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

1. `sudo apt update`
2. `sudo apt install cryptsetup`
3. `sudo fdisk /dev/sdb`
4. `sudo cryptsetup luksFormat /dev/sdb1`

![luks 1](img/luks1.png)

1. `sudo cryptsetup open /dev/sdb1 luks_netology`
2. `sudo mkfs.ext4 /dev/mapper/luks_netology`
3. `sudo mkdir /mnt/luks_netology`
4. `sudo mount /dev/mapper/luks_netology /mnt/luks_netology`
6. `touch /mnt/luks_netology/HelloNetologyLuks`

![luks 2](img/luks2.png)

1. `sudo umount /mnt/luks_netology`
2. `sudo cryptsetup close luks_netology`

![luks 3](img/luks3.png)

---

### Задание 3 *

1. Установите **apparmor**.
2. Повторите эксперимент, указанный в лекции.
3. Отключите (удалите) apparmor.


*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

```
Поле для вставки кода...
....
....
....
....
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота](ссылка на скриншот)`

