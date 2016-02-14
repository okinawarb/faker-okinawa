#!/usr/bin/perl
#
# wcount.pl - 沖縄辞書の単語数をファイルごとに集計
#
#		$Id: wcount.pl,v 1.5 2002/06/16 04:31:52 void Exp $
#
#     # foreach i (../*.dic)
#		cat $i | ./wcount.pl | wc -l
#		echo $i
#     end
require 5.6.0;
require 'ODIC.pm';
use strict;
our $phonate;
our $word;
our $class;

while (<>) {
	s/#.*$//;		# `#'以降を取り去る
	next if (/^\s*$/);	# その結果空行になった行は読み飛ばす。
	if (/(\S+)\s+(\S+)\s+(\S+)/) {
		$phonate = $1;	# 読み
		$word    = $2;	# 単語
		$class   = $3;	# 品詞
		ODIC::check_phonate($phonate);
		ODIC::check_word($word);
		&check_class;
	}
	else {
		print STDERR "Error: $.: too few field number `$_'\n";
		print  "$_";
	}
}
exit 0;


sub check_class {
	if ($class eq "普通名詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "サ変名詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "形動名詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "姓") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "名") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "その他の人名") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "単純地名") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "接尾語付き地名") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "組織名") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "その他固有名詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "副詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "接続詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "感動詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "形容詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "形容動詞") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "接頭語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "数字列接頭語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "接尾語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "人名接尾語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "地名接尾語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "組織名接尾語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "数字列接尾語") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "成句") {
		print "$phonate\t$word\tclass\n";
	}
	elsif ($class eq "無品詞") {
		print "$phonate\t$word\tclass\n";
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate\t$word\tclass\n";
	}
}
