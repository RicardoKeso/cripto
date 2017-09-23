servidorX(){
  pacman -S xorg xorg-xinit --noconfirm ### instala o servidor X
  echo "" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "Section \"InputClass\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "    Identifier \"evdev keyboard catchall\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "    MatchIsKeyboard \"on\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "    MatchDevicePath \"/dev/input/event*\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "    Driver \"evdev\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "    Option \"XkbLayout\" \"br\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "    Option \"XkbVariant\" \"abnt2\"" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "EndSection" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
  echo "" >> /usr/share/X11/xorg.conf.d/10-evdev.conf
}

ambienteGrafico(){

  pacman -S xfce4 xfce4-goodies --noconfirm
  pacman -S docky --noconfirm
  pacman -S lightdm lightdm-gtk-greeter light-locker --noconfirm
  pacman -S networkmanager network-manager-applet --noconfirm
}

yaourt(){
  pacman -S yaourt --noconfirm ### instala o yaourt (repositório não oficial de usuários do Arch)
  echo "" >> /etc/pacman.conf
  echo "[archlinuxfr]" >> /etc/pacman.conf
  echo "SigLevel = Never" >> /etc/pacman.conf
  echo "Server = http://repo.archlinux.fr/`uname -m`/" >> /etc/pacman.conf
}

essenciais(){  
  pacman -S vim --noconfirm ### instala o sudo
  pacman -S unzip unrar p7zip --noconfirm ### instala ferramentas de compactação
  pacman -S ntfs-3g dosfstools --noconfirm ### instala as ferramentas necessárias para acesso e formatação de sistemas de arquivos microsoft
  pacman -S wget curl --noconfirm ### instala gerenciadores de download
  pacman -S bash-completion --noconfirm ### instala ferramenta para autocomplemento (tab) no terminal
  pacman -S mlocate --noconfirm ### instala as funções de pesquisa (updatedb, locate)
  pacman -S gnupg --noconfirm ### instala gnupg (GPG)
  pacman -S openssh --noconfirm ### instala openSSH  
  pacman -S openvpn --noconfirm ### instala openVPN
  pacman -S cronie --noconfirm ### instala cron
  pacman -S rsync --noconfirm
  pacman -S zsh --noconfirm ### outro shell
  pacman -S git --noconfirm ### github

  pacman -S transmission --noconfirm
  pacman -S htop --noconfirm
}

essenciaisGUI(){
  pacman -S firefox --noconfirm ### instala o firefox
  pacman -S pcmanfm --noconfirm ### gerenciado de arquivos grafico
  pacman -S feh --noconfirm ### visualizador de imagens (serve para gerir o wallpaper do desktop)
  pacman -S scrot --noconfirm ### ferramenta de printscreen
  pacman -S imagemagick --noconfirm ### manipulador de imagem
  pacman -S terminator --noconfirm
}

ferramentasAnalise(){
  pacman -S mtr --noconfirm ### combina ping com traceroute (ex.: mtp -c 1 --report 8.8.8.8)
  pacman -S nmap --noconfirm ### Utility for network discovery and security auditing
  pacman -S nethogs --noconfirm ### A net top tool which displays traffic used per process instead of per IP or interface
  pacman -S tcpdump --noconfirm ###
  pacman -S kismet --noconfirm ###
  pacman -S aircrack-ng --noconfirm ###
  pacman -S nikto --noconfirm ###
  pacman -S gnu-netcat --noconfirm ###
}

ferramentasAnaliseGUI(){

  pacman -S wireshark --noconfirm ###
  pacman -S openvas --noconfirm ###
}

audio(){

  pacman -S alsa-lib alsa-utils alsa-firmware alsa-plugins pulseaudio-alsa pulseaudio --noconfirm ### instala os pacotes para o funcionamento do audio
  pacman -S cmus vlc --noconfirm ### instala o players multimídia (cmus media player termnal)
}

multilib(){ # apenas para sistemas 64bits
  echo "" >> /etc/pacman.conf 
  echo "[multilib]" >> /etc/pacman.conf 
  echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
}


sincronizarAtualizar(){
  pacman -Syyu ### sincronizacao e atualizacao total
  pacman -Sc --noconfirm ### limpa cache
  echo ""
}

finalizar(){
  rm /root/.bashrc
  exit
  umount -R /run/lvm
  umount -R /mnt/hostrun
  umount -R /mnt/boot
  umount -R /mnt/home
  umount -R /mnt

  swapoff -a

  cryptsetup luksClose crypto
  systemctl reboot
}

servidorX
yaourt
essenciais
essenciaisGUI
ferramentasAnalise
audio
multilib
sincronizarAtualizar
finalizar

# para personalizar o ZSH executar no usuario ricardokeso o seguinte comando (disponivel em: http://ohmyz.sh/)
# sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
