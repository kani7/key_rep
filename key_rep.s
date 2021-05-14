* X680x0のキーリピート設定をSRAMから読み出し、キーボードに反映する
*   by kani7
*   GPL2.0
*   2021-05-15 多分動く版

	.include	DOSCALL.MAC
	.include	IOCSCALL.MAC

FIRST_KY	equ $00ed_003a		* キーリピート開始までの待ち時間
NEXT_KEY	equ $00ed_003b		* キーリピート間隔

_KEYDLY		equ $08
_KEYREP		equ $09

	.text

start:
	lea.l	user_stack(PC),SP

	lea.l	FIRST_KY,A1
	IOCS	_B_BPEEK
	move.l	D0,D1
	IOCS	_KEYDLY

	lea.l	NEXT_KEY,A1
	IOCS	_B_BPEEK
	move.l	D0,D1
	IOCS	_KEYREP

	pea.l	help_msg(PC)
	DOS	_PRINT
	add.l	#4,SP
	DOS	_EXIT

	.data
help_msg:
	dc.b	'Sent key repeat setting commands using stored value on SRAM.',$0d,$0a,$00
	.even

	.stack
	ds.l	256
user_stack:

	.end	start
