% -*- Prolog -*-
modulus_exponents(Config, Mods) :- setof(Mod, contains_mod(Config, Mod), Mods). 

contains_mod(Term, SubTerm) :- sub_term(SubTerm, Term), nonvar(SubTerm), SubTerm = _Z mod N, integer(N), N > 0. 

find_mod(Mods, _Progs, _Regs, Exponents, Names, Mods) :-
    member(mod(X,_N,_V), Mods), sub_term(S, Exponents), var(S), term_string(S, String, [variable_names(Names)]), String == X, !. % There is a compatible constraint, ie some variable has an existing constraint on it. 
find_mod(Mods, Progs, Regs, Exponents, Names, NewMods) :-
    % No compatible constraint
    sub_term(S, Exponents), var(S), term_string(S, Var, [variable_names(Names)]), init_value(Var, Progs, Regs, V1), member(_Exp mod N, Exponents), V is V1 mod N,
    append(Mods, [mod(Var,N,V)], NewMods). 
    
init_value("X1", Progs, _, V1) :- Progs = [V1|_],!. % Ugh!
init_value("X2", Progs, _, V1) :- append(P1, P2, Progs), length(P1, 1), P2 = [V1|_], !.
init_value("X3", Progs, _, V1) :- append(P1, P2, Progs), length(P1, 2), P2 = [V1|_].
init_value("Y1", _, Regs, V1) :-  Regs = [V1|_], !. % Ugh! 
init_value("Y2", _, Regs, V1) :-  append(R1, R2, Regs), length(R1, 1), R2 = [V1|_], !.
init_value("Y3", _, Regs, V1) :-  append(R1, R2, Regs), length(R1, 2), R2 = [V1|_].

rewrite_modulus([], Config, Hops, Pos, Moves, _, Config, Hops, Pos, Moves).
rewrite_modulus(Mods, Config, Hops, Pos, Moves, _, Config, Hops, Pos, Moves) :-  Mods \== [], \+ compatible_moduli2(Mods). 
rewrite_modulus(Mods, Config, Hops, Pos, Moves, Names, NewConfig, NewHops, NewPos, NewMoves) :-
    Mods \== [], compatible_moduli2(Mods), % Either only one or all the same modulus.
    rewrite_modulus1(Mods, Config, Hops, Pos, Moves, Names, NConfig, NHops, NPos, NMoves), % Still need to check if moduli remain anywhere in Config or Hops (or anywhere else?)
    ( check_for_moduli(Mods, Names, NConfig, NHops) -> rewrite_modulus(Mods, NConfig, NHops, NPos, NMoves, Names, NewConfig, NewHops, NewPos, NewMoves); (NewConfig = NConfig, NewHops = NHops, NewPos = NPos, NewMoves = NMoves) ), 
    true. 

% Needs to be specific for variables, so that X2 mod 2 does not get detected for X1 mod 2 ... 
check_for_moduli(Mods, Names, Config, _Hops) :- modulus_exponents(Config, Exponents), contains_mods(Mods, Names, Exponents), !. % At least one modulus is in Mods 
check_for_moduli(Mods, Names, _Config, Hops) :- modulus_exponents(Hops, Exponents),   contains_mods(Mods, Names, Exponents),  !. % At least one modulus is in Mods 

contains_mods(Mods, Names, Exponents) :- member(mod(X,_N,_V), Mods), sub_term(S, Exponents), var(S), term_string(S, String, [variable_names(Names)]), String == X, !. % There is a compatible constraint, ie some variable has an existing constraint on it. 

rewrite_modulus1([], Config, Hops, Pos, Moves, _, Config, Hops, Pos, Moves).
rewrite_modulus1([Mod|RestMods], Config, Hops, Pos, Moves, Names, NewConfig, NewHops, NewPos, NewMoves) :-
    Config = config(Left, State, Item, Dir, Right),
    % format("Rewriting Left ... ~n", []), 
    rewrite_expressions_tape(Mod, Names, Left, NewLeft1),
    % format("Rewriting Item ... ~n", []), 
    rewrite_expressions_tape(Mod, Names, [Item], [NewItem1]),
    % format("Rewriting Right ... ~n", []), 
    rewrite_expressions_tape(Mod, Names, Right, NewRight1),

    NConfig1 = config(NewLeft1, State, NewItem1, Dir, NewRight1), reconfigure(NConfig1, NewConfig1), % Need to potentially reconfigure here ...
    % format("Rewriting Hops ... ", []), write_term(Hops, [variable_names(Names)]), format(" which is ", []), writeln(Hops), 
    rewrite_expression(Mod, Names, Hops, NewHops1),
    % format("Rewriting Pos ... ~n", []), 
    rewrite_expression(Mod, Names, Pos, NewPos1),
    % format("Rewriting Moves ... ~n", []), 
    rewrite_expression(Mod, Names, Moves, NewMoves1),

    rewrite_modulus1(RestMods, NewConfig1, NewHops1, NewPos1, NewMoves1, Names, NewConfig, NewHops, NewPos, NewMoves).

compatible_moduli(Mods) :- length(Mods, 1), !. 
% compatible_moduli(Mods) :- length(Mods, L), L > 1, Mods = [mod(_, N, _)|RestMods], compatible_moduli(RestMods, N).
compatible_moduli(Mods) :- Mods = [mod(_, N, _)|RestMods], compatible_moduli(RestMods, N).
compatible_moduli([], _).
compatible_moduli([mod(_,N,_)|Rest], N) :- compatible_moduli(Rest, N).

compatible_moduli2(Mods) :- length(Mods, 1), !.
compatible_moduli2(Mods) :- findall(V, member(mod(V,_,_), Mods), VarList), length(VarList, L1), sort(VarList, Sorted), length(Sorted, L1). % cheap test to see if there are duplicated varibles. If not the moduli are compatible. 


			    


rewrite_expressions_tape(_, _, [], []).
rewrite_expressions_tape(Mod, Names, [Item|Rest], [NewItem|Result]) :-
    Item = grp(I,Exp), !, rewrite_expression(Mod, Names, Exp, NewExp),
    NewItem = grp(I, NewExp), 
    rewrite_expressions_tape(Mod, Names, Rest, Result).

