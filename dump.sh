#!/usr/bin/env bash

#dump.sh
#Used for testing snippets of code.

download="$(curl -s "https://gpgtools.org" | grep "version" | awk -F "/" '{ print $4 }')"

echo $download 

download_dmg="GPG_Suite-${download}.dmg"

echo $download_dmg

if [ -f "${download_dmg}" ] ; then

	shasum -a 256 "${download_dmg}"

elif curl -o "${download_dmg}" "https://releases.gpgtools.org/${download_dmg}"; then
 	
 	echo "[DOWNLOADED]"
 	shasum -a 256 "${download_dmg}"
 	
 fi
