% -*- Prolog -*-
:- op(1000, fx, timex).
timex G :- time(G).

% permitted(M, N, K) means that for Dragon M otter N, previously determined otter K can be used

% Dragon 74  Otter 3 can only use Otter 1
% Dragon 154 Otter 3 can only use Otter 1
% Dragon 154 Otter 4 can only use Otter 1
% all others allowed
% Dragon 74 missed a proof of otter 3 which requires otter 1 but the absence of otter 2. So we only allow otter 1 for otters in otter proof searches. Same with Dragon 154 otter 3. A bit hacky but ...

% permitted_otter(_, _, K) :- K == 1. % otter 1 is always permissible
% permitted_otter(M, N, K) :- K > 1, \+ excluded_otter(M, N, K).
permitted_otter(M, N, K) :- \+ excluded_otter(M, N, K).
allowed_otter(M, N) :- \+ banned_otter(M, N). 

excluded_otter(M, N, K) :- M = machine(T1, _, _), exclude(Monster, N, K), monster(Monster, T2), sort(T1, M1), sort(T2, M2), M1 == M2.
banned_otter(M, N) :- M = machine(T1, _, _), banned(Monster, N), monster(Monster, T2), sort(T1, M1), sort(T2, M2), M1 == M2.

% exclude(M, N, K) means in machine M in the proof of otter N exclude otter K. 
exclude(74,  3, 2).
exclude(129, 3, 2). 
exclude(154, 3, 2).
exclude(154, 4, 2).
exclude(154, 4, 3).
exclude(154, 5, 2).
exclude(154, 5, 3).
exclude(154, 5, 4).
exclude(191, 6, 1).
exclude(191, 6, 5).
exclude(209, 3, 2).
exclude(237, 4, 3).

banned(191, 1).
banned(184, 3). % Not sure if this does anything ...
banned(182, 3). % Not sure if this does anything ...
% banned(70, 2). % No help!
% banned(240, 3). 

% No need to worry about named machines for this case, as this is only used in search mode. 
find_trans(machine(M,_,_), M).
find_trans(M, M) :- M \= machine(_,_,_). 

% M is usually a list of transitions, but it can be the name of a special machine, ie riemann, zermelo, goldbach. 
machine(_, M, M) :- M = machine(_,_,_), !.
machine(Mode, M, machine(M, [], [])) :- member(Mode, [naive, macro(_K), flex, search]), !. 

blank_tape(config(Left, _State, Item, _Dir, Right)) :- is_blank(Item), all_blank(Left), all_blank(Right).

is_blank(I) :- blank_symbol(I).
is_blank(grp(I,N)) :- ground(N), all_blank(I). % Don't delete terms with variables in them in check_blank

check_blank(Tape, Tape) :- \+ all_blank(Tape). 
check_blank(Tape, []) :- all_blank(Tape). 

all_blank([]).
all_blank([I|Rest]) :- is_blank(I), all_blank(Rest). 

make_list(0, _, []).
make_list(N, Item, [Item|Rest]) :- N > 0, N1 is N-1, make_list(N1, Item, Rest).

expanded(I, L, SoFar, NewI) :- append(SoFar, I, NewI), length(NewI, N), N =< L. 
expanded(I, L, SoFar, NewI) :- append(SoFar, I, NewSoFar), length(NewSoFar, N), N =< L, !, expanded(I, L, NewSoFar, NewI).

% NI is N copies of I as a list
expand(_, 0, []).
expand(I, 1, I).
expand(I, N, NI) :- N > 1, N1 is N-1, expand(I, N1, Rest), append(I,Rest, NI). 

flatten_tape(_, [], []).
flatten_tape(right, [grp(I,N)|Rest], NewResult) :- flatten_tape_grp(I, N, Flat), flatten_tape(right, Rest, Result), append(Flat, Result, NewResult). 
flatten_tape(left, [grp(I,N)|Rest], NewResult) :-  flatten_tape_grp(I, N, Flat), flatten_tape(left, Rest, Result), reverse(Flat, RevFlat), append(RevFlat, Result, NewResult). 
flatten_tape(Direction, [I|Rest], [I|Result]) :- is_input(I), flatten_tape(Direction, Rest, Result).
    
flatten_tape_grp(_I, N, []) :- ground(N), 0 is N. 
flatten_tape_grp(I, N, I)   :- ground(N), 1 is N.  
flatten_tape_grp(I, N, Result) :- ground(N), RealN is N, RealN > 1, N1 is RealN-1, flatten_tape_grp(I, N1, Rest), append(I, Rest, Result). 
flatten_tape_grp(I, N, [grp(I,N)]) :- variable(N).

list_values(0, _, []).
list_values(L, N, [N|List]) :- L > 0, L1 is L-1, list_values(L1, N, List). 

% 4-way version of string_concat, ie S = S1S2S3 
string_compose(S1, S2, S3, S) :- var(S), string_concat(S1, S2, T), string_concat(T, S3, S).
string_compose(S1, S2, S3, S) :- ground(S), string_concat(T, S3, S), string_concat(S1, S2, T).

% Replace all occurrences of S1 with S2 in S3 giving S4 (all strings)
replace_string(S1, _S2, S3, S3) :- \+ divide_string(S3, _T1, S1, _T2). % S1 does not occur in S3, so nothing to do. 
replace_string(S1, S2, S3, S4) :- divide_string(S3, T1, S1, T2), !, replace_string(S1, S2, T2, Temp), string_compose(T1, S2, Temp, S4). 

opposite_direction(l,r). 
opposite_direction(r,l). 

symbols_list(Symbols, List, SymbolsList) :- symbols_list1(Symbols, List1), legal_list(List, List1, SymbolsList).

symbols_list1(2, [0,1]). 
symbols_list1(3, [0,1,2]). 
symbols_list1(4, [0,1,2,3]). 
symbols_list1(5, [0,1,2,3,4]). 
symbols_list1(6, [0,1,2,3,4,5]). 
symbols_list1(7, [0,1,2,3,4,5,6]). 
symbols_list1(8, [0,1,2,3,4,5,6,7]). 

symbol(N,X) :- symbols_list1(N, List), member(X, List). 

% states_list(1, [a]). 
states_list(2, [a,b]). 
states_list(3, [a,b,c]). 
states_list(4, [a,b,c,d]).
states_list(5, [a,b,c,d,e]). 
states_list(6, [a,b,c,d,e,f]). 
states_list(7, [a,b,c,d,e,f,g]). 
states_list(8, [a,b,c,d,e,f,g,h]). 

state(N,X) :- states_list(N, List), member(X, List). 

next_state(a,b).
next_state(b,c).
next_state(c,d).
next_state(d,e).
next_state(e,f).
next_state(f,g).
next_state(g,h).
next_state(h,i).
next_state(i,j).
next_state(j,k).
next_state(k,l).
next_state(l,m).
next_state(m,n).
next_state(n,o).
next_state(o,p).
next_state(p,q).
next_state(q,r).
next_state(r,s).
next_state(s,t).
next_state(t,u).
next_state(u,v).
next_state(v,w).
next_state(w,x).
next_state(x,y).
next_state(y,aa). % as z is the halt state

