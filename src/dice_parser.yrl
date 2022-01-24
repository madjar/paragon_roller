Nonterminals
expr
roll
integer
.

Terminals
int
d
separator
.

Rootsymbol expr.

expr -> roll: ['$1'].
expr -> roll separator expr : ['$1'| '$3'].
roll -> integer d integer : {'$1', '$3'}.
roll -> integer : {'$1', 1}.

integer -> int : element(3, '$1').