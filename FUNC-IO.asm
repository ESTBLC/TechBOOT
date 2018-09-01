;Fichier contenant des fonctions d'entré sortie


;----------VIDEO----------
;----------MANAGE---------
;----------vidmod---------
vidmod:			;Change le mode vidéo |IN Stack1 = Code du mode choisi ((00h: text mode 40x25; 03h: text mode 80x25) 16 colors 8 pages; 13h: graphical mode 40x25 256 colors 320x200 pixels 1 page )
  pop ax		;Retrive selected mode
  xor ah, ah          	;RAZ AX car le code d'instruction : AH = 0
  int 10h             	;INT gestion affichage
  ret

;----------changepage-----
changepage:           	;Change de page |IN Stack1 = Page number
  pop ax		;Retrive page number
  mov ah, 05h         	;Code instruction chagement de page
  int 10h             	;INT gestion affichage
  ret
;----------/MANAGE--------

;----------OUTPUT---------
;----------printstr-------
printstr:	      	;Affiche une chaine de caractères |IN Stack1 = Adresse de la chaine
  pop pc
  pop si		;Retrive string adresse
  push pc
  mov ah, 0Eh	      	;Code d'instruction écriture d'un caractère

  printstr_next:
    mov al, [si]	;Déplace caractère à afficher dans AL
    cmp al, 0		;Test de fin de variable (si AL = 0)
    je printstr_stop	;Si AL = 0 nouvelle ligne
    int 10h		;INT screen manager
    inc si		;Go to next char in string
    jmp printstr_next	;Loop scan buffer

    printstr_stop:
    mov al, 13		;
    int 10h		;
    mov al, 10		;Print new line
    int 10h		;
    ret			;

;---------printchar-------
printchar:          	;Affiche un caractère |IN AL = Caractère à afficher
  pop ax		;Retrive char to print
  mov ah, 0Eh		;Code d'instruction écriture d'un caractère
  xor bx, bx		;RAZ (paramètres inutiles)
  int 10h             	;INT gestion affichage
  ret
;---------/OUTPUT---------
;---------/VIDEO----------


;---------INPUT-----------
;---------scan------------
scan:			;Wait for user entry |IN Stack1 = pointer to free memory |OUT NONE
  pop si

  scan_start:
    xor ah, ah		;ah = 0 to get a keystroke with int 16h
  
  scan_buffer:		;Check if the entry is valid
    int 16h		;INT keybord management
    cmp al, 0		;
    je scan_buffer	;If nothing has been typed loop for waiting
    
    cmp al, 13		;
    je scan_stop	;If user has pressed "ENTER" go out of loop
    
    cmp al, 8		;
    jne scan_default	;
    dec si		;If backspace has benn pressed erase of the memory the last char
    xor al, al		;
    mov [si], al	;
    jmp scan_buffer	;

    scan_default:
      mov ah, 0Eh	;Print to screen what user typed
      int 10h		;
      mov [si], al	;Write to variable
      inc si		;Step to the next adresse
      jmp scan_start	;Loop for an other entry

  scan_stop:		;When user press "ENTER"
    mov ah, 0Eh		;
    int 10h		;
    mov al, 10		;Print new line
    int 10h		;
    xor al, al		;0 in al
    mov [si], al	;Stop the string with 0
    ret			;
;---------/INPUT----------

;---------VAR-------------
;---------string_cmp------
string_cmp:
  mov al, [si]
  mov ah, [si]
  cmp al, ah
  jne string_cmp_exit
  push 0
  jne string_cmp
  push 1
  ret

  string_cmp_exit:
    xor al, al
    ret
;---------/VAR------------

;---------TIME------------
;---------delay-----------
delay:              ;Attend pendant X microsecondes | IN CX:DX = Nombres de micro secondes
  mov al, 86h
  int 15h
  ret
;---------/TIME-----------


;---------POWER MANAGEMENT
;---------REBOOT----------
REBOOT:
  int 19h
  ret
;---------/POWER MANAGEMENT


;---------STOP------------
STOP:
 ret
;---------/STOP-----------


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
