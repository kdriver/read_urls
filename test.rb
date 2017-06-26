require 'net/http'
require "uri"
require 'open-uri'

counter = 1
ips = File.new("ip_addresses","w")
good = File.new("com_responded","w")

file = File.new("clean_alexa", "r")
while (line = file.gets)
    counter = counter + 1
    begin
	    line.chop!
	    url = URI.encode(line)
	    url1 = URI.parse(url)
            http = Net::HTTP.new(url,80)
            http.read_timeout = 5
            http.open_timeout = 5
	    resp = http.start() { |http| http.get(url1.path) }
#	    content = Net::HTTP.get_response(URI.parse(url)).body
            ip = IPSocket.getaddress(line.gsub("http://",""))
	    ips.write(line + " , " + ip + "\n")
            puts "#{counter}: #{line}"
	    good.write(line+"\n")
    rescue SignalException => e
	   raise e
    rescue Exception => e
          puts "url is dead " , line , e.message
    end
end
file.close
