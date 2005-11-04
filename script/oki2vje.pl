#!/usr/bin/perl
#
# oki2vje.pl - 沖縄辞書のファイルをVJE-Deltaに持って行くテキストに変換する
#
#		$Id: oki2vje.pl,v 1.1.1.1 2005/11/04 00:14:15 ga2 Exp $
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成しておいて、
#     $ nkf -e *.dic | ./oki2vje.pl | sort -u | nkf -s > okinawa.txt
#  VJE-Deltaの辞書ユーティリティを起動し、
# あらかじめ「ファイル」-「新規作成」をやってから
# 「ファイル]-「テキストの登録/削除」にokinawa.txtを食わせてください。
require 5.6.0;
use strict;
our $phonate;
our $word;
our $class;

while (<>) {
	s/#.*$//;		# `#'移行を取り去る
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
		print "$phonate\t$word\t［名詞］\n";
	}
	elsif ($class eq "サ変名詞") {
		print "$phonate\t$word\t［名サ］\n";
	}
	elsif ($class eq "形動名詞") {
		print "$phonate\t$word\t［名形］\n";
	}
	elsif ($class eq "姓") {
		print "$phonate\t$word\t［人姓］\n";
	}
	elsif ($class eq "名") {
		print "$phonate\t$word\t［人名］\n";
	}
	elsif ($class eq "その他の人名") {
		print "$phonate\t$word\t［人名］\n";
	}
	elsif ($class eq "単純地名") {
		print "$phonate\t$word\t［地名］\n";
	}
	elsif ($class eq "接尾語付き地名") {
		print "$phonate\t$word\t［地名行政区分］\n";
	}
	elsif ($class eq "組織名") {
		print "$phonate\t$word\t［組織］\n";
	}
	elsif ($class eq "その他固有名詞") {
		print "$phonate\t$word\t［固名］\n";
	}
	elsif ($class eq "副詞") {
		print "$phonate\t$word\t［副詞］\n";
	}
	elsif ($class eq "接続詞") {
		print "$phonate\t$word\t［接続］\n";
	}
	elsif ($class eq "感動詞") {
		print "$phonate\t$word\t［感動］\n";
	}
	elsif ($class eq "形容詞") {
		print "$phonate\t$word\t［形容］\n";
	}
	elsif ($class eq "形容動詞") {
		print "$phonate\t$word\t［形動］\n";
	}
	elsif ($class eq "接頭語") {
		print "$phonate\t$word\t［接頭］\n";
	}
	elsif ($class eq "数字列接頭語") {
		print "$phonate\t$word\t［冠数］\n";
	}
	elsif ($class eq "接尾語") {
		print "$phonate\t$word\t［接尾］\n";
	}
	elsif ($class eq "人名接尾語") {
		print "$phonate\t$word\t［接尾人名］\n";
	}
	elsif ($class eq "地名接尾語") {
		print "$phonate\t$word\t［接尾地名］\n";
	}
	elsif ($class eq "組織名接尾語") {
		print "$phonate\t$word\t［接尾］\n";
	}
	elsif ($class eq "数字列接尾語") {
		print "$phonate\t$word\t［助数］\n";
	}
	elsif ($class eq "成句") {
		print "$phonate\t$word\t［名詞］\n";
	}
	elsif ($class eq "無品詞") {
		print "$phonate\t$word\t［単漢］\n";
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate\t$word\t［〓］\n";
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
	print "おきなわじしょのひづけ\t$year/$mon/$mday(沖縄辞書の日付け)\t［名詞］\n";
}
