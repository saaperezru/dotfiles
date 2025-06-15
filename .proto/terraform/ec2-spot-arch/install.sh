git clone https://github.com/saaperezru/dotfiles
NIXPKGS_ALLOW_INSECURE=1 nix-shell -p python2 --command "~/dotfiles/install"
# Add Plugin 'ycm-core/YouCompleteMe' to ~/.vimrc.vundle
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all
