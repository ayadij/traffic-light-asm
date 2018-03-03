; AYA DIJKWEL CS 224
;	this code is written by me.
;
;*******************************************************************************
;   Lab 5b - traffic.asm
;
;   Description:  1. Turn the large green LED and small red LED on and
;                    delay 20 seconds while checking for orange LED.
;                    (If orange LED is on and 10 seconds has expired, immediately
;                    skip to next step.)
;                 2. Turn large green LED off and yellow LED on for 5 seconds.
;                 3. Turn yellow LED off and large red LED on.
;                 4. If orange LED is on, turn small red LED off and small green
;                    LED on.  After 5 seconds, toggle small green LED on and off
;                    for 6 seconds at 1 second intervals.  Finish by toggling
;                    small green LED on and off for 4 seconds at 1/5 second
;                    intervals.
;                    Else, turn large red LED on for 5 seconds.
;                 5. Repeat the stoplight cycle.
;
;   I certify this to be my source code and not obtained from any student, past
;   or current.
;
;*******************************************************************************
;                            MSP430F2274
;                  .-----------------------------.
;            SW1-->|P1.0^                    P2.0|<->LCD_DB0
;            SW2-->|P1.1^                    P2.1|<->LCD_DB1
;            SW3-->|P1.2^                    P2.2|<->LCD_DB2
;            SW4-->|P1.3^                    P2.3|<->LCD_DB3
;       ADXL_INT-->|P1.4                     P2.4|<->LCD_DB4
;        AUX INT-->|P1.5                     P2.5|<->LCD_DB5
;        SERVO_1<--|P1.6 (TA1)               P2.6|<->LCD_DB6
;        SERVO_2<--|P1.7 (TA2)               P2.7|<->LCD_DB7
;                  |                             |
;         LCD_A0<--|P3.0                     P4.0|-->LED_1 (Green)
;        i2c_SDA<->|P3.1 (UCB0SDA)     (TB1) P4.1|-->LED_2 (Orange) / SERVO_3
;        i2c_SCL<--|P3.2 (UCB0SCL)     (TB2) P4.2|-->LED_3 (Yellow) / SERVO_4
;         LCD_RW<--|P3.3                     P4.3|-->LED_4 (Red)
;   TX/LED_5 (G)<--|P3.4 (UCA0TXD)     (TB1) P4.4|-->LCD_BL
;             RX-->|P3.5 (UCA0RXD)     (TB2) P4.5|-->SPEAKER
;           RPOT-->|P3.6 (A6)          (A15) P4.6|-->LED 6 (R)
;           LPOT-->|P3.7 (A7)                P4.7|-->LCD_E
;                  '-----------------------------'
;
;*******************************************************************************
;**************************************STEPS TO FOLLOW IN CODE*****************************************
;~Initialize car lights  (P4.0 - P4.3)	(bis.b	0x0f, &P4DIR)
;examples of port outputs
;	0000 0001 = 0x01 = green_car
;	0000 0100 = 0x04 = yellow_car
;	0010 0001 = 0x21 = red_pedestrian, green_car

;~Initialize pedestrial lights	(P4.6 & P3.4)
;~Initialize switches

;~turn OFF all car lights

;turn ON the green_car
;turn ON the red_pedestrian
;delay for 20 seconds

;turn OFF green_car
;turn ON yellow_car
;delay for 5 seconds

;if a button has NOT been pressed...
;turn OFF the yellow_car
;turn ON the red_car
;delay for 5 seconds

;if a buton HAS been pressed...
;turn OFF yellow_car
;turn ON orange_light
;turn ON red_car

;turn ON green_pedestrian
;Delay 5 seconds

;Second toggle
;toggle green_pedestrian
;delay 1 second
;decrement 6 counter
;jump back to second toggle (6 times)

;fifth_toggle

;jump back to the main loop






*******************************************************************************
		.cdecls C,LIST,"msp430.h" ; MSP430

		;car lights

		.asg "bis.b #0x08,&P4OUT",REDCAR_ON
		.asg "bic.b #0x08,&P4OUT",REDCAR_OFF

		.asg "bis.b #0x04,&P4OUT",YELLOWCAR_ON
		.asg "bic.b #0x04,&P4OUT",YELLOWCAR_OFF

		.asg "bis.b #0x02,&P4OUT",ORANGE_ON
		.asg "bic.b #0x02,&P4OUT",ORANGE_OFF
		.asg "bit.b #0x02,&P4OUT",ORANGE_TEST

		.asg "bis.b #0x01,&P4OUT",GREENCAR_ON
		.asg "bic.b #0x01,&P4OUT",GREENCAR_OFF

		;ped lights

		.asg "bis.b #0x40,&P4OUT",REDPED_ON
		.asg "bic.b #0x40,&P4OUT",REDPED_OFF

		.asg "bis.b #0x10,&P3OUT",GREENPED_ON
		.asg "bic.b #0x10,&P3OUT",GREENPED_OFF
		.asg "xor.b #0x10,&P3OUT",GREENPED_TOGGLE

		;clear interrupt flags

		.asg "bic.b	#0x0f,&P1IFG",CLEAR_INTERRUPTS

		;turn off all LEDs

		.asg "bic.b #0x4f,&P4OUT",LEDS_OFF



;Variables----------------------------------------------------------------------

COUNT		.equ	36000 					;10th of a second
TWENTY		.equ	200
FIVE		.equ	50
SIX			.equ	60
FOUR		.equ	40
HALF		.equ	25
TENTH		.equ  	5


;-------------------------------------------------------------------------------
            .text                           ; beginning of executable code
            .retain                         ; Override ELF conditional linking
