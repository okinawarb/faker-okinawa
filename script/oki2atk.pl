#!/usr/bin/perl
#
# oki2atk.pl - 沖縄辞書のファイルをATOK13形式に変換する。
#
#                                                         yonesu@syon.co.jp
#
# このスクリプトを使って、以下のように「okinawa.txt」を生成しておいて、
#     $ nkf -e *.dic | ./oki2atk.pl | sort -u | nkf -s > okinawa.txt
#  ATOK13の辞書ユーティリティを起動し、
# 「一括処理]-「単語一括処理」の「単語ファイル(T)」に
#  okinawa.txtを指定し、「登録」を押下してください。
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
#
#require 5.6.0;
#use strict;
#our $phonate;
#our $word;
#our $class;

&header;

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
	if ($phonate =~ /[^あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみ
むめもらりるれろがぎぐげござじずぜぞだぢづでどばびぶべぼぁぃぅぇぉっょゃゅゎぱぴぷぺぽやゆ
よわをんヴー]/) {
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
		print "$phonate\t$word\t 1 \n";
	}
	elsif ($class eq "サ変名詞") {
		print "$phonate\t$word\t 9 \n";
	}
	elsif ($class eq "形動名詞") {
		print "$phonate\t$word\t 11 \n";
	}
	elsif ($class eq "姓") {
		print "$phonate\t$word\t 2 \n";
	}
	elsif ($class eq "名") {
		print "$phonate\t$word\t 3 \n";
	}
	elsif ($class eq "その他の人名") {
		print "$phonate\t$word\t 4 \n";
	}
	elsif ($class eq "単純地名") {
		print "$phonate\t$word\t 5 \n";
	}
	elsif ($class eq "接尾語付き地名") {
		print "$phonate\t$word\t 5 \n";
	}
	elsif ($class eq "組織名") {
		print "$phonate\t$word\t 6 \n";
	}
	elsif ($class eq "その他固有名詞") {
		print "$phonate\t$word\t 7 \n";
	}
	elsif ($class eq "副詞") {
		print "$phonate\t$word\t 14 \n";
	}
	elsif ($class eq "接続詞") {
		print "$phonate\t$word\t 16 \n";
	}
	elsif ($class eq "感動詞") {
		print "$phonate\t$word\t 17 \n";
	}
	elsif ($class eq "形容詞") {
		print "$phonate\t$word\t 37 \n";
	}
	elsif ($class eq "形容動詞") {
		print "$phonate\t$word\t 39 \n";
	}
	elsif ($class eq "接頭語") {
		print "$phonate\t$word\t 19 \n";
	}
	elsif ($class eq "数字列接頭語") {
		print "$phonate\t$word\t 20 \n";
	}
	elsif ($class eq "接尾語") {
		print "$phonate\t$word\t 21 \n";
	}
	elsif ($class eq "人名接尾語") {
		print "$phonate\t$word\t 21 \n";
	}
	elsif ($class eq "地名接尾語") {
		print "$phonate\t$word\t 21 \n";
	}
	elsif ($class eq "組織名接尾語") {
		print "$phonate\t$word\t 21 \n";
	}
	elsif ($class eq "数字列接尾語") {
		print "$phonate\t$word\t 13 \n";
	}
	elsif ($class eq "成句") {
		print "$phonate\t$word\t 1 \n";
	}
	elsif ($class eq "無品詞") {
		print "$phonate\t$word\t 41 \n";
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

sub header {
	print "!!DICUT16\n";
}

