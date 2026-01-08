org 0x7c00

TEXT_COLOR			equ	0x0000		;[1]Kolor(atrybut) tekstu.

TEXT_HEX_BUFF		equ	0x0002		;[2]Bufor wartości szesnastkowej.


TEXT_DEF_COLOR		equ 0x07		;Kolor(atrybut) domyślny tekstu.

mov byte[cs:TEXT_COLOR], TEXT_DEF_COLOR

;;Testowe generowanie znaków w różnych trybach graficznych.
bits 16
test_charGen:
	xor ax, ax
	mov bl, 0x00
	push cs
	pop ds
	mov si, .STR_MODE
	.nextMode:
		push ax
		call text_newLine
		mov al, bl
		int 0x10
		call test_textColor
		call text_newLine
		call text_strz
		mov al, bl
		inc bl
		call text_hex
;		xor ax, ax
;		int 0x16
;		call text_newLine
;		call test_charMap
		xor ax, ax
		int 0x16
		pop ax
		jmp .nextMode

.STR_MODE db "Tryb graficzny: ", 0

;;Testowe wyświetlanie tablicy znaków.
bits 16
test_charMap:
	push ax
	push bx
	push cx
	mov bx, 0x0007
	mov al, 16
	mov cx, 256-16
	.nextChar:
		push cx
		test cx, 0x000f
		jnz .skipNL
		call text_newLine
	.skipNL:
		mov ah, 0x09
		mov cx, 1
		int 0x10
		mov ah, 0x0e
		int 0x10
		inc al
		pop cx
		loop .nextChar
	pop cx
	pop bx
	pop ax
	ret

;;Testowe wyświetlanie kolorowych napisów.
bits 16
test_textColor:
	push bx
	push cx
	push si
	xor bl, bl
	mov cx, 256
	push cs
	pop ds
	mov si, .STR_TEST
	.nextTest:
		mov [cs:TEXT_COLOR], bl
		call text_strz
		inc bl
		loop .nextTest
	pop si
	pop cx
	pop bx
	ret

.STR_TEST db "Test ", 0

;;Przejście kursora do nowej linii.
bits 16
text_newLine:
	push ax
	push bx
	push cx
	push dx
	mov ah, 0x03
	xor bh, bh
	int 0x10
	cmp dh, 24
	jb .setCursor
	push dx
	mov ax, 0x0601
	mov bh, 0x00
	xor cx, cx
	mov dx, 0x184f
	int 0x10
	pop dx
	dec dh
.setCursor:
	mov ah, 0x02
	inc dh
	xor bh, bh
	mov dl, bh
	int 0x10
.end:
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;;Wyświetlanie wartości 8-bitowej szesnastkowej.
;AL <- Wartość do wyświetlenia
bits 16
text_hex:
	push bx
	push cx
	push si
	push ds
	movzx bx, al
	shr bl, 4
	lea si, [.HEX_DIGITS+bx]
	push cs
	pop ds
	mov bl, [si]
	mov [ds:TEXT_HEX_BUFF+0], bl
	movzx bx, al
	and bl, 0b1111
	lea si, [.HEX_DIGITS+bx]
	mov bl, [si]
	mov [cs:TEXT_HEX_BUFF+1], bl
	mov si, TEXT_HEX_BUFF
	mov cx, 2
	call text_chars
	pop ds
	pop si
	pop cx
	pop bx
	ret

.HEX_DIGITS:
	db 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37
	db 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46

;;Wyświetlanie tekstu.
;DS:SI <- Adres łańcucha zakończonego zerem
bits 16
text_strz:	
	push ax
	push bx
	push cx
	push si
	movzx bx, byte[cs:TEXT_COLOR]
	mov cx, 1
	.next:
		mov ah, 0x09
		lodsb
		or al, al
		jz .end
		int 0x10
		mov ah, 0x0e
		int 0x10
		jmp .next
.end:
	mov byte[cs:TEXT_COLOR], TEXT_DEF_COLOR
	pop si
	pop cx
	pop bx
	pop ax
	ret

;;Wyświetlanie danej liczby znaków.
;DS:SI <- Adres znaków
;CX <- Ilość znaków
bits 16
text_chars:
	push ax
	push bx
	push cx
	push si
	movzx bx, byte[cs:TEXT_COLOR]
	.next:
		push cx
		mov ah, 0x09
		mov cx, 1
		lodsb
		int 0x10
		mov ah, 0x0e
		int 0x10
		pop cx
		loop .next
.end:
	mov byte[cs:TEXT_COLOR], TEXT_DEF_COLOR
	pop si
	pop cx
	pop bx
	pop ax
	ret

times 510-($-$$) db 0
dw 0xaa55

;;END
