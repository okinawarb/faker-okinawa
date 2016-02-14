#
# 沖縄辞書フォーマット共通ライブラリー
#

package ODIC;

use strict;
use Encode;

our $MAX_PHONATE = 40;
our $MAX_WORD    = 64;

sub check_phonate {
    my $phonate = shift;

    if (length(Encode::decode('utf-8', $phonate)) > $MAX_PHONATE) {
	print STDERR "Warning: $.: too long phonate `$phonate'\n";
    }
    if ($phonate =~ /[^あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろがぎぐげござじずぜぞだぢづでどばびぶべぼぁぃぅぇぉっょゃゅゎぱぴぷぺぽやゆよわをんヴー]/) {
	print STDERR "Warning: $.: illegal character in `$phonate'\n";
    }
}

sub check_word {
    my $word = shift;

    if (length(Encode::decode('utf-8', $word)) > $MAX_WORD) {
	print STDERR "Warning: $.: too long word `$word'\n";
    }
    if ($word =~ /[ \t",#]/) {
	print STDERR "Warning: $.: illegal character in `$word'\n";
    }
}

sub to_eucjp {
    my $utf8_string = Encode::decode('utf-8', shift);
    return Encode::encode('euc-jp', $utf8_string);
}

sub to_shiftjis {
    my $utf8_string = Encode::decode('utf-8', shift);
    # 'cp932' は、「～」の変換でおかしくなるので使用しない。
    return Encode::encode('shift_jis', $utf8_string);
}

sub to_utf16 {
    my $utf8_string = Encode::decode('utf-8', shift);
    return Encode::encode('utf-16', $utf8_string);
}

1;
__END__

=head1 NAME

ODIC - 沖縄辞書 <http://www.zukeran.org/o-dic/> フォーマット向けの共通関数

=head1 EXAMPLE

  require 'ODIC.pm';

  while (<>) {
    next if (/^\s*$|^\s*\#.*$/);	# 空行・コメントのみの行を読み飛ばす

    if (/^(\S+)\s+(\S+)\s+(\S+)\s+#\s*([[:^cntrl:]]*).*$/) {
      my $phonate = $1;	# 読み
      my $word    = $2;	# 単語
      my $class   = $3;	# 品詞
      my $comment = $4;	# コメント
      ODIC::check_phonate($phonate);
      ODIC::check_word($word);
      &convert_class;

    } elsif (/^(\S+)\s+(\S+)\s+(\S+)/) {
      my $phonate = $1;	# 読み
      my $word    = $2;	# 単語
      my $class   = $3;	# 品詞
      my $comment = '';	# コメント
      ODIC::check_phonate($phonate);
      ODIC::check_word($word);
      &convert_class;

    } else {
      print STDERR "Error: $.: too few field number `$_'\n";
      print  "$_";
    }
  }
  exit 0;

  sub convert_class {
    print "$phonate\t$word\t$class\t$comment\n";
  }

=head1 LICENSE

Public domain.

=cut
