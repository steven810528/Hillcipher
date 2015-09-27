#!/usr/bin/sage

import sys
from sage.all import *
import fileinput

#
# Function for reading the key matrix
# Modify this function so that it supports NxN matrices
#
n=256
def ReadHillCipherKey(keyFileName):
	row_num = 0; K = None
	keyFile = open(keyFileName, "r")

	if (keyFile is None):
		return None
	
	for line in keyFile:
		# Parse each line into a list of numbers
		line = line.strip()
		row = line.split("\t")	# The result of this line is a list of arrays
		row = [int (num_str) for num_str in row] # Convert to list of integers
			
		if (len(row) != 2):
			raise ValueError, "M must be a 2x2 matrix"

		if (row_num == 0):
			K = matrix(ZZ, 2, 2)

		K.set_row(row_num, row)
		row_num = row_num + 1

		if (row_num >= 2):	# ignore extra lines and exit the loop
			break

	# Validate the key matrix
	if (not K in MatrixSpace(IntegerModRing(n), 2)):
		raise ValueError, "M must be a 2x2 matrix over the integers mod 256."
	if (K.det() == 0):
		raise ValueError, "M must be an invertible matrix."
	
	keyFile.close()
	return K

# Check the arguments
if (len(sys.argv) != 3) or (sys.argv[1] not in ["d", "e"]):
	print "Usage: %s e/d key_file"%sys.argv[0]
	print "Encrypt/decrypt a text file using Hill Cipher"
	sys.exit	

K = ReadHillCipherKey(sys.argv[2])

if (K is None):
	sys.exit

# The following code packs data files into a 2x2 matrix and 
# performs encryption/decryption
count = 0; plist=list([])

K_de = K ** -1
#a= 97,z =122

for line in sys.stdin:	
	for ch in line:
		plist.append(ord(ch))

		# Todo 2: Modify the following so that this supports NxN matrices
		count = (count + 1) % 2
		if (count == 0):
			D = matrix(ZZ,1,2,plist) # This is plaintext matrix

			# Todo: Modify the following so that when sys.argv[1]=='e'
			# you encrypt the input data. When sys.argv[1]=='d', decrypt
			# the input data
			if(sys.argv[1]=='e'):				
				C=D*K%n				
			else :				

				K_de=K_de%n
				C=D*K_de%n
			outLine = ""
			for i in range(2):				
				outLine = outLine + str(chr(C[0,i]))
			sys.stdout.write(outLine) # print will be buffered, use sys.stdout instead to make redirection work
			plist = list([])
print # output a newline to make the screen look nice
sys.exit

