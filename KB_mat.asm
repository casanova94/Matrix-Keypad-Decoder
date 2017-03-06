#include <C:\Program Files (x86)\Microchip\MPLABX\v3.20\mpasmx\p18f4550.inc>
  ; CONFIG1L
  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (Divide by 5 (20 MHz oscillator input))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 2            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = INTOSC_XT             ; Oscillator Selection bits (HS oscillator (HS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 0              ; Brown-out Reset Voltage bits (Maximum setting 4.59V)
  CONFIG  VREGEN = ON         ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 1             ; Watchdog Timer Postscale Select bits (1:1)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = OFF           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is protected from table reads executed in other blocks)

;variables utilizadas
SIZE EQU 0X00
ROW EQU 0X01
SIGNAL EQU 0X02
COLUMN EQU 0X03
 
ORG 0X00     
    ;------------ inicializo las variables
     clrf SIZE,0
     movlw b'00000100'
     movwf SIZE,0
     clrf ROW,0
     clrf SIGNAL,0
     movlw b'00001110'
     movwf SIGNAL,0
     clrf COLUMN,0
     movlw b'00001111'
     movwf COLUMN,0
    ;------------ configuración resistores pull up puerto B--------------
     bcf INTCON2,7
    ;----------------------------------configuro puerto D como salida
    movlw b'00000000'
    movwf TRISD,0
   ;----------------- inicializo puerto b como entrada/salida
    movlw b'11110000'
    movwf TRISB,0
    ;------------------------- inicializo puerto D
    movlw b'00000000'
    movwf LATD,0
    movlw b'00000000'
    movwf LATB,0
    ;si quiero revisar una entrada perifico PORTB, si quiero activar algun bit envio a LATB
    
    
MAIN:
  movf ROW,0
  CPFSEQ SIZE,0
  bra CHECK
  bra RESTART

;Escaneamos cada una de las columnas
CHECK:
   movff SIGNAL,LATB  
   btfsc PORTB,4
   bra COL2
   ;guardamos la columna
   movlw b'00000000'
   movwf COLUMN,0
COL2:
    bsf STATUS,0
    RLCF SIGNAL,1,0
    movff SIGNAL,LATB 
    btfsc PORTB,5
    bra COL3
   ;guardamos la columna
    movlw b'00000001'
    movwf COLUMN,0
COL3:
    bsf STATUS,0
    RLCF SIGNAL,1,0
    movff SIGNAL,LATB 
    btfsc PORTB,6
    bra COL4
   ;guardamos la columna
    movlw b'00000010'
    movwf COLUMN,0
COL4:
    bsf STATUS,0
    RLCF SIGNAL,1,0
    movff SIGNAL,LATB 
    btfsc PORTB,7
    bra REFRESH
   ;guardamos la columna
    movlw b'00000011'
    movwf COLUMN,0
REFRESH:
    movlw b'00000001'
    addwf ROW,1,0
    clrf SIGNAL,0
    movlw b'00001110'
    movwf SIGNAL,0
    movff COLUMN,LATD
    movlw b'00001111'
    movwf COLUMN,0
    bra MAIN
    
RESTART:  
  clrf ROW,0
  movlw b'00001111'
  movwf COLUMN,0
  bra MAIN
  
END             ;Fin de Programa


