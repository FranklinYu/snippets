set -o errexit

parted --script /dev/sda mklabel msdos
parted --script /dev/sda mkpart primary linux-swap 1MiB 4GiB
parted --script /dev/sda mkpart primary 4GiB 100%
echo '[info]: Disk partitioned.'

mkswap -L swap /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
echo '[info]: Filesystem created.'

swapon /dev/sda1
sleep 1 # for some reason the file isn’t available immediately
mount /dev/disk/by-label/nixos /mnt

nixos-generate-config --root /mnt 2>&1
(cd /mnt && patch -p 1 < /tmp/configuration.patch)
nixos-install --no-root-passwd

echo root:vagrant | chpasswd --root /mnt

ssh_dir=/mnt/home/vagrant/.ssh
mkdir --mode=0700 --verbose $ssh_dir
version_pin=7ffbf85c1d9249c156f3140fe0d6f8df5c084877
url=https://cdn.jsdelivr.net/gh/hashicorp/vagrant@$version_pin/keys/vagrant.pub
curl $url --output $ssh_dir/authorized_keys
chmod 0600 $ssh_dir/authorized_keys
chown --recursive --verbose --reference=/mnt/home/vagrant $ssh_dir
