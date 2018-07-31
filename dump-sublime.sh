#!/usr/bin/env bash

#dump-sublime.sh
#Used for testing download and install of Sublime Text 3

function cleanup {

	#Unmounting and deleting any installers that were mounted or downloaded
	echo "${INFO}|||${NC} Starting Cleanup"
	local download_dmg
	#local installer

	download_dmg=${1}
	#installer=${2}

	echo "${INFO}|||${NC} deleting ${download_dmg}"
	rm "${download_dmg}"

	#echo "${INFO}|||${NC} Unmounting from ${installer}"
	#hdiutil detach -quiet "${installer}"
	
}

download_url="$(curl -s "https://www.sublimetext.com" | grep ".dmg" | awk -F '"' '{ print $4 }')"

echo "$download_url"

download_dmg="$(echo $download_url | awk -F "/" '{ print $4 }')"

echo "$download_dmg"

if ! [ -f "${download_dmg}" ] ; then

		#No need for shasum as there is none available on the website
		curl -o "${download_dmg}" "${download_url}"
 		echo "[DOWNLOADED]"

else 
	echo "[ALREADY DOWNLOADED]"

fi

#cleanup "${download_dmg}"

