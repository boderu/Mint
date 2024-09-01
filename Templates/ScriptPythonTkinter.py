#!/usr/bin/env python3
"""
Documentation here
"""

import sys
import argparse
import pathlib
import tkinter as tk
import tkinter.ttk as ttk

argParser = argparse.ArgumentParser(description="Program description")
argParser.add_argument('lstpathFiles', type=pathlib.Path, nargs='*', help='Path of files')
cmdlineargs = argParser.parse_args()

# ---------------------------------------------------------------------------------------------------------------------
class clssTkApp(tk.Tk):
	''' Application class '''
	def __init__	(
						self,
						screenName:		str | None	= None,
						baseName:		str | None	= None,
						className:		str			= "clssApp",
						useTk:			bool		= True,
						sync:			bool		= False,
						use:			str | None	= None,
						strTitleWindow:	str			= 'Window tilte'
					) -> None:
		super().__init__(screenName, baseName, className, useTk, sync, use)

		self.iCntLoop:		int = 10000
		self.iCnt:			int = 0

		self.iExitValue:	int = 0

		self.title(strTitleWindow)
		self.resizable(width=False, height=False)

		self.lblTitle = ttk.Label(master=self, text='Title text')
		self.lblTitle.pack(padx=5, pady=5, fill='x')

		self.frameButtons = ttk.Frame(master=self)
		self.frameButtons.pack(padx=5, pady=5, fill='x')

		self.bttnCancel = ttk.Button(master=self.frameButtons, text='Cancel', command=self.BttnCancelClicked)
		self.bttnCancel.pack(padx=5, pady=5, side='left')
		self.bttnOk = ttk.Button(master=self.frameButtons, text='Ok', command=self.BttnOkClicked)
		self.bttnOk.pack(padx=5, pady=5, side='right')

		self.after(500, self.TkIdle)	# start Idle method afer the GUI has been created

	def TkIdle(self) -> None:
		''' part of the event loop '''
		if self.iCntLoop == 0:
			print(f'Tk Idle {self.iCnt}')
			self.iCnt += 1
			self.iCntLoop = 10000
		else:
			self.iCntLoop -= 1
		self.after_idle(self.TkIdle)	# retrigger method

	def BttnCancelClicked(self) -> None:
		print('Button "Cancel" clicked')

	def BttnOkClicked(self) -> None:
		print('Button "Ok" clicked')

	def ExitValue(self) -> int:
		return self.iExitValue


# ---------------------------------------------------------------------------------------------------------------------
if __name__ == '__main__':
	for pathItem in cmdlineargs.lstpathFiles:
		print(pathItem)

	app = clssTkApp(strTitleWindow='Python Tk script')
	app.mainloop()

	sys.exit(app.ExitValue())

# EOF
