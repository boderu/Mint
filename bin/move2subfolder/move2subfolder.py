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

# looking for sub-folders ---------------------------------------------------------------------------------------------
lststrDirectoriesSelected:	list	= ['New Folder']
lststrDirectories:			list	= ['New Folder']
for anyItem in os.listdir():
	if os.path.isdir(anyItem):
		lststrDirectories.append(str(anyItem))
lststrDirectories.sort()

# GUI and event functions ---------------------------------------------------------------------------------------------
tkwinMain = tkinter.Tk()
# winMain = ThemedTk(theme="yaru")
tkwinMain.title('Move files to a subdirectory')
tkwinMain.resizable(width=False, height=False)

tklblTitle = tkinter.ttk.Label(master=tkwinMain, text='Select subdirectories!', anchor='center')
tklblTitle.pack(fill='x')

tkframeTreeView = tkinter.ttk.Frame(master=tkwinMain)
tkframeTreeView.pack(fill='x')

iHeightTree = len(lststrDirectories) if len(lststrDirectories) <= 8 else 8
tktreeviewDirectories = tkinter.ttk.Treeview	(	master=tkframeTreeView,
											  		height=iHeightTree,
													show='tree',
												)
for strDir in lststrDirectories:
	tktreeviewDirectories.insert('', tkinter.END, text=strDir)
tktreeviewDirectories.pack(side='left', fill='x')

def selectedTreeItem(event) -> None:
	''' get selected items from tree view '''
	print('Directories selected:')
	lststrDirectoriesSelected.clear()
	# transfer all selected items into lststrDirectoriesSelected
	for strSelectedItem in tktreeviewDirectories.selection():
		dicItem = tktreeviewDirectories.item(strSelectedItem)
		strRecord = dicItem['text']
		lststrDirectoriesSelected.append(strRecord)
	for item in lststrDirectoriesSelected:
		print(item)

tktreeviewDirectories.bind('<<TreeviewSelect>>', selectedTreeItem)

# a scrollbar for the tree view
tkscrollbarTreeDirectories = tkinter.ttk.Scrollbar	(	master=tkframeTreeView,
												  		orient='vertical',
														command=tktreeviewDirectories.yview
													)
tktreeviewDirectories.configure(yscroll=tkscrollbarTreeDirectories.set)
tkscrollbarTreeDirectories.pack(side='right', fill='y')

tkframeButtons = tkinter.ttk.Frame(master=tkwinMain)
tkframeButtons.pack()


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
	tkwinMain.destroy()

tkbttnOk = tkinter.ttk.Button(master=tkframeButtons, text='Ok', command=clickOk)
tkbttnOk.pack(side='left', padx=5, pady=5)

def clickCancel() -> None:
	''' button: cancel action and quit program '''
	print('Cancel clicked')
	global iExitValue
	iExitValue = 2
	tkwinMain.destroy()

tkbttnCancel = tkinter.ttk.Button(master=tkframeButtons, text='Cancel', command=clickCancel)
tkbttnCancel.pack(side='right', padx=5, pady=5)

# program start -------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
	tkwinMain.mainloop()
	sys.exit(iExitValue)

# EOF
