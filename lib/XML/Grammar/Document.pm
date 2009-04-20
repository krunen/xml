grammar XML::Grammar::Document;

rule TOP {
  ^
  <xmldecl>?      [ <comment> | <pi> ]*
  <doctypedecl>?  [ <comment> | <pi> ]*
  <root=element>  [ <comment> | <pi> ]*
  $
}

token comment { '<!--' ~ '-->' $<content> = .*? }
token pi { '<?' ~ '?>' $<content> = .*? }

rule xmldecl {
   '<?xml'
   'version'  '=' '"' $<version> = <-[\"]>+ '"'
   'encoding' '=' '"' $<encoding> = <-[\"]>+ '"'
   '?>'
}

rule doctypedecl {
  '<!DOCTYPE ' <name> $<therest> = <-[\>]>* '>'
}

rule element {
  '<' <name> <attribute>*
  [
  | '/>'
  | '>' <child>* '</' $<name> '>'
  ]
}

rule attribute { <name> '=' '"' $<value> = <-["]>* '"' }

rule child {
  [
  | <element>
  | <cdata>
  | <text=textnode>
  | <comment>
  | <pi>
  ]
}

token cdata {
 '<![CDATA[' ~ ']]>' $<text> = .*?
}

token textnode { <-[<]>+ }
token name { <alpha><ident>+ }

