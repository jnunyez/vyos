#!/bin/vbash

logger "Renewal IPSec public certificate"
source /opt/vyatta/etc/functions/script-template

# activate web port for ACME challenge
set firewall name WAN_LOCAL rule 142 action accept
set firewall name WAN_LOCAL rule 142 description SSLAcmeCertificate
set firewall name WAN_LOCAL rule 142 protocol tcp
set firewall name WAN_LOCAL rule 142 destination port 80
commit

curl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh > /config/user-data/letsencrypt/acme.sh
sudo /bin/sh /config/user-data/letsencrypt/acme.sh --home /config/user-data/letsencrypt --standalone -d loc2casa.duckdns.org --issue --renew

# deactivate web port

delete firewall name WAN_LOCAL rule 142
commit
save
exit

# refresh certificate
sudo ipsec rereadall
