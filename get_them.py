import urllib2


with open('com') as f:
    lines = f.readlines()

value=0

for url in lines:
	try:
		response = urllib2.urlopen(url)
		html = response.read()
		print ("OK " + url)
	except:
		print ("Oh no " +  url )
	value= value + 1
		
	
