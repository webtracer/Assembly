TITLE Number Counter     (Project3_bittsr.asm)

; Author: Randy Bitts
; Last Modified: 02/09/2023
; OSU email address: bittsr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  3               Due Date:  02/12/2023
; Description: This program will count and sum negative integers within specified bounds
;              then display various statistics on the input values1.

INCLUDE Irvine32.inc

; constant variables for user input limits [-200,-100] and/or [-50,-1]
LOWEST_LIMIT = -200	; -200 is the lowest integer the user is allowed to enter
LOWEST_MAX = -100	; -100 is the upper end of the lowest range user is allowed to enter
LOW_LIMIT = -50		; -50 is the next lowest limit for user input that is allowed
LOW_MAX = -1		; -1 is the highest integer value the user is allowed to enter

.data

; program introduction and information variables
program_title			BYTE "Welcome to the Negative Number Counter - by Randy Bitts",13,10,0
program_description_1	BYTE "I will be counting and accumulating statistics on negative number",13,10,0
program_description_2	BYTE "Statistics will include minimum, maximum, average value, total",13,10,0
program_description_3	BYTE "I will also collect statistics on how often you enter correct input",13,10,0

; variables to greet user and get their name
user_greeting_1     BYTE "Welcome!  May I get your name please?  ",0
user_name		    DWORD 33 DUP(0)
user_greeting_2     BYTE "Hi there, ",0

; variables for display of program rules and requirements
program_rules_1     BYTE "Please enter integer values within the range of [-200,-100] or [-50,-1]",13,10,0
program_rules_2     BYTE "When you are done and would like to see your stats, enter any positive number",13,10,0

; variables for user integer input collection
user_input_prompt       BYTE "Enter a number: ",0
user_input          SDWORD ?

; variables for data storage
minimum_value                   SDWORD  0
maximum_value                   SDWORD  0
integer_count                   DWORD   0
average_of_integers             SDWORD  0
sum_of_integers                 SDWORD  0

; variables for entry error
out_of_bounds_error     BYTE "Oops, that number is out of bounds, please keep entries between [-200,-100] or [-50,-1].  Thanks!",13,10,0
no_valid_input_1        BYTE "Well, ",0
no_valid_input_2        BYTE " you did not want to use me the way I was coded, thanks anyway!",13,10,0

; variables for finishing up the program
ending_1                BYTE "Here are your statistics:",13,10,0
ending_2_part_1         BYTE "You entered ",0
ending_2_part_2         BYTE " valid numbers.",13,10,0
ending_3                BYTE "Your minimm value was: ",0
ending_4                BYTE "Your maximum value was: ",0
ending_5                BYTE "The sum of all your valid numbers is ",0
ending_6                BYTE "The rounded average of your valid numbers is ",0
say_goodnight_gracie    BYTE "I have enjoyed calculating for you!  Bye!",13,10,0

.code
main PROC

; Display program title and description
	MOV EDX, OFFSET program_title
	CALL WriteString
	Call CRLF

	MOV EDX, OFFSET program_description_1
	CALL WriteString
	MOV EDX, OFFSET program_description_2
	CALL WriteString
	MOV EDX, OFFSET program_description_3
	CALL WriteString
	Call CRLF

; Say hello, get users name, and greet the user
	MOV EDX, OFFSET user_greeting_1
	Call WriteString
	MOV EDX, OFFSET user_name
	MOV ECX, 32
	Call ReadString
	Call CRLF

	MOV EDX, OFFSET user_greeting_2
	Call WriteString
	MOV EDX, OFFSET user_name
	Call WriteString
	Call CRLF

; Explain the Rules to the User
    MOV EDX, OFFSET program_rules_1
    Call WriteString
    MOV EDX, OFFSET program_rules_2
    Call WriteString

; Prompt the user for input
_getUserInput:
    MOV EDX, OFFSET user_input_prompt
    Call WriteString
    Call ReadInt
    MOV user_input, EAX
    Call CRLF

