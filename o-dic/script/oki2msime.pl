#!/usr/bin/perl
#
# oki2msime.pl - 沖縄辞書のファイルをMS-IMEで取り込めるテキスト形式に変換するスクリプト
#							GANAHA Makoto makoto@ganaha.org
#		$Id: oki2msime.pl,v 1.5 2008/01/16 02:26:58 ga2 Exp $
# 使用例:
#    以下の様に「okinawa.txt」を作成し
#    $ cat ../*.dic | ./oki2msime.pl -g | sort -u > okinawa.txt
#    ユーザー辞書に取り込む場合
#     「Microsoft IME 辞書ツール 2000」を起動し「ツール(T)」->「テキスト ファイルからの登録(T)」から「okinawa.txt」を取り込んで下さい。
#    システム辞書を作成する場合
#     「Microsoft IME 辞書ツール 2000」を起動し「ファイル(F)」->「新規作成(N)」よりダミーのユーザー辞書を作成します。
#     「ツール(T)」->「テキスト ファイルからの登録(T)」から「okinawa.txt」を取り込んで下さい。
#     「ツール(T)」->「システム辞書の作成(S)」からシステム辞書を作成します。
#     ダミーのユーザー辞書はいりませんので削除してください。
#
#  「尚灝王」(しょうこうおう)など、JIS X 0208の範囲外の文字が含まれる単語を
#  辞書にインポートする場合には、UTF-8 で出力してから、Notepad.exeなどで
#  「Unicode」(UTF-16LE BOM付き)に変換してください。
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
my $skip_geta;
my $utf8_output;

GetOptions(
    'with-comment|c' => \$with_comment,
    'help|h' => \$help_only,
    'skip-geta|g' => \$skip_geta,
    'utf8|u'      => \$utf8_output
);
if (defined($help_only)) {
    print STDERR "usage: $0 [--with-comment|-c] [--help|-h] [--skip-geta|-g] [--utf8-output|-u]\n";
    exit 1;
}

while (<>) {
    next if (/^\s*$|^\s*\#.*$/);	# 空行・コメントのみの行を読み飛ばす

    # JIS X 0208 に含まれていない文字を含む行を読み飛ばす
    # 読み飛ばしにはコメントに「〓あり」マーカーが必要
    next if (defined($skip_geta) && /〓あり/);

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


sub print_dictionary {
    my $phonate = shift;
    my $word    = shift;
    my $class   = shift;
    my $comment = shift;

    given ($class) {
	when ('普通名詞')	{ $class = '名詞'; }
	when ('サ変名詞')	{ $class = 'さ変名詞'; }
	when ('その他の人名')	{ $class = '人名'; }
	when ('単純地名')	{ $class = '地名その他'; }
	when ('接尾語付き地名')	{ $class = '地名接尾語'; }
	when ('組織名')		{ $class = '固有名詞'; }
	when ('その他固有名詞')	{ $class = '固有名詞'; }
	when ('数字列接頭語')	{ $class = '接頭語'; }
	when ('人名接尾語')	{ $class = '姓名接尾語'; }
	when ('組織名接尾語')	{ $class = '接尾語'; }
	when ('数字列接尾語')	{ $class = '接尾語'; }
	when ('成句')		{ $class = '名詞'; }
	when ('無品詞')		{ $class = '名詞'; }
	default {
	    # 形動名詞、姓、名、副詞、接続詞、感動詞、形容詞、
	    # 接頭語、接尾語、地名接尾語
	}
    }

    if (defined($utf8_output)) {
	print "$phonate\t$word\t$class\t$comment\r\n";
    } else {
	print ODIC::to_shiftjis("$phonate\t$word\t$class\t$comment\r\n");
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
	print "おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t名詞\r\n";
    }  else {
	print ODIC::to_shiftjis("おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t名詞\r\n");
    }
}
