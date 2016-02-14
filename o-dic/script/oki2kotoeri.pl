#!/usr/bin/perl
#
# oki2kotoeri.pl - 沖縄辞書のファイルをことえり3.1で読み込める形式のテキストに変換
#
#		$Id: oki2kotoeri.pl,v 1.8 2006/09/01 18:20:06 void Exp $
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成してください。
#     $ cat *.dic | script/oki2kotoeri.pl | sort -u > okinawa.txt
# 読みは20文字以内、単語は32文字以内です。
# 
# メニューバーのことえりメニューから[単語登録/辞書編集...]を選び、
# 「ことえり単語登録」ダイアログを出す。
# メニューバーの[辞書]メニューの[新規ユーザ辞書の作成...]を選び
# 別名で保存欄に『okinawa.dic』と記入。
# このときに[場所]が『Dictionaries』になっていることを確認して、[保存]ボタンを押す。
# (すでに同名のファイルがある場合は別のディレクトリーにするのではなく、
# 別のファイル名にしておいてあとでなんとかする。そのディレクトリーじゃないとうまくいかないようだ)
# 『ユーザー辞書』、『指定変換辞書』の指定はdefaultのままでOK。
# [ことえり単語登録]ダイアログ上部の[辞書]のところで『okinawa.dic』を選ぶ。
# メニューバーの[辞書]メニューの[テキストや辞書から取り込む...]を選び、
# ここで先ほど生成しておいた『okinawa.txt』を指定。(選んで[開く]を押す)

require 5.6.0;
use FindBin;
use lib $FindBin::Bin;  # For search scripts/ODIC.pm
require 'ODIC.pm';
use strict;
our $phonate;
our $word;
our $class;

while (<>) {
	# JIS X 0208 に含まれていない文字を含む行を読み飛ばす
	# 読み飛ばしにはコメントに「〓あり」マーカーが必要
	next if (/〓あり/);

	s/#.*$//;		# `#'以降を取り去る
	next if (/^\s*$/);	# その結果空行になった行は読み飛ばす。
	if (/(\S+)\s+(\S+)\s+(\S+)/) {
		$phonate = $1;	# 読み
		$word    = $2;	# 単語
		$class   = $3;	# 品詞
		ODIC::check_phonate($phonate);
		ODIC::check_word($word);
		&convert_class;
	}
	else {
		print STDERR "Error: $.: too few field number `$_'\n";
		print  "$_";
	}
}
&version;
exit 0;


sub convert_class {
	if ($class eq "普通名詞") {			# OK
	}
	elsif ($class eq "サ変名詞") {			# OK
	}
	elsif ($class eq "形動名詞") {
	}
	elsif ($class eq "姓") {
	}
	elsif ($class eq "名") {
	}
	elsif ($class eq "その他の人名") {
	}
	elsif ($class eq "単純地名") {
	}
	elsif ($class eq "接尾語付き地名") {
	}
	elsif ($class eq "組織名") {
	}
	elsif ($class eq "その他固有名詞") {
		$class = 'その他の固有名詞';
	}
	elsif ($class eq "副詞") {
	}
	elsif ($class eq "接続詞") {
	}
	elsif ($class eq "感動詞") {
	}
	elsif ($class eq "形容詞") {			# OK
	}
	elsif ($class eq "形容動詞") {			# OK
	}
	elsif ($class eq "接頭語") {			# *
		$class = '普通名詞';
	}
	elsif ($class eq "数字列接頭語") {		# OK
	}
	elsif ($class eq "接尾語") {			# *
		$class = '普通名詞';
	}
	elsif ($class eq "人名接尾語") {
	}
	elsif ($class eq "地名接尾語") {
	}
	elsif ($class eq "組織名接尾語") {
	}
	elsif ($class eq "数字列接尾語") {
	}
	elsif ($class eq "成句") {
	}
	elsif ($class eq "無品詞") {			# OK
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
	}
	print ODIC::to_shiftjis("$phonate,$word,$class\r\n");
}


sub version {
	my $sec;
	my $min;
	my $hour;
	my $mday;
	my $mon;
	my $year;

	($sec, $min, $hour, $mday, $mon, $year) = localtime(time());
	$year += 1900;
	$mon++;
	print ODIC::to_shiftjis("おきなわじしょのひづけ,$year年$mon月$mday日(沖縄辞書の日付け),無品詞\r\n");
}
