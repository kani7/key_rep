* X680x0�̃L�[���s�[�g�ݒ��SRAM����ǂݏo���A�L�[�{�[�h�ɔ��f����
*   by kani7
*   GPL2.0
*   2021-05-15 ����������
*	2021-05-19 LED�ݒ�����f����悤�ɂ���
*	2022-07-14 OPT.2�L�[���e���r�R���g���[���Ɏg�p���邩�ۂ��̐ݒ�����f����悤�ɂ���

	.include	DOSCALL.MAC
	.include	IOCSCALL.MAC

FIRST_KY	equ $00ed_003a		* �L�[���s�[�g�J�n�܂ł̑҂�����
NEXT_KEY	equ $00ed_003b		* �L�[���s�[�g�Ԋu
OPT2TV		equ $00ed_0027		* OPT.2 �L�[���e���r�R���g���[���Ɏg�p���邩(0:�g�p���� 1:���Ȃ�)

MFP_TSR		equ $00e8_802d		* MFP��TSR(���M��ԃ��W�X�^)
MFP_UDR		equ $00e8_802f		* MFP��UDR(���M�f�[�^���W�X�^)

_LEDSET		equ $07
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

	IOCS	_LEDSET

	lea.l	OPT2TV,A1
	IOCS	_B_BPEEK
	move.l	D0,D1
	eori.b	#1,D1
	or.b	#%01011100,D1	* �L�[�{�[�h���̃R�}���h(����͏��6�r�b�g)+�ݒ�l(����2�r�b�g)
mfp_wait:
	lea.l	MFP_TSR,A1		* MFP��TSR��
	IOCS	_B_BPEEK		*
	btst.l	#7,D0			*	BE�t���O(bit7)���m�F����
	beq	mfp_wait		* ���M�o�b�t�@����łȂ���΃��[�v���đ҂�
	lea.l	MFP_UDR,A1		* MFP��UDR��
	IOCS	_B_BPOKE		*	����R�}���h(D1)����������

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
