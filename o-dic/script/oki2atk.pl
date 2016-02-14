#!/usr/bin/perl
#
# oki2atk.pl - 沖縄辞書のファイルをATOK13形式に変換する。
#
#                                                         yonesu@syon.co.jp
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成しておいて、
#  $ cat *.dic | script/oki2atk.pl --utf8 | env LC_ALL=C sort --unique > okinawa.txt
#  ATOK13の辞書ユーティリティを起動し、
# 「一括処理」-「単語一括処理」の「単語ファイル(T)」に
#  okinawa.txtを指定し、「登録」を押下してください。
#
#  「尚灝王」(しょうこうおう)など、JIS X 0208の範囲外の文字が含まれる単語を
#  辞書にインポートする場合には、UTF-8 で出力してから、Notepad.exeなどで
#  「Unicode」(UTF-16LE BOM付き)に変換してください。
#
#############################################################################
#                          ATOK13での品詞体系                               #
#1  名詞	2  固有人姓	3  固有人名	4  固有人他	5  固有地名 #
#6  固有組織	7  固有商品	8  固有一般	9  名詞サ変	10 名詞ザ変 #
#11 名詞形動	12 名サ形動	13 数詞		14 副詞		15 連体詞   #
#16 接続詞	17 感動詞	18 独立語	19 接頭語	20 冠数詞   #
#21 接尾語	22 助数詞	23 カ行五段	24 ガ行五段	25 サ行五段 #
#26 タ行五段	27 ナ行五段	28 バ行五段	29 マ行五段	30 ラ行五段 #
#31 ワ行五段	32 ハ行四段	33 一段動詞	34 カ変動詞	35 サ変動詞 #
#36 ザ変動詞	37 形容詞	38 形容詞ウ	39 形容動詞	40 形動タリ #
#41 単漢字                                                                  #
#############################################################################

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
my $utf8_output;

GetOptions(
    'help|h'      => \$help_only,
    'skip-geta|g' => \$skip_geta,
    'utf8|u'      => \$utf8_output
);
if (defined($help_only)) {
    print STDERR "usage: $0 [--help|-h] [--skip-geta|-g] [--utf8-output|-u]\n";
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
		$class = 1;
	}
	elsif ($class eq "サ変名詞") {
		$class = 9;
	}
	elsif ($class eq "形動名詞") {
		$class = 11;
	}
	elsif ($class eq "姓") {
		$class = 2;
	}
	elsif ($class eq "名") {
		$class = 3;
	}
	elsif ($class eq "その他の人名") {
		$class = 4;
	}
	elsif ($class eq "単純地名") {
		$class = 5;
	}
	elsif ($class eq "接尾語付き地名") {
		$class = 5;
	}
	elsif ($class eq "組織名") {
		$class = 6;
	}
	elsif ($class eq "その他固有名詞") {
		$class = 7;
	}
	elsif ($class eq "副詞") {
		$class = 14;
	}
	elsif ($class eq "接続詞") {
		$class = 16;
	}
	elsif ($class eq "感動詞") {
		$class = 17;
	}
	elsif ($class eq "形容詞") {
		$class = 37;
	}
	elsif ($class eq "形容動詞") {
		$class = 39;
	}
	elsif ($class eq "接頭語") {
		$class = 19;
	}
	elsif ($class eq "数字列接頭語") {
		$class = 20;
	}
	elsif ($class eq "接尾語") {
		$class = 21;
	}
	elsif ($class eq "人名接尾語") {
		$class = 21;
	}
	elsif ($class eq "地名接尾語") {
		$class = 21;
	}
	elsif ($class eq "組織名接尾語") {
		$class = 21;
	}
	elsif ($class eq "数字列接尾語") {
		$class = 13;
	}
	elsif ($class eq "成句") {
		$class = 1;
	}
	elsif ($class eq "無品詞") {
		$class = 41;
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		if (defined($utf8_output)) {
			print "$phonate\t$word\t［〓］\r\n";
		} else {
			print ODIC::to_shiftjis("$phonate\t$word\t［〓］\r\n");
		}
		return;
	}
	if (defined($utf8_output)) {
		print "$phonate\t$word\t $class \r\n";
	} else {
		print ODIC::to_shiftjis("$phonate\t$word\t $class \r\n");
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
	if (defined($utf8_output)) {
		print "おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t 1 \r\n";
	} else {
		print ODIC::to_shiftjis("おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t 1 \r\n");
	}
}

sub header {
	print "!!DICUT16\r\n";
}

