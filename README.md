# Firecracker vs Docker
## rep description
In this report, a machine learning model (KNN) is run on Firecracker and a Docker container, both on CPU, and the performance of the algorithm is benchmarked in both scenarios. GPU utilization is not taken into account.

## Firecracker part
there is a complete documentat on [Getting Started with Firecracker](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md#getting-started-with-firecracker). but there are some considerations for deploying a model on firecracker that I listed and answered.
- there aren't enough storage for installing python and other libraries on the Vm so you have increase it as shown below (I chosed 5G but you can define more if needed):
 ```
truncate -s 5G final-hello-rootfs.ext4
sudo mkfs.ext4 final-hello-rootfs.ext4

mkdir /mnt/psudo_partition/
mkdir /mnt/original_partition/

mount final-hello-rootfs.ext4 /mnt/psudo_partition/
mount hello-rootfs.ext4 /mnt/original_partition/

cp -r /mnt/original_partition/* /mnt/psudo_parition/

umount /mnt/original_partition/
umount /mnt/psudo_partition/
 ```
- there is no network configuration for the VM so you will have many problems for connections, Downloading and etc. you can config the network as following:

**In Host**
```
sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.16.0.1/24 dev tap0
sudo ip link set tap0 up
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o eth0 -j ACCEPT
```
**In guest**
```
echo "nameserver 8.8.8.8" > /etc/resolv.conf  

ip addr add 172.16.0.2/24 dev eth0
ip link set eth0 up
ip route add default via 172.16.0.1 dev eth0
```
after finishing this part you should update the package manager
```
apt update
apt install vim
```
this part can be ambigous even after reading the whole document provided by [firecracker network setup](https://github.com/firecracker-microvm/firecracker/blob/main/docs/network-setup.md) so I got help from this three:
External resource:
https://kruzenshtern.org/firecracker-network-setup/  
https://gist.github.com/s8sg/1acbe50c0d2b9be304cf46fa1e832847  
https://blog.herecura.eu/blog/2020-05-21-toying-around-with-firecracker/
Finally I installed python on VM by
```
apt install python3 python3-pip -y
pip3 install numpy
```
and for conveying the test1 folder to VM Nginx is used

### why KNN
It is preferable to run a more complex DNN in order to gain insight into the impact of the underlying system on the model-serving performance. However, due to time constraints, it was decided to opt for the KNN approach initially. In order to provide more accurate results, the model should be run 100 or 1000 times and the average time calculated so having a more complex model will multiply the time. This is due to the fact that a single run may be biased and not provide an accurate result. Additionally, the complexity of a model requires the downloading of numerous libraries when building a Docker Image. This can be a challenge due to current connection and filtering issues within Iran. As such, the KNN model was written from scratch, only relying on the NumPy library.
