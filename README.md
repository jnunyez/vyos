# vyos

An environment to play with multi-nic vyos router inside docker running KVM considering:

1) multiple interfaces on different vlans are managed using macvtap interfaces inside the virtual KVM ifaces inside the docker container 

2) docker macvlan interfaces are mapped to KVM macvtap iface 

3) ansible playbook to provision the vyos router confifguration, get certs, vpns
