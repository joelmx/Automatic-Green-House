#include "P18F4585.inc" 
	UDATA_ACS
variable1 res 1				;VARIABLE PARA CONSEGUIR LOS 10 SEGUNDOS EN EL TIMER
variable2 res 1				;VARIABLE PARA CUENTA DEL DELAY
variable3 res 1				;VARIABLE PARA CUENTA DEL DELAY
regcont1 res 1				;VARIABLE CONTADOR PARA LOOPS
alta res 1
baja res 1
bcd res 1					;VARAIBLE PARA GUARDAR EL VALOR HEXADECIMAL QUE SE QUIERE CONVERTIR A BCD PARA DESPLEGAR EN LCD
TMIN RES 1					;VARIABLE PARA GUARDAR LIMITE INFERIOR AL QUE PUEDE LLEGAR EL RANGO MENOR DE TEMPERATURA
TMAY res 1					;VARIABLE PARA GUARDAR LIMITE INFERIOR AL QUE PUEDE LLEGAR EL RANGO MAYOR DE TEMPERATURA
CMD_DELAY RES 1          
LCD_TMP   RES 1				;VARIABLE PARA GUARDAR EL VALOR HEXADECIMAL DEL CARACTER QUE SE DESPLEGARA EN EL LCD
DELAYCNT EQU 0x20
XDELAYCNT EQU 0x21
LCD_RS EQU 0
LCD_RW EQU 1
LCD_EN EQU 2
TEMPME RES 1				;VARIABLE PARA GUARDAR EL RANGO MENOR DE TEMPERATURA
TEMPMA RES 1				;VARIABLE PARA GUARDAR EL RANGO MAYOR DE TEMPERATURA
TMPACT RES 1				;VARIABLE PARA GUARDAR LA TEMPERATURA ACTUAL QUE REGISTRA EL SENSOR
HUMACT RES 1				;VARIABLE PARA GUARDAR LA HUMEDAD ACTUAL QUE REGISTRA EL SENSOR
HUMEDA RES 1				;VARIABLE PARA GUARDAR EL LIMITE INFERIOR DE HUMEDAD A SENSAR
CONT1  EQU 0X38
CTEMP EQU 0X44
CHUMD EQU 0X12
DOWN EQU D'10'
TOP equ D'45'
	org 0x600
texto db "MIN:25C  MAX:30C                        TMP:  C  HUM:  %"

	ORG 0X00
	GOTO INICIO

	ORG 0X08 				;VECTOR DE INTERRUPCION TIMER0	
	BCF INTCON,2			;APAGAMOS BANDERA DE INTERRUPCION
	DECFSZ variable1		;DECREMENTAMOS TIMER PARA CONSEGUIR 10 SEGUNDOS
	GOTO FININTERRUPT		;SALIR DE LA INTERRUPCION
	GOTO RUTINTERRUPT		;IR A RUTINA DE ATENCION A INTERRUPCION
	NOP
	RETFIE

INICIO:	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINCIPIA INICIALIZACION DEL LCD 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOVLW 0x0B	
	MOVWF ADCON1			;VOLTAJES DE REFERENCIA SELECCIONADOS VSS Y VCC DEL PIC, SELECCIONAMOS COMO PUERTOS ANALOGOS AN0 Y AN1 
	CLRF TRISC				;PUERTOC SALIDA VARIABLES DE CONTROL LCD RS,RW,EN --> RC0,RC1,RC2
	CLRF TRISB				;PUERTOB SALIDA RB7,RB6,RB5,RB4 BITS DE SALIDA DE DATOS PARA EL LCD
	CLRF PORTC
	CLRF PORTC
	

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x30 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 3
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x00 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 0
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x20 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 2
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x00 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 0
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0xF0 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 15
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x00 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 0
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x20 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 2
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0	
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x00 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 0
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY

	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x10 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 1
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SE TERMINA INICIALIZACION DEL LCD 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Para escribir un dato en LCD lo pones primero en W y despues llamas a "write_text"
    MOVLW DOWN
	MOVWF TMIN				;RANGO MAYOR DE TEMPERATURA HASTA LA QUE SE PUEDE CONTROLAR
	MOVLW TOP
	MOVWF TMAY				;RANGO MAYOR DE TEMPERATURA HASTA LA QUE SE PUEDE CONTROLAR
	MOVLW CONT1
	MOVWF regcont1			;CARGA UN 0X38 EN LA VARIABLE PARA GENERAR UN CONTADOR PARA RECORRER EL TEXTO GUARDADO EN ROM
	MOVLW UPPER texto       ;OBTIENE PARTE MÁS ALTA DE LA DIRECCIÓN A LA QUE APUNTA LA ETIQUETA texto
	MOVWF TBLPTRU			
	MOVLW HIGH texto		;OBTIENE PARTE ALTA DE LA DIRECCIÓN A LA QUE APUNTA LA ETIQUETA texto
	MOVWF TBLPTRH
	MOVLW LOW texto			;OBTIENE PARTE BAJA DE LA DIRECCIÓN A LA QUE APUNTA LA ETIQUETA texto
	MOVWF TBLPTRL
	LFSR FSR0,0x800			;CARGAMOS UN 0X800 A FSR0 PARA GUARDAR EN RAM APARTIR DE ESA LOCALIDAD DE MEMORIA EL TEXTO QUE TENEMOS EN ROM
