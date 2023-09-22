;PRACTICA 03 ENCENDER 3 LED'S, EL PRIMERO ENCENDIDO Y EL RESTO APAGADO
;							   EL SEGUNDO ENCENDIDO Y EL RESTO APAGADO
;							   EL TERCERO ENCENDIDO Y EL RESTO APAGADO
;Realizo:
;Fecha:
;Ver:

;F=16mhz = 16x10^[6]
;T=1/F = 1/16x10^[6] =0.0625

.org 0X00       ;empieza a escribir codigo en la menoria 0 del microprocesador

rjmp inicio     ;Salto hacia la etiqueta //// Tiempo que se tarda en hacer la instruccion 
inicio:

ldi r16,low(RAMEND)			;cada imnediatamente un valor (RAMEND) en el registro (r16)
out SPL,r16					;mueve el valor del registro a la pila (spl)
ldi r16,high(RAMEND)
out SPH,r16

ldi r16, 0xFF			;almacena puros 1 en r16=0B11111111 valor maximo de 64bits (255)

out DDRB, r16			;todas las terminales van a funcionar como salidas 8-13

;Inicio del programa

ciclo:
;sbi led encendido y cbi Led apagado

; Encender el primer LED (pin 8) y apagar los otros dos
sbi PORTB, 0  ; establecer el bit correspondiente al pin 8 en PORTB
cbi PORTB, 1  ; borrar el bit correspondiente al pin 9 en PORTB
cbi PORTB, 2  ; borrar el bit correspondiente al pin 10 en PORTB
rcall Retraso05     ; esperar medio segundo

; Encender el segundo LED (pin 9) y apagar los otros dos
cbi PORTB, 0  ; borrar el bit correspondiente al pin 8 en PORTB
sbi PORTB, 1  ; establecer el bit correspondiente al pin 9 en PORTB
cbi PORTB, 2  ; borrar el bit correspondiente al pin 10 en PORTB
rcall Retraso05     ; esperar medio segundo

; Encender el tercer LED (pin 10) y apagar los otros dos
cbi PORTB, 0  ; borrar el bit correspondiente al pin 8 en PORTB
cbi PORTB, 1  ; borrar el bit correspondiente al pin 9 en PORTB
sbi PORTB, 2  ; establecer el bit correspondiente al pin 10 en PORTB
rcall Retraso05     ; esperar medio segundo

rjmp ciclo ; Vuelve al inicio del ciclo


;---------------------------------------------------------------------------------------
;Sub-Rutinas

Retraso05:
ldi	R16,31
exter_Reta:
ldi	R24,low(1021)		;Low(1021)		;almaceno la parte baja de 1021 en R24
ldi	R25,high(1021)		;high(1021)		;Añmaceno la parte alta de 1021 en R25

retar_ciclo:

adiw	R24,1			;toma solamente los primeros 16 registros y verifica si existe un 1 o 0
				;Va sumando de uno en uno y cuando....
brne	retar_ciclo		;Cuando rebasa los 16 bits (65536) se sale del ciclo
				;

dec	R16			;disminuye en una unidad el registro R16 hasta que llegue a cero
				;salta a "exter_Reta"
brne	exter_Reta	
;262145 + 1 (dec) + 2(brne)  = 262148 * 31 = 8126488
;126588 / 31 = 4083 deberia empezar aqui para que sea el medio segundo exacto
;adiw y brne consume 4 ciclos y esos se deben dividir entre 4 para que desde ahi se empiece ahi y se cumpla el medio segundo

ret