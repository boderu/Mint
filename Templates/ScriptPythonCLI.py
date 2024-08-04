#!/usr/bin/env python3
"""
Documentation here
"""

import sys
import argparse
import pathlib

iExitValue = int(0)

# TODO describe open topics
# FIXME describe topics to be fixed

argParser = argparse.ArgumentParser(description="Program description")
argParser.add_argument('lstpathFiles', type=pathlib.Path, nargs='*', help='Path of files')
cmdlineargs = argParser.parse_args()

if __name__ == '__main__':
	print("Hello World!")

	for pathItem in cmdlineargs.lstpathFiles:
		print(pathItem)

	pass

	sys.exit(iExitValue)

# EOF
