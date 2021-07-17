#! /usr/bin/python
import cgi
import sqlite3

conn=sqlite3.connect('/var/www/db/directory.db')
curs=conn.cursor()
print "Content-type:text/plain\n\n";
form = cgi.FieldStorage()
querystring = form.getvalue("querystring")
if querystring != None:
  queryval = "%" + querystring + "%"
  select = "SELECT * FROM directory WHERE name LIKE '" + queryval + "'"
else:
  select = "SELECT * FROM directory"
  for row in curs.execute(select):
    if len(row) == 4:
      for item in row:
        print item,'|'
      print "#"
conn.close()