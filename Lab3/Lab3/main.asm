
.org 0x100 ; create 7SEG CODE TABLE at address 0x100 (word address, which will be byte address of 200)
.DB     0b01000000,0b01111001,0b0100100,0b00110000,0b00011001,0b00010010,0b00000010,0b01111000,0b00000000,0b00011000,0b00000001,0b00000010,0b00000100,0b00001000,0b00010000,0b00100000
//            0   ,   1      ,   2     ,     3    ,    4     ,    5     ,    6     ,    7     ,    8     ,     9    , A digit 1, B digit 2, C digit 3, D digit 4, E digit 5, F digit 6
// test change in the atmel studio :)
// 0b0GFEDCBA
//	   G   F  E  D  C   B    A
//   (15)(11)(5)(3)(13)(16)(14) THIS FOR THE LED
//   https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_instruction_list.html


; Replace with your application code
start:
    LDI R16, 0xFF ; load 1's into R16
	OUT DDRB, R16 ; output 1's to configure DDRB as "output" port
	OUT DDRC, R16 ; output 1's to configure DDRC as "output" port
	ldi r23,0x08 ;seconds one's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r24,0x05 ;seconds ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r25,0x08 ;minutes one's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r26,0x05 ;minutes ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r27,0x03 ;hours ones's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r28,0x02 ;hours ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)

tog:
	LDI R22, 8;
	
	LOP_1:LDI R21, 10;
		LOP_2:LDI R20, 10;
			LOP_3:
				
				ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
				ldi zl,00 ; load low byte of z register with low hex portion of table address
				add zl,r23 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
				lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer

				call TurnOnFirstDigit
		   		out PORTB, r19
				
				call LoopDelay

				ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
				ldi zl,00 ; load low byte of z register with low hex portion of table address
				add zl,r24 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
				lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer

				call TurnOnSecondDigit
				out PORTB, r19
				
				call LoopDelay
				
				ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
				ldi zl,00 ; load low byte of z register with low hex portion of table address
				add zl,r25 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
				lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer

				call TurnOnThirdDigit
				out PORTB, r19
				call LoopDelay

				ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
				ldi zl,00 ; load low byte of z register with low hex portion of table address
				add zl,r26 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
				lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer

				call TurnOnFourthDigit
				out PORTB, r19
				call LoopDelay

				
				ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
				ldi zl,00 ; load low byte of z register with low hex portion of table address
				add zl,r27 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
				lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer

				call TurnOnFifthDigit
				out PORTB, r19
				call LoopDelay
				
				ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
				ldi zl,00 ; load low byte of z register with low hex portion of table address
				add zl,r28 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
				lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer

				call TurnOnSixthDigit
				out PORTB, r19
				call LoopDelay

				DEC R20;
			BRNE LOP_3;
			DEC R21;
		BRNE LOP_2;
		DEC R22;
	BRNE LOP_1;

	ldi r30,0x09; load 9 in so we can compare it
	cp r23,r30; compare
	brsh resetSeconds1sPlace; branch if same or higher,  https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_instruction_list.html
	

	
	inc r23; increase seconds one's place, this should be happening at 1Hz
	JMP tog; go to tog

TurnOnFirstDigit:
	; first digit code
	ldi r29, 0x0A ; set to 10 so we can load 10's item in the database
	ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
	ldi zl,00 ; load low byte of z register with low hex portion of table address
	add zl,r29 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r18,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	out PORTC, r18 // put on line adjacent to out portb
	ret
	
TurnOnSecondDigit:
	; first digit code
	ldi r29, 0x0B ; set to 10 so we can load 10's item in the database
	ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
	ldi zl,00 ; load low byte of z register with low hex portion of table address
	add zl,r29 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r18,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	out PORTC, r18 // put on line adjacent to out portb
	ret
	
TurnOnThirdDigit:
	; first digit code
	ldi r29, 0x0C ; set to 10 so we can load 10's item in the database
	ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
	ldi zl,00 ; load low byte of z register with low hex portion of table address
	add zl,r29 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r18,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	out PORTC, r18 // put on line adjacent to out portb
	ret
TurnOnFourthDigit:
	; first digit code
	ldi r29, 0x0D ; set to 10 so we can load 10's item in the database
	ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
	ldi zl,00 ; load low byte of z register with low hex portion of table address
	add zl,r29 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r18,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	out PORTC, r18 // put on line adjacent to out portb
	ret
TurnOnFifthDigit:
	; first digit code
	ldi r29, 0x0E ; set to 10 so we can load 10's item in the database
	ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
	ldi zl,00 ; load low byte of z register with low hex portion of table address
	add zl,r29 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r18,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	out PORTC, r18 // put on line adjacent to out portb
	ret
	
TurnOnSixthDigit:
	; first digit code
	ldi r29, 0x0F ; set to 10 so we can load 10's item in the database
	ldi zh,02        ; load high byte of z register with high hex portion of 7SEG CODE TABLE address (x2, since it is byte addressing)
	ldi zl,00 ; load low byte of z register with low hex portion of table address
	add zl,r29 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r18,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	out PORTC, r18 // put on line adjacent to out portb
	ret

LoopDelay:
	ldi r31,60;
	LOOP1:
		dec r31;
	BRNE LOOP1;
	ret

resetSeconds1sPlace:
	ldi r23,0x00;
	inc r24;

	ldi r30,0x06; load 6 in so we can compare it
	cp r24,r30; compare
	brsh resetSecondsTensPlace; branch if same or higher, 
	jmp tog;

	
resetSecondsTensPlace:
	ldi r23,0x00;
	ldi r24,0x00;
	inc r25;

	
	ldi r30,0x09; load 9 in so we can compare it
	cp r25,r30; compare
	brsh resetMinutes1sPlace; branch if same or higher, 
	jmp tog;

	
resetMinutes1sPlace:
	ldi r23,0x00;
	ldi r24,0x00;
	ldi r25,0x00;
	inc r26;
	
	ldi r30,0x06; load 9 in so we can compare it
	cp r26,r30; compare
	brsh resetMinutesTensPlace; branch if same or higher, 

	jmp tog;

	
resetMinutesTensPlace:
	ldi r23,0x00;
	ldi r24,0x00;
	ldi r25,0x00;
	ldi r26,0x00;
	inc r27;

	ldi r30,0x09; load 9 in so we can compare it
	cp r27,r30; compare
	brsh resetHoursOnesPlace; branch if same or higher, 

	ldi r30,0x04
	cp r27,r30;
	brsh CheckIfNeedToReset; branch if same or higher, 

	jmp tog;

	
resetHoursOnesPlace:
	ldi r23,0x00;
	ldi r24,0x00;
	ldi r25,0x00;
	ldi r26,0x00;
	ldi r27,0x00;
	inc r28;

	
	ldi r30,0x02; load 9 in so we can compare it
	cp r28,r30; compare
	brsh resetHoursTensPlace; branch if same or higher, 

	jmp tog;

	
resetHoursTensPlace:
	ldi r23,0x00;
	ldi r24,0x00;
	ldi r25,0x00; // minutes ones
	ldi r26,0x00; // minutes tens
	ldi r27,0x00

	jmp tog;

CheckIfNeedToReset: 

	ldi r30,0x02; load 9 in so we can compare it
	cp r28,r30; compare
	brsh ResetToZero; branch if same or higher, 

	
	jmp resetHoursOnesPlace;

ResetToZero:
	ldi r23,0x00 ;seconds one's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r24,0x00 ;seconds ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r25,0x00 ;minutes one's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r26,0x00 ;minutes ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r27,0x00 ;hours ones's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r28,0x00 ;hours ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	jmp tog;
