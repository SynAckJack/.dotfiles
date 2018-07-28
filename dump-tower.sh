#!/usr/bin/env bash

#dump-tower.sh
#Used for developing Tower install function for coffee.sh

#!/usr/bin/env bash

#dump-sublime.sh
#Used for testing download and install of Sublime Text 3

function cleanup {

	#Unmounting and deleting any installers that were mounted or downloaded
	echo "${INFO}|||${NC} Starting Cleanup"
	local download_dmg
	local installer

	download_dmg=${1:?download_dmg not passed to cleanup}
	installer=${2:?installer not passed to cleanup}

	echo "${INFO}|||${NC} Deleting ${download_dmg}"
	rm "${download_dmg}"

	if [ -f "${installer}" ] ; then
		if 	echo "${installer}" | grep ".zip" ; then

			echo "${INFO}|||${NC} Deleting ${installer}"
			rm -rf "${installer}"
		else 

			echo "${INFO}|||${NC} Unmounting from ${installer}"
			hdiutil detach -quiet "${installer}"
		fi
	fi
}

if ! [ -f "/Applications/Tower.app" ] ; then
		download_url="$(curl -s "https://www.git-tower.com/release-notes/mac" | grep ".zip" | awk -F ".zip" ' { print $1 }' | awk -F '"' ' { print $NF } ')"

		download_url+=".zip"
		download_zip="$(echo $download_url | awk -F "/" ' { print $NF } ')"


		if curl -o "$download_zip" "$download_url" ; then
			echo "DOWNLOADED"
		else
			echo "FAILED"
			exit 1
		fi

		if unzip -q "$download_zip" -d "." ; then
			echo "Unzipped $download_zip"

			if sudo cp "Tower.app" "/Applications" ; then
				echo "Installed Tower in Applications!"
			else
				echo "Failed to copy to /Applications. Running as sudo?!"
				exit 1
		else
			echo "FAILED"
			exit 1
		fi
else
	echo "Tower is already installed!"
	exit 0

cleanup "Tower.app" "$download_zip"
exit 0


#version_dmg="${download_url#*Tower-}"
#version_dmg="$(echo $download_url | awk -F '"' ' {print $NF} ')"

#echo "$version_dmg"

#download_dmg="Tower-${version_dmg}"