ILEER:						;RUTINA QUE SE ENCARGA DE PASAR EL CONTENIDO AL QUE APUNTA texto EN ROM A RAM A LA DIRECCION QUE APUNTA FSR0 Y A SU VEZ IMPRIME ESTE CONTENIDO EN EL LCD
	TBLRD*+
	MOVFF TABLAT,POSTINC0
	MOVFF TABLAT, LCD_TMP
	CALL  ESCRIBIR
	DECFSZ regcont1
	BRA ILEER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINCIPIA INICIALIZACION DE PUSH-BOTONS Y SALIDAS 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOVLW 0X07
	MOVWF CMCON				;APAGAMOS LOS COMPARADORES PARA PODER UTILIZAR COMO DIGITAL EL PUERTOD
	MOVLW 0X78				
	MOVWF TRISD				;SALIDAS RD0,RD1,RD2 --> VENTILADOR, BOMBA, CALENTOR. ENTRADAS PUSH-BOTONS RD3,RD4,RD5,RD6 --> INCREMENTA RANGO MENOR, DECREMENTA RANGO MENOR,INCREMENTA RANGO MAYOR, DECREMENTA RANGO MAYOR
	CLRF PORTD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SE TERMINA INICIALIZACION DE PUSH BOTONS Y SALIDAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINCIPIA INICIALIZACION DE SERIAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CLRF TXREG
	BSF		RCSTA,SPEN		;(HABILITA PUERTO SERIE)
	MOVLW	0X03			;9600 BAUDIOS
	MOVWF	SPBRG			;9600 BAUDIOS
	movlw	0x01			;9600 BAUDIOS
	movwf	SPBRGH			;9600 BAUDIOS
	MOVLW	0XAC			;sync(0), brgh(1)
	MOVWF	TXSTA
	movlw	b'00001000'		;brg16(1)
	movwf	BAUDCON
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SE TERMINA INICIALIZACION DE SERIAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOVLW     0xFF           
    MOVWF     TRISA 		;PUERTOA DECLARADO COMO ENTRADA (RA0 SENSOR DE TEMP Y RA1 SENSOR DE HUMEDAD)
	MOVLW D'25'
	MOVWF TEMPME            ;INICIALIZACIÓN DE VALOR DE RANGO MENOR DE TEMPERATURA A CONTROLAR
	MOVLW D'30'
	MOVWF TEMPMA			;INICIALIZACIÓN DE VALOR DE RANGO MAYOR DE TEMPORATURA A CONTROLAR
    MOVLW D'60'
    MOVWF HUMEDA			;INICIALIZACIÓN DEL RANGO MINIMO DE HUMEDAD QUE DEBE EXISTIR
	MOVLW D'95'
	MOVWF variable1         ;INICIALIZACIÓN variable1 NOS VA A SERVIR PARA OBTENER UNA TIMER DE INTERRUPCION DE MAS TIEMPO
	BSF ADCON2,7			;ALINEAR VALORES DE LOS ANALOGOS DIGIALES A LA IZQUIERDA
	BSF ADCON2,0			;FOSC/8 11MHZ VELOCIDAD DE LECTURA ANALAGOS
	MOVLW 0X01
	MOVWF ADCON0			;CONVERTIDOR ANALOGO DIGITAL ENCENDIDO
	BSF RCON,7				;HABILITAR NIVELES DE PRIORIDAD 
	BSF INTCON,7			;HABILITAR INTERRUPCIONES GLOBALES
	BSF INTCON,5			;INTERRUPCION DE DESOBORDAMIENTO DE TIMER0
	MOVLW 0x00
	MOVWF TMR0H
	MOVLW 0x00
	MOVWF TMR0L				;INICIALIZACION DE TIMER0 EN CUENTA 0000H
	MOVLW	0x81			
	MOVWF	T0CON			;ENCENDIDO DE TIMER0, CONFIGURACION DE 16 BITS, FUNCIONA CON EL CLOCK CICLO DE INSTRUCCION, PREESCALAR ASIGNADO 1:4

