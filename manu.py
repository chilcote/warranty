#!/usr/bin/python3

import datetime
import plistlib
import subprocess
import sys

manu_weeks = {
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
    "C": 10,
    "D": 11,
    "F": 12,
    "G": 13,
    "H": 14,
    "J": 15,
    "K": 16,
    "M": 17,
    "N": 18,
    "L": 19,
    "P": 20,
    "Q": 21,
    "R": 22,
    "T": 23,
    "V": 24,
    "W": 25,
    "X": 26,
    "Y": 27,
}

manu_years = {
    "C": ["2020", 0],
    "D": ["2020", 26],
    "F": ["2021", 0],
    "G": ["2021", 26],
    "H": ["2022", 0],
    "J": ["2022", 26],
    "K": ["2013", 0],
    "L": ["2013", 26],
    "M": ["2014", 0],
    "N": ["2014", 26],
    "P": ["2015", 0],
    "Q": ["2015", 26],
    "R": ["2016", 0],
    "S": ["2016", 26],
    "T": ["2017", 0],
    "V": ["2017", 26],
    "W": ["2018", 0],
    "X": ["2018", 26],
    "Y": ["2019", 0],
    "Z": ["2019", 26],
}

if len(sys.argv) == 2:
    serial = sys.argv[1]
else:
    output = subprocess.check_output(
        ["/usr/sbin/ioreg", "-c", "IOPlatformExpertDevice", "-d", "2", "-a"]
    )
    serial = plistlib.loads(output)["IORegistryEntryChildren"][0][
        "IOPlatformSerialNumber"
    ]

manu_year = manu_years[serial[3]][0]
manu_week = manu_weeks[serial[4]] + manu_years[serial[3]][1]
year_time = datetime.date(year=int(manu_year), month=1, day=1)
week_diff = datetime.timedelta(weeks=manu_week)
manu_date = year_time + week_diff

print(serial)
print(manu_date)
