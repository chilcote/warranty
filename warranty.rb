#!/usr/bin/env ruby
#
# File: 	warranty.rb
# Decription: 	Contact's Apple's selfserve servers to capture warranty information
#              	about your product. Accepts arguments of machine serial numbers.
# Edit:		This is a fork @glarizza's script:
# 		https://github.com/huronschools/scripts/blob/master/ruby/warranty.rb

require 'open-uri'

def get_warranty(serial)
  hash = {}
  open('https://selfsolve.apple.com/warrantyChecker.do?sn=' + serial.upcase + '&country=USA') {|item|
    item.each_line {|item|}
    warranty_array = item.strip.split('"')
    warranty_array.each {|array_item|
      hash[array_item] = warranty_array[warranty_array.index(array_item) + 2] if array_item =~ /[A-Z][A-Z\d]+/
    }
    
    puts "\nSerial Number:\t\t#{hash['SERIAL_ID']}\n"
    puts "Product Decription:\t#{hash['PROD_DESCR']}\n"
    puts "Purchase date:\t\t#{hash['PURCHASE_DATE'].gsub("-",".")}"
    puts (!hash['COV_END_DATE'].empty?) ? "Coverage end:\t\t#{hash['COV_END_DATE'].gsub("-",".")}\n" : "Coverage end:\t\tEXPIRED\n"
  }
  
# Import the latest list of ASD versions and match the PROD_DESCR with the correct ASD
  asd_hash = {}
  open('https://github.com/chilcote/warranty/raw/master/asdcheck').each do |line|
    asd_arrary = line.split(":")
    asd_hash[asd_arrary[0]] = asd_arrary[1]
  end
  puts "ASD Version:\t\t#{asd_hash[hash['PROD_DESCR']]}\n"
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

