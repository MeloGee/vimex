# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export PS1='\[\e[32;1m\][\u@\h \W]\\$ \[\e[0m\]'

alias rm='$HOME/.vim/base/remove/remove.sh'
alias rmm='/bin/rm -i'
alias lr='ll $HOME/.trash'
alias grep='grep --color=auto'

#alias vim='$HOME/.vim/base/vim/bin/vim'
#alias vimdiff='$HOME/.vim/base/vim/bin/vimdiff'

alias lid='$HOME/.vim/base/idutils/bin/lid'
alias mkid='$HOME/.vim/base/idutils/bin/mkid'
alias ctags='$HOME/.vim/base/ctags/bin/ctags'
