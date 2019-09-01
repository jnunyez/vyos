#!/bin/vbash

curl https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh > /config/user-data/letsencrypt/acme.sh
sudo /bin/sh /config/user-data/letsencrypt/acme.sh --home /config/user-data/letsencrypt --standalone -d loc2casa.duckdns.org --issue 
