#!/usr/bin/env bash

#dump-sublime.sh
#Used for testing download and install of Sublime Text 3

download_url="$(curl -s "https://www.sublimetext.com" | grep ".dmg" | awk -F '"' '{ print $4 }')"

echo $download_url

download_dmg="$(echo $download_url | awk -F "/" '{ print $4 }')"

echo $download_dmg

if [ -f "${download_dmg}" ] ; then

		#No need for shasum as there is none available on the website
		shasum -a 256 "${download_dmg}"

elif curl -o "${download_dmg}" "${download_url}"; then
 	
 	echo "[DOWNLOADED]"
 	
fi

