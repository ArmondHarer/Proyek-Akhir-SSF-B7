;===============================================================================================
; Slave Tx
;===============================================================================================

#define __SFR_OFFSET 0
#include "avr/io.h"

.global main
.org 0x0000
  rjmp main

.org 0x0004
  jmp interupsi

.org 0x1000

main:
  SBI DDRC, 2                       ; set bit port C A2 dijadikan sebagai input interrupt button
  SBI PORTC, 2                    
  LDI R30, 0xC0                     ;set bit to ADMUX for pick A0 for the first input

  LDI R16, (1 << ISC11)             ; Configure ISC11 to trigger on falling edge
  STS EICRA, R16
  LDI R16, (1 << INT1)              ; Enable INT1
  STS EIMSK, R16
  SEI                               ; Enable global interrupts
  
;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

pick_ADC:
  STS ADMUX, R30                  ;internal 2.56V, right-justified data, ADC0 <==> ADC1
  
setup_ADC:
  LDI R20, 0x87                   ;enable ADC, ADC prescaler CLK/128
  STS ADCSRA, R20

I2C_init:
  LDI R21, 0
  STS TWSR, R21                   ;prescaler = 0
  LDI R21, 12                     ;division factor = 12
  STS TWBR, R21                   ;SCK freq = 400kHz
  LDI R21, (1<<TWEN)
  STS TWCR, R21                   ;enable TWI

read_ADC:
  LDI R20, 0xC7                   ;set ADSC in ADCSRA to start conversion
  STS ADCSRA, R20

wait_ADC:
  LDS R21, ADCSRA                 ;check ADIF flag in ADCSRA
  SBRS R21, 4                     ;skip jump when conversion is done (flag set)
  RJMP wait_ADC                   ;loop until ADIF flag is set
;--------------------------------------------------------------
  LDI R17, 0xD7                   ;set ADIF flag again
  STS ADCSRA, R17                 ;so that controller clears ADIF
;--------------------------------------------------------------
  LDS R18, ADCL                   ;get low-byte result from ADCL
  LDS R19, ADCH                   ;get high-byte result from ADCH

;Baris pengiriman data melalui I2C ke master------------------
;Pengiriman ADCL----------------------------------------------
  RCALL I2C_start                 ;transmit START condition
  LDI R27, 0b10010000             ;SLA(1001000) + W(0) ini adalah alamat dari slave
  RCALL I2C_write                 ;write slave address SLA+W (Write pertama untuk identifikasi slave)
  MOV R27, R18                    ;data byte to be transmitted, yaitu ADCL
  RCALL I2C_write                 ;write data byte (Write kedua untuk mengirim data)
  RCALL I2C_stop                  ;transmit STOP condition
  
;Pengiriman ADCH----------------------------------------------
  RCALL I2C_start                 ;transmit START condition
  LDI R27, 0b10010000             ;SLA(1001000) + W(0) ini adalah alamat dari slave
  RCALL I2C_write                 ;write slave address SLA+W (Write pertama untuk identifikasi slave)
  MOV R27, R19                    ;data byte to be transmitted, yaitu ADCL
  RCALL I2C_write                 ;write data byte (Write kedua untuk mengirim data)
  RCALL I2C_stop                  ;transmit STOP condition


  RCALL delay_sec                 ;Memberikan delay ke pengiriman berikutnya
  RJMP pick_ADC

;<><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><>
;<><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><><><><><>><><><><><><><><><>

I2C_start:
  LDI R21, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
  STS TWCR, R21 ;transmit START condition

wt1:
  LDS R21, TWCR
  SBRS R21, TWINT               ;TWI interrupt = 1? Interrupt akan menjadi 1 jika transmisi selesai
  RJMP wt1                      ;no, wait for end of transmission
  RET
;=============================================

I2C_write:
  STS TWDR, R27                 ;copy SLA+W into data register
  LDI R21, (1<<TWINT)|(1<<TWEN)
  STS TWCR, R21                 ;transmit SLA+W
;--------------------------------------------
wt2:
  LDS R21, TWCR
  SBRS R21, TWINT
  RJMP wt2                      ;wait for end of transmission
  RET

;============================================
I2C_stop:
  LDI R21, (1<<TWINT)|(1<<TWSTO)|(1<<TWEN)
  STS TWCR, R21 ;transmit STOP condition
  RET


;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

delay_sec: ; 250 ms delay
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

;TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
;TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

interupsi:              ; ini adalah subrutin yang dilakukan untuk mengaktifkan interrupt
  EOR R30, 1            ; Complement nilai ADMUX dari A0 <==> A1
  SBI EIFR, INTF1       ; Clear INT1 Flag
  RETI                  ; Return dari interrupt
