#!/usr/bin/env python3

# The MIT License (MIT)
#
# Copyright (c) 2014-2024 Fraunhofer FKIE, Alexander Tiderko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##################################################################################


import argparse
import sys

from fkie_iop_json_generator.json_generator import JsonGenerator

'''
'''
if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='file_manager')
  parser.add_argument('-i', "--input_path", help='Path to folder with JSIDL-files. If empty search for fkie_iop_builder ROS package.')
  parser.add_argument('-o', "--output_path", help="path and name of the resulting JSON definitions, Default: '{cwd}/schemes'")
  parser.add_argument('-t', "--typescript_path", help="generates additional typescript files if this path is set, Default: ''")
  parser.add_argument('-e', '--exclude', nargs='+', help='List with folder names to exclude from parsing')
  parser.add_argument('-v', '--verbose', dest='verbose', action='store_true', help='Show debug output')
  parser.set_defaults(verbose=False)
  args = parser.parse_args()
  input_path = args.input_path
  output_path = args.output_path
  exclude = []
  if isinstance(args.exclude, list):
    exclude = args.exclude
  try:
    path = JsonGenerator(input_path, output_path, args.typescript_path, exclude, args.verbose)
  except KeyboardInterrupt:
    sys.exit()
