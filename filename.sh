function overwriteask(){
	echo -en """
Do you want to overwrite the file?

[y/N]: """
	read -n 1
	case "$REPLY" in
		'y'|'Y')
			rm "$SSHKEYFILENAME"
			rm ""$SSHKEYFILENAME".pub"
			;;
		'n'|'N'|'')
			echo -en """
[ Hit any key to enter another filename ]

"""
			read -n 1
			;;
		*)
			echo -en """
ERROR - Invalid selection

[ Hit any key to continue ]

"""
			overwriteask
			;;
	esac
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
			;;
		*)
			SSHKEYFILENAME="$SSHFILENAME"
			;;
	esac
	if [ -f "$SSHKEYFILENAME" ]; then
		overwriteask
		typefile
	fi
	unset SSHFILENAME
	MAINMENU
}

