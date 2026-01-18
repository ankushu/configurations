#!/bin/bash
set linenumbers
#source /usr/local/Homebrew/Library/Taps/now/homebrew-devtools/etc/bashrc
[ -f /usr/local/homebrew-now/etc/bashrc ] && source /usr/local/homebrew-now/etc/bashrcalias gerrit="git push origin HEAD:refs/for/master"
# alias gerrit-wo-branch="git push origin HEAD:refs/for/"
# alias mysql-server="/usr/local/Cellar/mysql56/5.6.37/support-files/mysql.server"
alias sublime="/Applications/Sublime\ Text\ 2.app/Contents/MacOS/Sublime\ Text\ 2"
# alias gerrit="git push origin HEAD:refs/for/master"
alias gitstatus="git fetch -p;git status"
# alias git-clean-merged-branch="git branch -vv | grep ': gone' | awk '{print $1}' | xargs git branch -D"
git-clean-merged-branch() {
    for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}
gitblame() {
git ls-files -- "$1" | xargs git blame
}
autoload -Uz compinit && compinit
export PATH=$PATH:~/Downloads/apache-maven-3.2.1/bin/:.:/usr/local/mysql/bin

#Dev dir
ws=~/git
export ws
alias dev="cd ws"
alias devc="cd ws/commons/commons-glide"
alias devg="cd ws/glide/glide-parent"
alias soundRestart="sudo kill -9 `ps ax|grep 'coreaudio[a-z]' | awk '{print $1}' `"

# source ~/.git-completion.bash

# Add colors for git repo to your terminal
function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
setopt prompt_subst
prompt='%F{087}[%2/]%f %F{green}$(git_branch)%f$ '

function setjdk() {

if [ $# -ne 0 ]; then

removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'

if [ -n "${JAVA_HOME+x}" ]; then

removeFromPath $JAVA_HOME

fi
export JAVA_HOME=`/usr/libexec/java_home -v $@`
export PATH=$JAVA_HOME/bin:$PATH

fi

}

function removeFromPath() {

export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")

}

alias python=/usr/bin/python3
alias pip=/usr/bin/pip3
#Cordova setup
#export ANT_HOME=/usr/local/homebrew/Cellar/ant/1.9.4
#export ANDROID_HOME=/Applications/Android\ Studio.app/Contents/lib/
#export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANT_HOME:$ANDROID_HOME

setjdk 1.8

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#source ~/.profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Claude
export PATH=$HOME/.local/bin:$PATH
export NODE_EXTRA_CA_CERTS=~/Downloads/zscaler_root_ca.pem

#Windsurf
alias windsurf="~/Applications/Windsurf.app/Contents/MacOS/Electron"

# added by Anaconda3 2019.07 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/ankush.agrawal/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/Users/ankush.agrawal/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ankush.agrawal/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/Users/ankush.agrawal/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