BPRINCIPAL:
	BTFSS PORTD,3			;COMPRUEBA PUSHBOTON 1 PRESIONADO
	GOTO INCMEN				
	BTFSS PORTD,4			;COMPRUEBA PUSHBOTON 2 PRESIONADO
	GOTO DECMEN
	BTFSS PORTD,5			;COMPRUEBA PUSHBOTON 3 PRESIONADO
	GOTO INCMAY
	BTFSS PORTD,6			;COMPRUEBA PUSHBOTON 4 PRESIONADO
	GOTO DECMAY
	GOTO BPRINCIPAL

INCMEN:						;RUTINA DE INCREMENTO EN 1 GRADO EL MARGEN MENOR DE TEMPERATURA
	INCF TEMPME,0			;INCREMENTAMOS EN WREG EL VALOR DEL RANGO DE TEMPERATURA MENOR
	CPFSGT TEMPMA			;COMPROBAMOS QUE SI INCREMENTAMOS LA TEMPERATURA DEL RANGO MENOR LA DEL RANGO MAYOR SIGUE SIENDO MAYOR DE SER ASI BRINCAMOS LA SIGUIENTE INSTRUCCION
	GOTO RERROR				;RUTINA DE MANEJO DE ERROR EN CASO DE QUE LA TEMPERATURA DEL RANGO MENOR SE DESEE INCREMENTAR MAS ALLA DE LA DEL RANGO MAYOR
	INCF TEMPME				;INCREMENTAMOS EN UNO EL REGISTRO QUE CONTIENE NUESTRO RANGO MENOR DE TEMPERATURA
	CALL REFRESHMEN			;LLAMAMOS RUTINA PARA ACTUALIZAR EL LCD CON EL NUEVO VALOR DE TEMEPERATURA EN EL RANGO MENOR
LINCME:  
  	CALL DELAY
  	BTFSS PORTD,3			;COMPRUEBA PUSHBOTON 1 NO PRESIONADO
  	GOTO LINCME
	GOTO BPRINCIPAL

DECMEN:						;RUTINA DE DECREMENTO EN 1 GRADO EL MARGEN MENOR DE TEMPERATURA
	DECF TEMPME,0			;DECREMENTAMOS EN WREG EL VALOR DEL RANGO DE TEMPERATURA MENOR			
	CPFSLT TMIN				;COMPROBAMOS QUE SI AL DECREMENTAR LA TEMPERATURA DEL RANGO MENOR NO SEA MAS BAJA QUE EL LIMITE ESTABLECIDO
	GOTO RERROR				;RUTINA DE MANEJO DE ERROR EN CASO DE QUE LA TEMPERATURA DEL RANGO MENOR SE DESEE DECREMENTAR MAS ALLA DEL LIMITE INFERIOR DE TEMPERATURA PERMITIDO PARA EL RANGO MENOR
    DECF TEMPME				;DECREMENTAMOS EN UNO EL REGISTRO QUE CONTIENE NUESTRO RANGO MENOR DE TEMPERATURA
	CALL REFRESHMEN			;LLAMAMOS RUTINA PARA ACTUALIZAR EL LCD CON EL NUEVO VALOR DE TEMEPERATURA EN EL RANGO MENOR
LDECME:  
  	CALL DELAY
  	BTFSS PORTD,4			;COMPRUEBA PUSHBOTON 2 NO PRESIONADO
  	GOTO LDECME	
	GOTO BPRINCIPAL

