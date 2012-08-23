#!/usr/bin/env ruby
#
# File:        warranty.rb¬
# Decription:  Contacts Apple's selfserve servers to capture warranty information¬
#              about your product. Accepts arguments of machine serial numbers.¬
# Edit:        This is a fork @glarizza's script:¬
#              https://github.com/glarriza/scripts/blob/master/ruby/warranty.rb¬
require 'uri'
require 'open-uri'
require 'net/http'
require 'net/https'
require 'date'

def get_prod_descr(serial)
  # Get product description from http://support-sp.apple.com/sp/product
  begin
    snippet = serial[-3,3]
    snippet = serial[-4,4] if serial.length == 12
    open('http://support-sp.apple.com/sp/product?cc=' + snippet + '&lang=en_US').each do |line|
      @prod_descr = line.split('Code>')[1].split('</config')[0]
    end
    get_warranty(serial)
  rescue
    puts "ERROR:\tPlease check serial number and try again."
  end
end

def get_warranty(serial)
  # Setup HTTP connection
  uri              = URI.parse('https://selfsolve.apple.com/wcResults.do')
  http             = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl     = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request          = Net::HTTP::Post.new(uri.request_uri)

  # Prepare POST data
  request.set_form_data(
    {
      'sn'       => serial,
      'Continue' => 'Continue',
      'cn'       => '',
      'locale'   => '',
      'caller'   => '',
      'num'      => '0'
    }
  )

  # POST data and get the response
  response      = http.request(request)
  response_data = response.body

  warranty_status = response_data.split('warrantyPage.warrantycheck.displayHWSupportInfo').last.split('Repairs and Service Coverage: ')[1] =~ /^Active/ ? true : false
  expiration_date = response_data.split('Estimated Expiration Date: ')[1].split('<')[0] if warranty_status
  
  # Import ASD versions and match correct version with prod_descr
  asd_hash = {}
  open('https://github.com/chilcote/warranty/raw/master/asdcheck').each do |line|
    asd_arrary = line.split(":")
    asd_hash[asd_arrary[0]] = asd_arrary[1]
  end
  
  #puts "\n#{response_data}\t"
  puts "\nProduct Description:\t#{@prod_descr}"
  puts "Serial Number:\t\t#{serial}"
  puts "Expires:\t\t" + (warranty_status ? "#{Date.parse expiration_date}" : 'Expired')
  puts "ASD Version:\t\t#{asd_hash[@prod_descr]}\n"

  #TODO: 
  #  Calculate Purchase Date
  #  Trap for Limited warranty or Applecare
end

if ARGV.size > 0 then
  serial = ARGV.each do |serial|
    get_prod_descr(serial.upcase)
  end
else
  puts "Without your input, we'll use this machine's serial number."
  serial = %x(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}').upcase.chomp
  get_prod_descr(serial)
end
