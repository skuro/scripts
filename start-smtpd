#!/usr/bin/python

import smtpd
import asyncore
import sys

class CustomSMTPServer(smtpd.SMTPServer):
    
    def process_message(self, peer, mailfrom, rcpttos, data):
        print 'Receiving message from:', peer
        print 'Message addressed from:', mailfrom
        print 'Message addressed to  :', rcpttos
        print 'Message length        :', len(data)
        print 'Message               :', unicode(data)
        return

print "Starting the echo SMTP server"

port = 1025
if len(sys.argv) > 1:
    try:
        port = int(sys.argv[1])
    except ValueError:
        print sys.argv[1] +" is not a valid port number, defaulting to 1025"
        port = 1025

server = CustomSMTPServer(('127.0.0.1', port), None)

asyncore.loop()