INCMAY:						;RUTINA DE INCREMENTO EN 1 GRADO EL MARGEN MAYOR DE TEMPERATURA				
	INCF TEMPMA,0			;INCREMENTAMOS EN WREG EL VALOR DEL RANGO DE TEMPERATURA MAYOR	
	CPFSGT TMAY				;COMPROBAMOS QUE SI AL INCREMENTAR LA TEMPERATURA DEL RANGO MAYOR NO SEA MAS ALTA QUE EL LIMITE ESTABLECIDO
	GOTO RERROR				;RUTINA DE MANEJO DE ERROR EN CASO DE QUE LA TEMPERATURA DEL RANGO MAYOR SE DESEE INCREMENTAR MAS ALLA DEL LIMITE SUPERIOR DE TEMPERATURA PERMITIDO PARA EL RANGO MAYOR
	INCF TEMPMA				;INCREMENTAMOS EN UNO EL REGISTRO QUE CONTIENE NUESTRO RANGO MAYOR DE TEMPERATURA
	CALL REFRESHMAY			;LLAMAMOS RUTINA PARA ACTUALIZAR EL LCD CON EL NUEVO VALOR DE TEMEPERATURA EN EL RANGO MAYOR
LINCMA:  
  	CALL DELAY
  	BTFSS PORTD,5			;COMPRUEBA PUSHBOTON 3 NO PRESIONADO
  	GOTO LINCMA	
	GOTO BPRINCIPAL

DECMAY:						;RUTINA DE DECREMENTO EN 1 GRADO EL MARGEN MAYOR DE TEMPERATURA
	DECF TEMPMA,0			;DECREMENTAMOS EN WREG EL VALOR DEL RANGO DE TEMPERATURA MAYOR			
	CPFSLT TEMPME			;COMPROBAMOS QUE SI DECREMENTAMOS LA TEMPERATURA DEL RANGO MAYOR LA DEL RANGO MENOR SIGUE SIENDO MENOR DE SER ASI BRINCAMOS LA SIGUIENTE INSTRUCCION
	GOTO RERROR				;RUTINA DE MANEJO DE ERROR EN CASO DE QUE LA TEMPERATURA DEL RANGO MAYOR SE DESEE DECREMENTAR MAS ALLA DE LA DEL RANGO MENOR
	DECF TEMPMA				;DECREMENTAMOS EN UNO EL REGISTRO QUE CONTIENE NUESTRO RANGO MAYOR DE TEMPERATURA
	CALL REFRESHMAY			;LLAMAMOS RUTINA PARA ACTUALIZAR EL LCD CON EL NUEVO VALOR DE TEMEPERATURA EN EL RANGO MAYOR
LDECMA:  
  	CALL DELAY
  	BTFSS PORTD,6			;COMPRUEBA PUSHBOTON 4 NO PRESIONADO
  	GOTO LDECMA
	GOTO BPRINCIPAL

RERROR:
	GOTO BPRINCIPAL

ESCRIBIR: 					;RUTINA PARA ESCRIBIR EN EL LCD EL CONTENIDO EN EL REGISTRO LCD_TMP
	BSF PORTC,LCD_EN 		;EN = 1
	BSF PORTC,LCD_RS 		;RS = 1
	MOVF LCD_TMP,W			;MANDAMOS PARTE ALTA DE PUERTOB
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY2
	CALL DELAY2

	BSF PORTC,LCD_EN 		;EN = 1
	BSF PORTC,LCD_RS 		;RS = 1
    SWAPF LCD_TMP,W			;MANDAMOS PARTE BAJA DE PUERTOB
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY2
	CALL DELAY2
	RETURN

