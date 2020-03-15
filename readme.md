## Описание решения
### Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
Тестовое окружение настраивается в Vagrant.  
Выполненное задание было немного модицифировано в целях более наглядной проверки. А именно, кроме пользователя, принадлежащего группе admin, был создан пользователь, принадлежащей группе weekend_admin. Для членов группы weekend_admin доступ разрешен только в выходные дни.
1. Создаем пользователей для проверки.
Пользователь _testuser_ - пароль '_Otus2020_'. Пользователь __является членом группы admin__. Для членов группы admin доступ должен быть 7 дней в неделю.  
Пользователь _testuser1_ - пароль 'Otus2020'. Пользователь  __является членом группы weekend_admin__. Для членов группы weekend_admin доступ должен быть только по выходным.
Пользователь _testuser2_ - пароль 'Otus2020'. Пользователь  __не является членом ни одной группы__. Для таких пользователей доступ должен быть только по рабочим дням.
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
sudo sed  -i -E "s/#PasswordAuthentication\s+yes/PasswordAuthentication yes/" /etc/ssh/sshd_config
sudo systemctl restart sshd
```
3. Меняем /etc/pam.d/sshd для прохождения дополнительной аутентификации через модуль pam_exec.
```sh
sudo sed  -i -E "s/account.+include.+password-auth/account    include    password-auth\naccount    required    pam_exec.so    \/usr\/local\/bin\/is-admin.sh/" /etc/pam.d/sshd
```
4. Создаем bash срипт, который выясняет, входит ло пользователь в группу admin/weekend_admin, получает день недели и принимает решение о завершении с кодом 0 или 1 в зависимости от принятого решения. Этот скрипт будет размещен в /usr/local/bin/
```sh
#!/bin/bash
echo "PAM_USER"$PAM_USER
if id -nG $PAM_USER | grep -qw "admin"; then
        echo "group admin"
        exit 0
else
        if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
                echo "Sa-Su other group"
                exit 1
        else
                echo "Mo-Fri all users"
                exit 0
        fi
fi
```
5. Реализуем п.п.1-4 в виде provision скрипта или provision команд файла Vagrant file.

__Проверка:__
1. vagrant up
2. vagrant ssh
3. Пробуем войти под testuser,testuser1,testuser с паролем Otus2020. Получаем результат в зависимости от дня недели.
