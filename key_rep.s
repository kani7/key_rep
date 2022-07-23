* X680x0のキーリピート設定をSRAMから読み出し、キーボードに反映する
*   by kani7
*   GPL2.0
*   2021-05-15 多分動く版
*	2021-05-19 LED設定も反映するようにした
*	2022-07-14 OPT.2キーをテレビコントロールに使用するか否かの設定も反映するようにした

	.include	DOSCALL.MAC
	.include	IOCSCALL.MAC

FIRST_KY	equ $00ed_003a		* キーリピート開始までの待ち時間
NEXT_KEY	equ $00ed_003b		* キーリピート間隔
OPT2TV		equ $00ed_0027		* OPT.2 キーをテレビコントロールに使用するか(0:使用する 1:しない)

MFP_TSR		equ $00e8_802d		* MFPのTSR(送信状態レジスタ)
MFP_UDR		equ $00e8_802f		* MFPのUDR(送信データレジスタ)

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
	or.b	#%01011100,D1	* キーボード宛のコマンド(今回は上位6ビット)+設定値(下位2ビット)
mfp_wait:
	lea.l	MFP_TSR,A1		* MFPのTSRの
	IOCS	_B_BPEEK		*
	btst.l	#7,D0			*	BEフラグ(bit7)を確認する
	beq	mfp_wait		* 送信バッファが空でなければループして待つ
	lea.l	MFP_UDR,A1		* MFPのUDRに
	IOCS	_B_BPOKE		*	制御コマンド(D1)を書き込む

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
