#!/usr/bin/perl
#
# 沖縄辞書のファイルを Mac OS X 日本語入力メソッド(Yosemite 以降)の
# 「追加辞書」として変換するためのスクリプト
#
#   $ cat *.dic | script/oki2osxjapaneseim.pl --utf8 | env LC_ALL=C sort --unique > okinawa.txt
# 読みは20文字以内、単語は32文字以内です。
# ことえりと違い、UTF8のCSVファイルとして変換します。
# 
# システム環境設定の[キーボード] で日本語入力メソッドの
# [入力ソース]タブを選択し、追加辞書リストボックスに
# 変換したファイルをドロップする。

use FindBin;
use lib $FindBin::Bin;	# For search scripts/ODIC.pm

require 5.6.0;
require 'ODIC.pm';
use strict;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

our $phonate;
our $word;
our $class;

my $help_only;
my $skip_geta;
my $utf8;

GetOptions(
    'help|h' => \$help_only,
    'skip-geta|g' => \$skip_geta,
    'utf8|u' => \$utf8
);

if (defined($help_only)) {
    print STDERR "usage: $0 [--help|-h] [--utf8|-u [--skip-geta|-g]]\n";
    exit 1;
}
while (<>) {
	# JIS X 0208 に含まれていない文字を含む行を読み飛ばす
	# 読み飛ばしにはコメントに「〓あり」マーカーが必要
	next if ( (defined($skip_geta) || (not defined($utf8)) ) && /〓あり/);

	s/#.*$//;		# `#'以降を取り去る
	next if (/^\s*$/);	# その結果空行になった行は読み飛ばす。
	if (/(\S+)\s+(\S+)\s+(\S+)/) {
		$phonate = $1;	# 読み
		$word    = $2;	# 単語
		$class   = $3;	# 品詞
		# Yosemite では「Q's瑞穂」が「Qs瑞穂」になる。
		$word =~ s/\'/\"\'/g;	# ' → "'   # 「Q's瑞穂」対応
		ODIC::check_phonate($phonate);
		if ($word !~ /\"\'/g) {
			# check_word() では " をエラーにするので
			# エスケープしたら避ける。
			ODIC::check_word($word);
		}
		&convert_class;

	} else {
		print STDERR "Error: $.: too few field number `$_'\n";
		print  "$_";
	}
}
&version;
exit 0;

# 品詞変換規則はこちらを参考にしました。
#
# 【Yosemite版】JapaneseIM(旧ことえり)を操る時に便利な覚え書き(Tips集)
# http://nadroom.dousetsu.com/kotoeri/kotoeri_yosemite.html
sub convert_class {
	if ($class eq "普通名詞") {			# OK
	}
	elsif ($class eq "サ変名詞") {			# OK
	}
	elsif ($class eq "形動名詞") {
		$class = '普通名詞';
	}
	elsif ($class eq "姓") {
		$class = 'その他の固有名詞';
	}
	elsif ($class eq "名") {
		$class = 'その他の固有名詞';
	}
	elsif ($class eq "その他の人名") {
		$class = 'その他の固有名詞';
	}
	elsif ($class eq "単純地名") {
		$class = '地名';
	}
	elsif ($class eq "接尾語付き地名") {
		$class = '地名';
	}
	elsif ($class eq "組織名") {
		$class = 'その他の固有名詞';
	}
	elsif ($class eq "その他固有名詞") {
		$class = 'その他の固有名詞';
	}
	elsif ($class eq "副詞") {
	}
	elsif ($class eq "接続詞") {
		$class = '無品詞';
	}
	elsif ($class eq "感動詞") {
		$class = '無品詞';
	}
	elsif ($class eq "形容詞") {			# OK
	}
	elsif ($class eq "形容動詞") {
		$class = '無品詞';
	}
	elsif ($class eq "接頭語") {
		$class = '普通名詞';
	}
	elsif ($class eq "数字列接頭語") {
		$class = '無品詞';
	}
	elsif ($class eq "接尾語") {
		$class = '普通名詞';
	}
	elsif ($class eq "人名接尾語") {
		$class = '無品詞';
	}
	elsif ($class eq "地名接尾語") {
		$class = '無品詞';
	}
	elsif ($class eq "組織名接尾語") {
		$class = '無品詞';
	}
	elsif ($class eq "数字列接尾語") {
		$class = '無品詞';
	}
	elsif ($class eq "成句") {
		$class = '無品詞';
	}
	elsif ($class eq "無品詞") {			# OK
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
	}
	if (defined($utf8)) {
		print "$phonate,$word,$class\r\n";
	} else {
		print ODIC::to_shiftjis("$phonate,$word,$class\r\n");
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
	if (defined($utf8)) {
		print "おきなわじしょのひづけ,$year年$mon月$mday日(沖縄辞書の日付け),無品詞\r\n";
	} else {
		print ODIC::to_shiftjis("おきなわじしょのひづけ,$year年$mon月$mday日(沖縄辞書の日付け),無品詞\r\n");
	}
}
