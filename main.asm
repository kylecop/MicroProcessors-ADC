.org 0x200 ; create 7SEG CODE TABLE at address 0x100 (word address, which will be byte address of 200)
data:.DB     0b01000000,0b01111001,0b0100100,0b00110000,0b00011001,0b00010010,0b00000010,0b01111000,0b00000000,0b00011000,0b00000001,0b00000010,0b00000100,0b00001000,0b00010000,0b00100000
//            0   ,   1      ,   2     ,     3    ,    4     ,    5     ,    6     ,    7     ,    8     ,     9    , A digit 1, B digit 2, C digit 3, D digit 4, E digit 5, F digit 6
// test change in the atmel studio :)
// 0b0GFEDCBA
//	   G   F  E  D  C   B    A
//   (15)(11)(5)(3)(13)(16)(14) THIS FOR THE LED
//   https://www.microchip.com/webdoc/avrassembler/avrassembler.wb_instruction_list.html
	.org 0x00
	jmp start

; Replace with your application code
start:
    LDI R16, 0xFF ; load 1's into R16
	OUT DDRB, R16 ; output 1's to configure DDRB as "output" port
	OUT DDRC, R16 ; output 1's to configure DDRC as "output" port

	ldi r23,0x01 ;seconds one's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r24,0x02 ;seconds ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r25,0x03 ;minutes one's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r26,0x04 ;minutes ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r27,0x05 ;hours ones's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r28,0x06 ;hours ten's place, load r16 with BCD(hex) value of the digit to be converted (digit 7 is used as an example)
	ldi r31,0x0a	; Preload binary 00001010 into r31
	ldi r17,0x00


tog:

	LDI R22, 1;
	
	LOP_1:LDI R21, 1;
		LOP_2:LDI R20, 1;
			LOP_3:
				call DisplayAll

				DEC R20;
			BRNE LOP_3;
			DEC R21;
		BRNE LOP_2;
		DEC R22;
	BRNE LOP_1;

	JMP tog; go to tog


LoadZRegister:
	ldi ZL, low(2*data)
	ldi ZH, high(2*data)
	add zl,r19 ; add the BCD  value to be converted to low byte of 7SEG CODE TABLE to create an offset numerically equivalent to BCD value 
	lpm r19,z ; load z into r17 from program memory from7SEG CODE TABLE using modified z register as pointer
	ret
	
TurnOnDigit:
	; first digit code
	ldi ZL, low(2*data)
	ldi ZH, high(2*data)
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

DisplayAll:
	mov r19,r23
	call LoadZRegister
	
	ldi r29, 0x0A ; set to 10 so we can load 10's item in the database
	call TurnOnDigit
	out PORTB, r19
				
	call LoopDelay

	mov r19,r24
	call LoadZRegister

	inc r29
	call TurnOnDigit
	out PORTB, r19
				
	call LoopDelay
			
	mov r19,r25
	call LoadZRegister	
	
	inc r29
	call TurnOnDigit
	out PORTB, r19
	call LoopDelay
	
	mov r19,r26
	call LoadZRegister
	
	inc r29
	call TurnOnDigit
	out PORTB, r19
	call LoopDelay

				
	mov r19,r27
	call LoadZRegister
	
	inc r29
	call TurnOnDigit
	out PORTB, r19
	call LoopDelay
				
				
	mov r19,r28
	call LoadZRegister
	
	inc r29
	call TurnOnDigit
	out PORTB, r19
	call LoopDelay
	ret
