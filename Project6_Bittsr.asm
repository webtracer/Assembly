TITLE Macros & String Primitives     (Proj6_Bittsr.asm)

; Author: Randy Bitts
; Last Modified: 03/19/2023
; OSU email address: bittsr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  6		Due Date: 3/18/2023
; Description: Takes signed/unsigned integers, converts them to string, sums their values, produces and average, 
; and performs other magics within the bowels of the computer

INCLUDE Irvine32.inc

; Macro Definitions
;--------------------------------------------------------------------------
; name: mGetString
; Reads string input
; Precondition: 	none
; Postconditions: 	userInput byte array and lenUserInput will be modified
; Receives: buffer, userInput, userInputCount, lenUserInput
; Returns:	userInput, lenUserInput
;--------------------------------------------------------------------------
mGetString MACRO buffer, userInput, userInputCount, lenUserInput
; Save the register states
	PUSH EDX
	PUSH ECX
	PUSH EAX

	MOV		EDX, buffer
	CALL	WriteString
	MOV		EDX, userInput
	MOV		ECX, userInputCount
	CALL	ReadString
	MOV		len_user_input, EAX

; return the register states
	POP	EAX
	POP	ECX
	POP	EDX
ENDM

;--------------------------------------------------------------------------
; name: mDisplayString
; Displays string passed to macro 
; Precondition: 	none
; Postconditions: 	none
; Receives: 		display_string
; Returns:  		none
;--------------------------------------------------------------------------
mDisplayString MACRO display_string
; Save the register states
	PUSH	EDX

	MOV		EDX, display_string
	CALL	WriteString

; return the register states
	POP	EDX
ENDM

; CONSTANT Declarations

LO					= -2147483648
HI					= 2147483647
ASCII_LOW			= 48
ASCII_HIGH			= 57
ASCII_POSITIVE		= 43
ASCII_NEGATIVE		= 45
ASCII_SPACE			= 32
MAX_INPUT_SIZE		= 11
MAX_NUM_LENGTH		= 10
NULL_PLACE_HOLDER	= 0

.data
; Variable Declarations
intro1					BYTE	"String Primitives and Macros - Playing with Numbers",13,10,0
intro2					BYTE	"Attempted to be lovingly coded by Randy Bitts",13,10,0
instructions_1			BYTE	"Please enter 10 signed numbers that can fit in a 32 bit register.",13,10,0
instructions_2			BYTE	"The maximum length should be 11 digits (including the sign) or 10 without.",13,10,0
instructions_3			BYTE	"I will then display the numbers, their sum, and the average.",13,10,0
prompt					BYTE	"Please enter a signed integer: ",0
numbers_user_entered	BYTE	"The numbers you entered are: ",0
display_sum				BYTE	"The sum is:      ",0
display_avg				BYTE	"The average is:  ",0
so_long_farewell		BYTE	"Thanks for stopping by!  I hope I met your expectations!",0
user_input				BYTE	MAX_INPUT_SIZE DUP(?)
len_user_input			DWORD	?
user_number				SDWORD	?
user_number_array		SDWORD	10 DUP(?)
invalid_entry_error		BYTE	"The number you entered is invalid. Try again.",0
make_negative			DWORD	0
number_output_string	BYTE	1 DUP(?)
average_output_string	BYTE	1 DUP(?)
sum						SDWORD	0
average					SDWORD	0

.code
main PROC

	; Call mDisplayString and print the intro
	mDisplayString	OFFSET intro1
	mDisplayString	OFFSET intro2
	CALL	CrLf

	; Call mDisplayString and print the rules
	mDisplayString  OFFSET instructions_1
	mDisplayString  OFFSET instructions_2
	mDisplayString  OFFSET instructions_3
	CALL	CrLf
	
	; Get the user input, then display the users numbers
	PUSH	OFFSET user_number_array
	PUSH	OFFSET make_negative
	PUSH	OFFSET invalid_entry_error
	PUSH	OFFSET prompt
	PUSH	OFFSET user_input
	PUSH	OFFSET len_user_input
	CALL	ReadVal
	CALL	CrLf

	mDisplayString OFFSET numbers_user_entered
	CALL	CrLf

	PUSH	OFFSET number_output_string
	PUSH	OFFSET user_number_array
	CALL	DisplayNumbers
	CALL	CrLf
	CALL	CrLf

	; Calculate and print the sum of the numbers
	PUSH	OFFSET sum
	PUSH	OFFSET user_number_array
	CALL	CalculateSum

	mDisplayString  OFFSET display_sum

	PUSH	OFFSET	number_output_string
	PUSH	sum
	CALL	WriteVal
	CALL	CrLf

	; Calculate and print the average
	PUSH	OFFSET average
	PUSH	sum
	CALL	CalculateAverage

	mDisplayString  OFFSET display_avg

	PUSH	OFFSET	number_output_string
	PUSH	average
	CALL	WriteVal
	CALL	CrLf
	CALL	CrLf

	; Bid the user farewell
	mDisplayString OFFSET so_long_farewell
	CALL	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

