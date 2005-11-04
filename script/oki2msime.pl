#!/usr/bin/perl
#
# oki2msime.pl - 沖縄辞書のファイルをMS-IMEで取り込めるテキスト形式に変換するスクリプト
#							GANAHA Makoto ga@ganaha.org
#		$Id: oki2msime.pl,v 1.1.1.1 2005/11/04 00:14:15 ga2 Exp $
# 使用例:
#    以下の様に「okinawa.txt」を作成し
#    $ nkf -e *.dic | ./oki2msime.pl | sort -u | nkf -s > okinawa.txt
#    ユーザー辞書に取り込む場合
#     「Microsoft IME 辞書ツール 2000」を起動し「ツール(T)」->「テキスト ファイルからの登録(T)」から「okinawa.txt」を取り込んで下さい。
#    システム辞書を作成する場合
#     「Microsoft IME 辞書ツール 2000」を起動し「ファイル(F)」->「新規作成(N)」よりダミーのユーザー辞書を作成します。
#     「ツール(T)」->「テキスト ファイルからの登録(T)」から「okinawa.txt」を取り込んで下さい。
#     「ツール(T)」->「システム辞書の作成(S)」からシステム辞書を作成します。
#     ダミーのユーザー辞書はいりませんので削除してください。
#
require 5.6.0;
use strict;
our $phonate;
our $word;
our $class;

while (<>) {
	s/#.*$//;		# `#'以降を取り去る
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
		print "$phonate\t$word\t名詞\n";
	}
	elsif ($class eq "サ変名詞") {
		print "$phonate\t$word\tさ変名詞\n";
	}
	elsif ($class eq "形動名詞") {
		print "$phonate\t$word\t形動名詞\n";
	}
	elsif ($class eq "姓") {
		print "$phonate\t$word\t姓\n";
	}
	elsif ($class eq "名") {
		print "$phonate\t$word\t名\n";
	}
	elsif ($class eq "その他の人名") {
		print "$phonate\t$word\t人名\n";
	}
	elsif ($class eq "単純地名") {
		print "$phonate\t$word\t地名その他\n";
	}
	elsif ($class eq "接尾語付き地名") {
		print "$phonate\t$word\t地名接尾語\n";
	}
	elsif ($class eq "組織名") {
		print "$phonate\t$word\t固有名詞\n";
	}
	elsif ($class eq "その他固有名詞") {
		print "$phonate\t$word\t固有名詞\n";
	}
	elsif ($class eq "副詞") {
		print "$phonate\t$word\t副詞\n";
	}
	elsif ($class eq "接続詞") {
		print "$phonate\t$word\t接続詞\n";
	}
	elsif ($class eq "感動詞") {
		print "$phonate\t$word\t感動詞\n";
	}
	elsif ($class eq "形容詞") {
		print "$phonate\t$word\t形容詞\n";
	}
	elsif ($class eq "形容動詞") {
		print "$phonate\t$word\t形容動詞\n";
	}
	elsif ($class eq "接頭語") {
		print "$phonate\t$word\t接頭語\n";
	}
	elsif ($class eq "数字列接頭語") {
		print "$phonate\t$word\t接頭語\n";
	}
	elsif ($class eq "接尾語") {
		print "$phonate\t$word\t接尾語\n";
	}
	elsif ($class eq "人名接尾語") {
		print "$phonate\t$word\t姓名接尾語\n";
	}
	elsif ($class eq "地名接尾語") {
		print "$phonate\t$word\t地名接尾語\n";
	}
	elsif ($class eq "組織名接尾語") {
		print "$phonate\t$word\t接尾語\n";
	}
	elsif ($class eq "数字列接尾語") {
		print "$phonate\t$word\t接尾語\n";
	}
	elsif ($class eq "成句") {
		print "$phonate\t$word\t名詞\n";
	}
	elsif ($class eq "無品詞") {
		print "$phonate\t$word\t名詞\n";
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate\t$word\t〓\n";
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
	print "おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t名詞\n";	# !!!
}
