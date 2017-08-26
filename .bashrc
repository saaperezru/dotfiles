if [[ ! -d ~/.liquidprompt ]];
then
    echo " == Downloading liquidprompt == "
    git clone -q https://github.com/nojhan/liquidprompt.git ~/.liquidprompt
fi;
if [[ -a ~/.liquidprompt/liquidprompt ]]
then
    [[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt
fi;

source ~/.alias

export HISTSIZE=100000                   # Lots of history.
export HISTFILESIZE=100000               # Lots of history in the file.
export HISTIGNORE="ll:fg:bg:j:jobs"      # Uninteresting commands to not record in history.