;--------------------------------------------------------------------------
; name: ReadVal
; Reads integer input as string converting storing each number input into an array
; Precondition: none
; Postconditions: user_number_array will be filled with 10 numbers, make_negative & len_user_input will be changed
; Receives: len_user_input, user_input, prompt, invalid_entry_error, make_negative, user_number_array 
; Returns: 	user_number_array 
;--------------------------------------------------------------------------
ReadVal PROC
; Save the register states
	PUSH EBP
	MOV	 EBP, ESP
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDI
	PUSH ESI

	MOV		ECX, MAX_NUM_LENGTH
	MOV		EDI, [EBP + 28]	

_prompt:
	PUSH		ECX
	mGetString	[EBP + 16], [EBP + 12], MAX_INPUT_SIZE, [EBP + 8]

	PUSH	EAX
	MOV		EAX, [EBP + 8]			; set ECX as the count of user_input
	MOV		ECX, [EAX]
	POP		EAX

	MOV		ESI, [EBP + 12]			; reset user_input mem location
		
	MOV		EBX, 0
	MOV		[EBP + 24], EBX		; reset negation variable


_checkSign:
	LODSB
	CMP		AL, 45				; negative sign
	JE		_set_negative
	CMP		AL, 43				; positive sign
	JE		_positive_number
	JMP		_validate_entry

_set_negative:
	PUSH	EBX
	MOV		EBX, 1
	MOV		[EBP + 24], EBX		; modify make_negative to 1
	POP		EBX
	DEC		ECX
	JMP		_next

_positive_number:
	DEC		ECX

_next:
	CLD
	LODSB
	JMP		_validate_entry

_validate_entry:
	CMP		AL, 48				; ascii 0
	JB		_invalid
	CMP		AL, 57				; ascii 9
	JA		_invalid
	JMP		_combiner

_invalid:
	mDisplayString	[EBP + 20]
	CALL	CrLf
	POP		ECX				; restore ECX to outer LOOP count
	MOV		EBX, 0
	MOV		[EDI], EBX		; reset accumulated value in destination register
	JMP		_prompt
		
_combiner:
	MOV		EBX, [EDI]			; save prev value

	PUSH	EAX					
	PUSH	EBX
	MOV		EAX, EBX			
	MOV		EBX, 10				; multiply EBX by 10
	MUL		EBX					
	MOV		[EDI], EAX
	POP		EBX
	POP		EAX

	SUB		AL, ASCII_LOW
	ADD		[EDI], AL

	DEC		ECX
	CMP		ECX, 0
	JA		_next

	PUSH	EAX
	MOV		EAX, [EBP + 24]			; if make_negative is 1, send to _make_negative
	CMP		EAX, 1
	JE		_make_negative
	JMP		_keep_going

_make_negative:
	MOV		EAX, [EDI]
	NEG		EAX
	MOV		[EDI], EAX

_keep_going:
	POP		EAX
	ADD		EDI, 4
	POP		ECX
	DEC		ECX
	CMP		ECX, 0
	JNZ		_prompt

; return the register states	
	POP	ESI
	POP	EDI
	POP	ECX
	POP	EBX
	POP	EAX
	POP	EBX

	RET	28
ReadVal ENDP

;--------------------------------------------------------------------------
; name: WriteVal
; Performs the ASCII conversion and displays the string
; Precondition: none
; Postconditions: number_output_string will be modified in memory
; Receives: user_number_array, number_output_string
; Returns: 	none
;--------------------------------------------------------------------------
WriteVal PROC
; Save the register states
	PUSH EBP
	MOV	 EBP, ESP
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDI
	PUSH EDX

	MOV		EDI, [EBP + 12]		; memory location of number_output_string
	MOV		EAX, [EBP + 8]		; value to write to number_output_string

