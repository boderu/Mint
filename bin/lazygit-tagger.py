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


class GitTagger:
	def __init__(self, RepositoryPath):
		try:
			# Initialise respository
			self.BaseRepository = Repo(RepositoryPath)
		except InvalidGitRepositoryError:
			raise Exception("Not a valid git repository")

		# check if the repository is clean
		if self.BaseRepository.index.diff(None) != [] or self.BaseRepository.untracked_files != []:
			raise Exception("Repository status is not clean")

		# generate components file path
		self.ComponentsFilePath = Path(RepositoryPath + "/components.conf")

		# check if components file exists and read content for backup
		if (self.ComponentsFilePath.is_file()):
			with open(self.ComponentsFilePath, 'r') as f:
				self.componentsFileContentBackup = f.read()
		else:
			raise Exception("components.conf not found in repository path")

	# Erstellen des Tags mit Commit
	def CreateTag(self, sTagName: str, sTagMessage: str):
		# prase available components
		self.__parseComponents()
		# find selected commit hash for each component
		self.__findCommitObjects()
		# modify the lines in the components.conf file
		self.__modifyComponents()

		# add changed components.conf to index
		self.BaseRepository.index.add(['components.conf'])
		# make a commit
		commitObj = self.BaseRepository.index.commit("Fixed version of components to commit hash values for tagging")
		# create tag to commit
		self.BaseRepository.create_tag(path=sTagName, ref=commitObj, message=sTagMessage, force=False)

	# Erstellen des nachfolge Commit Objekts für vorherigen Zustands
	def RestoreComponents(self):
		with open(self.ComponentsFilePath, 'w') as f:
			f.write(self.componentsFileContentBackup)

		# add changed components.conf to index
		self.BaseRepository.index.add(['components.conf'])
		# make a commit
		self.BaseRepository.index.commit("Restore components.conf to the state it was in before the tag")

	def __parseComponents(self):
		self.lComponents: list = []
		with open(self.ComponentsFilePath, 'r') as f:
			for line in f:
				self.lComponents.append(line.split())

		# Filter empty lines
		self.lComponents = list(filter(lambda item: item != [], self.lComponents))
		# Filter lines that starts with '#'
		self.lComponents = list(filter(lambda item: not item[0].startswith('#'), self.lComponents))

	def __findCommitObjects(self):
		for idx, Component in enumerate(self.lComponents):
			repo = Repo(self.BaseRepository.working_tree_dir + '/Components/' + Component[0])
			# get current object hash
			ObjectHash = repo.head.commit

			if(Component[1] != 'commit' or Component[2] != ObjectHash):
				self.lComponents[idx][1] = 'commit'
				self.lComponents[idx][2] = ObjectHash.hexsha

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
	argParser.add_argument("-tn", "--tagName", type=str, help="Name of the tag to create", required=True)
	argParser.add_argument("-tm", "--tagMessage", type=str, help="Message for the tag to create", required=True)

	# Parse arguments
	args = argParser.parse_args()

	try:
		# create instance
		gitTagger = GitTagger(args.repo)
		# create tag
		gitTagger.CreateTag(args.tagName, args.tagMessage)
		# create commit as it was before
		gitTagger.RestoreComponents()
		# print success message
		print("Tag with Name {} created sucessfully".format(args.tagName))
	except Exception as e:
		print("Error: {}".format(e))
