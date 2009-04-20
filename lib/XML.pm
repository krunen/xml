class XML;
use XML::Grammar::Document;

sub parse (Str $str) {
	if ($str ~~ /<XML::Grammar::Document::TOP>/) {
		return dumptree($/<XML::Grammar::Document::TOP>);
	} else {
		return "no match";
	}
}

sub dumptree ($tree,$indent='  ') {
	if ($tree.hash) {
		for $tree.hash.kv -> $k,$v {
			if ($v !~~ Str) {
				say "$indent$k => \{";
				dumptree($v, $indent~'  ');
				say "$indent\},";
			} else {
				say "$indent$k => " ~ $v.substr(0,60).subst(/\n/,' ') ~ ",";
			}
		}
	}
	elsif ($tree.list) {
		my $i=0;
		for $tree.list -> $v {
			if ($v !~~ Str and ($v.list or $v.hash)) {
				say $indent~$i~" => \{";
				dumptree($v, $indent~'  ') if $v.WHICH != $tree.WHICH;
				say "$indent\},";
			} else {
				say $indent~"TEXT => " ~ ($v.chars >= 60 ?? ($v.substr(0,58).subst(/\n/,' ')~"..") !! $v.subst(/\n/,' ')) ~ ",";
			}
			$i++;
		}
	}
	return '';
}