legal_list(_List, [0,1],           [0,1]).
legal_list(_List, [0,1,2],         [0,1,2]).
legal_list(List,  [0,1,2,3],       [0,1,2,3]) :- once( member(t(_,_,2,_,_), List) ). 
legal_list(List,  [0,1,2,3],       [0,1,2]) :- \+ member(t(_,_,2,_,_), List). 
legal_list(List,  [0,1,2,3,4],     [0,1,2,3,4]) :- once( member(t(_,_,3,_,_), List) ). 
legal_list(List,  [0,1,2,3,4],     [0,1,2,3]) :- \+ member(t(_,_,3,_,_), List), once( member(t(_,_,2,_,_), List) ). 
legal_list(List,  [0,1,2,3,4],     [0,1,2]) :- \+ member(t(_,_,2,_,_), List).
legal_list(List,  [0,1,2,3,4,5],   [0,1,2,3,4,5]) :- once( member(t(_,_,4,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5],   [0,1,2,3,4]) :- \+ member(t(_,_,4,_,_), List), once( member(t(_,_,3,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5],   [0,1,2,3]) :- \+ member(t(_,_,3,_,_), List), once( member(t(_,_,2,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5],   [0,1,2]) :- \+ member(t(_,_,2,_,_), List).
legal_list(List,  [0,1,2,3,4,5,6], [0,1,2,3,4,5,6]) :- once( member(t(_,_,5,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5,6], [0,1,2,3,4,5]) :- \+ member(t(_,_,5,_,_), List), once( member(t(_,_,4,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5,6], [0,1,2,3,4]) :- \+ member(t(_,_,4,_,_), List), once( member(t(_,_,3,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5,6], [0,1,2,3]) :-	\+ member(t(_,_,3,_,_), List), once( member(t(_,_,2,_,_), List) ). 
legal_list(List,  [0,1,2,3,4,5,6], [0,1,2]) :- \+ member(t(_,_,2,_,_), List).

legitimate_list(2, _,    [a,b]) :-         !. 
legitimate_list(3, _,    [a,b,c]) :-       !. 
legitimate_list(4, List, [a,b,c,d]) :-     once(  member(t(_,_,_,_,c), List) ). 
legitimate_list(4, List, [a,b,c]) :-       \+ member(t(_,_,_,_,c), List) . 
legitimate_list(5, List, [a,b,c,d,e]) :-   once(  member(t(_,_,_,_,d), List) ). 
legitimate_list(5, List, [a,b,c,d]) :-     \+ member(t(_,_,_,_,d), List) , once(  member(t(_,_,_,_,c), List) ). 
legitimate_list(5, List, [a,b,c]) :-       \+ member(t(_,_,_,_,d), List) , \+  member(t(_,_,_,_,c), List) . 
legitimate_list(6, List, [a,b,c,d,e,f]) :- once(  member(t(_,_,_,_,e), List) ). 
legitimate_list(6, List, [a,b,c,d,e]) :-   \+ member(t(_,_,_,_,e), List) , once(  member(t(_,_,_,_,d), List) ). 
legitimate_list(6, List, [a,b,c,d]) :-     \+ member(t(_,_,_,_,e), List) , \+ member(t(_,_,_,_,d), List) , once(  member(t(_,_,_,_,c), List) ). 
legitimate_list(6, List, [a,b,c]) :-       \+ member(t(_,_,_,_,e), List) ,\+ member(t(_,_,_,_,d), List) , \+  member(t(_,_,_,_,c), List) . 

% add_item(grp(I,N), List, NewList)
add_item(grp(I,_N), List, List) :- I == [], !.
add_item(grp(I,N), List, List)  :- I \== [], ground(N), 0 is N, !.
add_item(grp(I,N), [], [grp(I,N)]) :- I \== [], ground(N), N1 is N, N1 > 0, !. 
add_item(grp(I,N), [], [grp(I,Result)]) :- I \== [], variable(N), simplify_expression(N, Result), !.
% add_item(grp(I1,N1), [grp(I2,N2)|Rest], [grp(I1,N3)|Rest]) :-  I1 == I2, eager_sum(N1, N2, N3), !.
add_item(grp(I1,N1), [grp(I2,N2)|Rest], [grp(I1,N3)|Rest]) :-  I1 == I2, simplify_expression(N1+N2, N3), !.
add_item(grp(I,N), [I2|Rest], Result) :- simplify_expression(N, NewN), append([grp(I,NewN)], [I2|Rest], Result), !. 

next_item(naive, [], Blank, []) :- blank_symbol(Blank).
next_item(naive, [I|Rest], I, Rest).
next_item(search, [], Blank, []) :- blank_symbol(Blank).
next_item(search, [I|Rest], I, Rest).
next_item(flex, [], grp(Blanks,1), []) :- blank_symbol(B), blanks(B, 1, Blanks), !. 
next_item(flex, [I|Rest], I, Rest) :- I = grp(_Item, Num), ground(Num), N is Num, N > 0, I \== [], !. 
next_item(flex, [I|Rest], NewItem, NewRest) :- I = grp(Item, Num), ground(Num), N is Num, (N == 0; (N > 0, Item = [])), !, next_item(flex, Rest, NewItem, NewRest). 
next_item(flex, [I|Rest], I, Rest) :- I = grp(_Item, Num), variable(Num), !.

blanks(_, 0, []). 
blanks(Blank, N, [Blank|Result]) :- N > 0, N1 is N - 1, !, blanks(Blank, N1, Result). 

set_moves(l, r, N, N).
set_moves(r, l, N, M) :- M = -N. 
set_moves(r, r, _N, 1). 
set_moves(l, l, _N, M) :- M = -1. 

set_leaps_moves(l,r,Number, N, Steps, Leaps, Moves) :- ground(Number), !, Leaps is Steps * Number, Moves is N * Number.
set_leaps_moves(l,r,Number, N ,Steps, Leaps, Moves) :- \+ ground(Number), N = 1, Steps = 1, !, Leaps = Number, Moves = Number.
set_leaps_moves(l,r,Number, N ,Steps, Leaps, Moves) :- \+ ground(Number), N = 1, Steps > 1, !, Leaps = Steps * Number, Moves = Number. 
set_leaps_moves(l,r,Number, N, Steps, Leaps, Moves) :- \+ ground(Number), N > 1, Steps = 1, !, Leaps = Number, Moves = N * Number.
set_leaps_moves(l,r,Number, N, Steps, Leaps, Moves) :- \+ ground(Number), N > 1, Steps > 1, !, Leaps = Steps * Number, Moves = N * Number.
set_leaps_moves(r,l,Number, N, Steps, Leaps, Moves) :- ground(Number), !, Leaps is Steps * Number, Moves is 0-N * Number.
set_leaps_moves(r,l,Number, N, Steps, Leaps, Moves) :- \+ ground(Number), N = 1, Steps = 1, !, Leaps = Number, Moves = 0-Number.
set_leaps_moves(r,l,Number, N, Steps, Leaps, Moves) :- \+ ground(Number), N = 1, Steps > 1, !, Leaps = Steps * Number, Moves = 0-Number. 
set_leaps_moves(r,l,Number, N, Steps, Leaps, Moves) :- \+ ground(Number), N > 1, Steps = 1, !, Leaps = Number, Moves = 0-N * Number.
set_leaps_moves(r,l,Number, N, Steps, Leaps, Moves) :- \+ ground(Number), N > 1, Steps > 1, !, Leaps = Steps * Number, Moves = 0-N * Number.

% Leaps is (Number//K)*Steps
set_leaps_acc(Number, K, Steps, Leaps) :- ground(Number), !, Leaps is Steps * (Number//K).
set_leaps_acc(Number, K, Steps, Leaps) :- \+ ground(Number), K == 1, Steps == 1, !, Leaps = Number.
set_leaps_acc(Number, K, Steps, Leaps) :- \+ ground(Number), K > 1,  Steps == 1, !, Leaps = Number//K.
set_leaps_acc(Number, K, Steps, Leaps) :- \+ ground(Number), K == 1, Steps > 1, !, Leaps = Steps * Number.
set_leaps_acc(Number, K, Steps, Leaps) :- \+ ground(Number), K > 1,  Steps > 1, K == Steps, !, Leaps = Number - (Number mod K). % Is this overkill? 
set_leaps_acc(Number, K, Steps, Leaps) :- \+ ground(Number), K > 1,  Steps > 1, K \== Steps, !, Leaps = Steps * (Number//K). % Could we do more?

% Moves is (Number//K)*L
set_moves_acc(l,r,Number, K, L, Moves) :- ground(Number), !, Moves is L * (Number//K).
set_moves_acc(l,r,Number, K, L, Moves) :- \+ ground(Number), K == 1, L == 1, !, Moves = Number.
set_moves_acc(l,r,Number, K, L, Moves) :- \+ ground(Number), K > 1,  L == 1, !, Moves = Number//K. 
set_moves_acc(l,r,Number, K, L, Moves) :- \+ ground(Number), K == 1, L > 1,  !, Moves = L * Number.
set_moves_acc(l,r,Number, K, L, Moves) :- \+ ground(Number), K > 1,  L > 1,  !, Moves = L * (Number//K). 
set_moves_acc(r,l,Number, K, L, Moves) :- ground(Number), !, Moves is 0-L * (Number//K).
set_moves_acc(r,l,Number, K, L, Moves) :- \+ ground(Number), K == 1, L == 1, !, Moves = 0-Number.
set_moves_acc(r,l,Number, K, L, Moves) :- \+ ground(Number), K > 1,  L == 1, !, Moves = 0-(Number//K). 
set_moves_acc(r,l,Number, K, L, Moves) :- \+ ground(Number), K == 1, L > 1,  !, Moves = (0-L) * Number.
set_moves_acc(r,l,Number, K, L, Moves) :- \+ ground(Number), K > 1,  L > 1,  !, Moves = (0-L) * (Number//K).

% set_exponent and set_modulus are for the new extended acceleration transitions
% Exp is N*(Number // K) 
set_exponent(N, Number, K, Exp) :- ground(Number), K == 1, N1 is Number, !, Exp is N*N1. % Is this and the next three lines too fussy?
set_exponent(N, Number, K, Exp) :- ground(Number), K > 1, N == 1, N1 is Number, !, Exp is N1//K. 
set_exponent(N, Number, K, Exp) :- ground(Number), K > 1, N > 1, N == K, N1 is Number, !, Exp is N1 - (N1 mod K).
set_exponent(N, Number, K, Exp) :- ground(Number), K > 1, N > 1, N \== K, N1 is Number, !, Exp is N*(N1//K). 
set_exponent(N, Number, K, Exp) :- \+ ground(Number), K == 1, N == 1, !, Exp = Number.
set_exponent(N, Number, K, Exp) :- \+ ground(Number), K == 1, N > 1,  !, Exp = N*Number.
set_exponent(N, Number, K, Exp) :- \+ ground(Number), K > 1,  N == 1,  !, Exp = Number//K. 
set_exponent(N, Number, K, Exp) :- \+ ground(Number), K > 1,  N > 1, N == K, !, Exp = Number - (Number mod K).
set_exponent(N, Number, K, Exp) :- \+ ground(Number), K > 1,  N > 1, N \== K, !, Exp = N*(Number//K). % Perhaps could do more with this when N is a multiple of K? 

% Mod is N*(Number mod K)
set_modulus(_Number, K, Mod) :- K == 1, Mod == 0.
set_modulus(Number, K, Mod) :- ground(Number), K > 1, !, Mod is Number mod K.
set_modulus(Number, K, Mod) :- \+ ground(Number), K > 1, !, Mod = Number mod K.

splitlast(T, T1, T2) :- append(T1, T2, T), length(T2, 1). 

history_memory(list, 300). 
history_memory(list(N), N). % New mode to allow per case list. 
history_memory(trie(N), N). % Experiment with this value - was originally 10. 
history_memory(newtrie(N,_), N). % Experiment with this value - was originally 10. 

output_blanks(0).
output_blanks(N) :- N > 0, format("   ", []), N1 is N-1, !, output_blanks(N1). 

prettyprint(Args, State, Left, Item, Dir, Pos, Mode, Right, Hops, Ones, Used, Time) :-
	length(Left,L), setblanks(Pos, Mode, L, Blanks), 
	reverse(Left, PL), 
	leftprint(Args, Mode, Blanks, PL, State, Item, Dir, Right), 
	format(" % Hops: ", []), 
	write_term(Hops, [numbervars(true),ignoreops(true),variable_names(Args)]),
	% format(" Ones: ~k Pos: ", [Ones]),
        format(" Ones: ", []), print_bignum(Ones), format(" Pos: ", []), 
	write_term(Pos, [numbervars(true),ignoreops(true),variable_names(Args)]), 
	format(" Transition: ~k ", Used),
	( Time > 0 -> (get_time(Now), format(" Time so far: ~2f ", [Now-Time])) ; true ).

setblanks(Pos, Type, L, Blanks) :- member(Type, [naive]), padding(Pad), Blanks is Pad + Pos - L.
setblanks(_Pos, Type, _L, 0)    :- \+ member(Type, [naive]).

leftprint(_, _, Blanks, _PL, _State, _Item, _, Right) :-
	Blanks < 0, format("{too long on the left} ", []), pprint([], normal, Right).
leftprint(Args, naive, Blanks, PL, State, Item, _, Right) :- 
	Blanks >= 0, nblanks(Blanks), pprint(Args, normal, PL), format("{~k}",[State]), pprint(Args, normal, [Item]), pprint(Args, normal, Right).
leftprint(Args, Mode, Blanks, PL, State, Item, Dir, Right) :- 
        member(Mode, [macro(_K), flex, search]), 
	Blanks >= 0, nblanks(Blanks), pprint(Args, normal, PL), format("{~k}",[State]), pprint(Args, normal, [Item]), format("{~k}", [Dir]), pprint(Args, normal, Right).

padding(10). 
nblanks(N) :- N < 0, !, format("No space! ", []).
nblanks(0) :- !.
nblanks(N) :- N > 0, !, format(" ", []), N1 is N - 1, nblanks(N1). 

pprint(_, _, []). 
pprint(Args, Mode, [Item|Rest]) :- member(Item, [0,1,2,3,4,5,6,7,8,9]), !, number_string(Item, S), format("~s", [S]), pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(T,C)|Rest]) :-
        variable(C), T = [_|_], !,
 	format("(",[]), pchars(T), format(")^{",[]), ttyflush, write_term(C, [numbervars(true), variable_names(Args)]), format("}", []), pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(T,C)|Rest]) :-
        nonvar(C), C = *, T = [_|_], !,
 	format("(",[]), pchars(T), format(")*",[]), pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(T,C)|Rest]) :-
        \+ ground(C), !, 
        format("(",[]), pchars(T), format(")^_[", []), write_term(C, [numbervars(true), variable_names(Args)]),  format("]",[]), pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(T,C)|Rest]) :-
	T = [_|_], % T is a list
	ground(C), safe(C), NC is C, C > 1, !,
	format("(",[]), pchars(T), ttyflush, ( Mode = normal -> print_exponent(NC); format(")^{~d}",[NC]) ), !, pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(T,C)|Rest]) :-
	T = [_|_], % T is a list
	ground(C), safe(C), 1 is C, !, 
	pchars(T), pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(_T,C)|Rest]) :-
	ground(C), safe(C), 0 is C, !,
	pprint(Args, Mode, Rest). 
pprint(Args, Mode, [grp(T,C)|Rest]) :-
        ground(C), \+ safe(C), !,
    	format("(",[]), pchars(T), ttyflush, format(")^{too_big}",[]), !, pprint(Args, Mode, Rest). 
pprint(Args, Mode, [blank|Rest]) :-
        !, format("(blank)", []),
    	pprint(Args, Mode, Rest). 

print_exponent(N) :- ground(N), max_print(Max), N =< Max, !, format(")^{~d}",[N]), !.
print_exponent(N) :- ground(N), big_number_of_digits(N,  Number), !, format(")^{digits(~d)}",[Number]), !.
print_exponent(N) :- variable(N), !, format(")^{~k}",[N]), !.

print_bignum(N) :- print_bignum1(external, N).

print_bignum1(_,N) :-         ground(N), safe(N), max_print(Max), N =< Max, !, format("~d", [N]). 
print_bignum1(external, N) :- ground(N), safe(N), big_number_of_digits(N, Number), !, format("{~d digits}", [Number]).
print_bignum1(internal, N) :- ground(N), safe(N), big_number_of_digits(N, Number), !, format("digits(~d)", [Number]).
print_bignum1(internal, N) :- ground(N), \+ safe(N), !, format("too_ big", []).
print_bignum1(external, N) :- ground(N), \+ safe(N), !, write(N).
print_bignum1(internal, N) :- variable(N), !, format("~k", [N]). 

print_bignum(S, N) :- print_bignum1(S, external, N).

print_bignum1(S,_,N) :-          ground(N), safe(N), max_print(Max), N =< Max, format(S, "~d", [N]), !. 
print_bignum1(S, external, N) :- ground(N), safe(N), big_number_of_digits(N, Number), format(S, "{~k digits}", [Number]), !.
print_bignum1(S, internal, N) :- ground(N), safe(N), big_number_of_digits(N, Number), format(S, "digits(~k)", [Number]), !.
print_bignum1(S, internal, N) :- ground(N), \+ safe(N), !, format(S, "too_ big", []).
print_bignum1(S, external, N) :- ground(N), \+ safe(N), !, write(S, N). 

max_print(999999999999999).

big_number_of_digits(N, M) :- safe(N), M is 1 + round((msb(N)*log(2))/log(10)).
big_number_of_digits(N, M) :- \+ safe(N), !, M = too_big.

% Floats: N =< 10^308 or 2^1023. Integers =< 2^(2^31 - 1). 

% Convert N into "two form", ie N = 2^K + M, 0 <= M < 2^K
twoify(N, K, M) :- K is floor(log(N)/log(2)), T is 2^K, M is N mod T. 

number_of_digits(N, M, M) :- N >= 0, N < 10.
number_of_digits(N, M, Number) :- N >= 10, NewN is N // 10, !, NewM is M + 1, number_of_digits(NewN, NewM, Number). 
number_of_digits(N, M, Number) :- N < 0, !, NewN is 0 - N, number_of_digits(NewN, M, Number).

pchars([]). 
pchars([0|Rest]) :- !, format("0",[]), pchars(Rest). 
pchars([1|Rest]) :- !, format("1",[]), pchars(Rest). 
pchars([2|Rest]) :- !, format("2",[]), pchars(Rest). 
pchars([3|Rest]) :- !, format("3",[]), pchars(Rest). 
pchars([4|Rest]) :- !, format("4",[]), pchars(Rest). 
pchars([5|Rest]) :- !, format("5",[]), pchars(Rest). 
pchars([6|Rest]) :- !, format("6",[]), pchars(Rest). 
pchars([7|Rest]) :- !, format("7",[]), pchars(Rest). 

% Machine language predicates. 

blank_symbol(0). % default
initial_state(a). % default
halt_state(z). % default. 
looping_state(loop). % default. 

is_input(S) :- member(S, [0,1,2,3,4,5,6,7]). 

blanks(I, []) :- blank_symbol(I). 
blanks(K, [I|Rest]) :- blank_symbol(I), K > 0, K1 is K-1, !, blanks(K1, Rest).

number_of_states(machine(M, _, _), N) :-  states(M, Ss), length(Ss, N). 
number_of_states(M, N) :- M \== machine(_,_,_), states(M, Ss), length(Ss, N). 

states(M, States) :- \+ atomic(M), states1(M, [], States).
states(M, States) :- atomic(M), states1(M, States). % So this is a named machine ... 

states1(riemann, 1200).
states1(zermelo, 1200).
states1(goldbach,1200).

states1([], States, States).
states1([t(S,_,_,_,_)|Rest], StatesSoFar, States) :-
	add_to_list(S, StatesSoFar, NewSoFar),
	states1(Rest, NewSoFar, States).

number_of_states_used(machine(M, _, _), N) :- states_used(M, Ss), length(Ss, N). 
number_of_states_used(M, N) :- M \== machine(_,_,_), states_used(M, Ss), length(Ss, N). 
states_used(M, States) :- \+ atomic(M), states_used1(M, [], States).
states_used(M, States) :- atomic(M), states1(M, States). % So this is a named machine ... 

states_used1([], States, States).
states_used1([t(S,_,_,_,NS)|Rest], StatesSoFar, States) :-
	add_to_list(S, StatesSoFar, NewSoFar1),	add_to_list(NS, NewSoFar1, NewSoFar2), states_used1(Rest, NewSoFar2, States).

add_to_list(Item, List, List) :- member(Item, List). 
add_to_list(Item, List, NewList) :- \+ member(Item, List), append(List, [Item], NewList). 

% add every item of List1 to List2 if not present. 
add_list_to_list([], List2, List2). 
add_list_to_list([Item|Rest1], List2, NewList) :-
    add_to_list(Item, List2, NewList2), !,
    add_list_to_list(Rest1, NewList2, NewList). 

number_of_symbols_used(M, N) :- number_of_symbols(M, N). 

number_of_symbols(machine(M, _, _), N) :- symbols(M, Ss), length(Ss, N). 
number_of_symbols(M, N) :- M \== machine(_,_,_), symbols(M, Ss), length(Ss, N). 

symbols_used(M, Symbols) :- symbols(M, Symbols).

symbols(M, Symbols) :- \+ atomic(M), symbols1(M, [], Symbols).
symbols(M, Symbols) :- atomic(M), Symbols is 2.

symbols1([], Symbols, Symbols).
symbols1([t(_,I,O,_,_)|Rest], SymbolsSoFar, Symbols) :-
	add_to_list(I, SymbolsSoFar, NewSoFar1), add_to_list(O, NewSoFar1, NewSoFar2), symbols1(Rest, NewSoFar2, Symbols). 

number_of_dirs(machine(M,_,_),N) :- number_of_dirs1(M,N).
number_of_dirs(M,N) :- M \== machine(_,_,_), number_of_dirs1(M,N). 

number_of_dirs1(M,2) :- \+ atomic(M), up_dir(UpDir), down_dir(DownDir), \+ member(t(_,_,_,UpDir,_), M), \+ member(t(_,_,_,DownDir,_), M), !.
number_of_dirs1(M,3) :- \+ atomic(M), up_dir(UpDir), down_dir(DownDir), member(t(_,_,_,UpDir,_), M), \+ member(t(_,_,_,DownDir,_), M), !.
number_of_dirs1(M,4) :- \+ atomic(M), down_dir(DownDir), member(t(_,_,_,DownDir,_), M), !.
number_of_dirs1(M,2) :- atomic(M).

bound_max(1000000). 

remove(Item, List, NewList) :- member(Item, List), delete(List, Item, NewList). 

% List3 is all elements of List2 which are not in List1. 

extra_list(_, [], SoFar, SoFar).
extra_list(List1, [Item|List2], SoFar, Result) :- member(Item, List1), !, extra_list(List1, List2, SoFar, Result). 
extra_list(List1, [Item|List2], SoFar, Result) :- \+ member(Item, List1), !, append(SoFar, [Item], NewSoFar), extra_list(List1, List2, NewSoFar, Result). 

% delete_list(List1, List2, List3). List 3 is the result of deleting all elements of List2 from List1. 
delete_list(List1, [], List1). 
delete_list(List1, [Item|Rest], List3) :- member(Item, List1), !, delete(List1, Item, Temp), delete_list(Temp, Rest, List3). 
delete_list(List1, [Item|Rest], List3) :- \+ member(Item, List1), !, delete_list(List1, Rest, List3). 

variable(X) :- term_variables(X, List), List \== []. % Really means 'is an expression containing a variable'.

stringify([], [], []).
stringify([V|Vars], [VString|Rest], [Atom=V|Names]) :- var(V), !, term_string(V, VString), atom_string(Atom, VString), stringify(Vars, Rest, Names). 

separator(",").

% Variable names and so forth ... 

% variable_name("X").
variable_name("X1").  % Hacky but should do for now. 
variable_name("X2").
variable_name("X3").
% variable_name("Y").
variable_name("Y1").
variable_name("Y2").
variable_name("Y3").

prog_vars(1, [X1], ['X1'=X1], ["X1"]). % Keep it simple for now. May be a way to re-instate the default for 1 variable to be "X", but ... 
prog_vars(2, [X1,X2], ['X1'=X1,'X2'=X2], ["X1","X2"]).
prog_vars(3, [X1,X2,X3], ['X1'=X1,'X2'=X2,'X3'=X3], ["X1","X2","X3"]). % Hacky, but should do for now.

reg_vars(1, [Y1], ['Y1'=Y1], ["Y1"]). % As above, ... 
reg_vars(2, [Y1,Y2], ['Y1'=Y1,'Y2'=Y2], ["Y1","Y2"]).
reg_vars(3, [Y1,Y2,Y3], ['Y1'=Y1,'Y2'=Y2,'Y3'=Y3], ["Y1","Y2","Y3"]). % Hacky, but should do for now.

next_name(prog, Names, 'X1') :- \+ member('X1'=_, Names). % Hacky. Can do better than this presumably ... 
next_name(prog, Names, 'X2') :- member('X1'=_, Names), \+ member('X2'=_, Names).
next_name(prog, Names, 'X3') :- member('X1'=_, Names),  member('X2'=_, Names). 
next_name(reg,  Names, 'Y1') :- \+ member('Y1'=_, Names). 
next_name(reg,  Names, 'Y2') :- member('Y1'=_, Names), \+ member('Y2'=_, Names).
next_name(reg,  Names, 'Y3') :- member('Y1'=_, Names),  member('Y2'=_, Names). 

find_diff("X1", PosDiffs, _, VarDiff) :- PosDiffs = [VarDiff|_], !. 
find_diff("X2", PosDiffs, _, VarDiff) :- append(P1, P2, PosDiffs), length(P1, 1), P2 = [VarDiff|_], !.
find_diff("X3", PosDiffs, _, VarDiff) :- append(P1, P2, PosDiffs), length(P1, 2), P2 = [VarDiff|_], !. 
find_diff("Y1", _, NegDiffs, VarDiff) :- NegDiffs = [VarDiff|_], !. 
find_diff("Y2", _, NegDiffs, VarDiff) :- append(N1, N2, NegDiffs), length(N1, 1), N2 = [VarDiff|_], !.
find_diff("Y3", _, NegDiffs, VarDiff) :- append(N1, N2, NegDiffs), length(N1, 2), N2 = [VarDiff|_], !.

check_minimum("X1", V, XminsSoFar, YminsSoFar, NewXminsSoFar, YminsSoFar) :- XminsSoFar = [X1Min|Rest], check_minimum_var(V, X1Min, NewX1Min), NewXminsSoFar = [NewX1Min|Rest].
check_minimum("X2", V, XminsSoFar, YminsSoFar, NewXminsSoFar, YminsSoFar) :- append(T1, Rest, XminsSoFar), length(T1, 1), Rest = [X2Min|Rest2], check_minimum_var(V, X2Min, NewX2Min), append(T1, [NewX2Min|Rest2], NewXminsSoFar).
check_minimum("X3", V, XminsSoFar, YminsSoFar, NewXminsSoFar, YminsSoFar) :- append(T1, Rest, XminsSoFar), length(T1, 2), Rest = [X3Min|Rest2], check_minimum_var(V, X3Min, NewX3Min), append(T1, [NewX3Min|Rest2], NewXminsSoFar).
check_minimum("Y1", V, XminsSoFar, YminsSoFar, XminsSoFar, NewYminsSoFar) :- YminsSoFar = [Y1Min|Rest], check_minimum_var(V, Y1Min, NewY1Min), NewYminsSoFar = [NewY1Min|Rest].
check_minimum("Y2", V, XminsSoFar, YminsSoFar, XminsSoFar, NewYminsSoFar) :- append(T1, Rest, YminsSoFar), length(T1, 1), Rest = [Y2Min|Rest2], check_minimum_var(V, Y2Min, NewY2Min), append(T1, [NewY2Min|Rest2], NewYminsSoFar).
check_minimum("Y3", V, XminsSoFar, YminsSoFar, XminsSoFar, NewYminsSoFar) :- append(T1, Rest, YminsSoFar), length(T1, 2), Rest = [Y3Min|Rest2], check_minimum_var(V, Y3Min, NewY3Min),  append(T1, [NewY3Min|Rest2], NewYminsSoFar).

next_var_name(Name, String, RestString) :- string_compose(Name, ",", RestString, String), !. 
next_var_name(Name, String, RestString) :- Name = String, RestString = "". % Last string only 

% Utilities
append(W,X,Y,Z) :- append(W,X,T), append(T,Y,Z). 

bbinternalprint(Pred, N, M, O, H, Status) :- format("~k(~d,[", [Pred,N]), printint(M), format("],~d,~d,", [O,H]), write(Status), format("). ", []). 

printint([]) :- !. 
printint([A]) :- format("~k", [A]), !. 
printint(Arg) :- Arg = [A1|Temp], Temp = [A2|Rest], !, format("~k,", [A1]), !, printint([A2|Rest]).

% Parameters. These need to be rationalised!
% variable_bound(200). % How long to search for observant otter proof ... max found so far is 59 for multilinear one in monster 67 but bigger ones for multilinear cases. May need something more variable.
variable_bound(uni,100). % How long to search for observant otter proof ... max found so far is 59 for multilinear one in monster 67 but bigger ones for multilinear cases. May need something more variable.
variable_bound(multi,300). % How long to search for observant otter proof ... max found so far is 59 for multilinear one in monster 67 but bigger ones for multilinear cases. May need something more variable. 
% induction_bound(50). % How long to search for induction proof ... need some data on this one
% minimum_for_loop(12). % minimum number of copies of item in original
% maximum_for_loop(6). % maximum number of extra copies to try. 
% compress_length(10). % Was 5, but then found long(4,1,M) and then example(3,M). 

backwards_bound(10). % Experiment with this value.

beaver(input,  "G:/busybeaver/Data/Raw3/"). % Directory for input for analysis (ie where generated list of unanalysed machines gets put).  
beaver(output, "G:/busybeaver/Data/Results4/"). % Directory where analysis results get written. 

which_dir(Mode,States,Symbols,Dirs,Style,Type,Directory) :- member(Mode,[plot,refine,status]), directory(output,States,Symbols,Dirs,Style,Type,Directory).
which_dir(Mode,States,Symbols,Dirs,Style,Type,Directory) :- \+ member(Mode, [plot,refine, status]), directory(input,States,Symbols,Dirs,Style,Type,Directory).

% directory(output, States, Symbols, Style, Dirs, tnf, Base), 
directory(Mode, States, Symbols, Dirs, _Style, Type, Directory) :-
        Dimension is States * Symbols * Dirs, 
	((Dimension < 16); (Dimension == 16, Type \== all)), 
	beaver(Mode, Base), Directory = Base. 
directory(Mode, States, Symbols, Dirs, Style, Type, Directory) :-
        Dimension is States * Symbols * Dirs, 
	((Dimension > 16);(Dimension == 16, Type == all)), % Use subdirectory for larger cases. 16 is file unless Type is all
	beaver(Mode, Base), 
	number_string(States,S1), number_string(Symbols,S2), number_string(Dirs,S3),
	(Style = rel -> string_concat(S3,"rel", S4); S4 = S3), 
	string_concat(S1,S2,Temp0), string_concat(Temp0, S4, Temp1),
	string_concat("busybeaver", Temp1, Temp2),
	string_concat(Temp2, "/", Temp3),
	string_concat(Base, Temp3, Directory). 

ensure_exists(Directory) :- atom_codes(Real, Directory), exists_directory(Real). 
ensure_exists(Directory) :- atom_codes(Real, Directory), \+ exists_directory(Real), make_directory(Real). 

% filelinemax(1000000) :- !. % maximum number of lines to write to a file before starting a new one. 

produce_latex(all,       Dir, Suffix) :- sensible(List),  append([5,73], List, NList), sort(NList, NewList), produce_latex_files(NewList, Dir, Suffix).
produce_latex(sensible,  Dir, Suffix) :- sensible(List),  produce_latex_files(List, Dir, Suffix).
produce_latex(sensible2, Dir, Suffix) :- sensible2(List), produce_latex_files(List, Dir, Suffix).
produce_latex(evalnew, Dir, Suffix) :- monsters(evalnew, List), produce_latex_files(List, Dir, Suffix).
produce_latex(missing,   Dir, Suffix) :- monsters(missing, List), produce_latex_files(List, Dir, Suffix).

produce_latex_files(List, Dir, Suffix) :- initialise_otter_file(Dir, Stream), produce_latex_files(List, Dir, Suffix, Stream), close_otter_file(Stream). 

produce_latex_files([], _Dir, _Suffix, _Stream).
produce_latex_files([Num|Rest], Dir, Suffix, Stream) :- produce_latex_file(Num, Dir, Suffix, Stream), !, produce_latex_files(Rest, Dir, Suffix, Stream).

initialise_otter_file(Dir, Stream) :-
    base_directory(Base), string_concat(Base, Dir, NewDir), 
    string_concat(NewDir, "ottersraw.tex", File), atom_string(FileName, File), open(FileName, write, Stream), 
    Init_String = "\\noindent\n\\begin{tabular}{lllllll}\n& & & & & & \\\\\nDragon & Otter & Init & Final & Found & Times & Steps \\\\ \n",
    format(Stream, "~s~n", Init_String). 

close_otter_file(Stream) :- Final_String = "& & & & & & \\\\\n\\end{tabular}\n", format(Stream, "~s~n", Final_String), close(Stream). 

produce_latex_file(Num, Dir, Suffix, Stream) :-
    base_directory(Base), string_concat(Base, Dir, NewDir),
    number_string(Num, NumString), 
    assemble_string([NewDir, NumString, Suffix], Name), 
    string_concat(Name, ".tex", LatexName), 
    string_to_atom(LatexName, FName),
    format("~k ", [Num]),
    
    tell(FName),
    format("\\newpage~n\\subsection{Dragon ~k}~n~n\\begin{figure}~n\\centering~n", [Num]),
    format("\\includegraphics[width=0.60\\textwidth]{Diagrams/Monsters/monster~k.png}~n", [Num]),
    format("\\caption{Dragon ~k}~n\\label{fig:dragon~kdata}~n\\end{figure}~n~n", [Num,Num]),
    string_concat(Name, ".txt", FullName), 
    ( exists_file(FullName) -> ( open(FullName, read, In), read_line_to_string(In, Line), process_text_file(In, Line, Num, Stream), close(In) ) ;
                                format("No information available for Dragon ~k~n", [Num])
                                ),
     told.

process_text_file(_In, Line, _, _) :- Line == end_of_file, !.
process_text_file(In, Line, Num, Stream) :- process_text_line(In, Line, Num, Stream), read_line_to_string(In, NextLine), !, process_text_file(In, NextLine, Num, Stream).

echo_text_file(_In, Line) :- Line == end_of_file, !.
echo_text_file(In, Line) :- format("Line: ~s~n", [Line]), read_line_to_string(In, NextLine), !, echo_text_file(In, NextLine).

process_text_line(In, String, Num, Stream) :- final_config_string(String), !, finish_lines(In, String, Output_String, Num, Stream), format("~s~n", Output_String). 
process_text_line(_, String, _Num, _Stream) :- classify_line(String, NewString), !, format("~s~n", NewString). 

final_config_string(String) :- divide_string(String, _, "Final configuration is ", _).

finish_lines(In, String1, Output_String, Num, Stream) :-
    % Final configuration line
    divide_string(String1, Status, " Final configuration is ", Rest1), !,
    string_concat("% ", RealStatus, Status), 
    divide_string(Rest1, Config1, " Ones: ", Rest12), 
    convert_string_config(Config1, Output_Config1), 
    assemble_string(["\n", RealStatus, " {\\bf Final configuration}: $", Output_Config1, "$ Ones: ", Rest12], Output_String1),

    % Otters line
    read_line_to_string(In, String2),
    divide_string(String2, Pre2, " Unique Otters: ", Rest21), !,
    % string_concat("% Otters: ", Otters_Number, Pre2),
    divide_string(Pre2, Pre4, " Multilinear: ", _Pre5),
    string_concat("% Otters: ", Otters_Number, Pre4),
    divide_string(Rest21, Pre3, " Shape: ", Rest22),
    divide_string(Rest22, Config2, " Shape Size: ", Rest23), 
    convert_string_config(Config2, Output_Config2), 
    % assemble_string(["\nOtters: ", Otters_Number, " Unique Otters: ", Pre3, " Shape: $", Output_Config2, "$ Shape Size: ", Rest23, "\n"], Output_String2),
    assemble_string(["\n", Pre2, Pre3, " Shape: $", Output_Config2, "$ Shape Size: ", Rest23, "\n"], Output_String2),  

    % Applications lines
    number_string(Otters, Otters_Number),
    ( Otters > 0 -> ( read_applications_lines(In, Otters, [], Otter_Table_Values1) ); true ), 

    % Machine lines
    Start_Machine_String = "\\noindent\n\\begin{tabular}{lllllll}\n \\multicolumn{3}{c}{Initial} & \\multicolumn{3}{c}{Final} & Steps \\\\\n",
    read_machines_lines(In, "", Machines_String), 
    End_Machine_String = "& & & & & & \\\\ \n\\end{tabular}\n", 

    assemble_string([Start_Machine_String, Machines_String, End_Machine_String], Machine_String), 

     % Otter Transitions lines
    ( Otters > 0 -> (
	  read_otter_transitions_lines(In, Otters, [], Otter_Table_Values2), 
	  make_otter_table(Otter_Table_Values1, Otter_Table_Values2, Otter_Table_String, Num, Stream) ) ; Otter_Table_String = "" ), 
        
    % Time line
    ( Otters > 0 -> read_line_to_string(In, _); true ), % skip blank line
    read_line_to_string(In, Otter_Found_String), 
    read_line_to_string(In, TimeString),

    divide_string(TimeString, "", "took ", RestTime), !,
    divide_string(RestTime, Time, " seconds", ""),
    assemble_string(["Time taken: ", Time, " seconds"], Output_StringTime),

    % Put it altogether (!!)

    assemble_string([Output_String1, "\n", Output_String2, "\n", Otter_Table_String, "\n", Machine_String, "\n", Otter_Found_String, "\n", Output_StringTime], Output_String), 
    
    true. 

read_applications_lines(_, 0, Values, Values).
read_applications_lines(In, N, Values, Final_Values) :-
    N > 0, !, 
    read_line_to_string(In, NextString),
    divide_string(NextString, "", "Applications Otter ", Rest), 
    divide_string(Rest, Otter_Number, " times: ", Rest2), !,
    divide_string(Rest2, Otter_Times,  ", steps: ", Otter_Steps), 
    NewValue = o(Otter_Number, Otter_Times, Otter_Steps), 
    append(Values, [NewValue], NewValues), 
    N1 is N-1, 
    read_applications_lines(In, N1, NewValues, Final_Values). 

read_otter_transitions_lines(_, 0, Values, Values).
read_otter_transitions_lines(In, N, Values, Final_Values) :-
    N > 0, !, 
    read_line_to_string(In, String),

    divide_string(String, "", "Otter ", Rest), !, 
    divide_string(Rest, _Otter_Number, ": ", Rest2),
    divide_string(Rest2, Config1, " ++> ", Rest3),
    divide_string(Rest3, Config2, " Found: ", Rest4),
    divide_string(Rest4, FoundNum, " Diffs: ", _Rest5), 
    
    convert_string_config(Config1, Output_Config1), convert_string_config(Config2, Output_Config2),

    string_concat("% Found: ", Rest4, Rest_String), 
    NewValue = o(Output_Config1, Output_Config2, FoundNum, Rest_String), 
    append(Values,[NewValue], NewValues), 
    N1 is N-1, 
    read_otter_transitions_lines(In, N1, NewValues, Final_Values). 

read_machines_lines(In, Machines_String, Final_Machines_String) :- 
    read_line_to_string(In, String), machine_string(String), !,
    divide_string(String, "", "% Trans: ", Rest),
    divide_string(Rest, Trans, " Steps: ", Steps),
    divide_string(Trans, Init, " -> ", Final),
    divide_string(Init, State1, " ", T1), string_length(State1, 1),
    divide_string(T1, Input1, " ", InDir),
    divide_string(Final, State2, " ", T2), string_length(State2, 1),
    divide_string(T2, Input2, " ", OutDir),

    assemble_string([State1, " & ", Input1, " & ", InDir, " & ", State2, " & ", Input2, " & ", OutDir, " & ", Steps, " \\\\\n"], Line),
    string_concat(Machines_String, Line, New_Machines_String), !, 
    read_machines_lines(In, New_Machines_String, Final_Machines_String).

read_machines_lines(In, Machines_String, Machines_String) :- 
    % read_line_to_string(In, String), \+ machine_string(String), format("First non-machines line is ~s~n", String), !. % Not a machine transition, so pass it on.
    read_line_to_string(In, String), \+ machine_string(String), !. % Not a machine transition, so stop.

machine_string(String) :- divide_string(String, "", "% Trans: ", _). 

make_otter_table(Values1, Values2, String, Num, Stream) :-
    Init_String = "\\noindent\n\\begin{tabular}{llllll}\n& & & & \\\\\nOtter & Init & Final & Found & Times & Steps \\\\ \n",
    make_otter_table1(Values1, Values2, "", Table_String), 
    Final_String = "& & & & & \\\\\n\\end{tabular}\n",
    add_dragon(Num, Table_String, New_String), % add Num as a column to this!
    format(Stream, "~s", New_String), 
    assemble_string([Init_String, Table_String, Final_String], String). 

make_otter_table1([], [], String, String).
make_otter_table1([o(Number,Times,Steps)|Rest1], [o(Config1,Config2,Found,String)|Rest2], StringSoFar, Final_String) :-
    assemble_string([Number, " & $", Config1, "$ & $", Config2, "$ & ", Found, " & ", Times, " & ", Steps, "\\\\ ", String, "\n"], Line),
    string_concat(StringSoFar, Line, NewStringSoFar),  
    make_otter_table1(Rest1, Rest2, NewStringSoFar, Final_String). 

add_dragon(Num, OldString, NewString) :-
    string_concat(Num, " & ", Temp), 
    string_concat(Temp, OldString, TempNewString1),
    string_concat("\n", Temp, NewTemp), 
    replace_string("\n", NewTemp, TempNewString1, TempNewString2), % Adds one too many, so .. 
    string_length(Temp, L), string_length(TempNewString2, K), L2 is K - L, 
    sub_string(TempNewString2, _, L2, L, NewString). 

% Needs a lot more cases here
classify_line(String, Output_String) :-
    string_concat("% Regression (uni) ", Rest, String), !,
    divide_string(Rest, C1, " -> ", Rest2), divide_string(Rest2, C2, " -> ", C3),
    divide_string(C1, N1, ":", Config1), divide_string(C2, N2, ":", Config2),  divide_string(C3, N3, ":", Config3),
    convert_string_config(Config1, OutConfig1), convert_string_config(Config2, OutConfig2), convert_string_config(Config3, OutConfig3), 
    String1 = "\n\\noindent\n\\begin{tabular}{ll}\n& \\\\\n",
    assemble_string([N1, ": & $", OutConfig1, "$ \\\\\n"], Row1),
    assemble_string([N2, ": & $", OutConfig2, "$ \\\\\n"], Row2),
    assemble_string([N3, ": & $", OutConfig3, "$ \\\\\n"], Row3),
    assemble_string([Row1, Row2, Row3], Rows_String), 
    String2 = "& \\\\\n\\end{tabular}\n",
    assemble_string([String1, Rows_String, String2], Output_String).
classify_line(String, Output_String) :-
    string_concat("% Regression (multi) ", Rest, String), !,
    divide_string(Rest, C1, " -> ", Rest2), divide_string(Rest2, C2, " -> ", Rest3), divide_string(Rest3, C3, " -> ", C4), 
    divide_string(C1, N1, ":", Config1), divide_string(C2, N2, ":", Config2),  divide_string(C3, N3, ":", Config3), divide_string(C4, N4, ":", Config4),
    convert_string_config(Config1, OutConfig1), convert_string_config(Config2, OutConfig2), convert_string_config(Config3, OutConfig3),  convert_string_config(Config4, OutConfig4), 
    String1 = "\n\\noindent\n\\begin{tabular}{ll}\n& \\\\\n",
    assemble_string([N1, ": & $", OutConfig1, "$ \\\\\n"], Row1),
    assemble_string([N2, ": & $", OutConfig2, "$ \\\\\n"], Row2),
    assemble_string([N3, ": & $", OutConfig3, "$ \\\\\n"], Row3),
    assemble_string([N4, ": & $", OutConfig4, "$ \\\\\n"], Row4),
    assemble_string([Row1, Row2, Row3,Row4], Rows_String), 
    String2 = "& \\\\\n\\end{tabular}\n",
    assemble_string([String1, Rows_String, String2], Output_String).
classify_line(String, Output_String) :-
    string_concat("% Regression found ", Rest, String), !,
    divide_string(Rest, N3, "->", Rest2),
    divide_string(Rest2, N2, "->", N1), 
    assemble_string(["Regression from ", N3, " to ", N2, " to ", N1, "\n"], Output_String).
classify_line(String, Output_String) :-
    % string_compose(Otter, " proof attempt ", Rest, String), !,
    divide_string(String, Otter, " proof attempt ", Rest), !,
    string_concat("% otter ", Otter_Number, Otter),
    divide_string(Rest, Attempt, ": ", Rest2), 
    divide_string(Attempt, Attempt_Number, " ", Arguments),
    real_arguments(Arguments, Real_Args), 
    % divide_string(Rest2, Config1, " -->> ", Config2),
    divide_string(Rest2, Config1, " -->> ", Rest3),
    ( divide_string(Rest3, Config2, " Progressors: ", Rest4) -> true; (Config2 = Rest3, Rest4 = "") ), 
    convert_string_config(Config1, OutConfig1), convert_string_config(Config2, OutConfig2), !, 
    assemble_string(["\\noindent\nOtter ", Otter_Number, " proof attempt ", Attempt_Number, " arguments ", "(", Real_Args, ") ", " $", OutConfig1, " \\rightarrow ", OutConfig2, "$ Progressors: ", Rest4, "\n"], String1),
    String2 = "\n\\noindent\n{\\tiny \\begin{tabular}{ll}\n& \\\\",
    string_concat(String1, String2, Output_String).
classify_line(String, Output_String) :-
    divide_string(String, Otter, " verified ", Rest), !,
    string_concat("% otter ", Otter_Number, Otter),
    divide_string(Rest, "(attempt ", Attempt_Number, Rest2),
    divide_string(Rest2, ") in ", Steps_Number, " steps"), 
    String1 = "& \\\\\n\\end{tabular}}\n\n", 
    assemble_string(["Otter ", Otter_Number, " verified on attempt ", Attempt_Number, " in ", Steps_Number, " steps\n"], String2),
    string_concat(String1, String2, Output_String). 
classify_line(String, Output_String) :-
    divide_string(String, Otter, " abandoned ", Rest), !,
    string_concat("% otter ", Otter_Number, Otter),
    divide_string(Rest, _Going, " due to bound of ", Rest1), 
    divide_string(Rest1, _Bound, " being exceeded ", Rest2), 
    divide_string(Rest2, "(attempt ", Attempt_Number, ")"),
    String1 = "& \\\\\n\\end{tabular}}\n\n", 
    assemble_string(["Otter ", Otter_Number, " failed on attempt ", Attempt_Number, "\n"], String2),
    string_concat(String1, String2, Output_String).
classify_line(String, Output_String) :-
    divide_string(String, Mods, " not compatible with diffs ", Rest), !,
    string_concat("% Moduli ", Mods_Detail, Mods),
    divide_string(Rest, Diffs, " , so giving up otter proof attempt", Rest2), 
    String1 = "& \\\\\n\\end{tabular}}\n\n", 
    assemble_string(["Moduli failure with mods ", Mods_Detail, " and diffs ", Diffs, Rest2, "\n"], String2),
    string_concat(String1, String2, Output_String).
classify_line(String, Output_String) :-
    divide_string(String, Config, " % Hops: ", Rest), !,
    divide_string(Rest, Steps, " Ones: ", Rest2),
    convert_x(Steps, Steps1), convert_y(Steps1, Output_Steps),
    convert_string_config(Config, Output_Config),
    assemble_string(["$", Output_Steps, "$: & $", Output_Config, "$ \\\\ % Hops: ", Output_Steps, " Ones: ", Rest2] , Output_String). 
classify_line(String, Output_String) :-
    string_concat("% Otter transition is Otter ", Rest, String), !,
    divide_string(Rest, Otter_Number, ": ", Rest2),
    divide_string(Rest2, Config1, " ++> ", Rest3),
    divide_string(Rest3, Config2, " Diffs: ", Rest4),
    convert_string_config(Config1, Output_Config1), convert_string_config(Config2, Output_Config2),
    assemble_string(["Otter ", Otter_Number, " transition: $", Output_Config1, " \\leadsto ", Output_Config2, "$ \\\\ % Diffs: ", Rest4], Output_String). 
classify_line(String, Output_String) :-
    string_concat("% Final configuration is ", Rest, String), !,
    divide_string(Rest, Config, " Ones: ", Rest2), 
    convert_string_config(Config, Output_Config), 
    assemble_string(["\n{\\bf Final configuration}: $", Output_Config, "$ Ones: ", Rest2], Output_String). 
classify_line(String, Output_String) :-
    divide_string(String, Pre, " Unique Otters: ", Rest), !,
    string_concat("% Otters: ", Otters_Number, Pre),
    divide_string(Rest, Pre2, " Shape: ", Rest2),
    divide_string(Rest2, Config, " Shape Size: ", Rest3), 
    convert_string_config(Config, Output_Config), 
    assemble_string(["\n\nOtters: ", Otters_Number, " Unique Otters: ", Pre2, " Shape: $", Output_Config, "$ Shape Size: ", Rest3, "\n"], Output_String). 
classify_line(String, Output_String) :-
    string_concat("Applications Otter ", Rest, String), 
    divide_string(Rest, Otter_Number, " times: ", Rest2), !,
    divide_string(Rest2, Otter_Times,  ", steps: ", Otter_Steps), 
    assemble_string(["Otter ", Otter_Number, " applied ", Otter_Times, " times for ", Otter_Steps, " steps\n"], Output_String). 
classify_line(String, Output_String) :-
    string_concat("Otter ", Rest, String), !, % Must be otter dump after termination, so ... 
    divide_string(Rest, Otter_Number, ": ", Rest2),
    divide_string(Rest2, Config1, " ++> ", Rest3),
    divide_string(Rest3, Config2, " Diffs: ", Rest4),
    convert_string_config(Config1, Output_Config1), convert_string_config(Config2, Output_Config2),
    assemble_string(["%\\noindent\n%Otter ", Otter_Number, " transition: $", Output_Config1, " \\leadsto ", Output_Config2, "$ \\\\ % Diffs: ", Rest4], Output_String). 
classify_line(String, Output_String) :-
    string_concat("took ", Rest, String), !,
    string_concat(Time, " seconds", Rest),
    assemble_string(["Time taken: ", Time, " seconds"], Output_String).

% More cases here!
classify_line(String, String). % Note that this includes the case when String is empty.

% Take plain text string to Latex string ... 
convert_string_config(String, NewString) :-
    convert_x(String, String1), convert_y(String1, String2),
    clean_exponents(String2, String3),
    convert_brackets(String3, String4), 
    NewString = String4.

convert_x(String, NewString) :- divide_string(String, _, "X2", _), !, NewString = String. % Do nothing if more than one progressive variable
convert_x(String, NewString) :- replace_string("X1", "X", String, NewString). % Convert X1 into X. 
convert_y(String, NewString) :- divide_string(String,_, "Y2", _), !, NewString = String. % Do nothing if more than one regressive variable
convert_y(String, NewString) :- replace_string("Y1", "Y", String, NewString). % Convert Y1 into Y. 

clean_exponents(String, NewString) :- \+ single_exponent(_Term, String), !, NewString = String.
clean_exponents(String, NewString) :-
    single_exponent(Term, String), assemble_string(["(", Term, ")", "^"], Term1), string_concat(Term, "^", Term2),
    replace_string(Term1, Term2, String, String1),
    clean_exponents(String1, NewString). 

single_exponent(Term, String) :- divide_string(String, Pre, "^", _Rest), divide_string(Pre, Rest1, ")", ""), divide_string(Rest1, _Rest2, "(", Term), \+ divide_string(Term, _, "(", _), string_length(Term, 1).
% single_exponent(Term, String, "*") :- divide_string(String, Pre, "*", _Rest), divide_string(Pre, _, "(", Rest1), divide_string(Rest1, Term, ")", _), string_length(Term, 1).

% % Succeds if first char is ( and last is )
% bracket_string(String) :- sub_string(String, 0, 1, _, "("), sub_string(String, _, 1, 0, ")"). 

convert_brackets(String, NewString) :-
    replace_string("{a}", "\\{a\\}", String,   String1),
    replace_string("{b}", "\\{b\\}", String1,  String2),
    replace_string("{c}", "\\{c\\}", String2,  String3),
    replace_string("{d}", "\\{d\\}", String3,  String4),
    replace_string("{e}", "\\{e\\}", String4,  String5),
    replace_string("{f}", "\\{f\\}", String5,  String6),
    replace_string("{g}", "\\{g\\}", String6,  String7),
    replace_string("{h}", "\\{h\\}", String7,  String8),
    replace_string("{z}", "\\{z\\}", String8,  String9),
    replace_string("{r}", "\\{r\\}", String9,  String10),
    replace_string("{l}", "\\{l\\}", String10, String11), !, 
    NewString = String11.

real_arguments("([])", "none") :- !. 
real_arguments(Args, Real_Args) :- string_concat("([", Other, Args), string_concat(Real_Args, "])", Other).  

% assemble list of strings List into single string String
assemble_string([], "").
assemble_string(List, String) :- length(List, 1), List = [String].
assemble_string(List, String) :- length(List, N), N > 1, List = [S1|Rest], assemble_string(Rest, RestString), string_concat(S1, RestString, String). 

% divide string String around Substring. Pre is the string before Substring. Post is the string after it. 
divide_string(String, Pre, Substring, Post) :-
    sub_string(String, Before, _, After, Substring),
    sub_string(String, 0, Before, _, Pre),
    sub_string(String, _, After, 0, Post). 

% There is a path in machine M of length N from S to NS
path(S,NS,N,M,[t(S,I,O,D,NS)]) :- N is 1, remove(t(S,I,O,D,NS), M, _RestM). 
path(S,NS,N,M,[t(S,I,O,D,S1)|Path]) :- N > 1, remove(t(S,I,O,D,S1), M, RestM), N1 is N - 1, path(S1,NS,N1,RestM,Path).
      
% There is a simple path in machine M of length N from S to NS.
% This means that S does not appear in the internal part of the path. 
simple_path(S,NS,N,M,Path) :- simple_path1(S, S,NS,N,M,Path).
simple_path1(_Source, S,NS,N,M,[t(S,I,O,D,NS)]) :-
      N is 1, remove(t(S,I,O,D,NS), M, _RestM). 
simple_path1(Source, S,NS,N,M,[t(S,I,O,D,S1)|Path]) :-
      N > 1, remove(t(S,I,O,D,S1), M, RestM), 
      N1 is N - 1, Source \== S1, 
      simple_path1(Source,S1,NS,N1,RestM,Path).

% There is a cycle in machine M of length N from S to S
cycle(S,N,M,Path) :- path(S,S,N,M,Path). 

% There is a path in machine M of length somewhere between 1 and size(M) from S to NS
some_path(S,NS,M,Path) :- dimension(M,Size), between(1,Size,N), path(S,NS,N,M,Path).

% There is a simple path in machine M of length somewhere between 1 and size(M) from S to NS
some_simple_path(S,NS,M,Path) :- dimension(M,Size), between(1,Size,N), simple_path(S,NS,N,M,Path).

% Size is the size of M. One day this will include direction as well. 
dimension(M, Size) :- number_of_states(M,States), number_of_symbols(M,Symbols), Size is States * Symbols, !. 

dir_to_string(l, "L").
dir_to_string(r, "R").

% % Powershell:
% % cd C:\Users\User\'OneDrive - RMIT University'\Research\Papers\busybeaver\Diagrams\Monsters
% % $nums = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100
% foreach ($n in $nums) { C:\'Program Files'\Graphviz\bin\dot -Tpng -o monster$n.png monster$n.dot }

% % cd C:\Users\User\'OneDrive - RMIT University'\Research\Papers\busybeaver\Diagrams\Monsters
% % $nums = 116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240
% foreach ($n in $nums) { C:\'Program Files'\Graphviz\bin\dot -Tpng -o monster$n.png monster$nnormalnew.dot }

% Select-String -Patter 'Regression' *-test26-3.txt | Out-File regressions.txt

%  $nums = 1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115
% foreach ($n in $nums) { Select-String -Pattern 'Otter counting anomaly' *-test26-6.txt | Out-File anomalies2.txt }


% S = (200*(2^8589934592-1)+ -510*(2^4294967296-1)+734439407616)//3+307445734261178167080. 

% S = ((4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+2147483644//2*4860)//405.


% S = ((4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+2147483644//2*4860)//405, S = T //U, T = X+Y, Y1 is Y, T1 = X+Y1.
% S = ((4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+2147483644//2*4860)//405,
% T  = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+2147483644//2*4860,
% U = 405,
% X = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240),
% Y = 2147483644//2*4860,
% Y1 = 5218385254920,
% T1 = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+5218385254920.

% T1 = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+5218385254920, T1 = X+Y, X = W + Z, Z1 is Z.
% T1 = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240)+5218385254920,
% X = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972)+(4^(2147483644//2)-1)*(-1080*13+ -3240),
% Y = 5218385254920,
% W = (4^(2*(2147483644//2))-1)*(108*13*13+648*13+972),
% Z = (4^(2147483644//2)-1)*(-1080*13+ -3240),

%  B = 2147483644, Z = 4^B.

% B = 2147483666, Z = 4^B, C is B+B, _ is 2^C.


% B = 1234567892147483487, Z = 4^B, C is B+B, _ is 2^C. succeeds. 

% B = 2147483700, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483650, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483649, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483648, Z = 4^B, C is B+B, _ is 2^C. succeeds % 2^31
% B = 2147483647, Z = 4^B, C is B+B, _ is 2^C. crashes. % 2^31-1
% B = 2147483646, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483645, Z = 4^B, C is B+B, _ is 2^C. crashes
% B = 2147483644, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483643, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483642, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483641, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483640, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483639, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483638, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483600, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483500, Z = 4^B, C is B+B, _ is 2^C. crashes
% B = 2147483493, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483492, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483491, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483490, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483489, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483488, Z = 4^B, C is B+B, _ is 2^C. crashes.
% B = 2147483487, Z = 4^B, C is B+B, _ is 2^C. succeeds % 2^31-161
% B = 2147483486, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483485, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483484, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483483, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483482, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483481, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483480, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483479, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483478, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483477, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483476, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483475, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483450, Z = 4^B, C is B+B, _ is 2^C. succeeds
% B = 2147483400, Z = 4^B, C is B+B, _ is 2^C. succeeds

% C = 4294966974, _ is 2^C. succeeds
% C = 4294966975, _ is 2^C. succeeds
% C = 4294966976, _ is 2^C. crashes

% C is 2147479551, _ is 2^C. succeeds
% C is 2147479552, _ is 2^C. crashes
