CriarParticoes(){
	parted -s /dev/sda mklabel msdos
	parted -s /dev/sda mkpart primary ext4 1MiB 257MiB
	parted -s /dev/sda mkpart primary ext4 257MiB 100%
	parted -s /dev/sda set 1 boot on
}

Criptografar(){
	modprobe dm-crypt
	cryptsetup -c aes-xts-plain64 -y -s 512 luksFormat /dev/sda2
	cryptsetup luksOpen /dev/sda2 crypto
}

CriarVolumes(){
	pvcreate /dev/mapper/crypto
	vgcreate lvm /dev/mapper/crypto
	lvcreate -L 2G lvm -n swap
	lvcreate -L 16G lvm -n root
	lvcreate -l 100%FREE lvm -n home
}

FormatarVolumesParticoes(){
	# dd if=/dev/zero of=/dev/sda1 bs=1M status=progress
	mkfs.ext2 /dev/sda1
	mkfs.ext4 /dev/mapper/lvm-root
	mkfs.ext4 /dev/mapper/lvm-home
	mkswap /dev/mapper/lvm-swap
}

MontarVolumesParticoes(){
	mount /dev/mapper/lvm-root /mnt
	mkdir /mnt/home
	mount /dev/mapper/lvm-home /mnt/home
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	swapon /dev/mapper/lvm-swap
}

InstalarSistema(){

	pacstrap /mnt base base-devel grub-bios
}

CriarTabelaDiscos(){

	genfstab -U -p /mnt >> /mnt/etc/fstab
}

ComandosExtras(){
	mkdir /mnt/hostrun 
	mount --bind /run /mnt/hostrun
	
	wget raw.githubusercontent.com/RicardoKeso/cripto/master/p02.sh -O /mnt/root/p02.sh
	wget raw.githubusercontent.com/RicardoKeso/cripto/master/p03.sh -O /mnt/root/p03.sh

	echo "" >> /mnt/root/.bashrc
	cp /mnt/root/.bashrc /mnt/root/.bashrc_orig
	echo "/root/p02.sh" > /mnt/root/.bashrc
	echo "/root/p03.sh" > /mnt/root/.bashrc
	chmod +x /mnt/root/p02.sh
	chmod +x /mnt/root/p03.sh
	chmod +x /mnt/root/.bashrc

	arch-chroot /mnt /bin/bash
}

CriarParticoes
Criptografar
CriarVolumes
FormatarVolumesParticoes
MontarVolumesParticoes
InstalarSistema
CriarTabelaDiscos
ComandosExtras