; Validate user input
    MOV EAX, 0
    CMP EAX, user_input

	; If the input is non-zero positive, lets finish up
    JL _timeToFinishUp

    ; Check to see if users input is less than 200
    MOV EAX, user_input
    MOV EBX, LOWEST_LIMIT
    CMP EAX, EBX
    JL _invalidNumberEntered        ; Less than 200, lets try that again

    ; Check to see if users input is greater than 100
    MOV EBX, LOWEST_MAX
    CMP EAX, EBX
    JLE _incrementCounter           ; if user input is GT -200 or EQ -100, lets go    
    
    ; Check if users input is less than 50
    MOV EBX, LOW_LIMIT
    CMP EAX, EBX
    JL _invalidNumberEntered        ; users input is between -99 and -51, lets try again

    ; Check if user entered 0, we already know it isn't non-zero positive
    MOV EBX, LOW_MAX
    CMP EAX, EBX
    JG _timeToFinishUp        ; users input was 0, lets finish up

    ; We have valid input, time to start things
    JMP _incrementCounter

_incrementCounter:                  ; Increments the counter tracking valid integers input
	MOV EAX, integer_count
	INC EAX
    MOV integer_count, EAX

; alter the other variables per requirement
    ; First, lets check the minimum value entered
	MOV EAX, user_input
    CMP EAX, minimum_value
    JL _updateMinimumValue          ; We have a new minimum value, lets update it

_nextValueCheckMaximum:             ; Now Check the Maximum Value
    MOV EAX, integer_count
    ; First, lets see if it's first valid integer, if it is, just update the max value
    .if EAX <= 1
        MOV EAX, user_input
        MOV maximum_value, EAX
        MOV EAX, maximum_value

    .else                           ; More than one number has been entered, lets see if an update is needed    
	        MOV EAX,user_input
	        CMP maximum_value, EAX
            JL _updateMaximumValue  ; We have a new Maximum value, lets update
    .endif

_nextValueUpdateSum:                ; Now update the running total then go back for more input
    JMP _updateRunningSum


_updateMinimumValue:                ; Update the minimum user input entered
    MOV EAX, user_input
    MOV minimum_value, EAX
    MOV EAX, minimum_value

	JMP _nextValueCheckMaximum      ; Lets check the Maximum

_updateMaximumValue:                ; Update the maximum user entered value
    MOV EAX, user_input
    MOV maximum_value, EAX
    MOV EAX, maximum_value

    JMP _updateRunningSum

_updateRunningSum:                  ; Keeps a running sum of valid integer input
    MOV EAX, user_input
    MOV EBX, sum_of_integers
    ADD EAX, EBX
    
    MOV sum_of_integers, EAX
    MOV EAX, sum_of_integers

    JMP _getUserInput

_invalidNumberEntered:              ; User entered a value outside of the set bounds, but not positive
    MOV EDX, OFFSET out_of_bounds_error
    Call WriteString

    JMP _getUserInput


; Display Statistics and thank the user
_timeToFinishUp:
	; Check the integer count, if 0 lets go to the secondary exit
	MOV EAX, integer_count
    CMP EAX, 0
    JE _noUserInput         ; No valid integers entered, lets exit

    ; Calculate the rounded average of all valid numbers entered
    MOV EAX, sum_of_integers
    INC EAX
    MOV EBX, integer_count
    CDQ
    IDIV EBX
    MOV average_of_integers, EAX

    MOV EDX, OFFSET ending_1
    Call WriteString
	MOV EDX, OFFSET ending_2_part_1
    Call WriteString
    MOV EAX, integer_count
    Call WriteDec
    MOV EDX, OFFSET ending_2_part_2
    Call WriteString

    MOV EDX, OFFSET ending_3
    Call WriteString
    MOV EAX, minimum_value
    Call WriteInt
    Call CRLF

    MOV EDX, OFFSET ending_4
    Call WriteString
    MOV EAX, maximum_value
    Call WriteInt
    Call CRLF

    MOV EDX, OFFSET ending_5
    Call WriteString
    MOV EAX, sum_of_integers
    Call WriteInt
    Call CRLF

    MOV EDX, OFFSET ending_6
    Call WriteString
    MOV EAX, average_of_integers
    Call WriteInt
    Call CRLF

    MOV EDX, OFFSET say_goodnight_gracie
    Call WriteString
    Call CRLF

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; This only runs if user doesn't participate
_noUserInput:
    MOV EDX, OFFSET no_valid_input_1
    Call WriteString
    MOV EDX, OFFSET user_name
    Call WriteString
    MOV EDX, OFFSET no_valid_input_2
    Call WriteString
    Call CRLF

    Invoke ExitProcess, 0 ; exit to operating system

END main