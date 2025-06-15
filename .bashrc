setxkbmap -option caps:ctrl_modifier
setxkbmap us -variant altgr-intl
#xbindkeys --poll-rc
#export LC_ALL=en_US.UTF-8
if [[ ! -d ~/.liquidprompt ]];
then
    echo " == Downloading liquidprompt == "
    git clone -q https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
fi;

if [[ ! -d ~/.tmux/plugins/tpm ]];
then
    echo " == Downloading tmux plugin manager == "
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi;

eval "$(direnv hook bash)"

if [[ -a ~/.liquidprompt/liquidprompt ]]; then [[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt; fi;
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if [[ -a /usr/share/git/completion/git-completion.bash ]]; then [[ $- = *i* ]] && source /usr/share/git/completion/git-completion.bash; fi;
if [[ -a ~/.alias ]]; then [[ $- = *i* ]] && source ~/.alias; fi;

export HISTSIZE=100000                   # Lots of history.
export HISTFILESIZE=100000               # Lots of history in the file.
export HISTIGNORE="ll:fg:bg:j:jobs"      # Uninteresting commands to not record in history.
set -o ignoreeof
