#########################################################
#                          ROOT                         #
#########################################################

# We only have access to root

echo 'vm.swappiness = 200' >> /etc/sysctl.d/99-swappiness.conf
useradd -m admin
passwd admin
usermod -aG wheel admin
useradd -m user
passwd user
EDITOR=nano visudo
# Find and uncomment `%wheel ALL=(ALL) ALL`
exit

#########################################################
#                         ADMIN                         #
#########################################################
 
# Update
sudo pacman -Syyu

# Install needed packages
sudo pacman -S git pacman-contrib zip syncthing python-pip rsync reflector nginx mariadb cockpit

# Install yay
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
sudo rm -rf ./yay-bin

# Install needed AUR packages
yay -S plex-media-server

sudo systemctl enable --now nginx
sudo systemctl enable --now mariadb
sudo systemctl enable --now plexmediaserver
sudo systemctl enable --now syncthing.service 
sudo systemctl enable --now cockpit.socket 
# Clean pacman & yay caches
sudo paccache -rk0
sudo rm -rf ~/.cache/yay/*

exit 

#########################################################
#                          USER                         #
#########################################################
 
# Switch to user for operations that need to be done as non-sudo user
 
systemctl enable --now syncthing.service --user

#########################################################
#                          UTIL                         #
#########################################################

# Fix mirrors (pacman/yay slow download)
# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bkp
# sudo reflector --country 'United States' --latest 5 --age 2 --fastest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist