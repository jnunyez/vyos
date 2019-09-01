#!/bin/sh

ip link add link eth1 name macvtap1 address 00:22:33:44:55:66 type macvtap mode bridge
ip link set dev macvtap1 up

tapindex1=`cat /sys/class/net/macvtap1/ifindex`
IFS=':' read major minor < "/sys/devices/virtual/net/macvtap1/tap$tapindex1/dev"
mknod "/dev/tap$tapindex1" c $major $minor

ip link add link eth2 name macvtap2 address 52:55:00:d1:55:03 type macvtap mode bridge
ip link set dev macvtap2 up

tapindex2=`cat /sys/class/net/macvtap2/ifindex`
IFS=':' read major minor < "/sys/devices/virtual/net/macvtap2/tap$tapindex2/dev"
mknod "/dev/tap$tapindex2" c $major $minor

ip link add link eth3 name macvtap3 address 52:55:00:d1:55:04 type macvtap mode bridge
ip link set dev macvtap3 up

tapindex3=`cat /sys/class/net/macvtap3/ifindex`
IFS=':' read major minor < "/sys/devices/virtual/net/macvtap3/tap$tapindex3/dev"
mknod "/dev/tap$tapindex3" c $major $minor



# create bridge and tap iface for eth0 in vyos
ip link add name br0 type bridge
ip tuntap add mode tap tap0
ip link set tap0 master br0
ip link set dev br0 up
ip link set dev tap0 up

ip addr add 192.168.99.1/30 dev br0

# conect to VM for provisioning
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 22 -j DNAT --to-destination 192.168.99.2:22

dnsmasq -i br0 --dhcp-range=192.168.99.2,192.168.99.2,255.255.255.252,24h

#ip link add name br1 type bridge
#ip tuntap add mode tap tap1
#ip link set tap1 master br1
#ip link set dev br1 up
#ip link set dev tap1 up

#ip link add link eth1 name macvtap type macvtap mode bridge
#ip link set dev macvtap up

#ip link add name br2 type bridge
#ip tuntap add mode tap tap12
#ip link set tap12 master br2
#ip link set dev br2 up
#ip link set dev tap12 up

#ip link add name br3 type bridge
#ip tuntap add mode tap tap13
#ip link set tap13 master br3
#ip link set dev br3 up
#ip link set dev tap13 up


tapdev1=/dev/tap"$tapindex1"
tapdev2=/dev/tap"$tapindex2"
tapdev3=/dev/tap"$tapindex3"

# launch QEMU -serial telnet:0.0.0.0:1234,server,nowait 
#exec ${tapindex}<>/dev/tap${tapindex} 
/usr/bin/qemu-system-x86_64 -nographic -serial mon:stdio -device virtio-net,netdev=network0,mac=52:55:00:d1:55:01 -netdev tap,id=network0,ifname=tap0,script=no,downscript=no -device virtio-net,netdev=network1,mac=00:22:33:44:55:66 -netdev tap,id=network1,fd=10 10<>"$tapdev1" -device virtio-net,netdev=network2,mac=52:55:00:d1:55:03 -netdev tap,id=network2,fd=11 11<>"$tapdev2" -device virtio-net,netdev=network3,mac=52:55:00:d1:55:04 -netdev tap,id=network3,fd=12 12<>"$tapdev3" -m 512 -smp 1 -machine type=pc,accel=kvm -drive file=/root/vyos.img,if=virtio,cache=writeback,discard=ignore,format=qcow2 -boot once=d 
