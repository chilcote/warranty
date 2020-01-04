warranty
========

Apple warranty estimation script.

This script estimates whether a given serial number is under warranty.
Input can be one or more given serial numbers, or a text file listing serials.
Output can be standard out or a CSV file.

All of the good ideas herein came from [glarizza][1], except for the rest of the good ideas which came from [pudquick][2]. Every terrible idea is my own.

Usage
-----

	usage: warranty [-h] [-v] [--quit-on-error] [-i INPUT] [-o OUTPUT] ...

	positional arguments:
	  serials

	optional arguments:
	  -h, --help            show this help message and exit
	  -v, --verbose         print output to console while writing to file
	  --quit-on-error       if an error is encountered
	  -i INPUT, --input INPUT
	                        import serials from a file
	  -o OUTPUT, --output OUTPUT
	                        save output to a csv file

License
-------

	Copyright © 2014-2020 Joseph Chilcote

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

[1]: https://github.com/glarizza/scripts/blob/master/ruby/warranty.rb "glarizza"
[2]: https://github.com/pudquick/pyMacWarranty/blob/master/getwarranty.py "pudquick"
