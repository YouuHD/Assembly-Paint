;Proyecto U3 Paint    
;Lenguajes de Interfaz      6Y
;Equipo:
;Payan Rivera Luis Daniel
;Nevarez Lopez Fernanda Veronica

;Iniciamos a escribir el programa desde 0100h 
org 0100h   


;Declaraciones para el programa



;Variables para el cuadrado
colC1 dw ?
renC1 dw ?
colC2 dw ?
renC2 dw ?


;MACROS 
;---------------------------------------------------------------------------------------------------------
;Macro de las coordenadas
numero macro num 
 mov ax,num 
 mov bl,100d
 div bl 
 mov dl,al 
 add dl,30h 
 push ax 
 mov ah,02h 
 int 21h 
 pop ax 
 shr ax,8 
 mov bl,10d
 div bl
 mov dl,al
 add dl,30h
 push ax
 mov ah,02h
 int 21h
 pop ax
 shr ax,8d 
 mov dl,al
 add dl,30h
 mov ah,02h
 int 21h
endm


;Macro Ariana para el paint
ariana macro c r 
 ;La funcion 12 pinta el pixel   
 mov ah,0Ch 
 mov al,chayanne ;Color
 mov cx,c ;Cx=Columna donde se despliega PIXEL (empieza desde cero)
 mov dx,r ;Dx=Renglon donde se despliega PIXEL (empieza desde cero)
 int 10h ;INT 10H funcion 0CH, despliega PIXEL de color en posicion CX (Columna), DX (Renglon)
endm 
;Macro para la goma
gm macro c r
    mov ah,0Ch
    mov al, 15d
    mov cx,c
    mov dx,r
    int 10h     
endm            


jmp eti0
         
;Declaraciones para plantilla
cad db 'Error, la plantilla no se encontro... Presione una tecla para terminar.$' 
filename db "C:\pl2.bmp"  ;Ruta de la imagen
handle dw ?    ;manejador  
col dw 0 
ren dw 479   ;Por los 480 de la resolucion
buffer db ? 
colo db ? ; 

;Variables para pintar y coordenadas
col1 dw ?
ren1 dw ?
col2 dw ?
ren2 dw ?

;Color
chayanne db 0
;Tipo de herramienta
mouseHerr db 0 

;Variables para el boton, columnas y renglones
bot dw ?
c db ?
r db ?
cT db ?
rT db ?               

eti0:
 mov ah,3dh ;abre un archivo existente
 mov al,0 ;saber si se encuentra o no
 mov dx,offset filename ;DX tendr· la direccion de la ruta
 int 21h ;Archivo abierto 

 jc AmberHeard;Si hay error, salta a AmberHeard
 mov handle,ax ;Manejador de Archivo

 mov cx,118d ;Se prepara ciclo de 118 vueltas Para leer archivo en formato BMP
eti1:
 push cx
 mov ah,3fh     ;Leer del archivo
 mov bx,handle
 mov dx,offset buffer
 mov cx,1       ;Numero de Bytes a leer
 int 21h        ;Leer el archivo
 pop cx
 loop eti1
 ;Desplegar modo grafico
 mov ah,00h ;Resolucion de Pantalla
 mov al,18d ;despliegue de resolucion 640x480 a 16 colores
 int 10h ;Inicializar resolucion

eti2: 
 mov ah,3fh ;Leer del archivo
 mov bx,handle
 mov dx,offset buffer
 mov cx,1
 int 21h ;En BUFFER se almacenaran los datos leidos
 
 mov al,buffer ;4 bits superiores esta el color de un PRIMER Pixel
 and al,11110000b
 ror al,4
 mov colo,al ;Color de un PRIMER Pixel
 mov ah,0ch ;despliegue de un solo PIXEL con atributos
 mov al,colo ;Atributos del Pixel
 mov cx,col ;Columna de despliegue del PixelInstituto Tecnol√≥gico de Durango Lenguajes de Interfaz 
 mov dx,ren ;Renglon de desplieguie del Pixel
 int 10h ;pinta Pixel en coordenadas CX, DX
 
 mov al,buffer ;4 bits inferiores esta el color de un SEGUNDO Pixel
 and al,00001111b
 mov colo,al ;Color de un SEGUNDO Pixel
 inc col
 mov ah,0ch ;despliegue de un solo PIXEL con atributos
 mov al,colo ;Atributos del Pixel
 mov cx,col ;Columna de despliegue del Pixel
 mov dx,ren ;Renglon de desplieguie del Pixel
 int 10h ;pinta Pixel en coordenadas CX, DX
 inc col ;Se debe desplegar otro Pixel para dar FORMATO a la imagen
 mov ah,0ch ;despliegue de un solo PIXEL con atributos
 mov al,colo ;Atributos del Pixel
 mov cx,col ;Columna de despliegue del Pixel
 mov dx,ren ;Renglon de desplieguie del Pixel
 int 10h ;pinta Pixel en coordenadas CX, DX
 
 cmp col,639d
 jbe eti2 ;JBE=Jump if Below or Equal (salta si esta abajo o si es igual)
 
 mov col,0
 dec ren
 cmp ren,-1 ;Se compara con -1 para llegar hasta el ultimo renglon, que es el CERO
 jne eti2 ;JNE=Jump if Not Equal (salta si no es igual)

