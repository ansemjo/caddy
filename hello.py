#!/usr/bin/env python3

# use cgi debugging
import cgitb
cgitb.enable()

# initialize cgi and url parameter parser
import cgi
url = cgi.FieldStorage()

# generate formatted timestamp
import datetime
timestamp = datetime.datetime.now().strftime('%A, %d. %B %Y, %H:%M:%S')

# greeting name
name = url.getfirst("name", "World")

# print header and body
print("Content-Type: text/plain\n")
print(f"// {timestamp}\nHello, {name}!")

exit(0)
