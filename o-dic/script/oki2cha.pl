#!/usr/bin/perl
#
# oki2cha.pl - 沖縄辞書のファイルを茶筌で使える形式のテキストに変換する
#
#		$Id: oki2cha.pl,v 1.3 2003/04/25 06:15:56 void Exp $
#
# このスクリプトを使って、以下のように「okinawa.dic」を生成してください。
#     $ cat ../*.dic | ./oki2cha.pl > okinawa.dic
#     $ /usr/local/libexec/chasen/makeint okinawa.dic > okinawa.txt
#     $ /usr/local/libexec/chasen/sortdic okinawa.txt > okinawa.int
#     $ /usr/local/libexec/chasen/pattool -F okinawa
#     $ rm okinawa.txt

require 5.6.0;
use FindBin;
use lib $FindBin::Bin;  # For search scripts/ODIC.pm
require 'ODIC.pm';
use strict;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

our $phonate;
our $word;
our $class;

my $help_only;
my $skip_geta;

GetOptions(
    'help|h' => \$help_only,
    'skip-geta|g' => \$skip_geta
);
if (defined($help_only)) {
    print STDERR "usage: $0 [--help|-h] [--skip-geta|-g]\n";
    exit 1;
}

while (<>) {
	# JIS X 0208 に含まれていない文字を含む行を読み飛ばす
	# 読み飛ばしにはコメントに「〓あり」マーカーが必要
	next if (defined($skip_geta) && /〓あり/);

	next if (/@@@/);	# @@@のある行は読み飛ばす。
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
	if ($class eq "普通名詞") {
		print ODIC::to_eucjp("(品詞 (名詞 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "サ変名詞") {
		print ODIC::to_eucjp("(品詞 (名詞 サ変接続)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "形動名詞") {
		print ODIC::to_eucjp("(品詞 (名詞 形容動詞語幹)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "姓") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 人名 姓)) ((見出し語 ($word 1000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "名") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 人名 名)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "その他の人名") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 人名 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "単純地名") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 地域 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "接尾語付き地名") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 地域 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "組織名") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 組織)) ((見出し語 ($word 3000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "その他固有名詞") {
		print ODIC::to_eucjp("(品詞 (名詞 固有名詞 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "副詞") {
		print ODIC::to_eucjp("(品詞 (副詞 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "接続詞") {
		print ODIC::to_eucjp("(品詞 (接続詞)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "感動詞") {
		print ODIC::to_eucjp("(品詞 (感動詞)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "形容詞") {
		print ODIC::to_eucjp("(品詞 (形容詞 自立)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "形容動詞") {
		print ODIC::to_eucjp("(品詞 (名詞 形容動詞語幹)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "接頭語") {			# !!!
		print ODIC::to_eucjp("(品詞 (接頭詞 名詞接続)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "数字列接頭語") {
		print ODIC::to_eucjp("(品詞 (接頭詞 数接続)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "接尾語") {
		print ODIC::to_eucjp("(品詞 (名詞 接尾 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "人名接尾語") {
		print ODIC::to_eucjp("(品詞 (名詞 接尾 人名)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "地名接尾語") {
		print ODIC::to_eucjp("(品詞 (名詞 接尾 地域)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "組織名接尾語") {
		print ODIC::to_eucjp("(品詞 (名詞 接尾 一般)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "数字列接尾語") {
		print ODIC::to_eucjp("(品詞 (名詞 接尾 助数詞)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "成句") {
		print ODIC::to_eucjp("(品詞 (名詞 引用文字列)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	elsif ($class eq "無品詞") {
		print ODIC::to_eucjp("(品詞 (名詞 引用文字列)) ((見出し語 ($word 2000)) (読み $phonate))\n"); 
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print ODIC::to_eucjp("$phonate,$word,$class\n");
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
	print ODIC::to_eucjp("(品詞 (名詞 引用文字列)) ((見出し語 ($year/$mon/$mday沖縄辞書の日付け 2000)) (読み おきなわじしょのひづけ))\n"); 
}
