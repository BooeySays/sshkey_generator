#!/usr/bin/env python3

import os, sys, shutil

COLS, LINES = shutil.get_terminal_size()

OPTTYPE = None
OPTBIT = None
OPTCOMMENT = None
OPTPASSPHRASE = None
OPTFILENAME = None

class clr:
	RED = '[00;01;38;5;196m'
	red = '[00;38;5;196m'
	CYAN = '[00;01;38;5;51m'
	BLUE = '[00;01;38;5;21m'
	WHITE = '[00;01;38;5;15m'
	GREEN = '[00;01;38;5;46m'
	green = '[00;38;5;46m'
	reset = '[00m'

__VERSION__ = '0.2'
DASH = '─'

HELPQUIT = (' ' + clr.RED + '[' + clr.WHITE + 'H' + clr.RED + ']' + clr.WHITE + 'elp ' + clr.BLUE + DASH + clr.RED + ' [' + clr.WHITE + 'Q' + clr.RED + ']' + clr.WHITE + 'uit ' + clr.BLUE + DASH * 2 + clr.reset)	#19

BACKDASH = (clr.BLUE + DASH + ' ' + clr.GREEN + '[' + clr.WHITE + 'B' + clr.GREEN + ']' + clr.WHITE + 'ack ')	# 9

PROMPTD = (BACKDASH + clr.BLUE + DASH * (COLS - 28) + HELPQUIT)

def TitleLine(x):
	Title = str(x)
	print('\033c' + clr.RED + DASH * COLS + '\r' + DASH * 2 + ' ' + '\033[00;01mSSH-KEYGEN Generator v' + str(__VERSION__) + ' - ' + Title + ' ' + clr.reset + '\n')

def optstatus(x):
	OPTVAR=x
	if OPTVAR == None:
		print('\033[00;01mStatus: [ \033[00;01;38;5;196m✘ \033[00;01m]\033[m')
	elif OPTVAR is not None:
		print('\033[00;01mStatus: [ \033[00;01;38;5;46m✔ \033[00;01m]\tValue: ' + OPTVAR)
	del OPTVAR


class menus:
	def comment():
		TitleLine('Comment Configuration Menu')
		print("""\033[00;01mCOMMENTS:\033[00m

	Adding a comment to your key will allow you to easily organize
	the key(s) and keep it/them organized. The comment gets appended
	to the end of the key, so when you are doing something like, edit-
	ing the "Authorized ssh key" list, you can easily / quickly tell
	which key is which... etc. Personally, I add the name of the pc
	that I am generating the key on (plus the date). It just makes it
	easier for when I authorize computers on my servers.

\033[00;01mExample:\033[m

	Comment:"KaliOnRaspberryPi-20190101"
""")
		print(PROMPTD)
		OPTCOMMENT = input(': ')
		print(OPTCOMMENT)
		menus.main()

	def main():
		TitleLine('Main Menu')
		print("""
	[1] Choose the key type
		""",end='')
		print(optstatus(OPTTYPE))
		print("""
	[2] Choose number of bits
	[3] Choose a passphrase to use
	[4] Choose a filename for the keys
	[5] Enter a comment
		""",end='')
		print(optstatus(OPTCOMMENT))
		print("""

	[G]enerate the key

""")
		print(PROMPTD)
		mainopt = input(': ')
		if mainopt == '5':
			menus.comment()



menus.main()