REFRESHMEN:
;	BTG PORTC,3
	MOVFF TEMPME,bcd		;bcd ES EL REGISTRO QUE CONTIENE EL NUMERO A SER CONVERTIDO POR LA SIGUIENTE RUTINA
	CALL CONVERTIR_BCD		;LLAMAMOS RUTINA QUE CONVIERTE A NUESTROS NUMEROS A BCD
	MOVWF bcd				
	MOVLW 0XF0				
    ANDWF bcd,W				;SE HACE UN AND CON F0 EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE ALTA DEL REGISTRO bcd 
	SWAPF WREG				;SE HACE UN SWAP PARA PONER LOS BITS EN EL NIBBLE DE LA PARTE BAJA
	ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS DECENAS A MOSTRAR EN EL LCD
	MOVLB 0X08
	MOVWF 0X04,BANKED		;SE GUARDA EN LA DIRECCION 0X804 CORRESPONDIENTE A LAS DECENAS DEL RANGO MENOR DE TEMPERATURA	
	MOVLW 0X0F
	ANDWF bcd,W				;SE HACE UN AND CON 0F EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE BAJA DEL REGISTRO bcd
    ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS UNIDADES A MOSTRAR EN EL LCD
	MOVWF 0X05,BANKED	    ;SE GUARDA EN LA DIRECCION 0X805 CORRESPONDIENTE A LAS UNIDADES DEL RANGO MENOR DE TEMPERATURA	
	CALL HOME				;RUTINA QUE MUEVE EL CURSOR A HOME EN EL LCD
	MOVLW 0X04
	MOVWF regcont1
FA   CALL SHIFT				;RUTINA QUE HACE MOVE DEL CURSOR PARA POSICIONARNOS EN LA LOCALIDAD DEL LCD QUE QUEREMOS ESCRIBIR EN ESTE CASO LA 04		
	DECFSZ regcont1
    BRA FA
	MOVFF 0X804,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS DECENAS DEL RANGO DE TEMPERATURA MENOR
	CALL ESCRIBIR			;ESCRIBIMOS EN EL LCD
	MOVFF 0X805,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS UNIDADES DEL RANGO DE TEMPERATURA MENOR
	CALL ESCRIBIR			;ESCRIBIMOS EN EL LCD
	RETURN

REFRESHMAY:
;	BTG PORTC,3
	MOVFF TEMPMA,bcd		;bcd ES EL REGISTRO QUE CONTIENE EL NUMERO A SER CONVERTIDO POR LA SIGUIENTE RUTINA
	CALL CONVERTIR_BCD		;LLAMAMOS RUTINA QUE CONVIERTE A NUESTROS NUMEROS A BCD
	MOVWF bcd
	MOVLW 0XF0
    ANDWF bcd,W				;SE HACE UN AND CON F0 EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE ALTA DEL REGISTRO bcd
	SWAPF WREG				;SE HACE UN SWAP PARA PONER LOS BITS EN EL NIBBLE DE LA PARTE BAJA
	ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS DECENAS A MOSTRAR EN EL LCD
	MOVLB 0X08
	MOVWF 0X0D,BANKED		;SE GUARDA EN LA DIRECCION 0X80D CORRESPONDIENTE A LAS DECENAS DEL RANGO MAYOR DE TEMPERATURA
	MOVLW 0X0F
	ANDWF bcd,W				;SE HACE UN AND CON 0F EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE BAJA DEL REGISTRO bcd
    ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS UNIDADES A MOSTRAR EN EL LCD
	MOVWF 0X0E,BANKED		;SE GUARDA EN LA DIRECCION 0X80E CORRESPONDIENTE A LAS UNIDADES DEL RANGO MENOR DE TEMPERATURA
	CALL HOME				;RUTINA QUE MUEVE EL CURSOR A HOME EN EL LCD
	MOVLW 0X0D
	MOVWF regcont1
FB  CALL SHIFT				;RUTINA QUE HACE MOVE DEL CURSOR PARA POSICIONARNOS EN LA LOCALIDAD DEL LCD QUE QUEREMOS ESCRIBIR EN ESTE CASO LA 0D
	DECFSZ regcont1
    BRA FB
	MOVFF 0X80D,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS DECENAS DEL RANGO DE TEMPERATURA MAYOR
	CALL ESCRIBIR			;ESCRIBIMOS EN EL LCD
	MOVFF 0X80E,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS UNIDADES DEL RANGO DE TEMPERATURA MENOR
	CALL ESCRIBIR			;ESCRIBIMOS EN EL LCD
	RETURN

HOME:						;ENVIAMOS UN 02 PARA MOVER EL CURSOR A HOME
	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x00 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 0
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY2
	CALL DELAY2
    BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x20 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 2
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY2
	CALL DELAY2
	RETURN

SCREENCLEAR:				;ENVIAMOS UN 01 PARA LIMPIAR LA PANTALLA
    BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x00 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 0
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY
	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0
	MOVLW 0x10 				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 1
	MOVWF PORTB
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY
	CALL DELAY
	RETURN

