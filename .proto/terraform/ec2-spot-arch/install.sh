git clone https://github.com/saaperezru/dotfiles
NIXPKGS_ALLOW_INSECURE=1 nix-shell -p python2 --command "~/dotfiles/install"