;Inicio del programa
 jmp inicio

inicio:
;Desplegamos los graficos
mov ah,00h
mov al,18d 
mov c,65d
mov r,27d
call pos    ;coordenadas

mov ax,1d
int 33h
;Metodo principal
main:
mov ax,3d
int 33h
mov col,cx
mov ren,dx
mov col1,cx
mov ren1,dx
mov bot,bx
mov c,70d
mov r,27d
call pos
numero col   ;macro coordenada columna
mov ah,02h
mov dl,' ' ;Mover a DL un espacio en blanco
int 21h
numero ren   ;macro coordenada renglon 

;Evento boton salir
cmp bot,1d
jne main          

;si se presiona, validara la zona donde se encuentra
cmp col,547d
jb AreaDibujo ;JB=Jump if Below (Brinca si esta abajo)
cmp col,638d
ja AreaDibujo ;JA=Jmp if Above (Brinca si esta arriba)
cmp ren,6d
jb AreaDibujo
cmp ren,76d
ja AreaDibujo  

jmp KarlaPanini   ;Salimos porque no la queremos 

;Area de dibujo
AreaDibujo:
cmp col,5d
jb cmplapiz ;JB=Jump if Below (Brinca si esta abajo)
cmp col,444d
ja cmplapiz ;JA=Jmp if Above (Brinca si esta arriba)
cmp ren,82d
jb cmplapiz ;JB=Jump if Below (Brinca si esta abajo)
cmp ren,450d
ja cmplapiz ;JA=Jmp if Above (Brinca si esta arriba)


;Obtener el tipo de herramienta que se presione

getHerra:
cmp mouseHerr,0d    ;Compara si vale 0. 
jne getLapiz 

getLapiz:
cmp mouseHerr,1d
jne getGoma
call lapiz
jmp main  

getGoma:
cmp mouseHerr,2d
jne getBrocha
call goma
jmp main 

getBrocha:
cmp mouseHerr,3d  
jne getSpray
call brocha
jmp main 

getSpray:
cmp mouseHerr,4d
jne getLinea 
call spray
jmp main 

getLinea:
cmp mouseHerr,5d
jne getCuadro 
call line
jmp main 

getCuadro:
cmp mouseHerr,6d
call cuad
jmp main 


;comparaciones 
cmplapiz:
;Validacion de area para herramienta de lapiz
cmp col,93d
jb cmpgoma 
cmp col,180d
ja cmpgoma 
cmp ren,6d
jb cmpgoma 
cmp ren,76d
ja cmpgoma 
mov mouseHerr,1d
jmp main

cmpgoma:
;Validacion de area para herramienta de goma
cmp col,3d
jb cmpbrocha 
cmp col,90d
ja cmpbrocha 
cmp ren,6d
jb cmpbrocha 
cmp ren,76d
ja cmpbrocha 
mov mouseHerr,2d
;texto cad2
jmp main

cmpbrocha:
;Validacion de area para herramienta de pincel
cmp col,185d
jb Aero 
cmp col,270d
ja Aero 
cmp ren,6d
jb Aero
cmp ren,76d
ja Aero 
mov mouseHerr,3d
;texto cad3
jmp main
          
Aero:
;Aero
cmp col,274d
jb linea 
cmp col,360d
ja linea 
cmp ren,6d
jb linea 
cmp ren,76d
ja linea 
mov mouseHerr,4d
;texto cad3
jmp main
    
linea:
;Linea
cmp col,365d
jb cuadro 
cmp col,452d
ja cuadro 
cmp ren,6d
jb cuadro 
cmp ren,76d
ja cuadro 
mov mouseHerr,5d
;texto cad3
jmp main
                  
cuadro:
;Cuadrado
cmp col,455d
jb setColor 
cmp col,545d
ja setColor 
cmp ren,6d
jb setColor 
cmp ren,76d
ja setColor 
mov mouseHerr,6d
;texto cad3
jmp main
    
