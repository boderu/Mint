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

import tkinter as tk
import tkinter.ttk as ttk
# from ttkthemes import ThemedTk
# from tkinter.messagebox import showinfo

VERSION:	typing.Final[str]	= '0.1.0'

# parsing arguments ---------------------------------------------------------------------------------------------------
argParser = argparse.ArgumentParser(description="Program description")
argParser.add_argument('lstpathFiles', type=pathlib.Path, nargs='*', help='Path of files')
cmdlineargs = argParser.parse_args()

# GUI and event functions ---------------------------------------------------------------------------------------------
class clssTkApp(tk.Tk):
	''' application class '''
	def __init__(self, lstpathFilesMarked: list) -> None:
		super().__init__()

		self.iCntLoop:	int 	= 10000
		self.iCnt:		int 	= 0
		self.bQuit:		bool	= False

		self.iExitValue:					int		= 0
		self.lstpathFilesMarkedForDeletion:	list	= lstpathFilesMarked
		self.lstpathFilesMarked:			list	= lstpathFilesMarked
		self.lststrDirectoriesSelected:		list	= []
		self.lststrDirectories:				list	= ['New Folder']

		# looking for sub-folders
		for anyItem in os.listdir():
			if os.path.isdir(anyItem):
				self.lststrDirectories.append(str(anyItem))
		self.lststrDirectories.sort()

		self.title('Move files to a subdirectory')
		self.resizable(width=False, height=False)

		self.lblTitle = ttk.Label(master=self, text='Select subdirectories!', anchor='center')
		self.lblTitle.pack(fill='x')

		self.frameTreeView = ttk.Frame(master=self)
		self.frameTreeView.pack(fill='x')

		self.frameButtons = ttk.Frame(master=self)
		self.frameButtons.pack()

		self.iHeightTree: int = len(self.lststrDirectories) if len(self.lststrDirectories) <= 8 else 8
		self.treeviewDirectories = ttk.Treeview(master=self.frameTreeView, height=self.iHeightTree, show='tree')

		for strDir in self.lststrDirectories:
			self.treeviewDirectories.insert('', tk.END, text=strDir)
		self.treeviewDirectories.pack(side='left', fill='x')

		self.treeviewDirectories.bind('<<TreeviewSelect>>', self.TreeViewItemSelected)

		# a scrollbar for the tree view
		self.scrollbarTreeDirectories = ttk.Scrollbar	(	master=self.frameTreeView,
															orient='vertical',
															command=self.treeviewDirectories.yview
														)
		self.treeviewDirectories.configure(yscroll=self.scrollbarTreeDirectories.set)
		self.scrollbarTreeDirectories.pack(side='right', fill='y')

		self.bttnOk = ttk.Button(master=self.frameButtons, text='Ok', command=self.ButtonOkClicked)
		self.bttnOk.pack(side='left', padx=5, pady=5)

		self.bttnCancel = ttk.Button(master=self.frameButtons, text='Cancel', command=self.ButtonCancelClicked)
		self.bttnCancel.pack(side='right', padx=5, pady=5)

		self.after(500, self.TkIdle)	# start Idle method afer the GUI has been created

	def TkIdle(self) -> None:
		''' part of the event loop '''
		if self.iCntLoop == 0:
			#print(f'Tk Idle {self.iCnt}')
			self.iCnt += 1
			self.iCntLoop = 10000
		else:
			self.iCntLoop -= 1

		if self.bQuit == True:
			self.destroy()
		else:
			self.after_idle(self.TkIdle)	# retrigger method

	def TreeViewItemSelected(self, event) -> None:
		''' get selected items from tree view '''
		print('Directories selected:')
		self.lststrDirectoriesSelected.clear()
		# transfer all selected items into lststrDirectoriesSelected
		for strSelectedItem in self.treeviewDirectories.selection():
			dicItem = self.treeviewDirectories.item(strSelectedItem)
			strRecord = dicItem['text']
			self.lststrDirectoriesSelected.append(strRecord)
		for item in self.lststrDirectoriesSelected:
			print(item)

	def ButtonOkClicked(self) -> None:
		''' button: move files to the selected subdirectory '''
		print('Ok clicked')
		if len(self.lststrDirectoriesSelected) != 0 and len(self.lstpathFilesMarked) != 0:
			for strDir in self.lststrDirectoriesSelected:
				for pathFile in cmdlineargs.lstpathFiles:
					print(f'copy {pathFile} to {strDir}')
					try:
						shutil.copy2(pathFile, strDir)
					except:
						self.lstpathFilesMarkedForDeletion.remove(pathFile)
						print('Fily copy failed!')
			for pathFile in self.lstpathFilesMarkedForDeletion:
				print(f'delete {pathFile}')
				try:
					os.remove(pathFile)
				except FileNotFoundError:
					print(f"File {pathFile} does not exist.")
				except PermissionError:
					print(f"No authorization to delete the {pathFile} file.")
				except Exception as e:
					print(f"Error when deleting the file: {e}")
		else:
			self.iExitValue = 1
		self.bQuit = True

	def ButtonCancelClicked(self) -> None:
		''' button: cancel action and quit program '''
		print('Cancel clicked')
		self.iExitValue = 2
		self.bQuit = True

	def ExitValue(self) -> int:
		return self.iExitValue


# program start -------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
	app = clssTkApp(cmdlineargs.lstpathFiles)
	app.mainloop()
	sys.exit(app.ExitValue())

# EOF
