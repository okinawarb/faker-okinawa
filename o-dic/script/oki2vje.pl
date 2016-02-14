#!/usr/bin/perl
#
# oki2vje.pl - 沖縄辞書のファイルをVJE-Deltaに持って行くテキストに変換する
#
#		$Id: oki2vje.pl,v 1.16 2006/09/01 18:20:06 void Exp $
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成しておいて、
#     $ cat ../*.dic | ./oki2vje.pl | sort -u > okinawa.txt
#  VJE-Deltaの辞書ユーティリティを起動し、
# あらかじめ「ファイル」-「新規作成」をやってから
# 「ファイル]-「テキストの登録/削除」にokinawa.txtを食わせてください。
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
	if ($class eq "普通名詞") {
		$class = '名詞';
	}
	elsif ($class eq "サ変名詞") {
		$class = '名サ';
	}
	elsif ($class eq "形動名詞") {
		$class = '名形';
	}
	elsif ($class eq "姓") {
		$class = '人姓';
	}
	elsif ($class eq "名") {
		$class = '人名';
	}
	elsif ($class eq "その他の人名") {
		$class = '人名';
	}
	elsif ($class eq "単純地名") {
		$class = '地名';
	}
	elsif ($class eq "接尾語付き地名") {
		$class = '地名行政区分';
	}
	elsif ($class eq "組織名") {
		$class = '組織';
	}
	elsif ($class eq "その他固有名詞") {
		$class = '固名';
	}
	elsif ($class eq "副詞") {
		$class = '副詞';
	}
	elsif ($class eq "接続詞") {
		$class = '接続';
	}
	elsif ($class eq "感動詞") {
		$class = '感動';
	}
	elsif ($class eq "形容詞") {
		$class = '形容';
	}
	elsif ($class eq "形容動詞") {
		$class = '形動';
	}
	elsif ($class eq "接頭語") {
		$class = '接頭';
	}
	elsif ($class eq "数字列接頭語") {
		$class = '冠数';
	}
	elsif ($class eq "接尾語") {
		$class = '接尾';
	}
	elsif ($class eq "人名接尾語") {
		$class = '接尾人名';
	}
	elsif ($class eq "地名接尾語") {
		$class = '接尾地名';
	}
	elsif ($class eq "組織名接尾語") {
		$class = '接尾';
	}
	elsif ($class eq "数字列接尾語") {
		$class = '助数';
	}
	elsif ($class eq "成句") {
		$class = '名詞';
	}
	elsif ($class eq "無品詞") {
		$class = '単漢';
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		$class = '〓';
	}

	print ODIC::to_eucjp("$phonate\t$word\t［$class］\n");
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
	print ODIC::to_eucjp("おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t［名詞］\n");
}
