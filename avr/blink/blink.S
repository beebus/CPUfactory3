; Hello Blinky World for AVR
; Author: Roie R. Black
; Date: July 14, 2015

#include "config.h"

	.section .data
dummy: 	.byte 0		; dummy global variable

        .section .text
        .global     main
        .extern     delay          
        .org        0x0000

main:
	; clear the SREG register
        eor     r1, r1                  ; cheap zero
        out     _(SREG), r1                ; clear flag register


        ; set up the stack
        ldi         r28, (RAMEND & 0x00ff)
        ldi         r29, (RAMEND >> 8)
        out         _(SPH), r29
        out         _(SPL), r28

	; initialize the CPU clock to run at full speed
	ldi         r24, 0x80
        sts         CLKPR, r24              ; allow access to clock setup
        sts         CLKPR, r1               ; run at full speed
        
        ; set up the LED port
        sbi         LED_DIR, LED_PIN        ; set LED pin to output
        cbi         LED_PORT, LED_PIN       ; start with the LED off
       

        ; enter the blink loop
1:      rcall       toggle
        rcall       delay
        rjmp        1b

toggle:
        in          r24, LED_PORT           ; get current bits
        ldi         r25, (1 << LED_PIN)     ; LED is pin 5
        eor         r24, r25                ; flip the bit
        out         LED_PORT, r24           ; write the bits back
        ret