;-------------------------------------------------------------------------------

start:      mov.w   #__STACK_END,SP         ; init stack pointer
            mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; stop WDT
            bis.b   #0x08,&P4DIR            ; set P4.3 as output
            bis.w   #GIE,SR                 ; enable general interrupts

			ORANGE_OFF

;Outputs ----------------------------------------------------------------------
            bis.b   #0x4f,&P4DIR            ; set P4.0-3,6 as output
            bis.b   #0x10,&P3DIR            ; set P3.4 as output

;Inputs -----------------------------------------------------------------------
            bic.b   #0x0f,&P1DIR            ; set P1.0-3 as inputs
            bis.b   #0x0f,&P1OUT            ; use pull-up
            bis.b   #0x0f,&P1REN            ; pull-up P1.0-3
            bic.b   #0x01,&P1SEL          	; select GPIO
            bis.b   #0x0f,&P1IES          	; trigger on high to low transition
            bis.b   #0x0f,&P1IE           	; P1.0-3 interrupt enabled
        	bic.b   #0x0f,&P1IFG          	; P1.0-3 IFG cleared


;*****************************************************************************************************
main:		LEDS_OFF						;
			GREENPED_OFF					;
			GREENCAR_ON						;turn ON the green_car
			REDPED_ON						;turn ON the red_pedestrian
			call			#delay20		;delay for 20 seconds


			GREENCAR_OFF					;turn OFF green_car
			YELLOWCAR_ON					;turn ON yellow_car
											;red ped stays on
			call			#delay5			;delay for 5 seconds


			ORANGE_TEST						;check if orange is on
			jnz				pedcycle		;jumps to ped cycle if not zero ie is 1 ie is pressed


			YELLOWCAR_OFF					;turn OFF the yellow_car
			REDCAR_ON						;turn ON the red_car
											;red ped stays on
			call 			#delay5			;delay for 5 seconds

			jmp				main


pedcycle:
			YELLOWCAR_OFF					;turn OFF yellow_car
			REDCAR_ON						;turn ON red_car
			REDPED_OFF						;turn OFF red ped
			GREENPED_ON						;turn ON greed ped
											;orange stays on
			call			#delay6    		;delay for 6 seconds
											;red car and green ped stays on

			call 			#slowflash		;
			call			#fastflash		;

			jmp 			main			;jump back to the main loop



;generic delay loop-------------------------------------------------------------
delay:      push 	r15
			mov.w   #COUNT,R15      		;load R15 with value for delay
decrement:  dec.w   R15                     ;decrement R15
            jnz     decrement               ;if R15 is not zero jump to decrement
            pop 	r15
            ret


;delay for 20 seconds----------------------------------------------------------
delay20:	push	r14
			mov.w	#0,r14      			;load r14 with value for delay
delay_20:	cmp.w	#TWENTY,r14				;compare value in r14 to #TWENTY
			jge		done20					;jumps out of the loop if equal
			call	#delay					;delay loop
			add.w 	#1,r14					;add 1 to the value in r14
			jmp		delay_20				;go through the loop again
done20:		pop		r14
			ret


;delay for 5 seconds----------------------------------------------------------
delay5:		push 	r14
			mov.w	#0,r14      			;load r14 with value for delay
delay_5:	cmp.w	#FIVE,r14				;compare value in r14 to #FIVE
			jge		done5					;jumps out of the loop if equal
			call	#delay					;delay loop
			add.w 	#1,r14					;add 1 to the value in r14
			jmp 	delay_5					;go through the loop again
done5:		pop		r14
			ret


;delay for 6 seconds----------------------------------------------------------
delay6:		push 	r14
			mov.w	#0,r14      			;load r14 with value for delay
delay_6:	cmp.w	#SIX,r14				;compare value in r14 to #FIVE
			jge		done6					;jumps out of the loop if equal
			call	#delay					;delay loop
			add.w 	#1,r14					;add 1 to the value in r14
			jmp 	delay_6					;go through the loop again
done6:		pop		r14
			ret


;slowflash --------------------------------------------------------------------
slowflash:	push r14
			mov.w	#0,r14      			;load r14 with value for delay
slow_flash:	GREENPED_TOGGLE					;begin green ped toggle
			cmp.w	#TENTH,r14				;compare value in r14 to #FIVE
			jge		doneslow				;jumps out of the loop if equal
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			call	#delay					;delay loop
			add.w 	#1,r14					;add 1 to the value in r14
			jmp 	slow_flash				;go through the loop again
doneslow:	pop 	r14
			ret


;fastflash --------------------------------------------------------------------
fastflash:	push	r14
			mov.w	#0,r14      			;load r14 with value for delay
fast_flash:	GREENPED_TOGGLE					;begin green ped toggle
			cmp.w	#HALF,r14				;compare value in r14 to #FOUR
			jge		donefast				;jumps out of the loop if equal
			call	#delay					;delay loop
			call	#delay					;delay loop
			add.w 	#1,r14					;add 1 to the value in r14
			jmp 	fast_flash				;go through the loop again
donefast:	pop		r14
			ret


;Port 1 ISR------------------------------------------------------------------------------
P1_ISR:
			CLEAR_INTERRUPTS				;clear the interrupt flags
			ORANGE_ON						;turns orange light on
          	reti							;return from interrupt

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------

			.global __STACK_END
            .sect .stack

;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
          	.sect  	".int02"              	; P1 interrupt vector
           	.word  	P1_ISR					;;;;;
            .sect   ".reset"                ; MSP430 RESET Vector
            .word   start                   ; start address
            .end

