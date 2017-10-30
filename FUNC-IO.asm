;Fichier contenant des fonctions d'entré sortie

;Memory
malloc:


;------------------------------------------------------------------------VIDEO-----------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
vidmod:             ;Change le mode vidéo |IN AL = Code du mode choisi ((00h: text mode 40x25; 03h: text mode 80x25) 16 colors 8 pages; 13h: graphical mode 40x25 256 colors 320x200 pixels 1 page )
xor ah, ah          ;RAZ AX car le code d'instruction : AH = 0
int 10h             ;INT gestion affichage
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
changepage:         ;Change de page |IN AL = Numéro de la page
mov ah, 05h         ;Code instruction chagement de page
int 10h             ;INT gestion affichage
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
printstr:			;Affiche une chaine de caractères |IN SI = Adresse de la chaine
mov ah, 0Eh			;Code d'instruction écriture d'un caractère
;xor bx, bx			;RAZ (paramètres inutiles)

print_next:
mov al, [si]		;Déplace caractère à afficher dans AL
cmp al, 0			;Test de fin de variable (si AL = 0)
jz STOP				;Si AL = 0 nouvelle ligne

int 10h				;INT gestion affichage
inc si				;Caractère suivant
jmp print_next	    ;Boucle affichage

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
printchar:          ;Affiche un caractère |IN AL = Caractère à afficher
mov ah, 0Eh			;Code d'instruction écriture d'un caractère
xor bx, bx			;RAZ (paramètres inutiles)
int 10h             ;INT gestion affichage
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------PERIHERIQUE-----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
scan:
xor ah, ah
scan_buffer:
int 16h
cmp al, 0
je scan_buffer
cmp al, 13
je scan_stop
call printchar
jmp scan

scan_stop:
call printchar
mov al, 10
call printchar
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------TEMPS-----------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
delay:              ;Attend pendant X microsecondes | IN CX:DX = Nombres de micro secondes
mov al, 86h
int 15h
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------POWER MANAGEMENT------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
REBOOT:
int 19h
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
STOP:
ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------INSTRUCTIONS----------------------------------------------------------------------------------
;INT 10H = AFFICAHGE {
    ;02h = Définir possition curseur | IN BH = Numéro de page ; DH = Ligne ; DL = Colonne
    ;03h = Lecture possition curseur | IN BH = Numéro de page | OUT DH = Ligne ; DL = Colonne
    ;0Eh = Afficher un caractère + possition curseur + 1 | IN AL = Caractère ; BH = Numéro de page ; BL = Couleur
;}

;INT 16h = CLAVIER {
    ;00h = Lecture buffer + supression | OUT AH = Touche préssée ; AL = ASCII caractère
    ;01h = Test buffer | OUT AH = Touche préssée ; AL = ASCII caractère
;}
