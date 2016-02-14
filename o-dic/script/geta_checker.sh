#!/bin/sh
#
# 辞書ファイル内の JIS X 0208 に含まれていない文字を検出するためのスクリプト
#							山城 潤
#   $ ./geta_checker.sh
#	...UTF-8で差分を出力...
#
# このスクリプトの実行にはnkf(1)が必要です。
# https://sourceforge.jp/projects/nkf/

script_dir=`dirname $0`
for i in $script_dir/../*.dic
do
    to_file=`mktemp /tmp/geta.XXXXXXX`
    utf8_file=`mktemp /tmp/geta.XXXXXXX`

    # UTF-8 -> Shift_JIS -> UTF-8_2
    nkf -s "$i" > "$to_file"
    nkf -u "$to_file" > "$utf8_file"

    # UTF-8 と UTF-8_2 の差分を取って〓の位置を確認する。
    if ! diff -u "$i" "$utf8_file"; then
	echo "$i: Geta exists." 1>&2
    fi

    rm "$to_file"
    rm "$utf8_file"
done

