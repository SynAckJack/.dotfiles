#!/usr/bin/env bash
#coffee.sh


#THINGS TO ADD:
#	- install applications function instead of repeated code in each function
#	- potentially add .files to be installed
#	- add function to verify signature of applications before install
#	- checksum function for applications that have checksums online, again 
#	  instead of being repeated in functions
#	- add function to check if running with sudo


#Inspired from 0xmachos bittersweet.sh
#Tested on macOS 10.13, 10.14 beta w/ MacBook Pro 2016

set -euo pipefail
# -e if any command returns a non-zero status code, exit
# -u don't use undefined vars
# -o pipefall pipelines fails on the first non-zero status code

#Set colours for easy spotting of errors
FAIL=$(echo -en '\033[0;31m')
PASS=$(echo -en '\033[0;32m')
NC=$(echo -en '\033[0m')
WARN=$(echo -en '\033[0;33m')
INFO=$(echo -en '\033[0;35m')


function usage {
	# shellcheck disable=SC2028
	echo "\\nMake macOS the way it is meant to be 🤙\\n"
	echo "Usage: "
	echo " checkfv		- Check FileVault is enabled ⛑"
	echo " customise		- Customise the default options of macOS 😍"
	echo " cirrus			- Install Cirrus ☁️"
	echo " gpgtools		- Install GPG Tools ⚙️"
	echo " sublime		- Install Sublime Text 👨‍💻"
	echo " tower			- Install Tower 💂‍♂️"
	echo " rocket 		- Install Rocket 👽"
	echo " xcode		- Install Xcode "
	echo " brew			- Install Homebrew 🍺"
	echo " dotfiles		- Install dotfiles 🔑"
	echo " all 		- Install the items listed above  ❤️"

	# shellcheck disable=SC2028
	echo "\\nMake macOS the way it is meant to be 🤙\\n"
	exit 0
}

