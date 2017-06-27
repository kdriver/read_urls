from __future__ import print_function       #should be on the top
import threading
import urllib2
import sys
import time

threads=[]

with open('clean_alexa') as f:
    lines = f.readlines()

value=0

max_threads =50
thread_num=0


def get_page(page,num):
	try:
		response = urllib2.urlopen("http://" + page,timeout=5)
		html = response.read()
		print (num + " :OK " + page)
	except Exception as e:
		print(type(e))
		print (num + " :Oh no " +  page )

for url in lines:
	value +=1
	if thread_num < max_threads:
		t = threading.Thread(target=get_page, args=(url.replace('\r', '').replace('\n', ''),str(value),))
        	threads.append(t)
	        t.start()
		thread_num += 1
	else:
		print ( "waiting")
		for t in threads:
			t.join()
		print ( "reset")
		thread_num=0
		threads=[]

print("done ")




		
	
