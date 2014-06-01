#=============================================================================
#     FileName: zshrc
#         Desc: install my zshrc
#       Author: KuoE0
#        Email: kuoe0.tw@gmail.com
#     HomePage: http://kuoe0.ch/
#      Version: 0.0.1
#   LastChange: 2012-09-25 12:35:39
#      History:
#=============================================================================
export TERM=xterm-256color
################################################################################
# get OS name
OS=$(uname)
################################################################################
# Path setting
export PATH="/sbin:/usr/sbin:$PATH"
# Path config for Mac OS X
if [ "$OS" = 'Darwin' ]; then
	# use package of homebrew
	export PATH="/usr/local/bin:$PATH"
	# path of GNU coreutils
	export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

	# man page for GNU coreutils
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

	# let pkg-config find libxml-2.0 libxslt libexslt libcurl
	export PKG_CONFIG_PATH=/usr/local/Library/ENV/pkgconfig/10.8

	# environment variable of include directory for gnu tool
	export C_INCLUDE_PATH=/usr/local/include
	export CPLUS_INCLUDE_PATH=/usr/local/include

	# environment variable of library directory for gnu tool
	LIBRARY_PATH=/usr/local/lib
fi

# access the online help
export HELPDIR=/usr/local/share/zsh/helpfiles

################################################################################
# Path of oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh

# theme name (theme in .oh-my-zsh/theme)
ZSH_THEME="solarized-powerline"

# setup plugin (plugin in .oh-my-zsh/plugin)
plugins=(copydir copyfile history history-substring-search web-search urltools)

if [ "$OS" = 'Linux' ]; then	# Linux

elif [ "$OS" = 'Darwin' ]; then		# Mac OS X
	plugins+=osx
	# check homebrew
	if which brew &> /dev/null; then
		plugins+=brew
	fi
	# check macports
	if which port &> /dev/null; then
		plugins+=port
	fi
fi

# check git
if which git &> /dev/null; then
	plugins+=git
	# configuration git
	git config --global user.name "KuoE0"
	git config --global user.email "kuoe0.tw@gmail.com"
	git config --global core.editor `which vim`		# let git use the correct vim on Mac
	git config --global color.ui auto # colorize git output
fi

# check autojump
if which autojump &> /dev/null; then
	plugins+=autojump
fi

# check pip
if which pip &> /dev/null; then
	plugins+=pip
fi

# check pip
if which gem &> /dev/null; then
	plugins+=gem
fi

# start to install plugin
source $ZSH/oh-my-zsh.sh

################################################################################
# key bindkey

bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

################################################################################
# environment variable settings

# default editor
export EDITOR=vim

# language setting
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

################################################################################
# history setting

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPs
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

################################################################################
# variable setting

# dropbox directory setup

if [ -d $HOME/Dropbox ]; then
	dbox=$HOME/Dropbox
fi

################################################################################
# alias
alias l="ls --color=always"	# ls is GNU ls not BSD ls
alias ll="ls -al --color=always"	# ls is GNU ls not BSD ls
alias cgrep="grep --color=always" 
alias getip="curl -s http://ipecho.net/plain || echo -n 'no internet connection' ; echo"

if [ $OS = "Linux" ]; then
	alias pbcopy="xclip -i"
	alias pbpaste="xclip -o"
fi

# access the online help
unalias run-help &> /dev/null
autoload run-help

################################################################################
# colourify settings
eval `dircolors ~/.dir_colors`

# colorize less for manpage
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# setup grep color & style
export GREP_COLOR='4;32' 

# raw control (-R), highlight search (-g), merge consecutive blank line (-s)
export LESS="-RMgs"

# auto use grc (Generic Colouriser) to process content
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
then
    alias colourify="$GRC -es --colour=on"
    alias configure='colourify ./configure'
    alias diff='colourify diff -u'
    alias make='colourify make'
    alias gcc='colourify gcc'
    alias g++='colourify g++'
    alias as='colourify as'
    alias gas='colourify gas'
    alias ld='colourify ld'
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    alias traceroute='colourify /usr/sbin/traceroute'
fi

# use colordiff to replace diff
if [ -n "$(which colordiff)" ]; then
	alias diff='colordiff -u'
fi


# function load
source $HOME/.zsh/function.zsh

################################################################################
# start up

# auto launch tmux
if [ "$TMUX" = "" ]; then
	ret=""
	while [ "$ret" != "y" ] && [ "$ret" != "n" ]; do
		read -t 30 ret\?"launch tmux? [y/n] "
		if [ "$ret" = "" ]; then
			ret="y"
		fi
	done
fi

if [ `which tmux` &> /dev/null ] && [ "$ret" = "y" ]; then
	if [ "${SSH_TTY:-x}" != x ]; then
		# attach remote session when ssh login
		( (tmux has-session -t remote && tmux attach-session -t remote) || (tmux new-session -s remote) ) && exit 0
		echo "tmux failed to start"
	else
		# create new tmux-session
		tmux
	fi
fi

unset $ret &> /dev/null

PADDING=$((($(tput cols) - 70 + 1) / 2))

WELCOME="
   __ __          _______   Don't run after success.
  / //_/_ _____  / __/ _ \\  Be excellent, success will run after you.
 / .< / // / _ \\/ _// // /
/_/|_|\\___/\\___/___/\\___/                                   - 3 Idiot

        System load:        $(cpu_load)        Memory usage:    $(memory_usage) %
        Uptime:             $(machine_uptime)"

for i in $(seq 1 $PADDING);
do
	WELCOME=$(echo $WELCOME | sed "s/^/ /")
done

if ! which lolcat &> /dev/null; then
	alias lolcat=cat
fi

echo $WELCOME | lolcat

unalias lolcat &> /dev/null

################################################################################
# other
# Report CPU usage for each command
# REPORTTIME=0
export HOMEBREW_GITHUB_API_TOKEN=c68984b4b136f75b57644e87fec8e8661d29f84e
