# X680x0のキーリピート設定を即時反映する

## 概要
X680x0のキーリピート設定は `switch.x` から行う事ができますが、
設定を反映させるには本体の再起動が必要です。

このプログラムは `switch.x` がSRAMに保存したキーリピート設定の内容を読み出し、
これを即時にキーボードへ反映させるものです。

また、X680x0の現在の入力モードに合わせて、キーボードLEDを再設定します。

## 使い方
引数はありません。ヘルプメッセージもありません。
- SRAMに設定済みの内容をキーボードに反映する
	```
	key_rep
	```
- 出荷時設定に戻す
	```
	switch FIRST_KY=3 NEXT_KEY=4
	key_rep
	```
- キーリピート開始までの時間を最長(1700ms)、キーリピート間隔を最短(30ms)に変更する
	```
	switch FIRST_KY=15 NEXT_KEY=0
	key_rep
	```
`switch.x` における引数と時間の関係はマニュアルを見るか、オプション無しで `switch.x` を起動して確認してください。

## 補足
X680x0はIPL時にのみ、キーリピート設定の制御コマンドを送信しています。  
純正のキーボードを直結しているなら何の問題も無いのですが、キーボード変換機や切替器などを使っている場合、意図した通りになるとは限りません。  
設定を反映させるためだけに本体を再起動させたくないというのが、このプログラムが作成された理由です。

## ビルド方法
XC2.1を使っていますが、準拠するアセンブラ/リンカなら問題ありません。
```
as key_rep.s
lk key_rep.o
```
で実行ファイルが得られる筈です。

.r 形式の実行ファイルが必要なら、上記に続けて
```
cv key_rep.x
```
としてください。

## 謝辞
作成にあたって主に以下のツールを使用させていただきました。  
関係する皆様には深く感謝申し上げます。
- 無償公開されたシャープのソフトウェア  
	http://retropc.net/x68000/software/sharp/
- XM6g  
	http://retropc.net/pi/xm6/
- X680x0 GNU LIBC  
	http://retropc.net/x68000/software/develop/lib/


# X680x0 key repeat setting assistant

## Description
Send key repeat setting commands using stored value on SRAM.

## Usage
Just run it. No options required.
- Send key repeat setting commands using stored value on SRAM.
	```
	key_rep
	```
- Restore factory defaults.
	```
	switch FIRST_KY=3 NEXT_KEY=4
	key_rep
	```
- Set maximum first key repeat delay(1700ms) and minimum key repeat interval(30ms).
	```
	switch FIRST_KY=15 NEXT_KEY=0
	key_rep
	```
For `switch.x` detail, see "Human68k User's manual".

## Note
X680x0 sends key repeat settings commands to keyboard only at IPL.  
This programs will be useful with keyboard converter and/or KVM switch etc.

## Build
Use XC2.1 or equivalent.

## Special Thanks
- SHARP X680x0 software released free of charge  
	http://retropc.net/x68000/software/sharp/
- XM6g  
	http://retropc.net/pi/xm6/
- X680x0 GNU LIBC  
	http://retropc.net/x68000/software/develop/lib/
