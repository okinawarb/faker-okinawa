#!/usr/bin/perl
#
# oki2kotoeri.pl - 沖縄辞書のファイルをことえり3.1で読み込める形式のテキストに変換
#
#		$Id: oki2kotoeri.pl,v 1.1.1.1 2005/11/04 00:14:15 ga2 Exp $
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成してください。
#     $ nkf -e *.dic | ./oki2kotoeri.pl | sort -u | nkf -s > okinawa.txt
# 読みは20文字以内、単語は32文字以内です。
# 
# メニューバーの鉛筆メニューから「単語登録/辞書編集...」を選び、
# 「ことえり単語登録」ダイアログを出す。
# メニューバーの「辞書」メニューの「新規ユーザー辞書の作成...」を選び
# 別名で保存欄に「okinawa.dic」と記入。このときに「場所」が「Dictionaries」に
# なっていることを確認して、「保存」ボタンを押す。
# 「ことえり単語登録」ダイアログ上部の「辞書」のところで「okinawa.dic」を選ぶ。
# メニューバーの「辞書」メニューの「テキストや辞書から取り込む...」を選び、
# ここで先ほど生成しておいた「okinawa.txt」を指定。(選んで「開く」を押す)
require 5.6.0;
use strict;
our $phonate;
our $word;
our $class;

while (<>) {
	s/#.*$//;		# `#'移行を取り去る
	next if (/^\s*$/);	# その結果空行になった行は読み飛ばす。
	if (/(\S+)\s+(\S+)\s+(\S+)/) {
		$phonate  = $1;	# 読み
		$word = $2;	# 単語
		$class = $3;	# 品詞
		&check_phonate;
		&check_word;
		&convert_class;
	}
	else {
		print STDERR "Error: $.: too few field number `$_'\n";
		print  "$_";
	}
}
&version;
exit 0;


sub check_phonate
{
	if (length($phonate) > 40) {
		print STDERR "Warning: $.: too long phonate `$phonate'\n";
	}
	if ($phonate =~ /[^あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろがぎぐげござじずぜぞだぢづでどばびぶべぼぁぃぅぇぉっょゃゅゎぱぴぷぺぽやゆよわをんヴー]/) {
		print STDERR "Warning: $.: ilegal character in `$phonate'\n";
	}
}


sub check_word
{
	if (length($word) > 64) {
		print STDERR "Warning: $.: too long word `$word'\n";
	}
	if ($word =~ /[ \t",#]/) {
		print STDERR "Warning: $.: ilegal character in `$word'\n";
	}
}


sub convert_class {
	if ($class eq "普通名詞") {			# OK
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "サ変名詞") {			# OK
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "形動名詞") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "姓") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "名") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "その他の人名") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "単純地名") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "接尾語付き地名") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "組織名") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "その他固有名詞") {
		print "$phonate,$word,その他の固有名詞\n";
	}
	elsif ($class eq "副詞") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "接続詞") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "感動詞") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "形容詞") {			# OK
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "形容動詞") {			# OK
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "接頭語") {			# *
		print "$phonate,$word,普通名詞\n";
	}
	elsif ($class eq "数字列接頭語") {		# OK
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "接尾語") {			# *
		print "$phonate,$word,普通名詞\n";
	}
	elsif ($class eq "人名接尾語") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "地名接尾語") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "組織名接尾語") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "数字列接尾語") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "成句") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "無品詞") {			# OK
		print "$phonate,$word,$class\n";
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate,$word,$class\n";
	}
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
	print "おきなわじしょのひづけ,$year年$mon月$mday日(沖縄辞書の日付け),無品詞\n";
}
