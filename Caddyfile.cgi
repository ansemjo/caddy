{
  order cgi last
}

http://localhost:8080 {
  
  root * /srv/www
  cgi /*.py /usr/local/bin/python3 /srv/www{path}

}


