TITLE Elementary Arithmetic     (Project1_Bittsr.asm)

; Author: Randy Bitts
; Last Modified: 01/20/2023
; OSU email address: bittsr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1                Due Date: 01/22/2023
; Description: Program to perform simple arithmetic functions
;              as well as get input from the user

INCLUDE Irvine32.inc

.data
program_title BYTE "      Logic and Arithmetic Operations - the Basics   by Randy Bitts  ", 0		; Program title for display
intro_line BYTE "Hello!  My name is Randy, and I will be your mathemetician today!", 0	; intro line
;below lines are user instructions for use of the program
instruction_line1 BYTE "You have the easy part today - I will ask you for three numbers - in Descending order",0
instruction_line2 BYTE "In other words, as an example: First number - 5, Second number - 3, Third Number - 1",0
instruction_line3 BYTE "Feel free to enter any positive numbers you'd like - just make sure you count backwards!",0
;below lines are for requesting and storing the numbers the user will input
request_1 BYTE "Please enter your first number: ", 0
request_2 BYTE "Please enter your second number: ", 0
request_3 BYTE "Please enter your third and final number: ", 0

userFirstNumber DWORD ?			; uninitialized value for the users first number
userSecondNumber DWORD ?		; uninitialized value for the users second number
userThirdNumber DWORD ?			; uninitialized value for the users third number
additionString BYTE " + ",0		; string to hold the addition sign
subtractionString BYTE " - ",0	; string to hold the subtraction sign
equalString BYTE " = ",0		; string to hold the equal sign

; below lines are unititalized values to store the result of each operation
calculatedResult1 DWORD ?	
calculatedResult2 DWORD ?		
calculatedResult3 DWORD ?		
calculatedResult4 DWORD ?		
calculatedResult5 DWORD ?		
calculatedResult6 DWORD ?		
calculatedResult7 DWORD ?		

goodbyeString BYTE "Thanks for using Logic and Arithmetic Operations!  Have a great day!", 0		; String to say goodbye

; Extra Credit values
ecString1 BYTE "**EC: Program verifies numbers are descending order",0
ecString2 BYTE "**EC: Program displays Division, Quotients and Remainders",0
ecString3 BYTE "**EC: Program loops until user quits by selecting 'N'",0
; entryError is the displayed text if the user enters a number larger than their previous
entryError BYTE "Your current entry is bigger than the previous entry.  Thanks for playing",0
; the ecCalculatedReults store the division Quotient and Remainders 
ecCalculatedResult1	DWORD ?
ecCalculatedResult2	DWORD ?
ecCalculatedResult3	DWORD ?
ecCalculatedResult4	DWORD ?
ecCalculatedResult5	DWORD ?
ecCalculatedResult6	DWORD ?
; These two strings are filler text for formatting the division results
ecDivideString BYTE " / ",0
ecQuotientString BYTE " with a remainder of ",0
; first string prompts the user for a response on playing again, ecUserResponse is to store the comparison value
ecShallWePlayAgain BYTE "Would you like to play again? (Y/N): ",0
ecUserResponse BYTE "N"

.code
main PROC
; introduction
	mov EDX, OFFSET program_title
	Call WriteString
	Call CrLf
	Call CrLf
	mov EDX, OFFSET intro_line
	Call WriteString
	Call CrLf
	mov EDX, OFFSET ecString1
	Call WriteString
	Call CrLf
	mov EDX, OFFSET ecString2
	Call WriteString
	Call CrLf
	mov EDX, OFFSET ecString3
	Call WriteString
	Call CrLf
	Call CrLf
	mov EDX, OFFSET instruction_line1
	Call WriteString
	Call CrLf
	mov EDX, OFFSET instruction_line2
	Call WriteString
	Call CrLf
	mov EDX, OFFSET instruction_line3
	Call WriteString
	Call CrLf

; get the data
get_user_input:  ; destinatlon label for conditional check at the end to play again
	Call CrLf
	mov EDX, OFFSET request_1
	Call WriteString
	Call ReadDec
	mov userFirstNumber, EAX
	mov EDX, OFFSET request_2
	Call WriteString
	Call ReadDec
	mov userSecondNumber, EAX
	
	; compare the numbers, jump to the definition to end the program if greater than
	mov EAX, userFirstNumber
	mov EBX, userSecondNumber
	cmp EAX, EBX
	jb too_big
	
	mov EDX, OFFSET request_3
	Call WriteString
	Call ReadDec
	mov userThirdNumber, EAX
	Call CrLf

	; compare the numbers, jump to the definition to end the program if greater than
	mov EAX, userSecondNumber
	mov EBX, userThirdNumber
	cmp EAX, EBX
	jb too_big
	

