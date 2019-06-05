#!/usr/bin/env bash
#~/.bash_profile

#Load .files
#Based on 0xmachos/dotfiles/.bash_prompt
for file in ~/.{bash_prompt,aliases}; do
  # shellcheck source=/dev/null
  if [[ -r "${file}" ]] && [[ -f "${file}" ]]; then
    source "${file}"
  fi

done

#Ensure that brew-file wraps the standard brew command correctly
# shellcheck source=/dev/null
if [ -f "$(brew --prefix)/etc/brew-wrap" ];then
  source "$(brew --prefix)/etc/brew-wrap"
fi

