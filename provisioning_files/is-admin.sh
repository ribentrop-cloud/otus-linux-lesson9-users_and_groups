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
