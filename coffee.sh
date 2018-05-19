#!/usr/bin/env bash
#coffee.sh

#Inspired from 0xmachos bittersweet.sh

set -euo pipefail
# -e if any command returns a non-zero status code, exit
# -u don't use undefined vars
# -o pipefall pipelines fails on the first non-zero status code


function usage {

	echo -e "\\nMake macOS the way it is meant to be 🤙\\n"
	echo "Usage: "
	echo " checkfv		- Check FileVault is enabled ⛑"
	echo " customise		- Customise the default options of macOS 😍"
	echo " cirrus			- Install Cirrus ☁️"
	echo " gpgtools		- Install GPG Tools ⚙️"
	echo " sublime		- Install Sublime Text 👨‍💻"
	echo " tower			- Install Tower 💂‍♂️"
	echo " rocket 		- Install Rocket 👽"
	echo " xcode		- Install Xcode "
	echo " appstore 	- Install Appstore apps "
	echo " brew			- Install Homebrew 🍺"
	echo " all 		- Install the items listed above  ❤️"

	echo -e "\\nMake macOS the way it is meant to be 🤙\\n"
	exit 0
}

function check_FileVault {

	echo "Checking if FileVault is enabled..."

	if fdesetup status | grep "On" >/dev/null ; then
		echo "[✅] Filevault is turned on"
	else 
		echo "[❌] Filevault is turned off"
		exit 1
	fi
}

function customise_defaults {

	echo "Customising the defaults..."

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

	echo "Installing Cirruss..."

	exit 0
}

function install_gpg {

	echo "Installing GPG Tools..."

	exit 0
}

function install_sublime {

	echo "Installing Sublime Text..."

	exit 0
}

function install_tower {

	echo "Installing Tower..."

	exit 0
}

function install_rocket {

	echo "Installing Rocket..."

	exit 0
}

function install_xcode {

	echo "Installing Xcode..."

	exit 0
}

function install_apps {

	echo "Installing apps..."

	#TODO: Amphetamine

	#TODO: Keynote

	#TODO: Pages

	#TODO: The Unarchiver

	#TODO: Spotify
	exit 0
}

function install_brew {

	echo "Installing Homebrew..."

	exit 0
}

function install_all {

	echo -e "Installing everything ❤️  ..."

	exit 0
}

function main {

	local var=${1:-"usage"}

	# if [[ Internet Connected ]]; then 
	# 	#Do tha code

	# else 
	# 	echo "[❌] Failed to connect to the internet"
	# 	exit 1
	# fi

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

	elif [[ "${var}" = "appstore" ]]; then
		install_apps

	elif [[ "${var}" = "brew" ]]; then
		install_brew

	elif [[ "${var}" = "all" ]]; then
		install_all

	else
		usage

	fi

}

main "$@"



