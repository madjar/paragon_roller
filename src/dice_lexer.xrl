Definitions.

Number = [0-9]+
D = d
Separator = [\s\t,+]+


Rules.

{Separator} : {token, {separator, TokenLine, TokenChars}}.
{Number} : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{D} : {token, {d, TokenLine, TokenChars}}.

Erlang code.
