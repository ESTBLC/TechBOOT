ORG 0x7C00                      ;Adresse de début du bootlader (inchangeable)

mov al, 03h
call vidmod
mov al, 0
call changepage

xor bx, 0
mov si, OSNAME
call printstr
mov si, OSVER
call printstr

call scan

call REBOOT
	

;Variables
OSNAME: db "Techos ",0
OSVER:  db "V0.0.1",10,13,10,13,0
NEXTMEMBLOCK: db 7E00

;Inclusions
%include "FUNC-IO.asm"

;End of bootloader
times 510 - ($ - $$) db 0       ;Rempli de 0 le reste du secteur
dw 0xAA55	                ;Signature du bootloader