SHIFT:						;ENVIAMOS UN 14 PARA CONFIGURAR UN CORRIMIENTO DEL CURSOR DEL LCD A LA DERECHA
	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0	
	MOVLW 0X10	
	MOVWF PORTB				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 1
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY2
	CALL DELAY2
	BSF PORTC,LCD_EN 		;EN = 1
	BCF PORTC,LCD_RS 		;RS = 0	
	MOVLW 0X40			
	MOVWF PORTB				;CONFIGURACION INTERFAZ DE 8 BITS, CARACTERES 5X8 ENVIAMOS UN 4
	BCF PORTC,LCD_EN 		;EN = 0
	CALL DELAY2
	CALL DELAY2
	RETURN

CONVERTIR_BCD:   			;RUTINA QUE CONVIERTE UN NUMERO HEXADECIMAL A BCD     
	SWAPF   bcd, W, A   	;HACE UN SWAP DE LOS NIBBLES EN WREG
    ADDWF   bcd, W, A   	;SUMA PARTE ALTA CON LA BAJA RESULTADO EN WREG
    ANDLW   B'00001111' 	;PIERDE LA PARTE ALTA DE WREG
    BTFSC   STATUS, DC, A   ;SI LA SUMA DE LA PARTE ALTA CON LA BAJA ES MAYOR A 16 BRINCA
    ADDLW   0x16     		;SUMAMOS 16 A WREG   
    DAW      				;CHECAMOS OVERFLOW           
        
    BTFSC   bcd, 4, A 		;LUGAR DE LOS 16'S  
    ADDLW  0x16 - 1     	;SUMAMOS 15
        
    BTFSC   bcd, 5, A   	;LUGAR DE LOS 32'S
    ADDLW  0x30        		;SUMAMOS 30
        
    BTFSC   bcd, 6, A 		;LUGAR DE LOS 64'S  
    ADDLW  0x60      		;SUMAMOS 60  
        
    BTFSC   bcd, 7, A  		;LUGAR DE LOS 128'S
    ADDLW  0x20    			;SUMAMOS 20         
	DAW						;CHECAMOS SI HUBO OVERFLOW EN LA ULTIMA OPERACION
    RETURN

	
DELAY:
	MOVLW 0x88
	MOVWF variable2
	MOVWF variable3
LOOP1:
	DECFSZ variable3
	GOTO    LOOP1
	DECFSZ variable2
	GOTO    LOOP1
	RETURN

DELAY2:
	MOVLW 0x04
	MOVWF variable2
	MOVLW 0xFF
	MOVWF variable3
LOOP2:
	DECFSZ variable3
	GOTO    LOOP2
	DECFSZ variable2
	GOTO    LOOP2
	RETURN


RUTINTERRUPT:				;RUTINA DE INTERRUPCION
;	BTG PORTC,3
	MOVLW D'95'
	MOVWF variable1			;INCIALIZAMOS NUEVAMENTE EL TIMER PARA 10 SEGUNDOS							
	LFSR FSR0,0x800			;INICIALIZAMOS FSRO
	
	BSF ADCON2,7			;ALINEAR VALORES DE LOS ANALOGOS DIGIALES A LA IZQUIERDA
	BCF ADCON0,2			;LEER DEL PIN ANALOGO 0 AN0 CORRESPONDIENTE A NUESTRO SENSOR DE TEMPERATURA
	BSF ADCON0,1			;ENCENDEMOS EL BIT DE GO PARA COMENZAR LECTURA DE ANALOGOS
