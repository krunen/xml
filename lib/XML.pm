class XML;
use XML::Grammar::Document;

sub parse (Str $str) {
	if ($str ~~ /<XML::Grammar::Document::TOP>/) {
		#return dumptree($/<XML::Grammar::Document::TOP>);
		#say $/.perl;
		dump_node($/<XML::Grammar::Document::TOP><root>);
	} else {
		return "no match";
	}
}

sub dump ($docmatch) {
}

sub dump_node($node,$indent='') {
	say $indent ~ $node<name> ~ " => \{";
	if ($node<attribute>) {
		for @($node<attribute>) -> $a {
			say "$indent  " ~ $a<name> ~ " => \"" ~ $a<value> ~ "\"";
		}
	}
	if ($node<child>) {
		for @($node<child>) -> $c {
			if ($c<cdata>) {
				say "$indent  CDATA:" ~ $c<cdata>;
			} elsif ($c<text>) {
				my $txt = $c<text>;
				$txt = $txt.subst(/\s+/, " ", :g);
				chomp($txt);
				say "$indent  TEXT:" ~ $txt;
			} elsif ($c<comment>) {
				say "$indent  COMMENT: " ~ $c<comment>;
			} elsif ($c<pi>) {
				say "$indent  PI: " ~ $c<pi>;
			} elsif ($c<element>) {
				dump_node($c<element>,"$indent  ");
			}
		}
	}
	say $indent ~ "\},";
}

sub dumptree_old ($tree,$indent='  ') {
	if ($tree.hash) {
		for $tree.hash.kv -> $k,$v {
			if ($v.list or $v.hash) {
				say "$indent'$k' => \{";
				dumptree($v, $indent~'  ');
				say "$indent\},";
			} else {
				say "$indent'$k' => \"" ~ $v.substr(0,60).subst(/\n/,' ') ~ "\",";
			}
		}
	}
	elsif ($tree.list) {
		my $i=0;
		for $tree.list -> $v {
			if ($v !~~ Str and ($v.list or $v.hash)) {
				say $indent~"$i => \[";
				dumptree($v, $indent~'  ') if $v !== $tree;
				say "$indent\],";
			} else {
				say $indent~"TEXT => " ~ ($v.chars >= 60 ?? ($v.substr(0,58).subst(/\n/,' ')~"..") !! $v.subst(/\n/,' ')) ~ ",";
			}
			$i++;
		}
	} else {
		say "$indent\"$tree\"";
	}
	return '';
}
