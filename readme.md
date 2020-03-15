## Описание решения
### Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье) без учета праздников
Тестовое окружение настраивается в Vagrant.  
  
Выполненное задание было немного модицифировано в целях более наглядной проверки. А именно, кроме пользователя, принадлежащего группе __admin__, был создан пользователь, принадлежащей группе __weekend_admin__. Для членов группы __weekend_admin__ доступ разрешен только в выходные дни.
1. Создаем пользователей для проверки:  
- Пользователь __testuser__ - пароль '__Otus2020__'. Пользователь __является членом группы admin__. Для членов группы admin доступ должен быть 7 дней в неделю.  
- Пользователь __testuser1__ - пароль '__Otus2020__'. Пользователь  __является членом группы weekend_admin__. Для членов группы __weekend_admin__ доступ должен быть только по выходным.  
- Пользователь __testuser2__ - пароль '__Otus2020__'. Пользователь  __не является членом ни одной группы__. Для таких пользователей доступ должен быть только по рабочим дням.
```bash
sudo useradd testuser testuser1 testuser2
echo "Otus2020"|sudo passwd --stdin testuser
echo "Otus2020"|sudo passwd --stdin testuser1
echo "Otus2020"|sudo passwd --stdin testuser2
sudo groupadd admin
sudo groupadd weekend_admin
sudo usermod -G admin testuser
sudo usermod -G weekend_admin testuser2
```
2. Дополнительно в целях проверки домашнего задания разрешаем вход по ssh с аутентификацией по паролю:
```sh
sudo sed  -i -E "s/^PasswordAuthentication\s+no/PasswordAuthentication yes/" /etc/ssh/sshd_config
sudo systemctl restart sshd
```
3. Меняем _/etc/pam.d/sshd_ для прохождения дополнительной аутентификации через модуль pam_exec:
```sh
sudo sed  -i -E "s/account.+required.+pam_nologin.so/account    required     pam_nologin.so\naccount    required    pam_exec.so    \/usr\/local\/bin\/is-admin.sh/" /etc/pam.d/sshd
```
4. Создаем bash срипт, который выясняет, входит ли пользователь в группу _admin/weekend_admin_, получает день недели и принимает решение о завершении с кодом 0 или 1 в зависимости от принятого решения.  
Этот скрипт будет размещен в /usr/local/bin/:
```sh
#!/bin/bash
echo "PAM_USER"$PAM_USER
if id -nG $PAM_USER | grep -qw "admin"; then
        echo "group admin"
        exit 0
else
        if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
                        if id -nG $PAM_USER | grep -qw "weekend_admin"; then
                                echo "group weekend_admin"
                                exit 0
                        else
                echo "Sa-Su other group"
                exit 1
                        fi
        else
                echo "Mo-Fri all users"
                exit 0
        fi
fi
```
5. Реализуем п.п.1-4 в виде provision скрипта или provision команд файла _vagrantfile_.

__Проверка:__
1. vagrant up
2. vagrant ssh (пользователь vagrant так же был включен в группу __admin__ )
3. Пробуем войти:  
-ssh testuser@localhost,  
-ssh testuser1@localhost,  
-ssh testuser2@localhost  
с паролем _Otus2020_. 
Получаем результат в зависимости от дня недели.
