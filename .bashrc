# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]
then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]
then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
	then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

# show exit code: $(e=$?; (( e )) && echo "$e|")
if [ "$color_prompt" = yes ]
then
	PS1='$(e=$?; (( e )) && echo "$e|")${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='$(e=$?; (( e )) && echo "$e|")${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac
# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]
then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like ~/.bash_aliases, instead of adding them here
# directly. See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]
then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix
then
	if [ -f /usr/share/bash-completion/bash_completion ]
	then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]
	then
		. /etc/bash_completion
	fi
fi

# boderu ==============================================================================================================
# additional aliases are in ~/.bash_aliases
# additional pathes are in ~/.profile
# =====================================================================================================================

umask 0027

# fast navigation whithin the filesystem with broot (~/bin/broot)
function br
{
	local cmd cmd_file code
	cmd_file=$(mktemp)
	if broot --outcmd "$cmd_file" "$@"
	then
		cmd=$(<"$cmd_file")
		rm -f "$cmd_file"
		eval "$cmd"
	else
		code=$?
		rm -f "$cmd_file"
		return "$code"
	fi
}

# bash history
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

# Git prompt ==========================================================================================================
# get current status of git repo
function parse_git_dirty
{
	GITSTATUS="$(git status --porcelain=v1 --branch 2> /dev/null | sed 's/$/\\n/g')"

	if [ -z "$GITSTATUS" ]
	then
		printf "-"
		return
	else
		printf "[\e[0m "
	fi

	# untracked files
	if echo -e ${GITSTATUS} | grep -c '^ ??' &> /dev/null
	then
		echo -e ${GITSTATUS} | grep -c '^ ??' | tr -d '\n'
		echo -ne "\e[1m\e[33m?\e[0m "
	else
		printf ""
	fi

	# added files
	if echo -e ${GITSTATUS} | grep -c '^ A' &> /dev/null
	then
		echo -e ${GITSTATUS} | grep -c '^ A' | tr -d '\n'
		echo -ne "\e[1m\e[33m+\e[0m "
	else
		printf ""
	fi

	# modified files
	if echo -e ${GITSTATUS} | grep -c '^ M' &> /dev/null
	then
		echo -e ${GITSTATUS} | grep -c '^ M' | tr -d '\n'
		echo -ne "\e[1m\e[33mM\e[0m "
	else
		printf ""
	fi

	# renamed files
	if echo -e ${GITSTATUS} | grep -c '^ R' &> /dev/null
	then
		echo -e ${GITSTATUS} | grep -c '^ R' | tr -d '\n'
		echo -ne "\e[1m\e[33mR\e[0m "
	else
		printf ""
	fi

	# copied files
	if echo -e ${GITSTATUS} | grep -c '^ C' &> /dev/null
	then
		echo -e ${GITSTATUS} | grep -c '^ C' | tr -d '\n'
		echo -ne "\e[1m\e[33mC\e[0m "
	else
		printf ""
	fi

	# deleted files
	if echo -e ${GITSTATUS} | grep -c '^ D' &> /dev/null
	then
		echo -e ${GITSTATUS} | grep -c '^ D' | tr -d '\n'
		echo -ne "\e[1m\e[33mD\e[0m "
	else
		printf ""
	fi

	printf "\e[31m]"
}

parse_git_branch()
{
	# Long form
	# git rev-parse --abbrev-ref HEAD 2> /dev/null
	# Short form
	# git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'

	# my form
	LANGUAGE='en_US.UTF-8'
	git status --porcelain=v1 --branch 2> /dev/null | grep '##' | sed 's/^## //g'
}

prompt()
{
export PS1=\
"\n\
╭─\$(EXCODE="\$?" ; [ \$EXCODE == 0 ] && echo "\\e[1m\\e[32m\$EXCODE\\e[0m" || echo "\\e[1m\\e[31m\$EXCODE\\e[0m") \
[\[\033[0;32m\]\w\[\033[0m\]] (\033[33m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\[\033[00m\]) \n\
╰─[\[\033[1;36m\]\u\[\033[00m\]@\[\033[0;33m\]\h\[\033[00m\]]: \
"
}

prompt
PROMPT_COMMAND='prompt'
#======================================================================================================================

# prompt for more instances
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# status report
neofetch --color_blocks off

export LANGUAGE='en_US.UTF-8'

if [ -f ~/.cargo/env ]
then
	. ~/.cargo/env
fi

eval "$(thefuck --alias)"

# EOF =================================================================================================================
