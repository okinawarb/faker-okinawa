#!/usr/bin/perl
#
# oki2canna.pl - 沖縄辞書のファイルをCanna/Anthyに持って行くためのスクリプト
#							瑞慶覧辰
#
# 使用例:
# Canna向け
#    $ cat ../*.dic | ./oki2canna.pl -g | nkf -e | sort -u > okinawa.txt
#    $ mkbindic okinawa.txt
#
# Anthyユーザー辞書向け
#    $ cat ../*.dic | ./oki2canna.pl |
#	env LANG=C sort -u > ~/.anthy/imported_words_default.d/okinawa.t
#
# 品詞一覧
# anthy-9100h/src-worddic/wtab.h
#
# Canna37p3/cmd/wtoc/wtoc.c
# Canna37p3/dic/ideo/grammar/main.code
# Canna37p3/doc/man/guide/tex/hinshi.tex

use 5.10.1;		# for "use feature 'switch'"
use FindBin;
use lib $FindBin::Bin;  # For search scripts/ODIC.pm
require 'ODIC.pm';
use strict;
use feature 'switch';
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

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
    next if (/^\s*$|^\s*\#.*$/);	# 空行・コメントのみの行を読み飛ばす

    # JIS X 0208 に含まれていない文字を含む行を読み飛ばす
    # 読み飛ばしにはコメントに「〓あり」マーカーが必要
    next if (defined($skip_geta) && /〓あり/);

    if (/^(\S+)\s+(\S+)\s+(\S+)\s+#\s*([[:^cntrl:]]*).*$/) {
	my $phonate = $1;	# 読み
	my $word    = $2;	# 単語
	my $class   = $3;	# 品詞

	ODIC::check_phonate($phonate);
	ODIC::check_word($word);
	&print_dictionary($phonate, $word, $class);

    } elsif (/^(\S+)\s+(\S+)\s+(\S+)/) {
	my $phonate = $1;	# 読み
	my $word    = $2;	# 単語
	my $class   = $3;	# 品詞

	ODIC::check_phonate($phonate);
	ODIC::check_word($word);
	&print_dictionary($phonate, $word, $class);

    } else {
	print STDERR "Error: $.: too few field number `$_'\n";
	print  "$_";
    }
}

&version;
exit 0;


sub print_dictionary {
    my $phonate = shift;
    my $word    = shift;
    my $class   = shift;

    given ($class) {
	when ('普通名詞')	{ $class = '#T35'; }
	when ('サ変名詞')	{ $class = '#T30'; }
	when ('形動名詞')	{ $class = '#T05'; }
	when ('姓')		{ $class = '#JNS'; }
	when ('名')		{ $class = '#JNM'; }
	when ('その他の人名')	{ $class = '#JN'; }
	when ('単純地名')	{ $class = '#CN'; }
	when ('接尾語付き地名')	{ $class = '#CNS'; }
	when ('組織名')		{ $class = '#KK'; }
	when ('その他固有名詞')	{ $class = '#KK'; }
	when ('副詞')		{ $class = '#F04'; }
	when ('接続詞')		{ $class = '#CJ'; }
	when ('感動詞')		{ $class = '#CJ'; }
	when ('形容詞')		{ $class = '#KY'; }
	when ('形容動詞')	{ $class = '#T05'; }
	when ('接頭語')		{ $class = '#PRE'; }
	when ('数字列接頭語')	{ $class = '#JS'; }
	when ('接尾語')		{ $class = '#SUC'; }
	when ('人名接尾語')	{ $class = '#JNSUC'; }
	when ('地名接尾語')	{ $class = '#CNSUC1'; }
	when ('組織名接尾語')	{ $class = '#SUC'; }
	when ('数字列接尾語')	{ $class = '#SUC'; }
	when ('成句')		{ $class = '#KJ'; }
	when ('無品詞')		{ $class = '#KJ'; }
	default {
	    print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
	    print "$phonate 〓 $word\n";
	}
    }

    print "$phonate $class $word\n";
}

sub version {
    my $class = shift;

    my $sec;
    my $min;
    my $hour;
    my $mday;
    my $mon;
    my $year;

    ($sec, $min, $hour, $mday, $mon, $year) = localtime(time());
    $year += 1900;
    $mon++;
    print "おきなわじしょのひづけ #T35 $year/$mon/$mday(沖縄辞書の日付け)\n";
}

