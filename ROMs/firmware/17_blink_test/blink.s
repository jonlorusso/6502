      .setcpu "65C02"
      .include "utils.inc"
      .include "lcd.inc"
      .include "zeropage.inc"
      .include "via.inc"
      .include "blink.inc"

      .segment "VECTORS"

      .word   $0000
      .word   init
      .word   $0000

      .code

init:
      jsr _lcd_init
      lda #<blink_msg
      sta lcd_out_ptr
      lda #>blink_msg
      sta lcd_out_ptr+1
      jsr _lcd_print
      lda #$01
      jsr _delay_sec
      lda VIA1_DDRB
      ora #%00000001
      sta VIA1_DDRB
      lda #$ff
      sta VIA2_DDRA
      sta VIA2_DDRB
blink_loop:
; enable LED
      sec
      jsr _blink_led
; blink VIA2 port A
      lda #$ff
      sta VIA2_PORTA
; disable VIA2 port B
      lda #$00
      sta VIA2_PORTB
; delay 1s
      lda #$01
      jsr _delay_sec
; disable LED
      clc
      jsr _blink_led
; disable VIA2 port A
      lda #$00
      sta VIA2_PORTA
; enable VIA2 port B
      lda #$ff
      sta VIA2_PORTB
; delay another second
      lda #$01
      jsr _delay_sec
; repeat
      bra blink_loop

      .segment "RODATA"

blink_msg:
      .byte "Blink test", $00
