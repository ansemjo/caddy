#!/usr/bin/env python3

# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

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

# print header
print("Content-Type: text/plain\n")

# print sample file
print(f"// {timestamp}\nHello, {name}!")
