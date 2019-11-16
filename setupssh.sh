#!/bin/bash

__VERSION__='0.1'
function RESETVALUES(){
	PASSPHRASE='None'
	OPTA='None'
	OPTB='None'
	SSHKEYFILENAME='None'
	COMMENTS='None'
}

function optstat(){
	val=$1
	if [ "$val" == "None" ]; then
		echo -en "\033[00;01m[ \033[00;01;38;5;196m✘ \033[00;01m]\033[m		"
	else
		echo -en "\033[00;01m[ \033[00;01;38;5;46m✔ \033[00;01m]\033[m		"
		if [ "$1" == "$PASSPHRASE" ]; then
			echo -en " \033[00;01;38;5;196m†\033[00;3mHidden\033[23m"
		else
			echo "\033[3;38;5;190m\"\033[00;03m$val\033[3;38;5;190m\"\033[m"
		fi
	fi
#	unset val
}

function titlessh(){
	clear
	SUBTITLE=$1
	printf '\033[00;01;48;5;196m'
	printf ' %.s' $(seq 1 $COLUMNS)
	printf "\r SSH-KEYGEN Generator v"$__VERSION__" - $SUBTITLE\033[m\n\n"
	unset SUBTITLE
}

function MAINMENU(){
	titlessh 'Main Menu'
	echo -en """
\033[00;01mChoose item to set:

	\033[00;01;38;5;51m[\033[00;01m#\033[00;01;38;5;51m] \033[00;01;04mOption	\033[00;01m[\033[00;01;38;5;196m✘\033[00;01m/\033[00;01;38;5;46m✔\033[00;01m]  \033[4mValue\033[m

	\033[00;01;38;5;51m[\033[00;01m1\033[00;01;38;5;51m]\033[00;01m Key type	"$(optstat $OPTA)"
	\033[00;01;38;5;51m[\033[00;01m2\033[00;01;38;5;51m]\033[00;01m Bit type	"$(optstat $OPTB)"
	\033[00;01;38;5;51m[\033[00;01m3\033[00;01;38;5;51m]\033[00;01m Passphrase	"$(optstat $PASSPHRASE)"
	\033[00;01;38;5;51m[\033[00;01m4\033[00;01;38;5;51m]\033[00;01m Filename	"$(optstat $SSHKEYFILENAME)"
	\033[00;01;38;5;51m[\033[00;01m5\033[00;01;38;5;51m]\033[00;01m Comments	"$(optstat $COMMENTS)"

	\033[00;01;38;5;46m[\033[00;01mG\033[00;01;38;5;46m]\033[00;01menerate ket
	\033[00;01;38;5;196m[\033[00;01mQ\033[00;01;38;5;196m]\033[00;01muit
"""
	read -p ': ' -n 1
	case "$REPLY" in
		'1')
			typekey
			;;
		'2')
			typebit
			;;
		'3')
			typepassphrase
			;;
		'4')
			typefile
			;;
		'5')
			typecomments
			;;
		'g'|'G')
			GenerateKey
			;;
		'q'|'Q')
			echo -en """
Exiting ...
"""
			return
			;;
	esac
}

function typekey(){
	titlessh 'Encryption Key Type'
	echo -en """Choose key type:

	[1]	dsa
	[2] ecdsa
	[3]	ed25519
	[4] rsa

	[Q]uit
"""
	read -p ': ' -n 1
	case "$REPLY" in
		'1')
			OPTA='dsa'
			MAINMENU
			;;
		'2')
			OPTA='ecdsa'
			MAINMENU
			;;
		'3')
			OPTA='ed25519'
			MAINMENU
			;;
		'4'|'')
			OPTA='rsa'
			MAINMENU
			;;
		'Q'|'q')
			echo -en """
Exiting...
"""
			return
			;;
		*)
			echo -en """
Invalid Selection

[ Hit any key to try again ]

"""
			read -n 1
			typekey
			;;
		esac
		unset REPLY
#		MAINMANU
}

function typebit(){
	titlessh 'Number of bits'
	echo -en """
Enter number of bits to use.
(ex:For RSA keys, the min size is 1024 bits and the default is
	2048. Generally, 2048 is considered sufficient. DSA keys
	must be exactly 1024 bits as specified by FIPS 186-2... etc)

: """
	read -r OPTB
	MAINMENU
}