FC:	BTFSC ADCON0,1			;ESPERAMOS A QUE LA LECTURA ESTE LISTA
    BRA FC
  
    MOVLW CTEMP				
    SUBWF ADRESL			;RESTAMOS PARAMETRO CTEMP PARA HACER LINEAL LA LECTURA DEL SENSOR DE TEMPERATURA
	MOVFF ADRESL,TMPACT		;CARGAMOS EL VALOR CONTENIDO EN EL ADRESH A NUESTRA VARIABLE TMPACT
	MOVFF ADRESL,bcd		
	CALL CONVERTIR_BCD		;CONVERTIMOS A BCD EL CONTENIDO DE ADRESH Y LO GUARDAMOS WREG
	MOVWF bcd
	MOVLW 0XF0
    ANDWF bcd,W				;SE HACE UN AND CON F0 EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE ALTA DEL REGISTRO bcd
	SWAPF WREG				;SE HACE UN SWAP PARA PONER LOS BITS EN EL NIBBLE DE LA PARTE BAJA
	ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS DECENAS A MOSTRAR EN EL LCD
	MOVLB 0X08
	MOVWF 0X2C,BANKED		;SE GUARDA EN LA DIRECCION 0X82C CORRESPONDIENTE A LAS DECENAS DE LA TEMPERATURA ACTUAL
	MOVLW 0X0F
	ANDWF bcd,W				;SE HACE UN AND CON 0F EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE BAJA DEL REGISTRO bcd
    ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS UNIDADES A MOSTRAR EN EL LCD
	MOVWF 0X2D,BANKED		;SE GUARDA EN LA DIRECCION 0X82D CORRESPONDIENTE A LAS UNIDADES DE LA TEMPERATURA ACTUAL
	CALL HOME				;RUTINA PARA MOVER EL CURSOR A HOME
	MOVLW D'44'
	MOVWF regcont1
FD  CALL SHIFT				;RUTINA PARA POSICIONAR EL CURSOR DEL LCD EN ESTE CASO A LA DIRECCION 44H DEL LCD
	DECFSZ regcont1
    BRA FD
	MOVFF 0X82C,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS DECENAS DE LA TEMPERATURA ACTUAL
	CALL ESCRIBIR			;ESCRIBIMOS EN EL LCD
	MOVFF 0X82D,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS UNIDADES DE LA TEMPERATURA ACTUAL
	CALL ESCRIBIR 			;ESCRIBIMOS EN EL LCD

	BSF ADCON2,7			;ALINEAR VALORES DE LOS ANALOGOS DIGIALES A LA DERECHA
	BSF ADCON0,2			;LEER DEL PIN ANALOGO 1 AN1 CORRESPONDIENTE A NUESTRO SENSOR DE HUMEDAD
	BSF ADCON0,1			;ENCENDEMOS EL BIT DE GO PARA COMENZAR LECTURA DE ANALOGOS
FF:	BTFSC ADCON0,1			;ESPERAMOS A QUE LA LECTURA ESTE LISTA
    BRA FF  

	;MOVLW CHUMD
    ;SUBWF ADRESL			;RESTAMOS PARAMETRO CHUMD PRIMER PASO PARA HACER LINEAL LA LECTURA DEL SENSOR DE HUMEDAD
	MOVLW 0x00
	MOVWF regcont1

    MOVLW D'3'
div:SUBWF ADRESL			;HACEMOS DIVISION ENTRE 3 PARA CONSEGUIR UNA LECTURA LINEAL DE 0 A 100% EN EL SENSOR DE HUMEDAD
	INCF  regcont1
    CPFSLT ADRESL
	BRA div	    

    MOVLW CHUMD
    SUBWF regcont1
	MOVFF regcont1,HUMACT 	;CARGAMOS EL RESULTADO DE NUESTRA DIVISION CONTENIDO EN EL REGRISTRO ADRESL A NUESTRA VARIABLE HUMACT
	MOVFF regcont1,bcd
	CALL CONVERTIR_BCD		;CONVERTIMOS A BCD EL CONTENIDO DE REGCONT1 Y LO GUARDAMOS WREG
	MOVWF bcd
	MOVLW 0XF0
    ANDWF bcd,W				;SE HACE UN AND CON F0 EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE ALTA DEL REGISTRO bcd
	SWAPF WREG				;SE HACE UN SWAP PARA PONER LOS BITS EN EL NIBBLE DE LA PARTE BAJA
	ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS DECENAS A MOSTRAR EN EL LCD
	MOVLB 0X08
	MOVWF 0X35,BANKED		;SE GUARDA EN LA DIRECCION 0X835 CORRESPONDIENTE A LAS DECENAS DE LA HUMEDAD ACTUAL
	MOVLW 0X0F
	ANDWF bcd,W				;SE HACE UN AND CON 0F EL RESULTADO SE QUEDA EN WREG PARA TENER SOLO LA PARTE BAJA DEL REGISTRO bcd
    ADDLW 0x30				;SE SUMA UN 30 PARA TENER EL CODIGO HEXADECIMAL DE LAS UNIDADES A MOSTRAR EN EL LCD
	MOVWF 0X36,BANKED		;SE GUARDA EN LA DIRECCION 0X836 CORRESPONDIENTE A LAS UNIDADES DE LA HUMEDAD ACTUAL
	MOVLW D'7'
	MOVWF regcont1
