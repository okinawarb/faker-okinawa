#!/usr/bin/perl
#
# oki2cha.pl - 沖縄辞書のファイルを茶筌で使える形式のテキストに変換する
#
#		$Id: oki2cha.pl,v 1.1.1.1 2005/11/04 00:14:15 ga2 Exp $
#
# このスクリプトを使って、以下のように「okinawa.dic」を生成してください。
#     $ nkf -e *.dic | ./oki2cha.pl > okinawa.dic
#     $ /usr/local/libexec/chasen/makeint okinawa.dic > okinawa.txt
#     $ /usr/local/libexec/chasen/sortdic okinawa.txt > okinawa.int
#     $ /usr/local/libexec/chasen/pattool -F okinawa
#     $ rm okinawa.txt
require 5.6.0;
use strict;
our $phonate;
our $word;
our $class;

&header;
while (<>) {
	next if (/@@@/);	# @@@のある行は読み飛ばす。
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
	if ($class eq "普通名詞") {
		print "(品詞 (名詞 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "サ変名詞") {
		print "(品詞 (名詞 サ変接続)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "形動名詞") {
		print "(品詞 (名詞 形容動詞語幹)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "姓") {
		print "(品詞 (名詞 固有名詞 人名 姓)) ((見出し語 ($word 1000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "名") {
		print "(品詞 (名詞 固有名詞 人名 名)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "その他の人名") {
		print "(品詞 (名詞 固有名詞 人名 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "単純地名") {
		print "(品詞 (名詞 固有名詞 地域 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "接尾語付き地名") {
		print "(品詞 (名詞 固有名詞 地域 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "組織名") {
		print "(品詞 (名詞 固有名詞 組織)) ((見出し語 ($word 3000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "その他固有名詞") {
		print "(品詞 (名詞 固有名詞 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "副詞") {
		print "(品詞 (副詞 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "接続詞") {
		print "(品詞 (接続詞)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "感動詞") {
		print "(品詞 (感動詞)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "形容詞") {
		print "(品詞 (形容詞 自立)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "形容動詞") {
		print "(品詞 (名詞 形容動詞語幹)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "接頭語") {			# !!!
		print "(品詞 (接頭詞 名詞接続)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "数字列接頭語") {
		print "(品詞 (接頭詞 数接続)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "接尾語") {
		print "(品詞 (名詞 接尾 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "人名接尾語") {
		print "(品詞 (名詞 接尾 人名)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "地名接尾語") {
		print "(品詞 (名詞 接尾 地域)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "組織名接尾語") {
		print "(品詞 (名詞 接尾 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "数字列接尾語") {
		print "(品詞 (名詞 接尾 助数詞)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "成句") {
		print "(品詞 (名詞 引用文字列)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	elsif ($class eq "無品詞") {
		print "(品詞 (名詞 引用文字列)) ((見出し語 ($word 2000)) (読み $phonate))\n"; 
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate,$word,$class\n";
	}
}


sub header {
#	my($year, $mon, $mday);
#	my($hour, $min, $sec);

#	($sec, $min, $hour, $mday, $mon, $year) = localtime(time());
#	$year += 1900;
#	$mon++;
#	print ",,\"適合規格=JIS X 4062:1998\"\n";
#	print ",,\"表題=沖縄辞書\"\n";
#	print ",,\"分野=琉球、沖縄\"\n";
#	print ",,\"版=第$year/$mon/$mday版\"\n";
#	print ",,\"編者=沖縄辞書プロジェクト\"\n";
#	print ",,\"作成日=$year-$mon-$mday\"\n";
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
	print "(品詞 (名詞 引用文字列)) ((見出し語 ($year/$mon/$mday沖縄辞書の日付け 2000)) (読み おきなわじしょのひづけ))\n"; 
}
