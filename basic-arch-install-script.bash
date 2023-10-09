#! /bin/bash

# variables
BLUE='\033[0;34m'
RED= '\033[0;31m'

# arch install function. getting called when install starts.
function start {
echo -e ${BLUE}[INFO] this script only supports ethernet for now.
echo -e ${BLUE}[INFO] pinging archlinux.org...
ping archlinux.org && echo -e ${BLUE}[INFO] Success pinging. || echo -e '${RED}[ERROR]Ping Unsuccessful. exiting...'; exit
timedatectl
echo -e ${BLUE}[INFO] Partitioning. entering a bash shell. the script is NOT done yet. 
echo -e ${BLUE}[INFO] partition the drives and mount: ESP at /mnt/boot and root at /mnt. also enable a swap partition if needed using swapon.
bash
echo -e ${BLUE}[INFO] installing base, kernel and firmware for common hardware.
pacstrap -K /mnt base linux linux-firmware
echo -e ${BLUE}[INFO] generating fstab.
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
nano /etc/locale.gen
locale-gen
read -p '${BLUE}Set Language Variable (for example:en_US.UTF-8): ' LANG
read -p '${BLUE}Set Hostname: ' HOSTNAMEARCHINSTALLER
echo $HOSTNAMEARCHINSTALLER | tee /etc/hostname
mkinitcpio -P
echo -e ${BLUE}Set Root Password
passwd root
if [ $BITS = 32 ]
	then
		echo ${BLUE}Installing systemd-boot
		bootctl install
	else
		echo ${BLUE}Installing GRUB
		pacman -S grub efibootmgr
		grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	fi
echo ${BLUE}[SUCCESS]SYSTEM IS READY! reboot to use your new arch install.
exit
}

# actual code
if [ $(cat /sys/firmware/efi/fw_platform_size) = 64 ]
	then
		echo -e ${BLUE}[INFO] Your system is 64 bit.
		BITS=64
		start()
	else
		if ! ls /sys/firmware/efi/fw_platform_size
			then
				echo -e ${RED}[ERROR] Your system is a BIOS system. this script is designed for UEFI. exiting.
				exit
			else
				echo -e ${RED}[INFO] Your system is 32 bit. this will limit your bootloader choice to systemd-boot. do you want to continue?
				read 32bitcontinue
				BITS=32
				if [ ${32bitcontinue}^^ = Y ]
					then
						start()