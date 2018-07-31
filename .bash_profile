#!/usr/bin/env bash
#~/.bash_profile

export IDF_PATH="$HOME/esp/esp-idf"
export PATH="$PATH:$HOME/esp/xtensa-esp32-elf/bin"

#Link to /Users/jackclark/scripts for use with bash development
export PATH="$HOME/scripts/:$PATH"

#Working with BLE-CTF
alias get_esp32='$HOME/esp/xtensa-esp32-elf/bin'

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

