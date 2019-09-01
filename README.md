# vyos

An environment to play with multi-nic vyos router inside docker running KVM considering:

a) multiple interfaces on different vlans are managed using macvtap interfaces inside the virtual KVM ifaces inside the docker container 
b) docker macvlan interfaces are mapped to KVM macvtap iface 
b) ansible playbook to provision the vyos router confifguration, get certs, vpns
