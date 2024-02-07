sudo pacman-key --init
sudo pacman-key --populate
sudo reflector --country "US" --protocol https,http --score 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S networkmanager vim tmux git efibootmgr base-devel nix net-tools fzf github-cli inetutils direnv hexyl xclip docker
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon
sudo systemctl enable docker
sudo systemctl start docker
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
sudo usermod -a arch -G nix-users
sudo usermod -a arch -G docker
sg nix-users "nix-channel --update"
sg nix-users "NIXPKGS_ALLOW_INSECURE=1 nix-shell -p python2 python3 poetry"
sudo systemctl reboot
