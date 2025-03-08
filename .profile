# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask u=rwx,g=rx,o=
umask 0027

# if running bash
if [ -n "$BASH_VERSION" ]
then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]
	then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]
then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]
then
	PATH="$HOME/.local/bin:$PATH"
fi

# add path
if [ -d "$HOME/.local/share/gem/ruby/3.0.0/bin" ]
then
	PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]
then
	PATH="$HOME/.cargo/bin:$PATH"
fi


# looking for the TI ARM- and C2000 compilers (directory with the highest version)
DIRS_SEARCH=
if [ -d $HOME/ti ] ;			then DIRS_SEARCH="$DIRS_SEARCH $HOME/ti" ;			fi
if [ -d $HOME/Apps ] ;			then DIRS_SEARCH="$DIRS_SEARCH $HOME/Apps" ;		fi
if [ -d $HOME/bin ] ;			then DIRS_SEARCH="$DIRS_SEARCH $HOME/bin" ;			fi
if [ -d $HOME/.local/bin ] ;	then DIRS_SEARCH="$DIRS_SEARCH $HOME/.local/bin" ;	fi

TI_ARM_C_DIR=$(find $DIRS_SEARCH -type d -name 'ti-cgt-arm_*' | sort --version-sort | tail --lines=1)
if [ -d $TI_ARM_C_DIR ]
then
	export TI_ARM_C_DIR
	PATH="$TI_ARM_C_DIR/bin:$PATH"
fi

C2000_C_DIR=$(find $DIRS_SEARCH -type d -name 'ti-cgt-c2000_*' | sort --version-sort | tail --lines=1)
if [ -d $C2000_C_DIR ]
then
	export C2000_C_DIR
	PATH="$C2000_C_DIR/bin:$PATH"
fi

# Microchip compilers
if [ -d "/opt/microchip/xc8/v2.32/bin" ]
then
	PATH="/opt/microchip/xc8/v2.32/bin:$PATH"
fi

if [ -d "/opt/microchip/xc16/v1.70/bin" ]
then
	PATH="/opt/microchip/xc16/v1.70/bin:$PATH"
fi

if [ -d "/opt/microchip/xc32/v3.01/bin" ]
then
	PATH="/opt/microchip/xc32/v3.01/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/avr8-gnu-toolchain-linux_x86_64/bin" ]
then
	PATH="$HOME/.local/bin/avr8-gnu-toolchain-linux_x86_64/bin:$PATH"
fi


export STM32CubeMX_PATH=/home/boderu/STM32CubeMX
export EDITOR=micro
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:32

if [ -f ~/.cargo/env ]
then
	. ~/.cargo/env
fi

# activate virtual python environment
#if [ -d "$HOME/.pyvenv" ]
#then
#	source $HOME/.pyvenv/bin/activate
#fi

# activate local settings if exists
if [ -f "$HOME/.profile.local" ]
then
	source $HOME/.profile.local
fi

# EOF
