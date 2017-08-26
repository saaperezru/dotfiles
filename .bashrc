if [[ ! -d ~/.liquidprompt ]];
then
    echo " == Downloading liquidprompt == "
    git clone -q https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
fi;

if [[ -a ~/.liquidprompt/liquidprompt ]]; then [[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt; fi;
if [[ -a /usr/share/git/completion/git-completion.bash ]]; then [[ $- = *i* ]] && source /usr/share/git/completion/git-completion.bash; fi;
if [[ -a ~/.alias ]]; then [[ $- = *i* ]] && source ~/.alias; fi;

export HISTSIZE=100000                   # Lots of history.
export HISTFILESIZE=100000               # Lots of history in the file.
export HISTIGNORE="ll:fg:bg:j:jobs"      # Uninteresting commands to not record in history.
