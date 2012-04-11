#!/usr/bin/python
import time, MySQLdb 
from serial import *

def receiving(ser):
	print "entoy en el metodo"
	buffer = ''
	bol = False
	while True:
		print "inicia while"
		buffer = buffer + ser.read(ser.inWaiting())
		if '%' in buffer:
			# llamar a un metodo que procese el string del micro y una vez procesado que llame a save2DB
			#print "buffer bol: '%s'" %buffer
			linea = str(buffer)
			curtmp = linea[44:46]
			tmin = linea[4:6]
			tmax = linea[13:15]
			curhum = linea[53:55]
			#print "curtmp = %s\ntmin = %s\ntmax = %s\ncurhum = %s" %(curtmp,tmin,tmax,curhum)
			#sys.exit(0) # quitar cuando se este corriendo indefinidamente, sustituir por un sleep
			save2DB(curtmp, tmin, tmax, curhum)
			buffer = ''
		#print "Duerme por 10 segs"
		time.sleep(10)

def save2DB( curtmp, mintmp, maxtmp, curhum ):
	# server, user, pass, db
	db = MySQLdb.connect("localhost","micros","micros","micros" )
	# prepare a cursor object using cursor() method
	cursor = db.cursor()
	# Prepare SQL query to INSERT a record into the database.
	sql = "INSERT INTO GreenHouse( curtmp, mintmp, maxtmp, curhum, curdate, curtime ) VALUES ( %s, %s, %s, %s, CURDATE(), CURTIME() )" %(curtmp, mintmp, maxtmp, curhum)
	print "sql = ", sql
	try:
		# Execute the SQL command
		cursor.execute(sql)
		#print "query excecuted"
		# Commit your changes in the database
		db.commit()
		#print "committed. WIN!"
	except:
		# Rollback in case there is any error
		print "exception, do rollback"
		print "exception, ", sys.exc_info()
		db.rollback()
	# disconnect from server
	db.close()

if __name__ ==  '__main__':    
	ser = Serial( port='/dev/ttyUSB0', baudrate=9600, bytesize=EIGHTBITS, 
			parity=PARITY_NONE, stopbits=STOPBITS_ONE, timeout=0.1, xonxoff=0, rtscts=0, interCharTimeout=None )
	print ser.portstr
	receiving(ser)