_checkSign:
	CMP		EAX, 0
	JL		_make_negative
	JMP		_push_null
	CLD

_make_negative:
	PUSH	EAX
	MOV		AL, 45
	STOSB	
	mDisplayString	[EBP + 12]

	DEC		EDI					; Back to the start
		
	POP		EAX
	NEG		EAX					; turn number positive

_push_null:
	PUSH	0

_convert_ascii:

	MOV		EDX, 0
	MOV		EBX, 10
	DIV		EBX
		
	MOV		ECX, EDX
	ADD		ECX, 48
	PUSH		ECX
	CMP		EAX, 0
	JE		_pop_for_printing
	JMP		_convert_ascii

_pop_for_printing:
	POP		EAX

	STOSB
	mDisplayString	[EBP + 12]
	DEC		EDI				; Move back to display again

	CMP		EAX, 0
	JE		_wrap_up_ascii
	JMP		_pop_for_printing

_wrap_up_ascii:
	MOV		AL, ASCII_SPACE
	STOSB
	mDisplayString	[EBP + 12]
	DEC		EDI				; Move back to reset for next use 

; return the register states	
	POP	EDX
	POP	EDI
	POP	ECX
	POP	EBX
	POP	EAX
	POP	EBP

	RET	8
WriteVal ENDP

;--------------------------------------------------------------------------
; name: DisplayNumbers
; Loops over array of numbers and uses WriteVal to display the number
; Precondition: array must be filled
; Postconditions: none 
; Receives: array, number_output_string, MAX_NUM_LENGTH
; Returns: 	none
;--------------------------------------------------------------------------
DisplayNumbers PROC
; Save the register states
	PUSH EBP
	MOV	 EBP, ESP
	PUSH ESI
	PUSH EDI
	PUSH ECX

	MOV		ESI, [EBP + 8]			; input array
	MOV		EDI, [EBP + 12]			; number_output_string
	MOV		ECX, MAX_NUM_LENGTH

_printNumber:
	PUSH	EDI
	PUSH	[ESI]
	CALL	WriteVal
	ADD		ESI, 4
	LOOP	_printNumber

; return the register states
	POP	ECX
	POP	EDI
	POP	ESI
	POP	EBP
	
	RET	12
DisplayNumbers ENDP

;--------------------------------------------------------------------------
; name: CalculateSum
; Loops over array to calculate the sum
; Precondition:	array must be filled
; Postconditions: value of sum will be changed
; Receives: array, sum, MAX_NUM_LENGTH
; Returns: 	sum
;--------------------------------------------------------------------------
CalculateSum PROC
; Save the register states
	PUSH EBP
	MOV	 EBP, ESP
	PUSH ESI
	PUSH EAX
	PUSH EBX
	PUSH ECX

	MOV		ESI, [EBP + 8]			; input array
	MOV		ECX, MAX_NUM_LENGTH

	MOV		EAX, 0

_sumNumbers:
	ADD		EAX, [ESI]
	ADD		ESI, 4
	LOOP	_sumNumbers

	MOV		EBX, [ebp + 12]
	MOV		[EBX], EAX

; return the register states
	POP	ECX
	POP	EBX
	POP	EAX
	POP	ESI
	POP	EBP
	
	RET	8
CalculateSum ENDP

;--------------------------------------------------------------------------
; name: CalculateAverage
; Performs signed integer division and stores the result in average
; Precondition:  sum must have a value
; Postconditions: average will be updated
; Receives: sum, average
; Returns: 	average
;--------------------------------------------------------------------------
CalculateAverage PROC
; Save the register states
	PUSH EBP
	MOV	 EBP, ESP
	PUSH ECX
	PUSH EAX
	PUSH EBX

	MOV		ECX, MAX_NUM_LENGTH
	MOV		EAX, [EBP + 8]					
	MOV		EBX, MAX_NUM_LENGTH
	MOV		EDX, 0
	CDQ
	IDIV	EBX

	MOV		EBX, [ebp + 12]					
	MOV		[EBX], EAX

; return the register states
	POP	EBX
	POP	EAX
	POP	ECX
	POP	EBP

	RET	12
CalculateAverage ENDP

END main