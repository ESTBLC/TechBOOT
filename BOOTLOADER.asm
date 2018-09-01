ORG 0x7C00                      ;Adresse de début du bootlader (inchangeable)

mov ax, stack_top
mov ss, ax
mov ax, stack_bot
mov sp, ax 

;push 03h
;call vidmod

push OSNAME
call printstr

;push string
;call scan
;push string 
;call printstr

STOP_OS:
ret

;Inclusions
%include "FUNC-IO.asm"

;Variables
OSNAME: db "Techos V0.1",13,10,0
string: db 0,0,0,0,0,0,0,0,0,0,0

stack_bot:
 times 10 dw 0
stack_top:

;End of bootloader
times 510 - ($ - $$) db 0       ;Rempli de 0 le reste du secteur
dw 0xAA55	                ;Signature du bootloader
