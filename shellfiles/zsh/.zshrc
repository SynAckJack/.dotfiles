#!/usr/bin/env bash
#~/shellfiles/zsh/.zshrc

#-- ALIASES -- 
alias ll='ls -aFlhp'
alias rpi='ssh raspberrypi.local'
alias edit='sublime'               
alias open='open -a Finder ./' 

alias diff='git diff --no-index'
alias wg-up='sudo wg-quick up wg0'
alias wg-down='sudo wg-quick down wg0'
alias pihole='ssh -i ~/.ssh/pihole_rsa pi@192.168.1.253'
alias algo='ssh -i ~/.ssh/digitalOcean jack@104.248.162.114'
alias website='ssh -p 13795 -i ~/.ssh/digitalOcean jack@165.22.127.192'


#-- FUNCTIONS --
function mkcd() { 
	mkdir -p "$1"; cd "$1" || exit; 
}


#-- EXPORTS --

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/dotfiles:$PATH"
