Basico(){	
  hostnamectl set-hostname Kawasaki
  passwd
}

ConfigBoot(){
  echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
  sed -i '/GRUB_TIMEOUT=/s/5/0/g' /etc/default/grub
  sed -i '/GRUB_CMDLINE_LINUX=/s/""/"cryptdevice=\/dev\/sda2:crypto"/g' /etc/default/grub
  grub-install /dev/sda
  
  sed -i ':a;$!{N;ba;};s/\(.*\)filesystems/\1encrypt lvm2 filesystems/' /etc/mkinitcpio.conf
  mkinitcpio -p linux
  
  mkdir /run/lvm
  mount --bind /hostrun/lvm /run/lvm

  grub-install --recheck /dev/sda
  grub-mkconfig --output /boot/grub/grub.cfg
  
  sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=suspend/g' /etc/systemd/logind.conf # altera a função do botao de desligar para suspender
}

LinguagemRegiao(){
  echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
  mv /etc/localtime /etc/localtime_orig
  ln -s /usr/share/zoneinfo/America/Bahia /etc/localtime
  hwclock --systohc --utc
}

Rede(){
  pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
  systemctl enable netctl-auto@`ip addr | grep "<" | grep -vi loopback | awk '{print $2}' | sed 's/://g' | grep w` ### habilita permanentemente o cliente de DHCP para a interface wireless
  systemctl enable netctl-ifplugd@`ip addr | grep "<" | grep -vi loopback | awk '{print $2}' | sed 's/://g' | grep e` ### habilita permanetemente o cliente de DHCP para o interface ethernet
}

Basico
ConfigBoot
LinguagemRegiao
Rede
