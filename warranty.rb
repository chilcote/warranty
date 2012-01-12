#!/usr/bin/env ruby
#
# File: 	warranty.rb
# Decription: 	Contact's Apple's selfserve servers to capture warranty information
#              	about your product. Accepts arguments of machine serial numbers.
# Edit:		This is a fork @glarizza's script:
# 		https://github.com/huronschools/scripts/blob/master/ruby/warranty.rb

require 'rubygems'
require 'open-uri'
require 'openssl'
require 'json'
require 'date'

def get_warranty(serial)
  warranty_data = {}
  raw_data = open('https://selfsolve.apple.com/warrantyChecker.do?sn=' + serial.upcase + '&country=USA')
  warranty_data = JSON.parse(raw_data.string[5..-2])
    
  puts "\nSerial Number:\t\t#{warranty_data['SERIAL_ID']}\n"
  puts "Product Description:\t#{warranty_data['PROD_DESCR']}\n"
  puts "Warranty Type:\t\t#{warranty_data['HW_COVERAGE_DESC']}\n"
  puts "Purchase date:\t\t#{warranty_data['PURCHASE_DATE'].gsub("-",".")}"
  
  unless warranty_data['COV_END_DATE'].empty?
    puts "Coverage end:\t\t#{warranty_data['COV_END_DATE'].gsub("-",".")}\n"
  else
    puts "Coverage end:\t\tEXPIRED\n"
  end
  
# Import the latest list of ASD versions and match the PROD_DESCR with the correct ASD
  asd_hash = {}
  open('https://github.com/chilcote/warranty/raw/master/asdcheck').each do |line|
    asd_arrary = line.split(":")
    asd_hash[asd_arrary[0]] = asd_arrary[1]
  end
  puts "ASD Version:\t\t#{asd_hash[warranty_data['PROD_DESCR']]}\n"
end

if ARGV.size > 0 then
  serial = ARGV.each do |serial|
    get_warranty(serial.upcase)
  end
else
  puts "Without your input, we'll use this machine's serial number."
  serial = %x(system_profiler SPHardwareDataType |grep -v tray |awk '/Serial/ {print $4}').upcase.chomp
  get_warranty(serial)
end

