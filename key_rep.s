* X680x0�̃L�[���s�[�g�ݒ��SRAM����ǂݏo���A�L�[�{�[�h�ɔ��f����
*   by kani7
*   GPL2.0
*   2021-05-15 ����������

	.include	DOSCALL.MAC
	.include	IOCSCALL.MAC

FIRST_KY	equ $00ed_003a		* �L�[���s�[�g�J�n�܂ł̑҂�����
NEXT_KEY	equ $00ed_003b		* �L�[���s�[�g�Ԋu

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
