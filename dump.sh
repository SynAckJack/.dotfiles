#!/usr/bin/env bash

#dump.sh
#Used for testing snippets of code.

dmg=()
installers=()

function install {

	download="$(curl -s "https://gpgtools.org" | grep "version" | awk -F "/" '{ print $4 }')"

	echo $download 

	download_dmg="GPG_Suite-${download}.dmg"

	echo $download_dmg

	if [ -f "${download_dmg}" ] ; then

		shasum -a 256 "${download_dmg}"

	elif curl -o "${download_dmg}" "https://releases.gpgtools.org/${download_dmg}"; then
	 	
	 	echo "[DOWNLOADED]"
	 	
	fi

	hash="$(curl -s "https://gpgtools.org/gpgsuite.html" | grep "SHA256" | awk -F ">" ' $5>0 { print substr($5,1,64)}')  GPG_Suite-2018.3.dmg"


	if [[ "$(shasum -a 256 "$download_dmg")" = "$hash"* ]]; then

		echo "[WORKED]"

	else 
		echo "[FAILED]"

	fi 

	local installer_path="/Volumes/GPG Suite"

	if hdiutil attach -quiet "$download_dmg" ; then
		echo "[MOUNTED]"

		if sudo installer -pkg "${installer_path}/Install.pkg" -target "/" ; then

			echo "[INSTALLED]"
		else 
			echo "[FAILED TO INSTALL]"
			exit 1
		fi
	else
		echo "[FAILED TO MOUNT]"
		exit 1
	fi

	echo "[FINISHED!!!]"

	dmg+=("${download_dmg}")
	installer+=("${installer_path}")

}

function cleanup {
	echo "[Starting Cleanup]"

	for d in "${dmg[@]}" 
	do
		echo "deleting ${d}"
		rm $dmg
	done 

	for i in "${installer[@]}" 
	do
		echo "Unmounting from ${i}"
		hdiutil detach -quiet "${i}"
	done

	# echo "[UNMOUNTING GPG SUITE]"
	# hdiutil detach -quiet "/Volumes/GPG Suite/"

	# echo "[DELETING DMG]"
	# rm "${download_dmg}"

}
	install
	cleanup
#TODO: Delete dmg
#echo $hash
#echo $download_hash