function cleanup {

	#Unmounting and deleting any installers that were mounted or downloaded
	echo "${INFO}|||${NC} Starting Cleanup"
	local download_dmg
	local installer

	download_dmg=${1:?download_dmg not passed to cleanup}
	installer=${2:?installer not passed to cleanup}

	echo "${INFO}|||${NC} Deleting ${download_dmg}"
	rm -r "${download_dmg}"

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

function check_sudo_permission {

	if [ "$EUID" -ne 0 ]; then
    	# NOT SUDO
    	return 0
  	else 
    	return 1
  	fi
}

function check_filevault {

	echo "${INFO}|||${NC} Checking if FileVault is enabled..."

	if fdesetup status | grep "On" > /dev/null ; then
		echo "${PASS}|||${NC} Filevault is turned on"
	else 
		echo "${FAIL}|||${NC} Filevault is turned off"
		exit 1
	fi
}

function check_efi {

	echo "${INFO}|||${NC} Checking EFI..."

	#https://eclecticlight.co/2018/06/02/how-high-sierra-checks-your-efi-firmware/
	if [ "$(/usr/libexec/firmwarecheckers/eficheck/eficheck --integrity-check)" ] ; then
		echo "${PASS}|||${NC} EFI Intergrity check passed!"
	else
		echo "${FAIL}|||${NC} EFI Integrity check failed!"
		exit 1
	fi

	exit 0

}

function customise_defaults {

	echo "${INFO}|||${NC} Customising the defaults..."

	#Disable Guest User
	#default: sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool true
	sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false

	#Enable Firewall
	#default: sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool false
	sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
	#NOTE: Can set -int 2 for stricter firewall that will only allow essential services such as DHCP

	#TODO: Enable account name in tool bar

	#Enable Secure Keyboard Entry
	#default: defaults write com.apple.Terminal SecureKeyboardEntry -bool false
	defaults write com.apple.Terminal SecureKeyboardEntry -bool true

	#TODO: Enable unlock with Apple Watch (maybe)

	#Show battery percentage
	#default: defaults write com.apple.menubar.battery ShowPercent NO
	defaults write com.apple.menuextra.battery ShowPercent -string "YES"

	#TODO: Set Flip Clock screensaver

	#Enable Plain Text Mode in TextEdit by Default
	#default: defaults write com.apple.TextEdit RichText -int 1
	defaults write com.apple.TextEdit RichText -int 0

	#Save panel Expanded View by default
	#default: defaults write -g NSNavPanelExpandedStateForSaveMode -bool false
	# 	      defaults write -g NSNavPanelExpandedStateForSaveMode -bool false
	defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
	defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

	#Print panel Expanded View by default
	#default: defaults write -g PMPrintingExpandedStateForPrint -bool false
	# 	      defaults write -g PMPrintingExpandedStateForPrint2 -bool false
	defaults write -g PMPrintingExpandedStateForPrint -bool true
	defaults write -g PMPrintingExpandedStateForPrint2 -bool true


	#WORK IN PROGRESS --------------
	#Set dark mode
	#defaults write .GlobalPreferences AppleInterfaceTheme -string "Dark"


	#Show all hidden files in Finder
	#default: defautls write com.apple.Finder AppleShowAllFiles -bool false
	defautls write com.apple.Finder AppleShowAllFiles -bool true

	#Save Screenshots in PNG
	#default: defaults write com.apple.screencapture -string "???"
	defaults write com.apple.screencapture -string "png"

	#Require password immediately after sleep or screen saver starting
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	#Show icons for removable media on Desktop
	#default: defaults write com.apple.finder ShowMountedServersOnDesktop -bool false \
	# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true


	#Windows-style sorting: keep folder on top
	#default: defaults write com.apple.finder _FXSortFoldersFirst -bool false
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	#Finder: Search current folder first by default
	#default: defaults write com.apple.finder FXDefaultSearchScope -string "????"
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

	#Hot Corners 🤙
	#Bottom-left - Mission Control
	defaults write com.apple.dock wvous-bl-corner -int 2
	defaults write com.apple.dock wvous-bl-modifier -int 0

	#Bottom-right - Show Desktop
	defaults write com.apple.dock wvous-br-corner -int 4
	defaults write com.apple.dock wvous-br-modifier -int 0

	#App Store: Check for updates daily
	#default: defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1





	#NOTE: REMOVE "Show all hidden files/folder" and change it to
	# Show Desktop, .ssh, Documents in Users folder instead ❤️
	exit 0
}

function install_cirrus {

	echo "${INFO}|||${NC} Installing Cirruss..."

	exit 0
}

function install_gpg {
	local download
	local download_dmg
	local hash 
	local installer_path

	echo "${INFO}|||${NC} Installing GPG Tools..."
	#Get latest version of GPGTools from the GPGTools home page (work something more reliable out for this)
	download="$(curl -s "https://gpgtools.org" | grep "version" | awk -F "/" '{ print $4 }')"

	download_dmg="GPG_Suite-${download}.dmg"

	if [ -f "${download_dmg}" ] ; then

		echo "${PASS}|||${NC} ALREADY DOWNLOADED"
		#Not needed as hash is calculated in if statement later
		#local download_hash="$(shasum -a 256 "${download_dmg}")"

	elif curl -o "${download_dmg}" "https://releases.gpgtools.org/${download_dmg}"; then
	 	
	 	echo "${PASS}|||${NC} DOWNLOADED"
	 	
	fi

	#Retrieve hash from gpgtools.org
	hash="$(curl -s "https://gpgtools.org/gpgsuite.html" | grep "SHA256" | awk -F ">" ' $5>0 { print substr($5,1,64) } ')"

	#Compare hashes of download to hash online
	if [[ "$(shasum -a 256 "$download_dmg")" = "$hash"* ]]; then

		echo "${PASS}|||${NC} Hash verified"

		installer_path="/Volumes/GPG Suite"

		if hdiutil attach -quiet "$download_dmg" ; then
		echo "${PASS}|||${NC} Mounted installer"

		#Find a way to check if script running as sudo instead of just printing this...
		if check_sudo_permission ; then
			echo "${WARN}|||${NC} Password required to run as sudo"
		fi

			if sudo installer -pkg "${installer_path}/Install.pkg" -target "/" >/dev/null; then
				echo "${PASS}|||${NC} Installed GPG Tools"
			else 
				echo "${FAIL}|||${NC} Failed to Install"
				exit 1
			fi
		else
			echo "${FAIL}|||${NC} Failed to mount .dmg"
			exit 1
		fi
		echo "${PASS}|||${NC} Completed Installation"
	else 
		echo "${FAIL}|||${NC} Failed to verify hash"
		exit 1

	fi 

	cleanup "$download_dmg" "$installer_path"
	
	exit 0
}

function install_sublime {

	echo "${INFO}|||${NC} Installing Sublime Text..."
	local download_url
	local download_dmg

	download_url="$(curl -s "https://www.sublimetext.com" | grep ".dmg" | awk -F '"' '{ print $4 }')"

	echo "$download_url"

	download_dmg="$(echo "$download_url" | awk -F "/" '{ print $4 }')"

	echo "$download_dmg"

	if ! [ -f "${download_dmg}" ] ; then

		#No need for shasum as there is none available on the website
		if curl -o "${download_dmg}" "${download_url}" ; then
 			echo "${PASS}|||${NC} DOWNLOADED"
 		else
 			echo "${FAIL}|||${NC} Download failed."
 			exit 1
 		fi

	else 
		echo "${PASS}|||${NC} ALREADY DOWNLOADED"
	fi

	if [ -f "${download_dmg}" ] ; then

		installer_path="/Volumes/Sublime Text"

		if hdiutil attach -quiet "$download_dmg" ; then
		echo "${PASS}|||${NC} Mounted installer"

		#Find a way to check if script running as sudo instead of just printing this...
		if check_sudo_permission ; then
			echo "${WARN}|||${NC} Password required to run as sudo"
		fi

			if sudo cp -r "${installer_path}/Sublime Text.app" "/Applications" ; then
				echo "${PASS}|||${NC} Installed Sublime Text"
			else 
				echo "${FAIL}|||${NC} Failed to installed Sublime Text"
				exit 1
			fi
		else
			echo "${FAIL}|||${NC} Failed to mount .dmg"
			exit 1
		fi
		echo "${PASS}|||${NC} Completed Installation"
	else
		echo "${FAIL}|||${NC} Something went wrong. Installer is missing."
		exit 1
	fi

	if "ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime" ; then
		echo "${PASS}|||${NC} Symlinked Sublime to open from terminal!"
	else
		echo "${FAIL}|||${NC} Failed to symlink Sublime, so it won't open from terminal..."
	fi

	cleanup "$download_dmg" "$installer_path"

	exit 0
}

function install_tower {

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

			if check_sudo_permission ; then
				echo "${WARN}|||${NC} Password required to run as sudo"
			fi

			if sudo cp -r "Tower.app" "/Applications" ; then
				echo "Installed Tower in Applications!"
			else
				echo "Failed to copy to /Applications. Running as sudo?!"
				exit 1
			fi
		else
			echo "Failed to unzip."
			exit 1
		fi
	else
		echo "Tower is already installed!"
		exit 0
	fi

	cleanup "Tower.app" "$download_zip"
	exit 0
}

function install_rocket {

	echo "${INFO}|||${NC} Installing Rocket..."

	exit 0
}

function install_xcode {

	echo "${INFO}|||${NC} Installing Xcode..."

	exit 0
}


function install_brew {

	echo "${INFO}|||${NC} Installing Homebrew..."

	if ! [[ "$(command -v brew)" > /dev/null ]] ; then
		# shellcheck disable=SC2057
		if /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ; then
			echo "Homebrew installed!"
		else
			echo "Failed to installe Homebrew..."
			exit 1
		fi
	else
		echo "Homebrew already installed!"
		brew update
		brew upgrade
	fi

	if ! [[ "$(command -v brew-file)" > /dev/null ]] ; then
		echo "Installing brew-file"

		if brew install rcmdnk/file/brew-file ; then
			echo "brew-file installed"
		else
			echo "Failed to install brew-file"
			exit 1
		fi
	else
		echo "brew-file already installed"
	fi

	#At a later date, this will be changed to either be assigned from the command line or by default this repo path
	local brewFile="./Brewfile"

	if check_sudo_permission ; then
		echo "${WARN}|||${NC} Password required to run as sudo"
	fi

	if brew file install -f "${brewFile}" ; then
		echo "${PASS}|||${NC} Packages from Brewfile installed!"
	else
		echo "${FAIL}|||${NC} Packages failed to install"
		exit 1
	fi

	if check_sudo_permission ; then
		echo "${WARN}|||${NC} Password required to run as sudo"
	fi

	# Update Bash after install through homebrew
	#https://johndjameson.com/blog/updating-your-shell-with-homebrew/

	# Run following as Sudo user
	# https://unix.stackexchange.com/a/269080
	if sudo bash -c "echo /usr/local/bin/bash >> /etc/shells" ; then
		#Change shell to new bash
		if chsh -s /usr/local/bin/bash ; then
			echo "${PASS}|||${NC} Shell changed to Bash from homebrew"
		else
			echo "${FAIL}|||${NC} Failed to change shell to new Bash"
			exit 1
		fi
	fi

	exit 0
}

function install_dotfiles {

	echo "${INFO}|||${NC} Installing dotfiles..."

	exit 0
}

function install_all {

	echo "${INFO}|||${NC} Installing everything ❤️ ..."

	check_FileVault
	install_dotfiles
	install_xcode
	install_brew
	install_gpg
	install_tower
	install_rocket
	customise_defaults
	exit 0
}

function main {

	local var=${1:-"usage"}

	#Include script to check network connection

	if [[ "${var}" = "checkfv" ]]; then
		check_FileVault

	elif [[ "${var}" = "customise" ]]; then
		customise_defaults

	elif [[ "${var}" = "cirrus" ]]; then
		install_cirrus

	elif [[ "${var}" = "gpgtools" ]]; then
		install_gpg

	elif [[ "${var}" = "sublime" ]]; then
		install_sublime

	elif [[ "${var}" = "tower" ]]; then
		install_tower

	elif [[ "${var}" = "rocket" ]]; then
		install_rocket

	elif [[ "${var}" = "xcode" ]]; then
		install_xcode

	elif [[ "${var}" = "brew" ]]; then
		install_brew

	elif [[ "${var}" = "dotfiles" ]] ; then
		install_dotfiles

	elif [[ "${var}" = "all" ]]; then
		install_all

	else
		usage

	fi

	cleanup

}

main "$@"



