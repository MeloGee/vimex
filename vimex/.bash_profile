# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin
export PATH

PATH=$PATH:$HOME/.vim/base/idutils/bin/
export PATH

PATH=$PATH:$HOME/.vim/base/ctags/bin/
export PATH

PATH=$PATH:$HOME/.vim/base/vim/bin/
export PATH

export LC_CTYPE="zh_CN.UTF-8"
