#!/usr/bin/env python3
'''
Skript zum automatischen Entpacken von Archiven. Alle Kommandozeilenparameter werden als mögliche Dateien oder
Verzeichnisse behandelt. Bei verschlüsselten Archiven wird nach dem Passwort gefragt und bei einem erfolgreichen
Entpacken wird das verwendete Passwort in einer Passwortliste gespeichert. Entpackte Archive werden in den
Papierkorb verschoben.

usage: unpack_lazy.py archive [archive .. archive]
'''

import os
import sys
import threading
import wx

import subpub


# responsible thread for parsing all archives
class ThreadWorker(threading.Thread):

	def __init__(self, broker):
		super().__init__()
		self.broker = broker

		# complete path an name of the password list file
		self.strFilePassList = os.path.expandvars('$HOME/.plst')

	def run(self):
		# does a password file exist?
		if os.path.exists(self.strFilePassList):
			# yes, the password file exists
			# is this a file?
			if os.path.isfile(self.strFilePassList):
				# yes, this is a file
				pass
			else:
				# no, this is not a file
				print(f"{self.strFilePassList} is not a file")
		else:
			print(f"{self.strFilePassList} does not exist")

		print("Worker thread finished.")


# Panel class
class PanelMain(wx.Panel):

	def __init__(self, parent):
		super().__init__(parent)

		self.buttonCancel = wx.Button(self, label='Cancel')

		self.sizerMain = wx.BoxSizer(wx.VERTICAL)
		self.sizerMain.Add(self.buttonCancel, proportion=0, flag=wx.ALL | wx.CENTER, border=10)

		self.SetSizer(self.sizerMain, deleteOld=True)


# Main frame
class FrameMain(wx.Frame):

	def __init__(self):
		super().__init__(None, title="Lazy Unpack", size=(600, 300))
		self.panel = PanelMain(self)
		self.Show()


# Main application (View)
class AppMain(wx.App):

	def __init__(self, broker):
		super().__init__(redirect=False)
		self.broker		 = broker
		self.frameMain	 = FrameMain()


if __name__ == '__main__':
	# create all necessary objects
	brokerData		 = subpub.SubPub()
	appMain			 = AppMain(broker=brokerData)
	threadWorker	 = ThreadWorker(broker=brokerData)

	# start all threads
	threadWorker.start()
	appMain.MainLoop()

	# wait for the worker thread
	threadWorker.join()

	print('Script finished.')
	sys.exit(os.EX_OK)

# EOF
