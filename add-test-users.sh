#!/bin/bash
sudo useradd testuser 
sudo useradd testuser1 
sudo useradd testuser2
echo "Otus2020"|sudo passwd --stdin testuser
echo "Otus2020"|sudo passwd --stdin testuser1
echo "Otus2020"|sudo passwd --stdin testuser2
sudo groupadd admin
sudo groupadd weekend_admin
sudo usermod -G admin testuser
sudo usermod -G weekend_admin testuser2
sudo usermod -G admin vagrant

#sudo sed  -i -E "s/^PasswordAuthentication\s+no/PasswordAuthentication yes/" /etc/ssh/sshd_config
#sudo systemctl restart sshd
#sudo sed  -i -E "s/account.+required.+pam_nologin.so/account    required     pam_nologin.so\naccount    required    pam_exec.so    \/usr\/local\/bin\/is-admin.sh/" /etc/pam.d/sshd