FG  CALL SHIFT				;RUTINA PARA POSICIONAR EL CURSOR DEL LCD EN ESTE CASO A LA DIRECCION 4BH DEL LCD
	DECFSZ regcont1
    BRA FG
	MOVFF 0X835,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS DECENAS DE LA HUMEDAD ACTUAL
	CALL ESCRIBIR			;ESCRIBIMOS EN EL LCD
	MOVFF 0X836,LCD_TMP		;CARGAMOS EN LCD_TMP EL CONTENIDO DEL REGISTRO CORRESPONDIENTE A LAS UNIDADES DE LA HUMEDAD ACTUAL
	CALL ESCRIBIR 			;ESCRIBIMOS EN EL LCD

	MOVF TMPACT,W			;MOVEMOS EL VALOR CONTENIDO EN TMACT A WREG
	CPFSLT TEMPMA			;SI NUESTRO CONTENIDO DE LA VARIABLE TEMPMA ES MENOR AL DE TMPACT ENCENDEMOS VENTILADOR, DE LO CONTRARIO LO APAGAMOS
    BRA APAGAR_VENT
    BSF PORTD,0				;ENCIENDE RD0 CORRESPONDIENTE AL ENCENDIDO DEL VENTILADOR
	BRA BRINCAR
APAGAR_VENT:
	BCF PORTD,0				;APAGA RD0 CORRESPONDIENTE A APAGAR EL VENTILADOR
BRINCAR:
	MOVF TMPACT,W			;MOVEMOS EL VALOR CONTENIDO EN TMACT A WREG
	CPFSGT TEMPME			;SI NUESTRO CONTENIDO DE LA VARIABLE TEMPME ES MAYOR AL DE TMPACT ENCENDEMOS CALENTADOR, DE LO CONTRARIO LO APAGAMOS
    BRA APAGAR_CAL
    BSF PORTD,2				;ENCIENDE RD2 CORRESPONDIENTE AL ENCENDIDO DEL CALENTADOR
	BRA BRINCAR2
APAGAR_CAL:
	BCF PORTD,2				;APAGA RD2 CORRESPONDIENTE A APAGAR EL CALENTADOR
BRINCAR2:
	MOVF HUMACT,W			;MOVEMOS EL VALOR CONTENIDO EN HUMACT A WREG
	CPFSGT HUMEDA			;SI NUESTRO CONTENIDO DE LA VARIABLE HUMEDA ES MAYOR AL DE HUMACT ENCENDEMOS BOMBA DE AGUA, DE LO CONTRARIO LA APAGAMOS
	BRA APAGAR_BMB
	BSF PORTD,1				;ENCIENDE RD1 CORRESPONDIENTE AL ENCENDIDO DE LA BOMBA DE AGUA
	BRA BRINCAR3
APAGAR_BMB:
	BSF PORTD,1				;APAGA RD1 CORRESPONDIENTE A APAGAR LA BOMBA DE AGUA
BRINCAR3:

	MOVLW CONT1				
	MOVWF regcont1
SERIAL:						;ENVIO SERIAL DE DATOS CONTENIDOS EN LA MEMORIA RAM DE LA DIRECCION 0X800 HASTA LA 0X838 CORRESPONDIENTE A LOS DATOS QUE SE VISUALIZAN EN EL LCD
	BTFSS PIR1,TXIF
    BRA SERIAL
    NOP
    MOVFF POSTINC0,WREG
	MOVWF TXREG
    DECFSZ regcont1
    BRA SERIAL
    NOP
FININTERRUPT:
	RETFIE					;REGRESO DE LA INTERRUPCION

	END	




;CONFIGURACION DEL PIC

CONFIG 	OSC = HS 		;MODO DE OSCILADOR EXTERNO 10MHZ
CONFIG  PBADEN = OFF 	;PUERTOB CONFIGURADO COMO DIGITAL PARA SALIDAS DE LCD
CONFIG	LVP = OFF		;RB5 COMO DIGITAL
CONFIG  MCLRE = ON		;RESET ENCENDIDO

