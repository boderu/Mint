#!/usr/bin/env python3
'''
Skript um Dateien in ausgewählte Unterverzeichnisse zu verschieben.
Aufruf:			move2subfolder.py [file file file ...]
Rückgabewerte:	0:	Ok
				2:	Abbruch durch den Anwender
'''

import typing
import sys
import os
import argparse
import pathlib
import shutil

import tkinter
import tkinter.ttk
# from ttkthemes import ThemedTk
# from tkinter.messagebox import showinfo

iExitValue:	int					= 0
VERSION:	typing.Final[str]	= '0.1.0'

# parsing arguments ---------------------------------------------------------------------------------------------------
argParser = argparse.ArgumentParser(description="Program description")
argParser.add_argument('lstpathFiles', type=pathlib.Path, nargs='*', help='Path of files')
cmdlineargs = argParser.parse_args()
lstpathFilesMarkedForDeletion: list = cmdlineargs.lstpathFiles

# looking for sub-folder ----------------------------------------------------------------------------------------------
lststrDirectoriesSelected:	list	= ['New Folder']
lststrDirectories:			list	= ['New Folder']
for anyItem in os.listdir():
	if os.path.isdir(anyItem):
		lststrDirectories.append(str(anyItem))
lststrDirectories.sort()

# GUI and event functions ---------------------------------------------------------------------------------------------
winMain = tkinter.Tk()
winMain.title('Move files to a subdirectory')
winMain.resizable(width=False, height=False)

lblTitle = tkinter.ttk.Label(master=winMain, text='Select subdirectories!', anchor=tkinter.CENTER)
lblTitle.grid(column=0, row=0, columnspan=3, padx=5, pady=5, sticky='nsew')

iHeightTree = len(lststrDirectories) if len(lststrDirectories) <= 8 else 8
treeDirectories = tkinter.ttk.Treeview(winMain, height=iHeightTree)
# treeDirectories = tkinter.ttk.Treeview(winMain, columns='colDirs', show='headings', height=4)
# treeDirectories.heading('colDirs', text='Directories')
for strDir in lststrDirectories:
	treeDirectories.insert('', tkinter.END, text=strDir)
treeDirectories.grid(column=0, row=1, columnspan=2, padx=5, pady=0, sticky='nsew')

def selectedTreeItem(event) -> None:
	''' get selected items from tree view '''
	print('Directories selected:')
	lststrDirectoriesSelected.clear()
	# transfer all selected items into lststrDirectoriesSelected
	for strSelectedItem in treeDirectories.selection():
		dicItem = treeDirectories.item(strSelectedItem)
		strRecord = dicItem['text']
		lststrDirectoriesSelected.append(strRecord)
	for item in lststrDirectoriesSelected:
		print(item)

treeDirectories.bind('<<TreeviewSelect>>', selectedTreeItem)

# a scrollbar for the tree view
scrollbarTreeDirectories = tkinter.ttk.Scrollbar(winMain, orient=tkinter.VERTICAL, command=treeDirectories.yview)
treeDirectories.configure(yscroll=scrollbarTreeDirectories.set)
scrollbarTreeDirectories.grid(column=2, row=1, columnspan=1, sticky='ns')

def clickOk() -> None:
	''' button: move files to the selected subdirectory '''
	print('Ok clicked')
	global iExitValue
	global lstpathFilesMarkedForDeletion
	if len(lststrDirectoriesSelected) != 0 and len(cmdlineargs.lstpathFiles) != 0:
		for strDir in lststrDirectoriesSelected:
			for pathFile in cmdlineargs.lstpathFiles:
				print(f'copy {pathFile} to {strDir}')
				try:
					shutil.copy2(pathFile, strDir)
				except:
					lstpathFilesMarkedForDeletion.remove(pathFile)
		for pathFile in lstpathFilesMarkedForDeletion:
			print(f'delete {pathFile}')
	else:
		iExitValue = 1
	winMain.destroy()

bttnOk = tkinter.ttk.Button(master=winMain, text='Ok', command=clickOk)
bttnOk.grid(column=0, row=2, columnspan=1, padx=5, pady=5, sticky='ew')

def clickCancel() -> None:
	''' button: cancel action and quit program '''
	print('Cancel clicked')
	global iExitValue
	iExitValue = 2
	winMain.destroy()

bttnCancel = tkinter.ttk.Button(master=winMain, text='Cancel', command=clickCancel)
bttnCancel.grid(column=1, row=2, columnspan=1, padx=5, pady=5, sticky='ew')

# program start -------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
	for pathItem in cmdlineargs.lstpathFiles:
		print(pathItem)

	winMain.mainloop()

	sys.exit(iExitValue)

# EOF
