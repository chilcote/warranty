warranty
========

Mac manufactured date estimation script.

This script returns the serial, model identifier, and estimated manufacture date.
Input can be one or more given serial numbers, or a text file listing serials.

This script would not be possible without great work provided by the community:
- https://github.com/pudquick/pyMacdevice_info/blob/master/getdevice_info.py
- http://www.macrumors.com/2010/04/16/apple-tweaks-serial-number-format-with-new-macbook-pro/
- https://blog.kolide.com/determining-mac-hardware-manufacture-date-using-osquery-54091a9cccbb

Usage
-----

```
usage: warranty [-h] [-i INPUT] ...

positional arguments:
  serials

optional arguments:
  -h, --help            show this help message and exit
  -i INPUT, --input INPUT
                        import serials from a file
```

License
-------

	Copyright © 2014-2021 Joseph Chilcote

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
