sudo pacman-key --init
sudo pacman-key --populate
sudo reflector --country "US" --protocol https,http --score 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S networkmanager vim tmux git efibootmgr base-devel nix net-tools fzf github-cli inetutils direnv hexyl xclip
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
sudo usermod -a arch -G nix-users