; calculate the required values and store them in their variables
	mov EAX, userFirstNumber
	mov EBX, userSecondNumber
	add EAX, EBX
	mov calculatedResult1, EAX
	mov EAX, userFirstNumber
	mov EBX, userSecondNumber
	sub EAX, EBX
	mov calculatedResult2, EAX
	mov EDX, 0
	mov EAX, userFirstNumber
	mov EBX, userSecondNumber
	div EBX
	mov ecCalculatedResult1, EAX
	mov ecCalculatedResult2, EDX
	mov EAX, userFirstNumber
	mov EBX, userThirdNumber
	add EAX, EBX
	mov calculatedResult3, EAX
	mov EAX, userFirstNumber
	mov EBX, userThirdNumber
	sub EAX, EBX
	mov calculatedResult4, EAX
	mov EDX, 0
	mov EAX, userFirstNumber
	mov EBX, userThirdNumber
	div EBX
	mov ecCalculatedResult3, EAX
	mov ecCalculatedResult4, EDX
	mov EAX, userSecondNumber
	mov EBX, userThirdNumber
	add EAX, EBX
	mov calculatedResult5, EAX
	mov EAX, userSecondNumber
	mov EBX, userThirdNumber
	sub EAX, EBX
	mov calculatedResult6, EAX
		mov EDX, 0
	mov EAX, userSecondNumber
	mov EBX, userThirdNumber
	div EBX
	mov ecCalculatedResult5, EAX
	mov ecCalculatedResult6, EDX
	; now add all 3 together
	mov EAX, userSecondNumber
	add EAX, EBX
	mov EBX, userFirstNumber
	add EAX, EBX
	mov calculatedResult7, EAX

; display the results
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX,OFFSET additionString
	call WriteString
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult1
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX,OFFSET subtractionString
	call WriteString
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult2
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX, OFFSET ecDivideString
	call WriteString
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, ecCalculatedResult1
	call WriteDec
	mov EDX, OFFSET ecQuotientString
	call WriteString
	mov EAX, ecCalculatedResult2
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX,OFFSET additionString
	call WriteString
	mov EAX, userThirdNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult3
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX,OFFSET subtractionString
	call WriteString
	mov EAX, userThirdNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult4
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX, OFFSET ecDivideString
	call WriteString
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, ecCalculatedResult3
	call WriteDec
	mov EDX, OFFSET ecQuotientString
	call WriteString
	mov EAX, ecCalculatedResult4
	call WriteDec
	call CrLf
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX,OFFSET additionString
	call WriteString
	mov EAX, userThirdNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult5
	call WriteDec
	call CrLf
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX,OFFSET subtractionString
	call WriteString
	mov EAX, userThirdNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult6
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX, OFFSET ecDivideString
	call WriteString
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, ecCalculatedResult5
	call WriteDec
	mov EDX, OFFSET ecQuotientString
	call WriteString
	mov EAX, ecCalculatedResult6
	call WriteDec
	call CrLf
	mov EAX, userFirstNumber
	call WriteDec
	mov EDX, OFFSET additionString
	call WriteString
	mov EAX, userSecondNumber
	call WriteDec
	mov EDX, OFFSET additionString
	call WriteString
	mov EAX, userThirdNumber
	call WriteDec
	mov EDX, OFFSET equalString
	call WriteString
	mov EAX, calculatedResult7
	call WriteDec
	Call CrLf
	Call CrLf

	; Ask the user if they'd like to run through the program again
	mov EDX, OFFSET ecShallWePlayAgain
	Call WriteString
	call ReadChar
	mov ecUserResponse, AL
	cmp ecUserResponse, "Y"
	je get_user_input

; say goodbye
	Call CrLf
	mov EDX, OFFSET goodbyeString
	Call WriteString
	Call CrLf


	Invoke ExitProcess,0	; exit to operating system

main ENDP

; if the second entered value is greater than the first, end execution  (or third greater than second)
too_big:
	mov EDX, OFFSET entryError
	Call WriteString
	Invoke ExitProcess,0

END main
