#!/usr/bin/env python3
"""
Documentation here
"""

import tkinter
import sys
import argparse
import pathlib
import tkinter.ttk

iExitValue = int(0)

# TODO describe open topics
# FIXME describe topics to be fixed

argParser = argparse.ArgumentParser(description="Program description")
argParser.add_argument('lstpathFiles', type=pathlib.Path, nargs='*', help='Path of files')
cmdlineargs = argParser.parse_args()

winMain = tkinter.Tk()
winMain.title('Window name')
winMain.geometry('300x150')
lblTitle = tkinter.ttk.Label(master=winMain, text='Title text')
lblTitle.pack()

if __name__ == '__main__':
	for pathItem in cmdlineargs.lstpathFiles:
		print(pathItem)

	winMain.mainloop()

	sys.exit(iExitValue)

# EOF
