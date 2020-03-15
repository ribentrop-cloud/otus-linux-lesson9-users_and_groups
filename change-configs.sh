#!/bin/bash
sudo sed  -i -E "s/^PasswordAuthentication\s+no/PasswordAuthentication yes/" /etc/ssh/sshd_config
sudo sed  -i -E "s/account.+required.+pam_nologin.so/account    required     pam_nologin.so\naccount    required    pam_exec.so    \/usr\/local\/bin\/is-admin.sh/" /etc/pam.d/sshd
sudo systemctl restart sshd