;Colores
setColor:
 
cmp col,478d
jb setAzul 
cmp col,554d
ja setAzul 
cmp ren,210d
jb setAzul
cmp ren,274d
ja setAzul
mov chayanne,0d ; Se asigna color negro
call setCol 
jmp main
;Azul bonito
setAzul: 
cmp col,557d
jb setMarron 
cmp col,633d
ja setMarron 
cmp ren,278d
jb setMarron
cmp ren,341d
ja setMarron
mov chayanne,00001001b ; Se asigna color Azul bonito
call setCol
jmp main 
;Marron
setMarron: 
cmp col,478d
jb setRojo 
cmp col,554d
ja setRojo 
cmp ren,278d
jb setRojo
cmp ren,341d
ja setRojo
mov chayanne,00000110b ; Se asigna color marron
call setCol
jmp main

;rojo
setRojo:
cmp col,557d
jb setAmarillo 
cmp col,633d
ja setAmarillo
cmp ren,210d
jb setAmarillo
cmp ren,274d
ja setAmarillo
mov chayanne,00001100b ; Se asigna rojo
call setCol
jmp main    
;Amarillo
setAmarillo:
cmp col,478d
jb setGris 
cmp col,554d
ja setGris 
cmp ren,334d
jb setGris
cmp ren,410d
ja setGris
mov chayanne,00001110b ; Se asigna color amarillo
call setCol
jmp main
;gris
setGris:
cmp col,557d
jb setCyan 
cmp col,633d
ja setCyan 
cmp ren,334d
jb setCyan
cmp ren,410d
ja setCyan
mov chayanne,00000111b ; Se asigna color gris
call setCol
jmp main
;cyan
setCyan:
cmp col,478d
jb setAC 
cmp col,554d
ja setAC 
cmp ren,410d
jb setAC
cmp ren,479d
ja setAC
mov chayanne,00000011b ; Se asigna color cyan
call setCol
jmp main
;azul chido
setAC:
cmp col,557d
jb main 
cmp col,633d
ja main 
cmp ren,410d
jb main
cmp ren,479d
ja main
mov chayanne,00000001b ; Se asigna color azul chido
call setCol
jmp main
 

;PROCEDIMIENTOS
;------------------------------------------------------------------------------------------------

;Posicion
pos proc
 mov ah,02h
 mov dl,65d
 mov dh,8d
 mov bh,0d
 int 10h
 ret
endp

setCol proc
 mov dx,378d 

 mov cx,90d
 
 mov ah,0ch
 mov al,chayanne
 int 10h
 inc cx
 cmp cx,111d
 inc dx
 cmp dx,398d

ret
endp   

 
;Colores
 Blanco proc
     mov ah,0Ch 
     mov al,00001111b  
     int 10h
     jmp eti0
     ret
 Negro proc
     mov ah,0Ch 
     mov al,00000000b
     ret 
 GrisO proc
    mov ah,0Ch 
    mov al,00001000b
    ret 
 Azul proc
    mov ah,0Ch 
    mov al,00000001b  
    ;mov cx,c
    ;mov dx,r
    int 10h
    jmp eti0
    ret
 AzulIns proc
    mov ah,0Ch 
    mov al,00001001b
    ret    
 Verde proc
    mov ah,0Ch 
    mov al,00000010b
    ret       
 VerdeIns proc
    mov ah,0Ch 
    mov al,00001010b
    ret
 Cian proc
    mov ah,0Ch 
    mov al,00000011b
    ret 
 CianIns proc
    mov ah,0Ch 
    mov al,00001011b
    ret     
 Rojo proc
    mov ah,0Ch 
    mov al,00000100b
    ret    
 RojoIns proc
    mov ah,0Ch 
    mov al,00001100b
    ret 
 Magenta proc
    mov ah,0Ch 
    mov al,00000101b
    ret    
 MagIns proc
    mov ah,0Ch 
    mov al,00001101b
    ret    
 Marron proc
    mov ah,0Ch 
    mov al,00000110b
    ret    
 Amarillo proc
    mov ah,0Ch 
    mov al,00001110b
    ret    
 GrisC proc
    mov ah,0Ch 
    mov al,00000111b
    ret      

;HERRAMIENTAS
;----------------------------------------------------------------------------------------------
; Herramienta de lapiz pinta un pixel 
lapiz proc
 call apaga
 ; Pinta pixel con macro ariana
 ariana col1 ren1
 call prende
