#!/usr/bin/env python3

from git import Repo
from git.exc import InvalidGitRepositoryError
from inspect import currentframe
from pathlib import Path
import fileinput
import argparse

def lineno():
	# Returns the current line number in our program.
	return currentframe().f_back.f_lineno


class GitComponentsSwitcher:
	def __init__(self, RepositoryPath):
		self.RepositoryPath = RepositoryPath

		try:
			# Initialise respository
			self.BaseRepository = Repo(RepositoryPath)
		except InvalidGitRepositoryError:
			raise Exception("Not a valid git repository")

		# generate components file path
		self.ComponentsFilePath = Path(RepositoryPath + "/components.conf")

		# check if components file exists and read content for backup
		if (not self.ComponentsFilePath.is_file()):
			raise Exception("components.conf not found in repository path")

	# Setze Branches in components.conf zu den aktiven Branches der Komponenten
	def BranchActiveSwitchTo(self):
		# prase available components
		self.__parseComponents()
		# find current selected branch for each component
		self.__branchCurrentSetTo()
		# modify the lines in the components.conf file
		self.__modifyComponents()

	def __parseComponents(self):
		self.lComponents: list = []
		with open(self.ComponentsFilePath, 'r') as f:
			for line in f:
				self.lComponents.append(line.split())

		# Filter empty lines
		self.lComponents = list(filter(lambda item: item != [], self.lComponents))
		# Filter lines that starts with '#'
		self.lComponents = list(filter(lambda item: not item[0].startswith('#'), self.lComponents))

	def __branchCurrentSetTo(self):
		for idx, Component in enumerate(self.lComponents):
			if 'branch' == Component[1]:
				repo = Repo(self.RepositoryPath + '/Components/' + Component[0])

				# get active branch
				self.lComponents[idx][2] = repo.active_branch.name

	def __modifyComponents(self):
		# open file for inplace editing
		for line in fileinput.input(self.ComponentsFilePath, inplace=True):
			# save back line to write
			lineToWrite = line
			if not lineToWrite.startswith('#'):
				# search in components for new values to write
				for Component in self.lComponents:
					# search if the component is
					if Component[0] == (line.split()[0] if len(line.split()) > 0 else None):
						# replace the type (branch|tag|commit)
						lineToWrite = lineToWrite.replace(line.split()[1], Component[1])
						# replace the commit hash
						lineToWrite = lineToWrite.replace(line.split()[2], Component[2])
			print('{}'.format(lineToWrite), end='')

if __name__ == '__main__':
	# Build arguments to parse
	argParser = argparse.ArgumentParser()
	argParser.add_argument("-r", "--repo", type=str, help="Path of repository to tag", required=True)

	# Parse arguments
	args = argParser.parse_args()

	#try:
	# create instance
	gitComponentsSwitcher = GitComponentsSwitcher(args.repo)
	# create tag
	gitComponentsSwitcher.BranchActiveSwitchTo()
	#except Exception as e:
	#	print("Error: {}".format(e))
