#!/bin/bash

clish -c "lock database override" || true
clish -c 'set message banner on line msgvalue "+---------------------------------------+"' -s
clish -c 'set message banner on line msgvalue "|     UNAUTHORISED ACCESS TO THIS       |"' -s
clish -c 'set message banner on line msgvalue "|        SYSTEM IS PROHIBITED.          |"' -s
clish -c 'set message banner on line msgvalue "+---------------------------------------+"' -s
clish -c 'save config' -s
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/templates/sshd_config.templ
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/templates/sshd_config.templ
/bin/sshd_template_xlate </config/active
service sshd reload
echo -e "\nFinished gaia configuration"
