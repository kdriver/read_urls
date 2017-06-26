require 'net/http'
require "uri"
require 'open-uri'

$counter = 1
$ips = File.new("mt_ip_addresses","w")
$good = File.new("mt_alexa__responded","w")
$file = File.new("clean_alexa", "r")

$thread=0
$max_threads=5
$threads=[]
$hosts=[]
$list_urls=[]

def get_url( text  )
   begin
	    puts " GET " + text + " " + "%d"%text.object_id 
            text.chomp!
	    ip = IPSocket.getaddress(text)
            http = Net::HTTP.new(text,80)
            http.read_timeout = 5
            http.open_timeout = 5
            resp = http.start() { |http| http.get("index.html") }
            Thread.current[:output] = [true,text,ip]
    rescue SignalException => e
             raise e
    rescue Exception => e
              puts "url is dead " , text , e.message
              Thread.current[:output] = [false,"dead",nil]
    end
end

def reset_threads
   $thread = 0
   while($thread < $max_threads )
        $threads[$thread] = nil
	$thread = $thread + 1
   end
   $thread = 0
end

def copy_string(inp)

out = nil
out= String.new("")
	inp.each_char { |c|
		out = out + c
	}
		
       out
end
def read_list
reset_threads()

begin
		while (line = $file.gets)
		    if ( $thread < $max_threads )
                                lc = copy_string(line)
			        puts " thread " + "%d"%$thread + " of " + "%d"%$max_threads + " " + line
			        $threads[$thread] = Thread.new{ get_url(lc)}
			$thread = $thread + 1
		    else
			    $thread=99
			    puts "waiting " 
			    sleep(3)
			    while ( $thread < $max_threads )
					$threads[$thread].join
					    counter = counter + 1
					ok = $threads[$thread][:output][0]
					line1 = $threads[$thread][:output][1]
					ip = $threads[$thread][:output][2]
					if ( ok )
						$ips.write(line1 + " , " + ip + "\n")
						puts "#{counter}: #{line1}"
						$good.write(line1+"\n")
					end
					$thread = $thread + 1
			    end
			    reset_threads()
		#	    content = Net::HTTP.get_response(URI.parse(url)).body
		    end
		end
rescue SignalException => e
   raise e
end
end

read_list()
file.close