function typepassphrase(){
	titlessh 'Choose Passphrase'
	tput civis
	echo -en """
Enter passphrase to use (Empty for no passphrase)
: \033[8m"""
	read -r PASSONE
	case "$PASSONE" in
		'')
			echo -en """\033[m
Nothing entered for passphrase... 

Generating key without a passphrase
"""
			;;
		*)
			echo -en """\033[m
Please re-enter passphrase to confirm: \033[8m"""
			read -r PASSTWO
			;;
	esac
	if [ "$PASSONE" != "$PASSTWO" ]; then
		unset PASSONE PASSTWO
		echo -en """\033[m
Passphrases did not match - Please try again

[ Hit any key to continue ]

"""
		read -n 1
		typepassphrase
	else
		PASSPHRASE="$PASSONE"
		unset PASSONE PASSTWO
		echo -en """\033[m
Passphrase successfully set !
"""
	fi
	tput cnorm
	MAINMENU
}

function typefile(){
	titlessh 'Filename'
	echo -en """
Enter file in which to save the key (Default: \033[38;5;190m$HOME/.ssh/id_rsa\033[m)
(Hit enter to use the default filename)
: """
	read -r SSHFILENAME
	case "$SSHFILENAME" in
		'')
			SSHKEYFILENAME="$HOME/.ssh/id_rsa"
			MAINMENU
			;;
		*)
			SSHKEYFILENAME="$SSHFILENAME"
			unset SSHFILENAME
			MAINMENU
			;;
	esac
}

function __main(){
	typekey
	typebit
	typepassphrase
	typefile
	echo "$OPTA $OPTB $PASSPHRASE $SSHKEYFILENAME"
}

#MAINMENU
#__main

function STARTUP(){
	titlessh
	echo -en """
Warning!
You are about to generate a SSH KEY.

I wrote this script will help you generate a key while at
the same time, trying to explain every step taken along
the way, to the best of my abilities.

The key will not generate until you choose the option to
generate one at the end, so if at any time you are lost,
confused, and/or have no idea what you are doing, please
exit the script by choosing the Quit option, or by hitting
the [CTRL] + [C] keys.

Thanks.

[ Hit any key to continue ]

"""
	read -n 1
	RESETVALUES
	MAINMENU
}

function typecomments(){
	titlessh
	echo -en """
Enter comment to use (Helps identify the key file)
: """
	read -r COMMENTS
	MAINMENU
}

function GenerateKey(){
	if [ "$OPTA" == 'None' ] || [ "$OPTB" == 'None' ] || [ "$SSHKEYFILENAME" == 'None' ] || [ "$PASSPHRASE" == 'None' ] || [ "$COMMENTS" == 'None' ]; then
		echo -en """
One or more values has not been set.

Please set them before generating key.

[ Hit any key to continue ]

"""
		read -n 1
		MAINMENU
	else
		echo -en "\033[00;01m[ \033[00;01;38;5;190mWAIT \033[00;01m] Generating SSH keys with the entered values"
		ssh-keygen -q -t "$OPTA" -b "$OPTB" -f "$SSHKEYFILENAME" -P "$PASSPHRASE" -C "$COMMENTS"
		echo -e "\r\033[00;01m[ \033[00;01;38;5;46mDONE \033[00;01m] Generating SSH keys with the entered values"
		if [ $SSH_AGENT_PID ]; then
			echo -en "\033[00;01m[ \033[00;01;38;5;190mWAIT \033[00;01m] Killing the current agent"
			eval "$(ssh-agent -k)"
			echo -e "\r\033[00;01m[ \033[00;01;38;5;46mDONE \033[00;01m] Killing the current agent"
		fi
		echo -en "\033[00;01m[ \033[00;01;38;5;190mWAIT \033[00;01m] Adding key"
		ssh-add "$SSHKEYFILENAME"
		echo -e "\r\033[00;01m[ \033[00;01;38;5;46mDONE \033[00;01m] Adding key"
	fi
#	unset OPTA OPTB SSHKEYFILENAME PASSPHRASE COMMENTS
}

RESETVALUES
MAINMENU
#STARTUP