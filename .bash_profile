gitblame() {
git ls-files $1 | xargs git blame
}

source ~/.git-completion.bash

# Add colors for git repo to your terminal
function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
PS1='\[\033[0;37m\][\[\033[01;36m\]\W\[\033[0;37m\]] \[\033[0;32m\]$(git_branch)\[\033[00m\]\$ '