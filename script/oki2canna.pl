#!/usr/bin/perl
#
# oki2canna.pl - 沖縄辞書のファイルをCannaに持って行くためのスクリプト
#							瑞慶覧辰
#		$Id: oki2canna.pl,v 1.1.1.1 2005/11/04 00:14:15 ga2 Exp $
# 使用例:
#    $ nkf -e *.dic | ./oki2canna.pl | sort -u > okinawa.txt
#    $ mkbindic okinawa.txt
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
		print "$phonate #T35 $word\n";
	}
	elsif ($class eq "サ変名詞") {
		print "$phonate #T30 $word\n";
	}
	elsif ($class eq "形動名詞") {
		print "$phonate #T05 $word\n";
	}
	elsif ($class eq "姓") {
		print "$phonate #JNS $word\n";
	}
	elsif ($class eq "名") {
		print "$phonate #JNM $word\n";
	}
	elsif ($class eq "その他の人名") {
		print "$phonate #JN $word\n";
	}
	elsif ($class eq "単純地名") {
		print "$phonate #CN $word\n";
	}
	elsif ($class eq "接尾語付き地名") {
		print "$phonate #CN $word\n";
	}
	elsif ($class eq "組織名") {
		print "$phonate #KK $word\n";
	}
	elsif ($class eq "その他固有名詞") {
		print "$phonate #T35 $word\n";		# !!! #CK?  #KK?
	}
	elsif ($class eq "副詞") {
		print "$phonate #F04 $word\n";
	}
	elsif ($class eq "接続詞") {
		print "$phonate #F04 $word\n";
	}
	elsif ($class eq "感動詞") {
		print "$phonate #CJ $word\n";
	}
	elsif ($class eq "形容詞") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "形容動詞") {
		print "$phonate #T05 $word\n";
	}
	elsif ($class eq "接頭語") {
		print "$phonate #PRE $word\n";
	}
	elsif ($class eq "数字列接頭語") {
		print "$phonate #PRE $word\n";
	}
	elsif ($class eq "接尾語") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "人名接尾語") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "地名接尾語") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "組織名接尾語") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "数字列接尾語") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "成句") {
		print "$phonate #T35 $word\n";		# !!!
	}
	elsif ($class eq "無品詞") {
		print "$phonate #KJ $word\n";
	}
	else {
		print STDERR "Error: $.: unknown class `$class': $phonate\t$word\n";
		print "$phonate 〓 $word\n";
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
	print "おきなわじしょのひづけ #T35 $year/$mon/$mday(沖縄辞書の日付け)\n";	# !!!
}