% rewrite Exp using Var is Value mod N
rewrite_expression(Mod, Names, Exp, NewExp) :-
    % rewrite_expression1(Mod, Exp, Exp1),    % First re-write K*((Expression)//N) where K is a multiple of N as (K//N)*(Expression - Expression mod N )
    % simplify_expression(Exp, Exp1), % First re-write K*((Expression)//N) where K is a multiple of N as (K//N)*(Expression - Expression mod N )
    % rewrite_expression2(Mod, Names, Exp, Exp2), % Then replace all occurrences of Expression mod N with the value from Var mod N being Value
    % format("Rewriting ", []), write_term(Exp, [variable_names(Names)]), 
    rewrite_expression2_new(Mod, Names, Exp, Exp2), % Then replace all occurrences of Expression mod N with the value from Var mod N being Value
    % format(" ...rewritten to ", []), write_term(Exp2, [variable_names(Names)]), nl, 
    simplify_expression(Exp2, NewExp), % and simplify, just to be sure.
    % format(" ... and then simplified to to ", []), write_term(NewExp, [variable_names(Names)]), nl, 
    true. 

rewrite_expression1(_, Exp, Exp) :- ground(Exp); var(Exp), !.
rewrite_expression1(Mod, Exp, NewExp) :-                 Exp = X + Y, !, rewrite_expression1(Mod, X, NewX), rewrite_expression1(Mod, Y, NewY), NewExp = NewX + NewY.
rewrite_expression1(Mod, Exp, NewExp) :-                 Exp = X - Y, !, rewrite_expression1(Mod, X, NewX), rewrite_expression1(Mod, Y, NewY), NewExp = NewX - NewY.
rewrite_expression1(mod(_Var,N,_Value), Exp, NewExp)  :- sub_term(T, Exp), nonvar(T), T = _//_, Exp = N*(SubExp // N), !, NewExp = SubExp - (SubExp mod N).
rewrite_expression1(mod(_Var,N,_Value), Exp, NewExp)  :- sub_term(T, Exp), nonvar(T), T = _//_, Exp = N*((SubExp // N) + M), ground(M), !, NewExp = SubExp + N*M - (SubExp mod N).
rewrite_expression1(mod(_Var,N,_Value), Exp, NewExp)  :- sub_term(T, Exp), nonvar(T), T = _//_, Exp = K*(SubExp // N), 0 is K mod N, !, K1 is K//N, NewExp = K1*(SubExp) - K1*(SubExp mod N).
rewrite_expression1(mod(_Var,N,_Value), Exp, NewExp)  :- sub_term(T, Exp), nonvar(T), T = _//_, Exp = K*((SubExp // N) + M), 0 is K mod N, ground(M), !, K1 is K//N, NewExp = K1*(SubExp) + K*M - K1*(SubExp mod N).
rewrite_expression1(mod(_Var,_N,_Value), Exp, NewExp) :- NewExp = Exp. 

rewrite_expression2(mod(_Var,N,_Value), _Names, Term, Term) :- \+ contains_mod(Term, N, _), !. 
rewrite_expression2(mod(Var,N,_Value), Names, Term, Term) :-  contains_mod(Term, N, Exp mod _M), \+ contains_variable(Exp, Var, Names), !. % Check that Exp contains Var. If not, nothing to do. 
rewrite_expression2(mod(Var,N,Value), Names, Term, NewTerm) :-
    contains_mod(Term, N, Exp mod M), % We know we are good if we get to here ...
    term_string(Exp mod M, ExpS, [variable_names(Names)]),
    number_string(Value, ValueS), 
    replace_string(Var, ValueS, ExpS, NewExpS), % Replace Var with ValueS in ExpS
    format("Finding names with ~k~n", [Names]), 
    find_names(Names, NewExpS, [], SubNames1), % Find appropriate subset of Names (ie only those which occur in NewExpS). These names also have to be in the order they occur in the string (!!)
    format("Found ~k~n", [SubNames1]), 
    term_string(NewExp, NewExpS, [variable_names(SubNames1)]), % Simplify new expression if possible. Will be ground due to assumption that Var is the only variable in Exp
    format("Simplifying~n", []), 
    simplify_expression(NewExp, NewSimpleExp),
    term_string(NewSimpleExp, NewExpString, [variable_names(Names)]), 
    term_string(Term, TermString, [variable_names(Names)]), % Replace Exp mod N appropriately in Term
    format("Replacing ~s with ~s in ~s~n", [ExpS,NewExpString,TermString]), 
    replace_string(ExpS, NewExpString, TermString, NewTermS),
    format("Finding subnames in ~k~n", [Names]), 
    find_names(Names, NewTermS, [], SubNames2),     % find appropriate subset of names (ie only those which occur in NewTermS)
    format("Reconverting ~s with ~k~n", [NewTermS,SubNames2]), 
    term_string(NewTerm, NewTermS, [variable_names(SubNames2)]).

% True if the term Term contains the variable named VarName. 
contains_variable(Term, VarName, Names) :- term_string(Term, TermString, [variable_names(Names)]), string_compose(_, VarName, _, TermString), variable_name(VarName).

contains_mod(Term, N, Exp mod M) :- sub_term(S, Term), \+var(S), S = Exp mod M, 0 is N mod M. % S = Exp mod N, or S = Exp mod M where N is a multiple of M. 

reasonable_config(config(Left, _State, Item, _Dir, Right)) :- append(Left, [Item], Temp), append(Temp, Right, Tapes), \+ unreasonable(Tapes).

unreasonable(Tapes) :- member(grp(_Item, N), Tapes), unreasonable_term(N), !. 
unreasonable_term(Term) :- \+ ground(Term), div_subterm(Term, _S), !. % sub_term(S, Term), \+ var(S), S = _ / _. % Can't handle terms like 5/3 in Monster 74. Need to check this and 76, 77, 79 out.
unreasonable_term(Term) :- \+ ground(Term), min_subterm(Term, _S), !. 

simple_config(config(Left, _State, Item, _Dir, Right)) :- append(Left, [Item], Temp), append(Temp, Right, Tapes), \+ complex(Tapes).

complex(Tapes) :- member(grp(_Item, N), Tapes), complex_term(N), !.

complex_term(Term) :- \+ ground(Term), div_subterm(Term, _S), !.
complex_term(Term) :- \+ ground(Term), intdiv_subterm(Term, _S), !.
complex_term(Term) :- \+ ground(Term), min_subterm(Term, _S), !.
complex_term(Term) :- \+ ground(Term), mod_subterm(Term, _S), !. 

div_subterm(Exp, S) :- sub_term(S, Exp), \+ var(S), S = _ / _.
intdiv_subterm(Exp, S) :- sub_term(S, Exp), \+ var(S), S = _ // _.
min_subterm(Exp, S) :- sub_term(S, Exp), \+ var(S), S = min(_,_).
mod_subterm(Exp, S) :- sub_term(S, Exp), \+ var(S), S = _ mod _. 
exp_subterm(Exp, S) :- sub_term(S, Exp), \+var(S), (S = _**_; S = _^_). 

% Sort list of variables into term order, so that the ordering is X,X1,Y1,Y2,Z etc. 
sort_variables(L, Sorted) :- maplist(term_string, L, Sorted), true.  

construct_names(L, Names) :- length(L, N), name_list(N, VarNames), construct_names1(L, VarNames, Names).

name_list(0, []).
name_list(1, ['Var1']).
name_list(N, Names) :- N > 1, N1 is N-1, name_list(N1, Names1), number_string(N, Nstring), string_concat("Var", Nstring, StringName), atom_string(NameN, StringName), append(Names1, [NameN], Names). 

construct_names1([], [], []).
construct_names1([V|Rest], [Nextname|RestNames], [N|Result]) :- N = (Nextname=V), !, construct_names1(Rest, RestNames, Result). 
    
% term_sort(<, T1, T2) :- T1 @< T2.
% term_sort(=, T1, T2) :- T1 ==@< T2.
% term_sort(>, T1, T2) :- T1 @< T2. 

convert_to_strings([], []).
convert_to_strings([V|Rest], [VString|Result]) :-
    term_string(V, VString),
    convert_to_strings(Rest, Result). 

%% Note that simplifying 2**X where X is bigger than about 10**7 takes more than 1Gb of memory ... so don't do it explicitly! But how? Perhaps build it into simplify_expression rather than using the built-in evaluation?

% Needs to recognise that N*(X+K)//N = X + K//N and that (N*X +K)//N = X + K//N. 
% simplify_expression(Exp, ExpSimple) :- ground(Exp), integer_safe(Exp), !, ExpSimple is Exp.
simplify_expression(Exp, ExpSimple) :- ground(Exp), !, simplify_ground(Exp, ExpSimple).

simplify_expression(Exp, ExpSimple) :- 
    termify(Exp, Terms), classify_terms(Terms, Simple, Complex, Ground),
    % format("Term ", []), write(Exp), format("Classified as Simple: ", []), write(Simple), format(" Complex: ", []), write(Complex), format("Ground: ", []), writeln(Ground), 
        % format("Reducing ... ", []), writeln(Complex), flush_output, 
  	reduce_complex(Complex, T2),
	% ( (Complex \== [], T2 \== T3) -> format("Difference reducing ~k to ~k and ~k~n", [Complex, T2,T3]) ; true ), 
	% format("Reduced~n", []), flush_output, 
% 	termify_list(T2, [], ComplexTerms),
% 	(ComplexTerms \== [] -> (format("termified to", []), writeln(ComplexTerms)); true ), 
% 	format("termified to", []), writeln(ComplexTerms), 
	% update_ground(T2, VarT2, GroundT2), append(Ground, GroundT2, NewGround), % To allow for simple and ground outcomes from reduce_complex
	% 	classify_terms(ComplexTerms, ST2, CT2, GT2), append(Simple, ST2, NewSimple),
	classify_terms(T2, ST2, CT2, GT2), append(Simple, ST2, NewSimple),
	% (CT2 \== [] -> (format("classified to", []), writeln(CT2)); true ), 
	reduce_simple(NewSimple, T1, none), 

	append(Ground, GT2, NewGround), 
	eval_ground(NewGround, Constant), % Constant may not be simply a number due to non-integer-safe operations (/) and potentially overflowing exponentials.
	safe_eval(Constant, none, NewConstant), 
	%         compose_term(T1, VarT2, NewConstant, ExpSimple), !.
	compose_term(T1, CT2, NewConstant, ExpSimple), !. 

compose_term(T1, T2, C, Result) :- ground(T1), RealT1 is T1, RealT1 == 0, T2 == [], !, Result = C. 
compose_term(T1, T2, C, Result) :- ground(T1), RealT1 is T1, RealT1 == 0, T2 = [T|Rest], !, add_term(T, Rest, T3), add_nonzero(T3, C, Result).
compose_term(T1, T2, C, Result) :- add_term(T1, T2, T3), add_nonzero(T3, C, Result). 

termify(Exp, Terms) :- ground(Exp), safe(Exp), !, Term is Exp, Terms = [Term]. % Combine both cases into eval_ground???
termify(Exp, Terms) :- ground(Exp), !, Term = Exp, Terms = [Term]. % For cases which have exponentials that are too big. Must figure something else out here. Need also to integrate this into the below and other places in the code where is/1 is used. Will also need to consider when constant terms are used that there is nothing assuming that constant is an integer rather than just a ground expression containing ^. So need a lazy_ground_eval predicate. Check eval_ground and other places where integer_safe is used. 
termify(Exp, Terms) :- var(Exp), !, Terms = [Exp].
termify(Exp, Terms) :- nonvar(Exp), Exp = X + Y, !, termify(X, Terms1), termify(Y, Terms2), append(Terms1, Terms2, Terms).
termify(Exp, Terms) :- nonvar(Exp), Exp = -X, !, termify(X, Terms1), negify(Terms1, Ts), eliminate_double_negatives(Ts, Terms).
termify(Exp, Terms) :- nonvar(Exp), Exp = X - Y, X \== Y, !, termify(X, Terms1), termify(Y, Terms2), negify(Terms2, T3), eliminate_double_negatives(T3, Terms3), append(Terms1, Terms3, Terms).
termify(Exp, [])    :- nonvar(Exp), Exp = X - Y, X == Y, !.
termify(Exp, Terms) :- nonvar(Exp), Exp = X * Y, !, simplify_expression(X, T1), simplify_expression(Y, T2), termify(T1, Terms1), termify(T2, Terms2), multiply_terms(Terms1, Terms2, [], Terms).
termify(Exp, Terms) :- !, Terms = [Exp]. % Default

% Terms is a list of terms to be decomposed ... 
termify_list([], SoFar, SoFar).
termify_list([Term|Rest], SoFar, Result) :- termify(Term, Terms), append(SoFar, Terms, NewSoFar), termify_list(Rest, NewSoFar, Result). 

safe(Exp) :- integer_safe(Exp), exponential_safe(Exp).

integer_safe(Exp) :- div_subterms(Exp, Terms), Terms == []. 

div_subterms(Exp, SubTerms) :- findall(S, div_subterm(Exp, S), SubTerms1), sort(SubTerms1, SubTerms). 

exponential_safe(Exp) :- exponential_subterms(Exp, Terms), all_exp_safe(Terms).

exponential_subterms(Exp, SubTerms) :- findall(S, exp_subterm(Exp, S), SubTerms1), sort(SubTerms1, SubTerms). 

all_exp_safe([]).
all_exp_safe([Term|Terms]) :- (Term = B**N; Term = B^N), !, N1 is N, safe_max(B,N1), all_exp_safe(Terms). 

safe_max(1,_). % You never know ... :-)
safe_max(2,N) :- power2max(M), N =< M.
safe_max(K,N) :- K > 2, Factor is log(K)/log(2), power2max(M), N =< round(M/Factor). %  as K^N = (2^Factor)^N.  

power2max(2147483647). % Because _ is 2^2147483648 overflows a 1Gb stack ... 
% power2max(4611686018427387904). % This is 2^62, which gives a little margin of safely on a 64-bit machine

negify([], []).
% negify([T|Terms], [NT|Result]) :-  nonvar(T) =.. [-|Term], !, NT = Term, negify(Terms, Result).
negify([T|Terms], [NT|Result]) :- !, NT = -T, negify(Terms, Result).

eliminate_double_negatives([], []).
eliminate_double_negatives([T|Terms], [NT|Result]) :- eliminate_dn(T, NT), eliminate_double_negatives(Terms, Result).

eliminate_dn(T, Term) :- nonvar(T), T =.. [-|[Next]], nonvar(Next), Next =.. [-|[Term]].
eliminate_dn(T, T). 

multiply_terms([], _, SoFar, SoFar).
multiply_terms([T1|Terms1], Terms2, SoFar, Result) :- multiply_all(T1, Terms2, [], Temp1), append(SoFar, Temp1, NewSoFar), multiply_terms(Terms1, Terms2, NewSoFar, Result).

multiply_all(_T, [], SoFar, SoFar).
multiply_all(T, [T1|Rest], SoFar, Result) :- ground(T), ground(T1), !, NewT is T*T1, append(SoFar, [NewT], NewSoFar), multiply_all(T, Rest, NewSoFar, Result).
multiply_all(T, [T1|Rest], SoFar, Result) :- ground(T), \+ ground(T1), T \== 1, T \== 0, !, append(SoFar, [T*T1], NewSoFar), multiply_all(T, Rest, NewSoFar, Result).
multiply_all(T, [T1|Rest], SoFar, Result) :- ground(T), \+ ground(T1), T == 1, !, append(SoFar, [T1], NewSoFar), multiply_all(T, Rest, NewSoFar, Result).
multiply_all(T, [T1|Rest], SoFar, Result) :- ground(T), \+ ground(T1), T == 0, !, append(SoFar, [0], NewSoFar), multiply_all(T, Rest, NewSoFar, Result). 
multiply_all(T, [T1|Rest], SoFar, Result) :- \+ ground(T), ground(T1), T1 \== 1, T1 \== 0, !, append(SoFar, [T1*T], NewSoFar), multiply_all(T, Rest, NewSoFar, Result).
multiply_all(T, [T1|Rest], SoFar, Result) :- \+ ground(T), ground(T1), T1 == 1, !, append(SoFar, [T], NewSoFar), multiply_all(T, Rest, NewSoFar, Result).
multiply_all(T, [T1|Rest], SoFar, Result) :- \+ ground(T), ground(T1), T1 == 0, !, append(SoFar, [0], NewSoFar), multiply_all(T, Rest, NewSoFar, Result).
multiply_all(T, [T1|Rest], SoFar, Result) :- \+ ground(T), \+ ground(T1), NewT = T*T1, !, append(SoFar, [NewT], NewSoFar), multiply_all(T, Rest, NewSoFar, Result). 

classify_terms([], [], [], []).
classify_terms([Term|Rest], Simple, Complex, [Term|Ground]) :- ground(Term), !, classify_terms(Rest, Simple, Complex, Ground). 
classify_terms([Term|Rest], [Term|Simple], Complex, Ground) :- simple_term(Term), !, classify_terms(Rest, Simple, Complex, Ground). 
classify_terms([Term|Rest], Simple, [Term|Complex], Ground) :- classify_terms(Rest, Simple, Complex, Ground). 

update_ground([], [], []). 
update_ground([Term|Rest], Var, [Term|Ground]) :- ground(Term), !, update_ground(Rest, Var, Ground).
update_ground([Term|Rest], [Term|Var], Ground) :- update_ground(Rest, Var, Ground). 

eval_ground(List, Term) :- divide_ground(List, Safe, Others), sum_list(Safe, Constant), maplist(simplify_ground, Others, NewList), gather_constants(NewList, Constant, Term).

divide_ground([], [], []).
divide_ground([Term|Rest], [Term|Safe], Others) :- integer(Term), !, divide_ground(Rest, Safe, Others). % Only if it is an integer. Otherwise there is still work to do. 
divide_ground([Term|Rest], Safe, [Term|Others]) :- divide_ground(Rest, Safe, Others).

gather_constants([], C, C) :- !.
gather_constants(List, C, NewTerm) :- length(List, 1), List = [Term], C == 0,  !, NewTerm = Term. 
gather_constants(List, C, NewTerm) :- length(List, 1), List = [Term], C \== 0, !, NewTerm = Term + C. 
gather_constants(List, C, NewTerm) :- C == 0,  !, sum_terms(List, Sum), NewTerm = Sum.
gather_constants(List, C, NewTerm) :- C \== 0, !, sum_terms(List, Sum), NewTerm = Sum + C. 

sum_terms([], 0). 
sum_terms(List, Sum) :- length(List, 1), List = [Term], !, Sum = Term.
sum_terms([Term|Rest], Sum) :- sum_terms(Rest, Sum1), Sum = Term + Sum1. 

simple_term(T) :- var(T), !.
simple_term(T) :- T = N*X, ground(N), simple_term(X), !.
simple_term(T) :- T = X*N, ground(N), simple_term(X), !.
simple_term(T) :- T =.. [-|S], S = [W], simple_term(W). % Could do more --- what about -(X+1)?? 

reduce_simple(S, T, N) :- term_variables(S, Vars), gather_variables(Vars, S, N, T).

% This needs rewriting! 
% A complex term must contain mod, // or /. May also contain * and ** now (!!). Idea is term is the produce of the terms in the first arugment and the coefficient Num/Denom.
% Want (2*X + 7)//2 to reduce to X + 7//2 = X + 3.
% Also want 2*(X+4)//2 to reduce to X+4 - (X+4) mod 2, and to X+4 when it is known that X+4 mod 2 = 0. Note that this needs to be interpreted as 2*((X+4)//2), as the Prolog version of 2*(X+4)//2 assumes that // is outermost. Check where exponents are multiplied ...
% Note also the difference between 2(X//2) = X - X mod 2 and (2*X//2) = X. 

reduce_complex(Terms, Results) :-  gather_factors(Terms, Terms1),        % (Terms1 \== [] -> (write(Terms), format(" gathered to ", []),    writeln(Terms1)); true ), 
				    aggregate_factors(Terms1, Terms2),     % (Terms2 \== [] -> (format("Aggregrated to ", []), writeln(Terms2)); true ), 
				    reduce_divs(Terms2, Terms3),          % (Terms3 \== [] -> (format("Reduced to     ", []), writeln(Terms3)); true ), 
				    normalise_all_divs(Terms3, Terms4),    % (Terms4 \== [] -> (format("Normalised to  ", []), writeln(Terms4)); true ), 
				    reassemble_list_terms(Terms4, Terms5), % (Terms5 \== [] -> (format("Reassembled to ", []), writeln(Terms5)); true ), 
				    Results = Terms5. 

simplify_terms([], []).
simplify_terms([t(Factor, Base)|Rest], [t(Factor, NewBase)|Result]) :- maplist(simplify_expression, Base, NewBase), simplify_terms(Rest, Result). 

% Simplifies constants in each term
gather_factors([], []).
gather_factors([Term|Rest], [t(Factor, NewBase)|Result]) :- gather_factor_term(1, Term, Factor, Base), msort(Base, NewBase), gather_factors(Rest, Result). 
    
gather_factor_term(SoFar, Term, Factor, [1]) :- ground(Term), !, Factor = Term*SoFar. % Presumably should not happen!
gather_factor_term(SoFar, Term, Factor, [Base]) :- var(Term), !, Factor = SoFar, Base = Term.
gather_factor_term(SoFar, Term, Factor, Base) :- nonvar(Term), Term = -(Term1), !, NewSoFar = -1 * SoFar, gather_factor_term(NewSoFar, Term1, Factor, Base). 
gather_factor_term(SoFar, Term, Factor, Base) :- nonvar(Term), Term = Term1 * Term2, ground(Term1), !, NewSoFar is Term1*SoFar, gather_factor_term(NewSoFar, Term2, Factor, Base).
gather_factor_term(SoFar, Term, Factor, Base) :- nonvar(Term), Term = Term1 * Term2, ground(Term2), !, NewSoFar is Term2*SoFar, gather_factor_term(NewSoFar, Term1, Factor, Base).
gather_factor_term(SoFar, Term, Factor, Base) :- nonvar(Term), Term = Term1 * Term2, !, simplify_expression(Term1, T1), simplify_expression(Term2, T2), gather_factor_term(1, T1, F1, B1), gather_factor_term(1, T2, F2, B2), Factor is F1*F2*SoFar, append(B1,B2, Base). 
gather_factor_term(SoFar, Term, Factor, [Base]) :- nonvar(Term), (Term = Term1 ** Term2; Term = Term1 ^ Term2), ground(Term1), !, simplify_expression(Term2, SimpleT2), Factor = SoFar, Base = Term1 ^ SimpleT2.
gather_factor_term(SoFar, Term, Factor, [Base]) :- nonvar(Term), Term = Term1 // Term2, ground(Term2), N is Term2, integer(N), N > 1, !, simplify_expression(Term1, SimpleT1), Factor = SoFar, Base = SimpleT1 // Term2. 
gather_factor_term(SoFar, Term, Factor, [Base]) :- nonvar(Term), Term = Term1 // Term2, ground(Term2), 1 is Term2, !, simplify_expression(Term1, SimpleT1), Factor = SoFar, Base = SimpleT1.
gather_factor_term(SoFar, Term, Factor, [Base]) :- nonvar(Term), Term = Term1 mod N, ground(N), N1 is N, integer(N1), N1 > 1, !, simplify_expression(Term1, SimpleT1), reduce_modulo(SimpleT1, N1, T2), build_term_new(Term, T2, N1, 1, 1, F1, Base), Factor is SoFar*F1.
gather_factor_term(SoFar, Term, Factor, [Base]) :- nonvar(Term), Term = _Term1 mod N, ground(N), 1 is N, !, Factor = SoFar, Base = 0. % Shouldn't happen, but ...
gather_factor_term(SoFar, Term, Factor, [Base]) :- nonvar(Term), !, Factor = SoFar, Base = Term. % Catch all

% % Applies K*(Z//N) -> (K//N)*(Z - Z mod N) when possible 
reduce_divs([], []).
reduce_divs([t(Factor, Base)|Rest], Result)                        :- nonvar(Base), member(T, Base), nonvar(T), T = Z//N, integer(N), 0 is Factor mod N, !, % we have a // that we can reduce ...  
								       NewFactor is Factor // N, NewT = Z - Z mod N, replace_in_list(T, NewT, Base, NewBase), reduce_divs([t(NewFactor, NewBase)|Rest], Result).  % So see if we can repeat it. 
reduce_divs([t(Factor, Base)|Rest], [t(Factor, Base)|Result])      :- reduce_divs(Rest, Result). % Otherwise do nothing.

% Because delete stuffs up on  delete([(X-3)//4,X], (X-3)//4, Rest). (!! believe it or not!!)
replace_in_list(Item, NewItem, [Element|Rest], [NewItem|Rest]) :- Element == Item, !.
replace_in_list(Item, NewItem, [Element|Rest], [Element|Result]) :- Element \== Item, replace_in_list(Item, NewItem, Rest, Result). 

normalise_all_divs([], []).
normalise_all_divs([t(Factor,Base)|Rest], [t(Factor,NewBase)|Result]) :- maplist(normalise_divs, Base, NewBase), normalise_all_divs(Rest, Result). 

% Perform reduction like (2X+7)//2 = X+3. More generally this should be (a*X+b)//N = (a//N)*X + b//N + ((a mod N)*X + b mod N)//N. 
% normalise_divs(Term, NewTerm) :- nonvar(Term), Term = (Exp)//N, integer(N), !, termify(Exp, Ts), classify_terms(Ts, S, C, G), eval_ground(G, Constant), classify_ns(S, N, 1, S1, S2), compose_term_n(S1, S2, C, Constant, N, 1, 1, NewTerm).
normalise_divs(Term, NewTerm) :- nonvar(Term), Term = (Exp)//N, integer(N), !, simplify_expression(Exp, Exp1), terms_in_expression(Exp1, Terms), classify_terms_in_expression(Terms, Coefficients, TermsList), apply_div_coefficients(Coefficients, N, TermsList, NewTerm). 
normalise_divs(Term, Term). % Otherwise do nothing. 

% (a*X+b)//N = (a//N)*X + b//N + ((a mod N)*X + b mod N)//N. 
apply_div_coefficients(Coefficients, N, Terms, NewTerm) :-
    div_coefficients(Coefficients, N, Outer, Inner),
    % make_into_terms(Terms, TermsList),
    maplist(make_into_term, Terms, TermsList), 
    make_outer_term(TermsList, Outer, OuterTerm), 
    make_inner_term(TermsList, Inner, InnerTerm),
    check_div_term(OuterTerm, InnerTerm, N, NewTerm). 

check_div_term(OuterTerm, InnerTerm, N, NewTerm) :- ground(InnerTerm), New is InnerTerm//N, simplify_expression(OuterTerm + New, NewTerm), !.
check_div_term(OuterTerm, InnerTerm, N, NewTerm) :- ground(OuterTerm), 0 is OuterTerm, NewTerm = InnerTerm//N, !. 
check_div_term(OuterTerm, InnerTerm, N, NewTerm) :- NewTerm = OuterTerm + InnerTerm//N. 

div_coefficients([], _, [], []).
div_coefficients([C|Rest], N, [A|Rest1], [B|Rest2]) :- C >= 0, !, A is C//N, B is C mod N, div_coefficients(Rest, N, Rest1, Rest2).
div_coefficients([C|Rest], N, [A|Rest1], [B|Rest2]) :- C < 0, !, C1 is 0-C, A is 0-C1//N, B is 0-C1 mod N, div_coefficients(Rest, N, Rest1, Rest2). 

make_into_term([], 1).
make_into_term(L, T) :- length(L, N), N > 0, !, reassemble_term(L, T). 

make_outer_term(Terms, Cs, Term) :- multiply_factors(Terms, Cs, 0, Result), simplify_expression(Result, Term), !.
make_inner_term(Terms, Cs, Term) :- multiply_factors(Terms, Cs, 0, Result), simplify_expression(Result, Term), !.

multiply_factors([], [], SoFar, SoFar).
multiply_factors([T|Terms], [C|Cs], SoFar, Result) :- assemble_mult(C, T, NewT), NewSoFar = SoFar + NewT, multiply_factors(Terms, Cs, NewSoFar, Result). 

% Add coefficients of common terms
% Will also work when Base is a list of terms rather than a single term. But it is a little inelegant to do that. May need to have Base sorted in order to do this. If so, use msort() to avoid eliminaing duplicates. 
aggregate_factors([], []).
aggregate_factors([t(Factor, Base)|Rest], [t(NewFactor, Base)|Result]) :- aggregate_base(Base, Rest, Factor, NewFactor, Others), aggregate_factors(Others, Result). 

% Add up factors for all instances of Term in List. 
aggregate_base(_Term, [], SoFar, SoFar, []).
aggregate_base( Term, [t(Factor2, Term2)|List], SoFar, Factor, Others)                     :- Term == Term2,  NewSoFar is SoFar + Factor2, aggregate_base(Term, List, NewSoFar, Factor, Others). % found one, so add up factors
aggregate_base( Term, [t(Factor2, Term2)|List], SoFar, Factor, [t(Factor2, Term2)|Others]) :- Term \== Term2, aggregate_base(Term, List, SoFar, Factor, Others).% not this one, so move on. 

% Make it look like a term again
reassemble_terms([], []).
reassemble_terms([t(Factor, _Base)|Rest], [NewTerm|Result]) :- Factor == 0,  !, NewTerm = 0, reassemble_terms(Rest, Result).
reassemble_terms([t(Factor,  Base)|Rest], [NewTerm|Result]) :- Factor == 1,  !, NewTerm = Base, reassemble_terms(Rest, Result).
reassemble_terms([t(Factor,  Base)|Rest], [NewTerm|Result]) :- Factor == -1, !, NewTerm = -(Base), reassemble_terms(Rest, Result).
reassemble_terms([t(Factor,  Base)|Rest], [NewTerm|Result]) :- NewTerm = Factor * (Base), reassemble_terms(Rest, Result).

reassemble_list_terms([], []).
reassemble_list_terms([t(Factor, _Base)|Rest], [NewTerm|Result]) :- Factor == 0,  !, NewTerm = 0, reassemble_list_terms(Rest, Result).
reassemble_list_terms([t(Factor,  Base)|Rest], [NewTerm|Result]) :- Factor == 1,  !, reassemble_term(Base, NewTerm), reassemble_list_terms(Rest, Result).
reassemble_list_terms([t(Factor,  Base)|Rest], [NewTerm|Result]) :- Factor == -1, !, reassemble_term(Base, Temp), NewTerm = -(Temp), reassemble_list_terms(Rest, Result).
reassemble_list_terms([t(Factor,  Base)|Rest], [NewTerm|Result]) :- reassemble_term(Base, Temp), NewTerm = Factor * Temp, reassemble_list_terms(Rest, Result).

% reassemble_term(List, Term). Makes List of terms [T1,T2,...Tn] into T1*T2*...*Tn. 
reassemble_term([], 0). % !!
reassemble_term(List, T) :- length(List, 1), List = [T].
reassemble_term(List, T) :- length(List, N), N > 1, !, List = [T1|Rest], reassemble_term(Rest, T2), T = T1*T2. 

% Factor the cases below into the cases for the none version of * above.
% Perhaps just simplify_expression(A, T1), simplify(B, T2), and then use cases below?
assemble_mult(T1, _T2, Product) :- ground(T1), 0 is T1, !, Product = 0. % Applies even if T2 is not ground. 
assemble_mult(_T1, T2, Product) :- ground(T2), 0 is T2, !, Product = 0. % Applies even if T1 is not ground. 
assemble_mult(T1, T2, Product)  :- ground(T1), ground(T2), NewT1 is T1, NewT2 is T2, integer(T1), integer(T2), 1 is NewT1, !, Product is NewT2.
assemble_mult(T1, T2, Product)  :- ground(T1), ground(T2), NewT1 is T1, NewT2 is T2, integer(T1), integer(T2), 1 is NewT2, !, Product is NewT1.
assemble_mult(T1, T2, Product)  :- ground(T1), ground(T2), NewT1 is T1, NewT2 is T2, integer(T1), integer(T2), !, Product is NewT1*NewT2.
assemble_mult(T1, T2, Product)  :- ground(T1), \+ ground(T2), NewT1 is T1, integer(NewT1), 1 is NewT1, !, Product = T2.
assemble_mult(T1, T2, Product)  :- ground(T1), \+ ground(T2), NewT1 is T1, integer(NewT1), !, Product = NewT1*T2.
assemble_mult(T1, T2, Product)  :- \+ ground(T1), ground(T2), NewT2 is T2, integer(NewT2), 1 is NewT2, !, Product = T1.
assemble_mult(T1, T2, Product)  :- \+ ground(T1), ground(T2), NewT2 is T2, integer(NewT2), !, Product = NewT2*T1.
assemble_mult(T1, T2, Product)  :- Product = T1*T2. % catch all !

% reduce_modulo(T1, _N, T2) :- T2 = T1.
reduce_modulo(T1, N, T2) :- ground(N), !, termify(T1, Terms), reduce_modulo1(Terms, N, [], NewTerms), sum_terms(NewTerms, T2).
reduce_modulo(T1, _N, T1). % Just in case of weird stuff ... 

reduce_modulo1([], _, SoFar, SoFar). 
reduce_modulo1([T|Rest], N, SoFar, NewTerms) :- eliminate_multiple(T, N, NewT), update_terms(NewT, SoFar, NewSoFar), reduce_modulo1(Rest, N, NewSoFar, NewTerms). 

eliminate_multiple(T,  N, NewT) :- ground(T), !, NewT is T mod N.
eliminate_multiple(T,  N, NewT) :- \+ ground(T), nonvar(T), T = T1*_T2, ground(T1), 0 is T1 mod N, !, NewT = 0.
eliminate_multiple(T,  N, NewT) :- \+ ground(T), nonvar(T), T = _T1*T2, ground(T2), 0 is T2 mod N, !, NewT = 0. % Not sure that more cases are needed here ... 
eliminate_multiple(T, _N, NewT) :- !, NewT = T. 

update_terms(Term, Old, New) :- Term == 0, !, New = Old.
update_terms(Term, Old, New) :- Term \== 0, !, append(Old, [Term], New).

add_terms1([], SoFar, SoFar).
add_terms1([T|Rest], SoFar, Result) :- NewSoFar = SoFar + T, add_terms1(Rest, NewSoFar, Result). 

% use assemble_term where possible?
build_term(Term, Exp, N, _Num, _Denom, NewTerm) :- Term = _ mod N, Exp == 0, !, NewTerm = 0.
build_term(Term, Exp, N,  Num, _Denom, NewTerm) :- Term = _ mod N, Exp \== 0, Num == 0, !, NewTerm = 0. 
build_term(Term, Exp, N,  Num,  Denom, NewTerm) :- Term = _ mod N, Exp \== 0, assemble_factor(Num, Denom, Factor), Factor  == 1, !, NewTerm = Exp mod N.
build_term(Term, Exp, N,  Num,  Denom, NewTerm) :- Term = _ mod N, Exp \== 0, assemble_factor(Num, Denom, Factor), Factor \== 1, !, NewTerm = Factor * (Exp mod N). 
build_term(Term, Exp, N,  Num,  Denom, NewTerm) :- Term = -(_ mod N), ground(Exp), !, assemble_factor(Num, Denom, Factor), NewTerm is 0 - Factor * (Exp mod N).
build_term(Term, Exp, N,  Num,  Denom, NewTerm) :- Term = -(_ mod N), \+ ground(Exp), assemble_factor(Num, Denom, Factor), Factor  == 1, !, NewTerm =  - (Exp mod N).
build_term(Term, Exp, N,  Num,  Denom, NewTerm) :- Term = -(_ mod N), \+ ground(Exp), assemble_factor(Num, Denom, Factor), Factor \== 1, !, NewTerm =  - Factor * (Exp mod N).

build_term_new(Term, Exp, N, _Num, _Denom, Factor, NewTerm) :- Term = _ mod N, Exp == 0, !, Factor = 0, NewTerm = 0.
build_term_new(Term, Exp, N,  Num, _Denom, Factor, NewTerm) :- Term = _ mod N, Exp \== 0, Num == 0, !, Factor = 0, NewTerm = 0. 
build_term_new(Term, Exp, N,  Num,  Denom, Factor, NewTerm) :- Term = _ mod N, Exp \== 0, assemble_factor(Num, Denom, Factor), !, NewTerm = Exp mod N. % was NewTerm = Factor * (Exp mod N) with extra case when Factor == 1. 
build_term_new(Term, Exp, N,  Num,  Denom, Factor, NewTerm) :- Term = -(_ mod N), ground(Exp), !, assemble_factor(Num, Denom, Factor), NewTerm is 0 - Factor * (Exp mod N).
build_term_new(Term, Exp, N,  Num,  Denom, Factor, NewTerm) :- Term = -(_ mod N), \+ ground(Exp), assemble_factor(Num, Denom, F), Factor  is -1*F, !, NewTerm = Exp mod N. % was NewTerm = - Factor * (Exp mod N) with extra case when Factor == 1. 

safe_eval(Expression, N, Value) :- ground(Expression), integer(N), safe(Expression), !, Value is Expression mod N. 
safe_eval(Expression, N, Expression mod N) :- integer(N), !. 
safe_eval(Expression, none, Value) :- ground(Expression), safe(Expression), !, Value is Expression. 
safe_eval(Expression, none, Expression).

lowest_terms(Num, Denom, NewNum, NewDenom) :- Common is gcd(Num, Denom), NewNum is Num/Common, NewDenom is Denom/Common.

assemble_term(_Term, Num, _Denom, NewTerm) :- Num == 0, !, NewTerm = 0. 
assemble_term( Term, Num,  Denom, NewTerm) :- assemble_factor(Num, Denom, Factor), Factor == 1, !, NewTerm = Term.
assemble_term( Term, Num,  Denom, NewTerm) :- assemble_factor(Num, Denom, Factor), !, NewTerm = Factor*Term. % Should we have a special case for Factor == -1?

assemble_factor(Num, _Denom, Factor) :- Num == 0, !, Factor = 0.
assemble_factor(Num,  Denom, Factor) :- lowest_terms(Num, Denom, NewNum, NewDenom), NewDenom == 1, !, Factor = NewNum.
assemble_factor(Num,  Denom, Factor) :- lowest_terms(Num, Denom, NewNum, NewDenom), NewDenom \== 1, !, lowest_terms(Num, Denom, NewNum, NewDenom), Factor = NewNum/NewDenom.

% Split Terms into multiples of N and rest
classify_ns([], _, _, [], []).
classify_ns([Term|Rest], N, Num, [T|TermsN], Others) :-     var(Term), 0 is Num mod N, !, set_kterm(Num, N, Term, T), classify_ns(Rest, N, Num, TermsN, Others).
classify_ns([Term|Rest], N, Num, TermsN, [Term|Others]) :-  var(Term), L is Num mod N, L \== 0, !, classify_ns(Rest, N, Num, TermsN, Others).
classify_ns([Term|Rest], N, Num, [T|TermsN], Others) :-  nonvar(Term), Term = K*X, integer(K), var(X), % Could be more general!!
							  0 is K mod N, !, set_kterm(K, N, X, T),  classify_ns(Rest, N, Num, TermsN, Others).
classify_ns([Term|Rest], N, Num, TermsN, [Term|Others]) :- classify_ns(Rest, N, Num, TermsN, Others).

set_kterm(K, N, T, Term) :-  1  is K // N, !, Term = T. % We know K mod N is 0, so ... 
set_kterm(K, N, T, Term) :-  K1 is K // N, !, Term = K1*T. 

compose_term_n(S1, S2, C, Constant, N, Num, Denom, Term) :-
    S2 == [], C == [], !, 
    lowest_terms(Num, Denom, NewNum, NewDenom), assemble_factor(NewNum, NewDenom, Factor), multiply_all(Factor, S1, [], NewS1),
    Term2 is Constant // N, % Very simple case! 
    append(NewS1, [Term2], NewTerms),
    add_terms(NewTerms, Term). 
compose_term_n(S1, S2, C, Constant, N, Num, Denom, Term) :-
    lowest_terms(Num, Denom, NewNum, NewDenom), assemble_factor(NewNum, NewDenom, Factor), multiply_all(Factor, S1, [], NewS1),
    % reduce_or_not(Num, Denom, N, S2, C, Constant, Term2),
    append(S2, C, Temp), append(Temp, [Constant], Terms1), add_terms(Terms1, Term2), 
    assemble_term(Term2 // N, Num, Denom, Term3),
    append(NewS1, [Term3], NewTerms),
    add_terms(NewTerms, Term). 

gather_variables([], _, _, 0).
gather_variables([V|Vars], S, N, Term) :-  length(Vars, 0), !,  gather_one(V, S, Vs, _Others), find_coefficient(Vs, N, C), set_term(C, V, Term).
gather_variables([V|Vars], S, N, Term) :-  gather_one(V, S, Vs, Others), find_coefficient(Vs, N, C), set_term(C, V, T1), gather_variables(Vars, Others, N, T2), Term = T1 + T2.  

gather_one(_V, [], [], []).
gather_one(V, [T|Vars], [T|Rest1], Rest2) :- sub_term(Var, T), var(Var), V == Var, !, gather_one(V, Vars, Rest1, Rest2).
gather_one(V, [T|Vars], Rest1, [T|Rest2]) :- gather_one(V, Vars, Rest1, Rest2).

find_coefficient([], _, 0). 
find_coefficient([T|Rest], none, C) :- term_val(T, C1), find_coefficient(Rest, none, C2), sum_safe(C1, C2, C). 
find_coefficient([T|Rest], N, C) :-    integer(N), N > 1, term_val(T, C1), find_coefficient(Rest, N, C2), sum_safe_mod(C1, C2, N, C). 

sum_safe(C1, C2, C) :- safe(C1+C2), C3 is C1, C4 is C2, C3 \== 0, C4 \== 0, !, C is C3+C4.
sum_safe(C1, C2, C) :- safe(C1+C2), 0 is C1, C4 is C2, C4 \== 0, !, C is C4.
sum_safe(C1, C2, C) :- safe(C1+C2), C3 is C1, 0 is C2, C3 \== 0, !, C is C3.
sum_safe(C1, C2, C) :- safe(C1+C2), 0 is C1, 0 is C2, !, C = 0.
sum_safe(C1, C2, C) :- safe(C1), 0 is C1, !, C = C2.
sum_safe(C1, C2, C) :- safe(C1), C3 is C1, C3 \== 0, !, C = C2 + C3.
sum_safe(C1, C2, C) :- 0 is C2,  !, C = C1.
sum_safe(C1, C2, C) :- C4 is C2, !, C = C1 + C4.

sum_safe_mod(C1, C2, N, C) :- safe(C1+C2), !, C is (C1+C2) mod N.
sum_safe_mod(C1, C2, N, C) :- C = (C1+C2) mod N. 

set_term(0, _, 0) :- !.
set_term(1, V, V) :- !.
set_term(-1, V, T) :- T = -V, !. 
set_term(N, V, T) :-  T = N*V.

term_val(T, 1)   :- var(T), !. 
term_val(T, -1)  :- T = -V, var(V), !.
term_val(T, N2)  :- T = -V, V = -U, !, term_val(U, N2). 
term_val(T, -N2) :- T = -V, V = N*V1,  ground(N), N0 is N, integer(N0), N0 \== 0, N0 \== 1, !, term_val(V1, N1), N2 is N*N1.
term_val(T,  N2) :- T = -V, V = N*_V1, ground(N), N0 is N, integer(N0), N0 == 0, !, N2 is 0.
term_val(T,  N2) :- T = -V, V = N*V1,  ground(N), N0 is N, integer(N0), N0 == 1, !, term_val(V1, N1), N2 is N1.
term_val(T, -N2) :- T = -V, V = N*V1,  ground(N), N0 is N, \+ integer(N0), !, term_val(V1, N1), N2 = N*N1.
term_val(T, -N2) :- T = -V, V = V1*N,  ground(N), N0 is N, integer(N0), N0 \== 0, N0 \== 1, !, term_val(V1, N1), N2 is N0*N1.
term_val(T, -N2) :- T = -V, V = _V1*N, ground(N), N0 is N, integer(N0), N0 == 0, !, N2 is 0.
term_val(T, -N2) :- T = -V, V = V1*N,  ground(N), N0 is N, integer(N0), N0 == 1, !, term_val(V1, N1), N2 is N1.
term_val(T, -N2) :- T = -V, V = V1*N,  ground(N), N0 is N, \+ integer(N0), !, term_val(V1, N1), N2 = N0*N1, !.
term_val(T, N2)  :- T = N*V, term_val(V, N1), ground(N), N0 is N, integer(N0), N0 \== 0, N0 \== 1, !, N2 = N0*N1.
term_val(T, N2)  :- T = N*_V,                 ground(N), N0 is N, integer(N0), N0 == 0, !, N2 is 0.
term_val(T, N2)  :- T = N*V, term_val(V, N1), ground(N), N0 is N, integer(N0), N0 == 1, !, N2 is N1.
term_val(T, N2)  :- T = N*V, term_val(V, N1), ground(N), N1 \== 1, !, N2 = N*N1.
term_val(T, N2)  :- T = N*V, term_val(V, N1), ground(N), N1 == 1, !, N2 = N.
term_val(T, N2)  :- T = V*N, term_val(V, N1), ground(N), N0 is N, integer(N0), N0 \== 0, N0 \== 1,!, N2 = N0*N1.
term_val(T, N2)  :- T = _V*N,                 ground(N), N0 is N, integer(N0), N0 == 0, !, N2 is 0.
term_val(T, N2)  :- T = V*N, term_val(V, N1), ground(N), N0 is N, integer(N0), N0 == 1, !, N2 is N1.
term_val(T, N2)  :- T = V*N, term_val(V, N1), ground(N), N1 \== 1, !, N2 = N*N1, !.
term_val(T, N2)  :- T = V*N, term_val(V, N1), ground(N), N1 == 1, !, N2 = N, !.

add_terms([], 0).
add_terms([T|Rest], Result) :- add_term(T, Rest, Result). 

add_term(Term, [], Result) :- Result = Term. 
add_term(Term, [T|Rest], Result) :- T == 0, !, add_term(Term, Rest, NewTerm), Result = NewTerm.
add_term(Term, [T|Rest], Result) :- nonvar(T), T = - T1, !, Temp = Term - T1,  add_term(Temp, Rest, NewTerm), Result = NewTerm.
add_term(Term, [T|Rest], Result) :- nonvar(T), Temp = Term + T,  add_term(Temp, Rest, NewTerm), Result = NewTerm.

add_nonzero(Term, Constant, ExpSimple) :- Constant == 0, !, ExpSimple = Term.
add_nonzero(Term, Constant, ExpSimple) :- safe(Constant), C is Constant, C > 0, !, ExpSimple = Term + C.
add_nonzero(Term, Constant, ExpSimple) :- safe(Constant), C is Constant, C < 0, !, Neg is 0-C, ExpSimple = Term - Neg. 
add_nonzero(Term, Constant, ExpSimple) :- ExpSimple = Term + Constant.

% Assumes Exp is ground. It could be a number, +, -, *, //, mod, max, ^
simplify_ground(Exp, NewExp) :- safe(Exp), !, NewExp is Exp.
simplify_ground(Exp, NewExp) :- Exp = -(Exp1), !, simplify_ground(Exp1, Exp2), NewExp = -(Exp2). 
simplify_ground(Exp, NewExp) :- (Exp = A + B; Exp = (A+B)), safe(B), 0 is B, !,    simplify_ground(A, NewExp).                     % So A must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A + B; Exp = (A+B)), safe(B), NewB is B, !, simplify_ground(A, NewA), NewExp = NewA + NewB. % So A must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A + B; Exp = (A+B)), safe(A), 0 is A, !,    simplify_ground(B, NewExp).                     % So B must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A + B; Exp = (A+B)), safe(A), NewA is A, !, simplify_ground(B, NewB), NewExp = NewB + NewA. % So B must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A + B; Exp = (A+B)), !, simplify_ground(A, NewA),   simplify_ground(B, NewB), NewExp = NewA + NewB. % Neither A nor B integer safe
simplify_ground(Exp, NewExp) :- (Exp = A - B; Exp = (A-B)), safe(B), 0 is B, !,    simplify_ground(A, NewExp).                     % So A must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A - B; Exp = (A-B)), safe(B), NewB is B, !, simplify_ground(A, NewA), NewExp = NewA - NewB. % So A must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A - B; Exp = (A-B)), safe(A), 0 is A, !,    simplify_ground(B, NewB), NewExp = - NewB.      % So B must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A - B; Exp = (A-B)), safe(A), NewA is A, !, simplify_ground(B, NewB), NewExp = NewA - NewB. % So B must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A - B; Exp = (A-B)), !, simplify_ground(A, NewA),   simplify_ground(B, NewB), NewExp = NewA - NewB. % Neither A nor B integer safe
simplify_ground(Exp, Exp) :-    (Exp = _A/_B; Exp = (_A/_B)), !. % This is definitely not integer safe, so ... 
simplify_ground(Exp, NewExp) :- Exp = A mod B, safe(B), !, N is B, simplify_ground(A, NewA), simplify_mod(NewA, N, NewExp).
simplify_ground(Exp, Exp) :-    Exp = _A mod _B, !. 
simplify_ground(Exp, 0) :-      (Exp = _A*B; Exp = (_A*B)), safe(B), 0 is B, !.
simplify_ground(Exp, NewExp) :- (Exp = A*B; Exp = (A*B)), safe(B), 1 is B, !,     simplify_ground(A, NewExp).                   % So A must not be integer 
simplify_ground(Exp, NewExp) :- (Exp = A*B; Exp = (A*B)), safe(B), !, NewB is B,  simplify_ground(A, NewA), NewExp = NewB*NewA. % So A must not be integer safe. Should -1 be a special case? 
simplify_ground(Exp, 0) :-      (Exp = A*_B; Exp = (A*_B)), safe(A), 0 is A, !. 
simplify_ground(Exp, NewExp) :- (Exp = A*B; Exp = (A*B)), safe(A), 1 is A, !,     simplify_ground(B, NewExp).                   % So B must not be integer safe
simplify_ground(Exp, NewExp) :- (Exp = A*B; Exp = (A*B)), safe(A), !, NewA is A,  simplify_ground(B, NewB), NewExp = NewA*NewB. % So B must not be integer safe. Should -1 be a special case? 
simplify_ground(Exp, NewExp) :- (Exp = A*B; Exp = (A*B)), !, simplify_ground(A, NewA),    simplify_ground(B, NewB), NewExp = NewA*NewB. % Neither A nor B integer safe
simplify_ground(Exp, NewExp) :- (Exp = A//B; Exp = (A//B)), safe(B), 1 is B, !, simplify_ground(A, NewExp). % So A must not be safe
simplify_ground(Exp, NewExp) :- (Exp = A//B; Exp = (A//B)), safe(B), B1 is B, B1 > 1, !, simplify_ground(A, NewA), NewExp = NewA // B1. % So A must not be safe
simplify_ground(Exp, NewExp) :- (Exp = _A//B; Exp = (_A//B)), safe(B), 0 is B, !, NewExp = error. % For completeness ... 
simplify_ground(Exp, NewExp) :- (Exp = A//B; Exp = (A//B)), safe(A), NewA is A, !, simplify_ground(B, NewB), NewExp = NewA // NewB. % So B must not be safe (!!)
simplify_ground(Exp, NewExp) :- (Exp = A//B; Exp = (A//B)), !, simplify_ground(A, NewA), simplify_ground(B, NewB), NewExp = NewA // NewB. % Neither A no B is safe 
simplify_ground(Exp, NewExp) :-  Exp = min(A,B), safe(A), !, NewA is A, simplify_ground(B, NewB), NewExp = min(NewA,NewB). % So B must not be safe
simplify_ground(Exp, NewExp) :-  Exp = min(A,B), safe(B), !, NewB is B, simplify_ground(A, NewA), NewExp = min(NewA,NewB). % So A must not be safe
simplify_ground(Exp, NewExp) :-  Exp = min(A,B), !, simplify_ground(A, NewA), simplify_ground(B, NewB), NewExp = min(NewA,NewB). % Neither A nor B is safe
simplify_ground(Exp, NewExp) :-  Exp = A^B, safe(B), !, NewB is B, NewExp = A^NewB. % Note: to get here, A^B must not be safe ...
simplify_ground(Exp, NewExp) :-  Exp = A^B, !, simplify_ground(B, NewB), NewExp = A^NewB. % Note: to get here, A^B must not be safe ...
simplify_ground(Exp, Exp).

% simplify Exp mod N, so Term + X is Term if X is a multiple of N etc.
simplify_mod(Exp, N, NewExp) :- safe(Exp), NewExp is Exp mod N, !. 
simplify_mod(Exp, N, NewExp) :- Exp = A + B, safe(A), 0 is A mod N, !, simplify_mod(B, N, Exp1), NewExp = Exp1 mod N.
simplify_mod(Exp, N, NewExp) :- Exp = A + B, safe(A), K is A mod N, !, simplify_mod(B, N, Exp1), NewExp = (Exp1 + K) mod N. 
simplify_mod(Exp, N, NewExp) :- Exp = A + B, safe(B), 0 is B mod N, !, simplify_mod(A, N, Exp1), NewExp = Exp1 mod N.
simplify_mod(Exp, N, NewExp) :- Exp = A + B, safe(B), K is B mod N, !,  simplify_mod(A, N, Exp1), NewExp = (Exp1 + K) mod N. 
simplify_mod(Exp, N, NewExp) :- Exp = _A + _B, !, NewExp = Exp mod N.
simplify_mod(Exp, N, NewExp) :- Exp = A - B, safe(A), 0 is A mod N, !, simplify_mod(B, N, Exp1), NewExp = -(Exp1) mod N.
simplify_mod(Exp, N, NewExp) :- Exp = A - B, safe(A), K is A mod N, !, simplify_mod(B, N, Exp1), NewExp = (K- Exp1) mod N. 
simplify_mod(Exp, N, NewExp) :- Exp = A - B, safe(B), 0 is B mod N, !, simplify_mod(A, N, Exp1), NewExp = Exp1 mod N.
simplify_mod(Exp, N, NewExp) :- Exp = A - B, safe(B), K is B mod N, !, simplify_mod(A, N, Exp1), NewExp = (Exp1 - K) mod N. 
simplify_mod(Exp, N, NewExp) :- Exp = _A - _B, !, NewExp = Exp mod N.
simplify_mod(Exp, N, NewExp) :- Exp = A*B, safe(B), 1 is B mod N,   !, simplify_mod(A, N, NewA), NewExp = NewA mod N. 
simplify_mod(Exp, N, NewExp) :- Exp = A*B, safe(B), NewB is B mod N,!, simplify_mod(A, N, NewA), NewExp = NewB*NewA mod N . 
simplify_mod(Exp, N, NewExp) :- Exp = A*B, safe(A), 1 is A, !,         simplify_mod(B, N, NewB), NewExp = NewB mod N. 
simplify_mod(Exp, N, NewExp) :- Exp = A*B, safe(A), NewA is A, !,      simplify_mod(B, N, NewB), NewExp = NewA*NewB mod N.  
simplify_mod(Exp, N, NewExp) :- Exp = A*B, !, simplify_mod(A, N, NewA),        simplify_mod(B, N, NewB), NewExp = NewA*NewB mod N.
simplify_mod(Exp, N, Exp mod N). 

find_names(_Names, String, SoFar, SoFar)   :- \+ first_var(_Var, String, _). % No first variable name in this string, so there is no variable name in the string ... 
find_names(Names, String, SoFar, SubNames) :-    first_var(S, String, Rest), atom_string(NS1, S), member(NS1=Var, Names), !, add_to_list(NS1=Var, SoFar, NewSoFar), find_names(Names, Rest, NewSoFar, SubNames). % So we have found a variable name in the string which is in Names
find_names(Names, String, SoFar, SubNames) :-    first_var(S, String, Rest), atom_string(NS1, S), \+ member(NS1=_Var, Names), !, find_names(Names, Rest, SoFar, SubNames). % So we have found a variable name in the string which is in not Names ... probably shouldn't happen!

contains_var(S) :- string_compose(_, Var, _, S), variable_name(Var). 

% Var is the first variable name in String
first_var(Var, String, Rest) :- string_compose(S1, Var, Rest, String), variable_name(Var), \+ contains_var(S1). 

check_constraints(_, _, _, Mods) :- Mods == [], !. 
check_constraints(InitConfig, FinalConfig, Names, Mods) :- extract_vars(InitConfig, Mods, Names, InitVarList), extract_vars(FinalConfig, Mods, Names, FinalVarList), \+ \+ compatible(Mods, InitVarList, FinalVarList, Names). % To prevent any misleading bindings

% Lists is the list of terms var(Var, Exp) where Exp needs to be compatible for variable Var. 
extract_vars(_, Mods, _, []) :- Mods == [], !. 
extract_vars(Config, [mod(Var,_N,_Value)|Rest], Names, [var(Var, Expressions)|Result]) :- expressions_from_config(Var, Config, Names, Expressions), extract_vars(Config, Rest, Names, Result). 

expressions_from_config(Var, Config,  Names, ExpList) :-
    Config = config(Left, _State, Item, _Dir, Right),
    expressions_from_tape(Var, Left, Names, ExpLeft), expressions_from_tape(Var, [Item], Names, ExpItem), expressions_from_tape(Var, Right, Names, ExpRight),
    append(ExpLeft, ExpItem, Temp), append(Temp, ExpRight, ExpList).

expressions_from_tape(_, [], _, []).
expressions_from_tape(Var, [Item|Rest], Names, [Exp|Result]) :-
    Item = grp(_, Exp), term_string(Exp, String, [variable_names(Names)]), string_compose(_, Var, _, String), !, 
    expressions_from_tape(Var, Rest, Names, Result). 
expressions_from_tape(Var, [_Item|Rest], Names, Result) :-
    expressions_from_tape(Var, Rest, Names, Result). 

compatible([], _, _,_). 
compatible([mod(Var,N,Value)|Rest], [var(Var,Expressions1)|InitVarList], [var(Var,Expressions2)|FinalVarList], Names) :-
    assignment(Var, N, Value, Expressions1, Names, Result1),
    assignment(Var, N, Value, Expressions2, Names, Result2),
    Result1 == Result2,
    compatible(Rest, InitVarList, FinalVarList, Names). 

% Expression has value Result when V is Value mod N
assignment(Var, N, Value, Expression, Names, Result) :-
    copy_term(f(Expression, Names), f(Exp1, Names1)),
    term_string(Exp1, String1, [variable_names(Names1)]), 
    replace_string(Var, Value, String1, NewString),
    find_names(Names1, NewString, [], SubNames),
    term_string(Term1, NewString, [variable_names(SubNames)]),
    check_results(Term1, N, Result). 

check_results(List, N, Result) :- List = [Exp], !, Result is Exp mod N. % List = [Exp] will only succeed if List is of length 1. 
check_results(List, N, Result) :- List = [Exp|Rest], Result is Exp mod N, check_results(Rest, N, Result). 

% Note that the below turns the string "X1" into the term X1 with the right names and back again ...
% Term = "X1", atom_string(A,Term), atom_to_term(A, T2, Names), term_string(T2, T, [variable_names(Names)]).
%%     term_string(Exp, ExpString, Names), % make term out of ExpString

rewrite_expression2_new(mod(_Var,N,_Value), _Names, Term, Term) :- \+ contains_mod(Term, N, _), !. 
rewrite_expression2_new(mod(Var,N,_Value), Names, Term, Term) :-  contains_mod(Term, N, Exp mod _M), \+ contains_variable(Exp, Var, Names), !. % Check that Exp contains Var. If not, nothing to do. 
rewrite_expression2_new(mod(Var,N,Value), Names, Term, NewTerm) :-
    findall(Ts, (contains_mod(Term, N, T), term_string(T, Ts, [variable_names(Names)])), ModTermList),
    % nl,
    term_string(Term, TermString, [variable_names(Names)]),
    % term_string(Term, TermString2, []),
    % aliases(Names, Aliases), 
    % term_string(Term3, TermString2, []),
    % format("TermString is ", []), writeln(TermString), 
    %format("TermString2 is ", []), writeln(TermString2),
    %format("Term3 is ", []), writeln(Term3), 
    % format("ModTermList is ", []), writeln(ModTermList),
    %format("Aliases are ", []), writeln(Aliases), 
    rewrite_values(ModTermList, TermString, mod(Var,N,Value), Names, TermStringMod),
    % format("TermStringMod is ", []), writeln(TermStringMod),
    match_names2(TermStringMod, Names, SubNames), 
    !, 
    term_string(NewTerm, TermStringMod, [variable_names(SubNames)]),%% Need to ensure Names is appropriate still! Urgh!
    % term_string(NewTerm, TermStringMod, []),
    true. % writeln(NewTerm). 

match_names(_String, [], []). 
match_names(String, [Name=V|Rest], [Name=V|Result]) :-
    sub_string(String, _, 2, _, Sub), % All variable names have length 2 (!!).
    atom_string(Var, Sub), Name == Var, !, % Name occurs in string so keep it.
    match_names(String, Rest, Result).
match_names(String, [_Name=_V|Rest], Result) :-
    match_names(String, Rest, Result). % Name does not occur in string to delete it. 

match_names2(String, Names, NewNames) :-
    vars_from_names(Names, VarNames),
    findall(Sub, (sub_string(String, _, 2, _, Sub), member(Sub, VarNames)), VList), % Get ordered list of relevant names (depends on sub_string going from left to right ... )
    names_from_vars(Names, VList, [], NewNames). 

vars_from_names([], []).
vars_from_names([Name=_|Rest], [VarName|Result]) :- atom_string(Name, VarName), vars_from_names(Rest, Result). 

names_from_vars(_, [], SoFar, SoFar).
names_from_vars(Names, [Var|Vars], SoFar, Result) :- matches(Var, Names, Name, V), \+ member(Name=V, SoFar), !, append(SoFar, [Name=V], NewSoFar), names_from_vars(Names, Vars, NewSoFar, Result). % Get the name corresponding to Var
names_from_vars(Names, [Var|Vars], SoFar, Result) :- matches(Var, Names, Name, V), member(Name=V, SoFar), !, names_from_vars(Names, Vars, SoFar, Result). % Get the name corresponding to Var

matches(Var, Names, Name, V) :- atom_string(Atom, Var), matches1(Atom, Names, Name, V).

matches1(Atom, [Name=V|_Rest], Name, V) :- Atom == Name, !.
matches1(Atom, [_|Rest], Name, V) :- matches1(Atom, Rest, Name, V). 

rewrite_values([], TermString, _, _, TermString).
rewrite_values([Term|Rest], TermString, mod(Var,N,Value), Names, Result) :-
    value(Term, mod(Var,N,Value), Names, ExpValue),
    % format("Replacing ~s in ~s with ~s ... ", [Term, TermString, ExpValue]), 
    replace_string(Term, ExpValue, TermString, NewTermString),     % Replace Term in TermString with ExpValue
    % format("result is ~s~n", [NewTermString]), 
    rewrite_values(Rest, NewTermString, mod(Var,N,Value), Names, Result). 

% S = (big term), Names = ['X1'=X1], findall(String, (contains_mod(S, N, T), term_string(T, String, [variable_names(Names)])), List). % gives List of expressions as strings. 
% S = (big term), Names = ['X1'=X1], findall(T, contains_mod(S, N, T), List).% gives List of expressions as terms. 

% Converts a list of variable names into strings which denote the same variable. 
aliases([], []). 
aliases([Atom=Var|Names], [a(RealName,VarName)|Aliases]) :- atom_string(Atom, RealName), term_string(Var, VarName), aliases(Names, Aliases). 

% Exp is the term containing the mod expression, Var is the string value of the variable, ExpValueString is the string (not necessarily just a numeric value) to be substituted for ExpString. 
value(ExpString, mod(VarString, _N, Value), _Names, ExpValueString) :-
    string_concat(ExpString, "+", Temp), string_concat(Temp, VarString, Temp2), 
    % atom_string(Atom, VarString), atom_to_term(Atom, VV, N1),
    atom_string(Atom2, Temp2), atom_to_term(Atom2, Term2, N2), Term2 = Exp1+V1, 
    % writeln(N1), % writeln(N2),
    copy_term(Exp1+V1+N2, Exp2+V2+N3), % copy_term for Exp and V,
    V2 = Value, % assign V = Value, evaluate,
    simplify_expression(Exp2, ExpValue), % convert value to ExpValue term (and string?)
    % append(N3,N4,N5), 
    % write_term(ExpValue, [variable_names(N3)]), % Use this to 'write' final result
    term_string(ExpValue, ExpValueString, [variable_names(N3)]), !, 
    true. 

test_eval(X) :- _ is 2^X, format("Done!~n", []). % ie does evaluating 2**X crash or not ...
% X = 2147483647 works, but X = 2147483648 crashes out the 1G memory limit ...
% N bits can represent numbers between 0 and 2**N - 1; who knew? :-)

% N = 4, Names = ['X1'=X1], List = ["(X1-3)mod 4", "(X1+1)mod 4", "(X1+1)mod 4"], 
% S = 77*X1+14*(X1-3-(X1-3)mod 4)+319*((X1+ -3)//4)+ -49*((X1+ -3)//4*((X1+1)mod 4))+ -77*((X1+1)mod 4)+499,  N = 4, Names = ['X1'=X1], rewrite_expression2new(mod("X1",4,2), Names, S, NewS).

% E = 5*X1+13+(2*((Y1-3-(Y1-3)mod 3)*X1)+5*((Y1+ -3)//3*Y1)+ -5*((Y1+ -3)//3*(Y1 mod 3))+14*((Y1+ -3)//3)), rewrite_expression(mod("Y1", 3, 1),  ['Y1'=Y1, 'X1'=X1],E, New).

% Note: 
% ?- term_string(Term, "X+Y", [variable_names(['X'=Z,'Y'=W])]).
% Term = Z+W.
% BUT!  term_string(Term, "X+Y", [variable_names(['Y'=Z,'X'=W])]). FAILS! So the names have to be in the order that they occur in the string ... 