endm 
ret
endp   

    
; herramienta de goma pinta un pixel de color blanco
goma proc
     call apaga
     ;Llamamos a la macro de la goma varias veces e incrementamos la columna
     gm col1 ren1
     inc col1   ;Se incrementa para agregar mas pixeles a la herramienta
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1 
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
     inc col1
     gm col1 ren1
 
     call prende
endm 
ret
endp

;Herramienta brocha
brocha proc 
    call apaga
    ;Llamamos a la macro de dibujo para pintar varios pixeles a lavez
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1  
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    inc col1
    ariana col1 ren1
    
    call prende    
endm 
ret
endp
; procedimiento para dibujar el spray
spray proc 
    call apaga

    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    dec ren1
    ariana col1 ren1
    dec col1 
    
    ariana col1 ren1
    dec ren1  
    ariana col1 ren1
    dec col1 
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    dec col1 
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    dec col1 
    ariana col1 ren1
    dec ren1  
    ariana col1 ren1   
    
    ariana col1 ren1
    dec col1 
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    dec ren1
    ariana col1 ren1
    dec col1 
    
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    dec ren1  
    ariana col1 ren1
    
    ariana col1 ren1
    inc ren1  
    ariana col1 ren1
    dec col1 
    ariana col1 ren1
    dec ren1  
    ariana col1 ren1
    inc col1 
    ariana col1 ren1
    dec ren1  
    ariana col1 ren1
    
    call prende            
endm 
ret
endp  
     
lins proc
   mov cx,colC1
   mov dx,renC1
    cetill: ;Inicia proceso para dibujar linea superior horizontal
     mov ah,0ch
     mov al,chayanne
     int 10h
     inc cx
     cmp cx,colC2
     jbe cetill 


ret  
endp
     
     
    endp     
;Procedimiento de linea     
line proc 
   etil0: 
        mov ax, 3d
        int 33h
        cmp bx,1d
        jne etil0
    
    mov colC1,cx
    mov renC1,dx
        
    etil:
     mov ax,3d
     int 33h
     cmp bx,2d
     jne etil
     mov colC2,cx
     mov renC2,dx
     mov ax,2d 
     call lins
ret 
endp  
 


;Cuadrado
cdo proc
 mov cx,colC1
 mov dx,renC1
ceti2: ;Inicia proceso para dibujar linea superior horizontal
 mov ah,0ch
 mov al,chayanne
 int 10h
 inc cx
 cmp cx,colC2
 jbe ceti2 ;JBE=Jump if Below or Equal (Salta si esta abajo, o si es Igual)
 
 mov cx,colC1
 mov dx,renC2
 ceti3: ;Inicia proceso para dibujar linea inferior horizontal
 mov ah,0ch
 mov al,chayanne
 int 10h
 inc cx
 cmp cx,colC2
 jbe ceti3
 
 mov cx,colC1
 mov dx,renC1
 ceti4: ;Inicia proceso para dibujar linea izquierda vertical
 mov ah,0ch
 mov al,chayanne
 int 10h
 inc dx
 cmp dx,renC2
 jbe ceti4
 
 mov cx,colC2
 mov dx,renC1
 ceti5: ;Inicia proceso para dibujar linea derecha vertical
 mov ah,0ch
 mov al,chayanne
 int 10h
 inc dx
 cmp dx,renC2
 jbe ceti5
ret  
endp


cuad proc 
    etiC00: 
        mov ax, 3d
        int 33h
        cmp bx,1d
        jne etiC00
    
    mov colC1,cx
    mov renC1,dx
        
    etiC:
     mov ax,3d
     int 33h
     cmp bx,2d
     jne etiC
     mov colC2,cx
     mov renC2,dx
     mov ax,2d 
     call cdo
ret
endp  


;Metodo para cerrar el programa    
fin:
 call apaga ;Apaga raton
 call cierragraf ;Cierra graficos
 int 20h ;Termina el programa  
  
;Prender el raton
prende proc
 mov ax,1d
 int 33h
 ret
endp             
;Apaga el raton
apaga proc
 mov ax,2d
 int 33h
 ret           
endp           
;iniciar graficos
inigraf proc
 mov ah,0d
 mov al,18d
 int 10h
 ret
endp             
;Cerrar los graficos
cierragraf proc
 mov ah,0d
 mov al,3d
 int 10h
 ret  

;Salir  
AmberHeard: 
     mov ah,09h
     lea dx,cad
     int 21h 
     mov ah,07h
     int 21h 
     int 20h
endp

KarlaPanini:
    mov ah,00h
    mov al,3d
    int 10h
    int 20h
    endp

 


