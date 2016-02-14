#!/usr/bin/perl
#
# oki2jis.pl - 沖縄辞書のファイルを JIS X 4062 の形式のテキストに変換する
#
#		$Id: oki2jis.pl,v 1.7 2006/09/01 18:20:06 void Exp $
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成してください。
#     $ cat ../*.dic | script/oki2jis.pl | sort -u | nkf -s > okinawa.txt
# 後半のnkfのオプションは先方の都合に合わせて変更してください。

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

&header;
while (<>) {
	# JIS X 0208 に含まれていない文字を含む行を読み飛ばす
	# 読み飛ばしにはコメントに「〓あり」マーカーが必要
	next if (defined($skip_geta) && /〓あり/);

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
		print "$phonate,$word,$class\n";	# !!!
	}
	elsif ($class eq "サ変名詞") {
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
		print "$phonate,$word,$class\n";	# !!!
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
	elsif ($class eq "形容詞") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "形容動詞") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "接頭語") {			# !!!
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "数字列接頭語") {
		print "$phonate,$word,$class\n";
	}
	elsif ($class eq "接尾語") {
		print "$phonate,$word,$class\n";
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
		print "$phonate,$word,$class\n";	# !!!
	}
	elsif ($class eq "無品詞") {
		print "$phonate,$word,$class\n";
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate,$word,$class\n";
	}
}


sub header {
	my($year, $mon, $mday);
	my($hour, $min, $sec);

	($sec, $min, $hour, $mday, $mon, $year) = localtime(time());
	$year += 1900;
	$mon++;
	print ",,\"適合規格=JIS X 4062:1998\"\n";
	print ",,\"表題=沖縄辞書\"\n";
	print ",,\"分野=琉球、沖縄\"\n";
	print ",,\"版=第$year/$mon/$mday版\"\n";
	print ",,\"編者=沖縄辞書プロジェクト\"\n";
	print ",,\"作成日=$year-$mon-$mday\"\n";
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
	print "おきなわじしょのひづけ,$year/$mon/$mday(沖縄辞書の日付け),無品詞\n";
}
