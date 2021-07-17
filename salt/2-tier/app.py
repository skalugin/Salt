#!/usr/bin/python
import os, sys, cgi
import requests

print "Content-type:text/html\n\n";
print "<head><title>Company Phone Directory</title></head>\n"
print "<body>\n"
print "<h1>Directory Lookup</h1>\n"
remote = os.getenv("REMOTE_ADDR")
form = cgi.FieldStorage()
querystring = form.getvalue("querystring")
print "Accessed via:",remote,"\n<p>"
if querystring != None:
  url = 'http://{{ grains['databaseServer'] }}/cgi-bin/database.py?querystring=' + querystring
else:
  url = 'http://{{ grains['databaseServer'] }}/cgi-bin/database.py'
querystring = ""
r = requests.get(url)
print '<form action="/cgi-bin/app.py">'
print ' Name Filter (blank for all records):'
print ' <input type="text" name="querystring" value="'+querystring+'">'
print ' <input type="submit" value="Apply">'
print '</form>'
print "\n<table border=1 bordercolor=black cellpadding=5 cellspacing=0>"
print "\n<th>Phone Number</th><th>First Name</th><th>Surname</th><th>Department</th>"

#deal with the data coming across the wire
a = r.text.split("|\n#")
for row in a:
  if len(row) != 1:
    print "<tr>"
    splitrow = row.split("|")
    for item in splitrow:
      if item != None:
        print "<td>",item,"</td>"
    print "</tr>\n"
print "</body></html>\n"