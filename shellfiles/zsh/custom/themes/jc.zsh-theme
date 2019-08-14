#~/.oh-my-zsh/custom/themes/jc.zsh-theme

#Custom theme for moi 🤙

function emoji {
	EMOJI=(💩 🚀 🍕 ☕️ 🐶 🍻 💰 💎 🐶 🐙 🌭 🌶 🙃 🤯 🤔 👨‍💻 💻 🤙)
  	echo -n "$EMOJI[$RANDOM%$#EMOJI+1]"
}


function collapse_pwd {
    echo -n $(pwd | sed -e "s,^$HOME,~,")
}

function root_user {
	if [[ $UID == 0 || $EUID == 0 ]]; then
	  echo %{$fg_bold[red]%}%n%{$reset_color%}
	else
	  echo %{$fg[cyan]%}%n%{$reset_color%}
	fi
}

function ssh_user {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	  echo %{$fg_bold[red]%}%m%{$reset_color%}
	else
	  echo %{$FG[063]%}%m%{$reset_color%}
	fi
}

NEWLINE=$'\n'

PROMPT="[$(emoji)] $(root_user)@$(ssh_user) > %{$FG[202]%}%~%{$reset_color%}${NEWLINE}\$ "

#Sets right-promt to current time am/pm
RPROMPT="[%D{%L:%M:%S %p | %a %e %b}]"

