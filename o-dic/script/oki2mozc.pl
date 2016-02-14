#!/usr/bin/perl
#
# 沖縄辞書のファイルをMozc/Google日本語入力のユーザー辞書へ変換するスクリプト
#							山城潤
#
# 使用例:
#    $ cat ../*.dic | ./oki2mozc.pl | sort -u > mozc_okidic.txt
#
#    --mozc-source / -m オプションにMozcのソースツリーが指定された場合には、
#    沖縄辞書からMozcの辞書に取り込まれている単語を除外する。ただし、
#    品詞のチェックは行っていない。
#    $ cat ../*.dic | ./oki2mozc.pl -m /path/to/mozc-w.x.y.z | sort -u > mozc_okidic.txt
#
# 品詞一覧
# mozc-w.x.y.z/dictionary/user_dictionary_storage.proto
# mozc-w.x.y.z/dictionary/user_dictionary_util.cc
# mozc-w.x.y.z/data/rules/user_pos.def
# 他の日本語変換システムとの品詞マッピング
# mozc-w.x.y.z/data/rules/third_party_pos_map.def	
# サンプル
# mozc-w.x.y.z/third_party/japanese_usage_dictionary/usage_dict.txt
#

use 5.10.1;		# for "use feature 'switch'"
use FindBin;
use lib $FindBin::Bin;  # For search scripts/ODIC.pm
require 'ODIC.pm';

use strict;
use feature 'switch';
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my $with_comment;
my $help_only;
my $mozc_source;

GetOptions(
    'with-comment|c' => \$with_comment,
    'help|h' => \$help_only,
    'mozc-source|m=s' => \$mozc_source
);
if (defined($help_only)) {
    print STDERR "usage: $0 [--with-comment|-c] [--help|-h] [--mozc-source|-m path_to_mozc_source]\n";
    exit 1;
}
if (defined($mozc_source) && (! -d $mozc_source)) {
    print STDERR "`$mozc_source': Not a directory.\n";
    exit 2;
}

while (<>) {
    next if (/^\s*$|^\s*\#.*$/);	# 空行・コメントのみの行を読み飛ばす

    if (/^(\S+)\s+(\S+)\s+(\S+)\s+#\s*(.*)$/) {
	my $phonate = $1;	# 読み
	my $word    = $2;	# 単語
	my $class   = $3;	# 品詞
	my $comment = '';	# コメント
	if (defined($with_comment)) {
	    $comment = $4;	# 必要な時にはコメントを付けられる
	    # 不要なデータをコメントから除外する
	    $comment =~ s/\s*@@@\s*//;	# chasen 向け除外マーカー
	    $comment =~ s/〓あり\s*\([^\)]+\)\s*//; # JIS X 0208 範囲外マーカー
	}

	ODIC::check_phonate($phonate);
	ODIC::check_word($word);
	&print_dictionary($phonate, $word, $class, $comment);

    } elsif (/^(\S+)\s+(\S+)\s+(\S+)/) {
	my $phonate = $1;	# 読み
	my $word    = $2;	# 単語
	my $class   = $3;	# 品詞
	my $comment = '';	# コメント

	ODIC::check_phonate($phonate);
	ODIC::check_word($word);
	&print_dictionary($phonate, $word, $class, $comment);

    } else {
	print STDERR "Error: $.: too few field number `$_'\n";
	print  "$_";
    }
}

&version;
exit 0;


# mozc の辞書には沖縄辞書からデータが取り込まれているため、重複を避ける。
sub find_from_mozc_dictionary {
    my $phonate = shift;
    my $word = shift;
    if (defined $mozc_source) {
	my @dictionaries = glob "$mozc_source/data/dictionary_oss/dictionary*.txt";
	system('egrep', '-q', "^$phonate\[[:space:]]{1}[[:digit:]]{4}[[:space:]]{1}[[:digit:]]{4}[[:space:]]{1}[[:digit:]]{4}[[:space:]]{1}$word\$", @dictionaries);

	if ($? == 0) {
	    return 1;	# found
	}
    }
    return 0;	# not found
}

sub print_dictionary {
    my $phonate = shift;
    my $word    = shift;
    my $class   = shift;
    my $comment = shift;

    given ($class) {
	when ('普通名詞')	{ $class = '名詞'; }
	when ('サ変名詞')	{ $class = '名詞サ変'; }
	when ('形動名詞')	{ $class = '名詞形動'; }
	when ('その他の人名')	{ $class = '人名'; }
	when ('単純地名')	{ $class = '地名'; }
	when ('接尾語付き地名')	{ $class = '接尾地名'; }
	when ('組織名')		{ $class = '組織'; }
	when ('その他固有名詞')	{ $class = '固有名詞'; }
	when ('形容動詞')	{ $class = '名詞形動'; }
	when ('数字列接頭語')	{ $class = '接頭語'; }
	when ('接尾語')		{ $class = '接尾一般'; }
	when ('人名接尾語')	{ $class = '接尾人名'; }
	when ('地名接尾語')	{ $class = '接尾地名'; }
	when ('組織名接尾語')	{ $class = '接尾一般'; }
	when ('数字列接尾語')	{ $class = '助数詞'; }
	when ('成句')		{ $class = '名詞'; }
	when ('無品詞')		{ $class = '独立語'; }
	default {
	    # 姓、名、副詞、接続詞、感動詞、形容詞、接頭語
	}
    }

    if (!find_from_mozc_dictionary($phonate, $word)) {
	print "$phonate\t$word\t$class\t$comment\n";
    }
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
    # 「おきなわじしょのひづけ」と入力したときのみ候補に表示される。
    # 「おきなわじしょのひづけとにゅうりょく」と入力したら候補には出てこない。
    print "おきなわじしょのひづけ\t$year年$mon月$mday日(沖縄辞書の日付け)\t短縮よみ\t沖縄辞書生成時に作成される単語\n";
}

