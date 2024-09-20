set hlsearch
set t_Co=16
syntax on
set background=dark " dark | light "
set cindent
set smartindent
au FileType c set makeprg=gcc\ %
au FileType cpp set makeprg=g++\ %
imap jj <Esc>
nmap ; :
vmap ; :
nmap <C-j> <C-w><C-j>
nmap <C-k> <C-w><C-k>
nmap <C-h> <C-w><C-h>
nmap <C-l> <C-w><C-l>
" resize current buffer 
nnoremap h :vertical resize -2<cr>
nnoremap j :resize +2<cr>
nnoremap k :resize -2<cr>
nnoremap l :vertical resize +2<cr>
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
set number 

source ~/.vimrc.vundle
