from __future__ import print_function       #should be on the top
import threading
import urllib2
import sys
import time

threads=[]

with open('clean_alexa_5000_log') as f:
    lines = f.readlines()

log = open("log.txt","w")
log.truncate()

errors = open("errors.txt","w")
errors.truncate()
value=0

max_threads =200
thread_num=0
togo=0


def get_page(page,num):
	try:
		response = urllib2.urlopen("http://" + page,timeout=5)
		html = response.read()
		print (num + " :OK " + page)
	except Exception as e:
		s = repr(e)
		op = page + " " + s  + "\n"
		print(op)
		errors.write(op)

for url in lines:
	value +=1
	if thread_num < max_threads:
		t = threading.Thread(target=get_page, args=(url.replace('\r', '').replace('\n', ''),str(value),))
        	threads.append([t,url,str(value)])
	        t.start()
		togo +=1
		thread_num += 1
	else:
		print ( "waiting")
		for t in threads:
			t[0].join()
			log.write(t[2] + ": " + t[1] )
			togo -= 1
			print(" left " + str(togo) + '\r' )
		togo = 0
		print ( "reset")
		thread_num=0
		threads=[]

if ( togo > 0 ):
	print ( "waiting")
        for t in threads:
            t[0].join()
            log.write(t[2] + ": " + t[1] )
            togo -= 1
            print(" left " + str(togo) + '\r' )

print("done ")




		
	
