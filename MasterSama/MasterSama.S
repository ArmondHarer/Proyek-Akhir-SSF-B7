;============================
; Master Rx
;============================

#define __SFR_OFFSET 0x00
#include "avr/io.h"

.global main

main:
  LDI R21, 0xFF
  OUT DDRD, R21                 ;port D is o/p

;HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
;HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

anchor:
  LDI R16, 2

agn:
  RCALL I2C_init                ;initialize TWI module
  RCALL I2C_listen              ;listen to bus to be addressed
  RCALL I2C_read                ;read data byte

; hasil bacaan pengiriman I2C disimpan di R27
  ;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  ;Line pengaturan servo

    LDI   R26, 8                      ;counter for # of rotation pos
    ;LDI   ZL, lo8(rotate_pos)
    ;LDI   ZH, hi8(rotate_pos)
    ;-----------------------------------------------------------
l1: MOV   R24, R27                    ;Z+ load rotation pos
    RCALL rotate_servo                ;& rotate servo
    DEC   R26
    BRNE  l1                          ;go back & get another rotate pos

rotate_servo:
    LDI   R20, 10         ;count to give enough cycles of PWM
l2: 
    SBI   PORTD, 4
    RCALL delay_timer0
    CBI   PORTD, 4        ;send msec pulse to rotate servo
    RCALL delay_20ms      ;wait 20ms before re-sending pulse
    DEC   R20
    BRNE  l2              ;go back & repeat PWM signal

    DEC R16
    BRNE agn
    RCALL indikator
    RJMP anchor                      ; go back & listen to bus

  RCALL delay_sec
  RJMP agn                      ; go back & listen to bus
;<><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><>
;<><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><>

I2C_init:
  LDI R21, 0b10010000
  STS TWAR, R21                 ;store slave address 0b10010000
  LDI R21, (1<<TWEN)
  STS TWCR, R21                           ;enable TWI
  LDI R21, (1<<TWINT)|(1<<TWEN)|(1<<TWEA)
  STS TWCR, R21                           ;enable TWI & ACK
  RET
;==============================================================

I2C_listen:
  LDS R21, TWCR
  SBRS R21, TWINT
  RJMP I2C_listen                         ;wait for slave to be addressed
  RET
;==============================================================

I2C_read:
  LDI R21, (1<<TWINT)|(1<<TWEA)|(1<<TWEN)
  STS TWCR, R21                           ;enable TWI & ACK
;----------------------------------------------------------
wt:
  LDS R21, TWCR
  SBRS R21, TWINT
  RJMP wt                                 ;wait for data byte to be read
;----------------------------------------------------------
  LDS R27, TWDR                           ;store received byte
  RET

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

;---------------------------------------------------------------
;rotate_pos:
;.byte 40,70,90,110,180,110,90,70
;===============================================================





;===============================================================
;delay subroutines
;===============================================================
delay_timer0:             ;delay via Timer0
    ;-----------------------------------------------------------
    CLR   R25
    OUT   TCNT0, R25      ;initialize timer0 with count=0
    MOV   R25, R24
    OUT   OCR0A, R25
    LDI   R25, 0b00001100
    OUT   TCCR0B, R25     ;timer0: CTC mode, prescaler 256
    ;-----------------------------------------------------------
l3: IN    R25, TIFR0      ;get TIFR0 byte & check
    SBRS  R25, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l3              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R25
    OUT   TCCR0B, R25     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R25, (1<<OCF0A)
    OUT   TIFR0, R25      ;clear OCF0 flag
    RET


delay_sec: ; 0,25 s delay
    LDI R22, 255
Tick1: LDI R23, 255
Tick2: LDI R24, 20
Tick3: DEC R24
    BRNE Tick3
    DEC R23
    BRNE Tick2
    DEC R22
    BRNE Tick1
    RET

;------------------------------------------------------------------------------------------------------------

delay_20ms:               ;delay 20ms
    LDI   R21, 255
Del1: LDI   R22, 210
Del2: LDI   R23, 2
Del3: DEC   R23
    BRNE  Del3
    DEC   R22
    BRNE  Del2
    DEC   R21
    BRNE  Del1
    RET

indikator:
  RCALL I2C_init                ;initialize TWI module
  RCALL I2C_listen              ;listen to bus to be addressed
  RCALL I2C_read                ;read data byte
  OUT PORTB, R27
  RET

