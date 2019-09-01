#!/bin/sh

sleep 100
ansible-playbook -i prov/hostscp prov/prov.yml
ansible-playbook -i prov/hosts prov/config.yml
tail -f /dev/null
