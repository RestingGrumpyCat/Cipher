 #!/bin/bash

#Student Name: Shiyu Wang

#This script encrypt and depcrypt lines using a key, which is a string of 26 different letters in non-alphabetical order.

if [ $# -gt 4 ] || [ $# -lt 3 ]; then #error checkin for 1)wrong number of arguments; 2)wrong mode input; 3)file to encrypt doesn't exist.
	echo "Error: Need 3 or 4 arguments"
elif [ "$1" != '-e' ] && [ "$1" != '-d' ]; then
	echo "Error: First argument must be -e or -d"
else
	if [ -n "$4" ]; then #if target file is given but not exist, outputs error
		if [ ! -f "$4" ]; then 
			echo "Error: Target file does not exist"
			exit 2
		fi	
	fi	

	cat /dev/null > "$3"
	if [ "$1" == "-e" ]; then	#when encrypt mode, if target file not given, then use user input as the text to encrypt
        	if [ -z "$4" ]; then
                	while read input; do

	                        echo $input | tr a-z A-Z >> "$3" #translate all the text into capitals before encrypt and save the output into the output file given
				echo "input is $input"
			done	
                else
                        cat "$4" | tr a-z A-Z > "$3" #translate file text into capitals and save it to the output file 
                              
                fi


		key=$2 #read key 


		counter=0



		text=`cat $3` #backup the text to encrypt
		len=${#text}
		len=$((len-1))
		
		cat /dev/null > "$3" #clean the output file as the loop will append the encrypted letter to the file one by one
		for var in `seq 0 $len`; do #loop over the text to encrypt
			char=`echo "${text:$var:1}"` # get each letter in in encrypt text
			
			counter=0 #index counter 
			
			for letter in {A..Z}; do #loop over the alphabetas to find a match
					
				counter=$((counter+1))				
				if [ "$char" == "$letter" ]; then #once a match is found, replace the letter with the letter in the key that is at the index of the counter number 
					keyLetter=`expr substr $key $counter 1`
					echo "$char" | tr "$char" "$keyLetter" >> "$3" #replace the letter and append the letter to the output file
				elif [ "$char" == " " ]; then #read space in the original text and translate it to *, later can be found and then translate to space again
					echo "$char" | tr "$char" "*" >> "$3"
					
 				fi
			done
		done			
		
		
		line=`cat $3` #replace all the line break with space and delete sapce and replace * with space, finally redirect the text to outout file
				
		echo "$line" | tr "\n" " " | tr -d " " | tr -s "*" " " > "$3"
	
		echo "" >> "$3"
 			
	elif [ "$1" == "-d" ]; then #when decrypt mode
		key=$2 

		text=`cat $4`
		len=${#text}
		len=$((len-1))
		line="ABCDEFGHIJKLMNOPQRSTUVWXYZ" #prepare a string of letters in alphabetical order
		for var in `seq 0 $len`; do #loop over the text to decrypt
			char=`echo "${text:$var:1}"` #get each letter in the text
			counter1=0 
		
			for letter in `seq 0 25`; do #loop over the key
				counter1=$((counter1+1))
				keyLetter=`echo "${key:$letter:1}"` #get each letter in the key
				alphabeta=`echo "${line:$letter:1}"` #get each letter in the string of letters in alphabetical order 
				if [ "$char" == "$keyLetter" ]; then #once the letter in the text to decrypt matches the letter in the key, replace the letter with the letter in alphabeta

					echo "$char" | tr "$char" "$alphabeta" >> "$3"				
						
				elif [ "$char" == " " ]; then
					echo "$char" | tr "$char" "*" >> "$3"
				fi
			done
		done
		
		line=`cat $3`
		echo "$line" | tr "\n" " " | tr -d " " | tr -s "*" " " > "$3"
		echo "" >> "$3"
	
			

	fi
fi 


