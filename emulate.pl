% -*- Prolog -*-
emulate_bb(M, Bound, Mode, Inputs, Ones, Hops, Status, Outputs) :-
    emulate_general(M, blank, Bound, Mode, eval, [loop,blank], Inputs, Hops, Status, Outputs), !, % add escape as an option? 
    member(config(Left, State, Item, Dir, Right), Outputs),
    count_ones(config(Left, State, Item, Dir, Right), Ones),
    process_status(Status, NewStatus),

    ( member(final, Inputs) ->   ( final_output(config(Left,State,Item,Dir,Right), Ones, Hops, NewStatus, Outputs)  ) ; true ),
    ( member(full, Inputs) ->    ( full_output(config(Left,State,Item,Dir,Right), Ones, Hops, Outputs)  ) ; true ), 
    ( member(machine, Inputs) -> ( (member(machine(_,Trans,_Otters), Outputs), display_trans(Trans), nl) ) ; true ),
    ( member(otrans,  Inputs) -> ( (member(machine(_,_Trans,Otters), Outputs), display_otters(Otters, 1), nl), display_first_otter(Otters) ) ; true ). 

final_output(config(Left,State,Item,Dir,Right), Ones, Hops, Status, Outputs) :- 
    format("% ~k: Final configuration is ", [Status]), 
    display_config(config(Left, State, Item, Dir, Right), normal, []), !, % nl,
    format(" Ones: ", []), print_bignum(Ones), !, flush_output,
    simplify_expression(Hops, RealHops), 
    format(" Hops: ", []), print_bignum(RealHops), !, flush_output, 
    member(steps(Steps), Outputs),                format(" Steps: ", []),  print_bignum(Steps), !, nl, flush_output, 
    member(otters(Otters), Outputs),              format("% Otters: ", []), print_bignum(Otters), !, flush_output,
    member(multilinearotters(MLOtters), Outputs), format(" Multilinear: ", []), print_bignum(MLOtters), !, flush_output,
    member(machine(_,_,OtterList), Outputs), length(OtterList, UniqueOtters), format(" Unique Otters: ", []), print_bignum(UniqueOtters), !, flush_output,
    member(ottersnested(OttersNested), Outputs), format(" Otters Nested: ", []), print_bignum(OttersNested), !, flush_output,
    member(ottersteps(OtterSteps), Outputs), format(" Otter Steps: ", []), print_bignum(OtterSteps), !, flush_output, 
    member(otterjumps(OtterJumps), Outputs), format(" Otter Jumps: ", []), print_bignum(OtterJumps), !, flush_output,
    member(otterproofs(OtterProofs), Outputs), format(" Otter Proofs: ", []), write(OtterProofs), !, flush_output,
    member(otterdiffs(OtterDiffs), Outputs), format(" Otter Diffs: ", []), write(OtterDiffs), !, flush_output,
    count_flat_otters(OtterDiffs, 0, Flat), format(" Flat: ~d ", [Flat]),
    member(ocelots(Ocelots), Outputs),         format(" Ocelots: ", []), print_bignum(Ocelots), !, flush_output, 
    member(ocelotsteps(OcelotSteps), Outputs), format(" Ocelot Steps: ", []), print_bignum(OcelotSteps), flush_output, 
    member(ocelotproofs(OcelotProofs), Outputs), format(" Ocelot Proofs: ", []), print_bignum(OcelotProofs), flush_output, 
    extract_shape(config(Left, State, Item, Dir, Right), Shape), format(" Shape: ", []), display_config(Shape, normal, []),flush_output,  
    shape_size(config(Left, State, Item, Dir, Right), Size),     format(" Shape Size: ~d ", [Size]),flush_output, 
    member(ottercounts(Progs, Regs), Outputs), format(" MaxProgs: ~d MaxRegs: ~d ", [Progs, Regs]), flush_output, 
    format("~n", []),flush_output, 
    ( Otters \== UniqueOtters -> format("% Otter counting anomaly~n", []); true ),
    member(indocelotsteps(IndOcelotSteps), Outputs), output_ind_ocelots(1, UniqueOtters, IndOcelotSteps), 
    !, flush_output.

full_output(config(Left,State,Item,Dir,Right), Ones, Hops, Outputs) :- 
    format("% Final configuration: ", []), 
    display_config(config(Left, State, Item, Dir, Right), full, []), !, nl,
    format("% Ones: ~d~n", [Ones]), !, flush_output,
    RealHops is Hops, 
    format("% Hops: ~d~n", [RealHops]), !, flush_output, 
    member(ottersteps(OtterSteps), Outputs), format("% Otter Steps: ~d~n", [OtterSteps]), !, flush_output, 
    member(ocelotsteps(OcelotSteps), Outputs), format("% Ocelot Steps: ~d~n", [OcelotSteps]),
    member(machine(_,_,OtterList), Outputs), length(OtterList, UniqueOtters), 
    member(indocelotsteps(IndOcelotSteps), Outputs), output_ind_ocelots(1, UniqueOtters, IndOcelotSteps), 
    !, flush_output.

output_ind_ocelots(N, M, _) :- N > M, !. 
output_ind_ocelots(N, M, List) :- N =< M, member(o(N, Times, Steps), List), !, format("Applications Otter ~k times: ~k, steps: ", [N, Times]), print_bignum(Steps), nl, N1 is N+1, output_ind_ocelots(N1, M, List).
output_ind_ocelots(N, M, List) :- N =< M, \+ member(o(N, _Times, _Steps), List), !, format("Applications Otter ~k times: 0, steps: 0~n", [N]), N1 is N+1, output_ind_ocelots(N1, M, List). 

extract_shape(config(Left, State, Item, Dir, Right), config(SLeft, State, SItem, Dir, SRight)) :-
    extract_shape1(Left, SLeft), extract_shape1([Item], [SItem]), extract_shape1(Right, SRight).

extract_shape1([], []).
extract_shape1([Item|Rest], [Item|Result]) :- is_input(Item), extract_shape1(Rest, Result).
extract_shape1([grp(I,N)|Rest], [grp(I,N)|Result]) :- ground(N), safe(N), N1 is N, N1 =< 3, !, extract_shape1(Rest, Result). 
extract_shape1([grp(I,N)|Rest], [grp(I,'*')|Result]) :- ground(N), safe(N), N1 is N, N1 > 3, !, extract_shape1(Rest, Result).
extract_shape1([grp(I,N)|Rest], [grp(I,'*')|Result]) :- ground(N), \+ safe(N), !, extract_shape1(Rest, Result). 
extract_shape1([grp(I,N)|Rest], [grp(I,'_')|Result]) :- \+ ground(N), extract_shape1(Rest, Result).

shape_size(config(Left, _, Item, _, Right), Size) :- append(Left, [Item], Temp), append(Temp, Right, Tape), shape_size1(Tape, 0, Size).

shape_size1([], Size, Size).
shape_size1([Item|Rest], SizeSoFar, Size) :- is_input(Item), NewSizeSoFar is SizeSoFar + 1, shape_size1(Rest, NewSizeSoFar, Size).
shape_size1([Item|Rest], SizeSoFar, Size) :- Item = grp(I,N), ground(N), safe(N), N1 is N, N1 =< 3, !, length(I, L), NewSizeSoFar is SizeSoFar + N1*L, shape_size1(Rest, NewSizeSoFar, Size).
shape_size1([Item|Rest], SizeSoFar, Size) :- Item = grp(I,N), ground(N), safe(N), N1 is N, N1 > 3, !, length(I, L), NewSizeSoFar is SizeSoFar + 4*L,  % So all sizes 4 or bigger are the same ... 
					     shape_size1(Rest, NewSizeSoFar, Size).
shape_size1([Item|Rest], SizeSoFar, Size) :- Item = grp(I,N), ground(N), \+ safe(N), length(I, L), !, NewSizeSoFar is SizeSoFar + 4*L,  % So all sizes 4 or bigger are the same ... 
					     shape_size1(Rest, NewSizeSoFar, Size).
shape_size1([Item|Rest], SizeSoFar, Size) :- Item = grp(I,N), variable(N), length(I, L), NewSizeSoFar is SizeSoFar + 4*L,  % Treat variables as 4 or bigger.
					     shape_size1(Rest, NewSizeSoFar, Size).

initial_config(naive, eval, blank, config([], a, I, l, []), 0) :- blank_symbol(I), !. 
initial_config(naive, verify, blank, config([], a, I, l, []), 0) :- blank_symbol(I), !. % Only use variable hops for ossify, not verify. 
initial_config(naive, ossify, blank, config([], a, I, l, []), hops(0, [])) :- blank_symbol(I), !. 
initial_config(naive, eval, config(Left, State, Item, Dir, Right), config(Left, State, Item, Dir, Right), 0). 
initial_config(naive, verify, config(Left, State, Item, Dir, Right), config(Left, State, Item, Dir, Right), 0).
initial_config(naive, ossify, config(Left, State, Item, Dir, Right), config(Left, State, Item, Dir, Right), hops(0, VarList)) :- initial_vars(config(Left, State, Item, Dir, Right), VarList). 
initial_config(flex, eval, blank, config([], a, grp(List,1), l, []), 0) :- blanks(1, List), !. % Act like macro(1) initially
initial_config(flex, verify, blank, config([], a, grp(List,1), l, []), 0) :- blanks(1, List), !. % Act like macro(1) initially
initial_config(flex, ossify, blank, config([], a, grp(List,1), l, []), hops(0,[])) :- blanks(1, List), !. % Act like macro(1) initially
initial_config(flex, eval, config(Left, State, Item, Dir, Right), config(Left, State, Item, Dir, Right), 0). 
initial_config(flex, verify, config(Left, State, Item, Dir, Right), config(Left, State, Item, Dir, Right), 0).
initial_config(flex, ossify, config(Left, State, Item, Dir, Right), config(Left, State, Item, Dir, Right), hops(0, VarList)) :- initial_vars(config(Left, State, Item, Dir, Right), VarList). 

initial_vars(config(Left, _State, Item, _Dir, Right), VarList) :- append(Left, [Item|Right], Tape), initial_vars1(Tape, VarList). 
initial_vars1([], []).
initial_vars1([grp(_I, Num)|Rest], VarList) :- integer(Num), initial_vars1(Rest, VarList). 
initial_vars1([grp(_I, Num)|Rest], [h(Name,0)|VarList]) :- variable(Num), get_name(Num, Name), initial_vars1(Rest, VarList). 

% Status is one of halts, going, going(S), abort, abort(S), loops(cycle), blank, loops(road_runner), target(_), will soon include others.
emulate_general(M, Start, B, Mode, Type, Termination, Inputs, Hops, Status, NewOutputs) :-
     initial_config(Mode, Type, Start, Config, InitHops), 
     machine(Mode, M, Machine), number_of_states(Machine, States), number_of_symbols(Machine, Symbols), % number_of_dirs(Machine, Directions), 
     Directions = 2,
     append(Termination, Inputs, Inputs0), 
     process_inputs(States, Symbols, Directions, Inputs0, Config, Inputs1),
     ( member(maxhops(B1), Inputs1) -> RealB = B1; RealB = B),
     process_bound(RealB, Bound),
     output_status(M, Config, Mode, 0, Inputs1, Inputs2, init), 
     append([used(init)], Inputs2, NewInputs), 
     execute(Machine, Config, Bound, Mode, Type, InitHops, Termination, NewInputs, Result), 
     Result = result(Machine1, Config1, Bound, Mode, Hops, _, Outputs, Status), 
     append(Outputs, [Machine1], Outputs1),  
     append([Config1], Outputs1, Outputs2),
     NewOutputs = Outputs2.

process_inputs(States, _Symbols, Directions, Inputs, Config, FinalInputs) :-
    Directions == 2, 
    (member(loop, Inputs); member(history, Inputs); member(otter, Inputs); member(otter(_OtterType), Inputs); member(ocelot, Inputs)), !, 
    set_type(Inputs, Type), 
    initial_history(Type, States, Directions, History), 	
    append([now(Config), history(History)], Inputs, Inputs1), % history initialisation
    append([pos(0), steps(0), otters(0), multilinearotters(0), ottersnested(0), ottersteps(0), otterjumps(0), otterproofs([]), otterdiffs([]), ocelots(0), ocelotsteps(0), indocelotsteps([]), ocelotproofs(0), ottercounts(0,0)], Inputs1, Inputs2),
    ( \+ member(variable_names(_Names), Inputs) -> append([variable_names([])], Inputs2, Inputs3) ; Inputs3 = Inputs2 ),
    ( \+ member(ocelotstart(_OStart), Inputs) -> append([ocelotstart(0)], Inputs3, Inputs4) ; Inputs4 = Inputs3 ),
    ( \+ member(expansionstart(_EStart), Inputs) -> append([expansionstart(0)], Inputs4, Inputs5) ; Inputs5 = Inputs4 ),
    ( \+ member(inductionstart(_IStart), Inputs) -> append([inductionstart(0)], Inputs5, Inputs6) ; Inputs6 = Inputs5 ),
    ( member(time, Inputs) -> (get_time(T1), append([starttime(T1)], Inputs6, Inputs7)) ; Inputs7 = Inputs6 ),
    ( member(lemma, Inputs) -> append([lemmas([])], Inputs7, Inputs8) ; Inputs8 = Inputs7 ),
    FinalInputs = Inputs8. 

process_inputs(_States, _Symbols, Directions, Inputs, _Config, FinalInputs) :-
    Directions == 2, 
    \+ member(loop, Inputs), \+ member(history, Inputs), \+ member(otter, Inputs), \+member(otter(_), Inputs), \+ member(ocelot, Inputs), 
    append([pos(0), steps(0), otters(0), multilinearotters(0), ottersnested(0), ottersteps(0), otterjumps(0), otterproofs([]), otterdiffs([]), ocelots(0), ocelotsteps(0), indocelotsteps([]), ocelotproofs(0), ottercounts(0,0)], Inputs, Inputs1),
    ( \+ member(variable_names(_Names), Inputs) -> append([variable_names([])], Inputs1, Inputs2) ; Inputs2 = Inputs1 ),
    ( \+ member(ocelotstart(_OStart), Inputs) -> append([ocelotstart(0)], Inputs2, Inputs3) ; Inputs3 = Inputs2 ),
    ( \+ member(expansionstart(_EStart), Inputs) -> append([expansionstart(0)], Inputs3, Inputs4) ; Inputs4 = Inputs3 ),
    ( \+ member(inductionstart(_IStart), Inputs) -> append([inductionstart(0)], Inputs4, Inputs5) ; Inputs5 = Inputs4 ),
    ( member(time, Inputs) -> (get_time(T1), append([starttime(T1)], Inputs5, Inputs6)) ; Inputs6 = Inputs5 ),
    ( member(lemma, Inputs) -> append([lemmas([])], Inputs6, Inputs7) ; Inputs7 = Inputs6 ),
    FinalInputs = Inputs7.

process_bound(N, N) :- integer(N). 
process_bound(mill(N), Num) :- integer(N), Num is N*1000000. % Num is N million.
process_bound(bill(N), Num) :- integer(N), Num is N*1000000000. % Num is N billion.
process_bound(trill(N), Num) :- integer(N), Num is N*1000000000000. % Num is N trillion.
process_bound(tens(N), Num) :- integer(N), Num is 10 ^ N. % Num is 10^N.

execute(M, Config, Bound, Mode, _Type, Hops, Termination, Inputs, Result) :-
    halt_execution(0,0,0, M, Config, Bound, Mode, Hops, Termination, Inputs, Result), !. % (could take cuts out here due to possible backtracking in verify case for next_config ... )
execute(M, Config, Bound, Mode, Type, Hops, Termination, Inputs, Result) :-
    next_config(0, 0, 0, M, Config, Mode, Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, Used), !, 
    output_status(NewM, NewConfig, Mode, NewHops, NewInputs, NewerInputs, Used), flush_output, !, % Don't die wondering ... :-) (could take cuts out here due to possible backtracking in verify case for next_config ... )
    execute(NewM, NewConfig, Bound, Mode, Type, NewHops, Termination, NewerInputs, Result). 

halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- Config = config(_Left, State, _Item, _Dir, _Right), halt_state(State), !, Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, halts).
halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- Config = config(_Left, State, _Item, _Dir, _Right), looping_state(State), !, Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, loops(cycle)).
halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- no_transition(M, Config, Mode), !, Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, abort(Hops)).
halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- member(maxsteps(Max), Inputs), member(steps(Steps), Inputs), Steps >= Max, !, Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, going_steps(Hops)).
halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- \+ member(maxsteps(_), Inputs), ground(Hops), safe(Hops), NHops is Hops, NHops >= Bound, !, Result = result(M, Config, Bound, Mode, NHops, Termination, Inputs, going_hops(NHops)).
halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- \+ member(maxsteps(_), Inputs), ground(Hops), \+ safe(Hops), !, format("% !!STOP Can't tell if Hops exceeded or not at ", []), write(Hops), nl, Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, going_big(Hops)).
halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- member(targets(Tlist), Termination), member(Target, Tlist), member(variable_names(Names), Inputs),reached(Names, Config, Mode, Target), !, 
										    Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, target(Target)). 

halt_execution(_,_,_, M, Config, Bound, Mode, Hops, Termination, Inputs, Result) :- modulus_exponents(Config, Exponents), Exponents \= [], 
										    member(mods(Mods), Inputs), member(initials(Progs, Regs), Inputs), member(diffs(LDiffs, ItemDiff, RDiffs), Inputs), member(variable_names(Names), Inputs),
										    find_mod(Mods, Progs, Regs, Exponents, Names, NewMods),
										    \+ compatible_diffs(NewMods, diffs(LDiffs, ItemDiff, RDiffs)), !,
										    format("% Incompatible: ", []), writeln(NewMods+LDiffs+ItemDiff+RDiffs), 
										    Result = result(M, Config, Bound, Mode, Hops, Termination, Inputs, modulus(NewMods)). 

no_transition(M, Config, Mode) :- Mode = naive, Config = config(_Left, State, Item, _Dir, _Right), \+ simple_transition(M, State, Item, _NewState, _OutItem, _OutDir, _Steps). 
no_transition(M, Config, Mode) :- member(Mode, [macro(_K),flex,search]), Config = config(_Left, State, Item, Dir, _Right), first_item(Item, Dir, I), 
				  \+ simple_transition(M, State, I, _NewState, _OutItem, _OutDir, _Steps).

zero_dextrous(States, M) :- \+ atomic(M), states_list(States, SList), zero_dextrous1(SList, M).
% No named machine is zero_dextrous, hence the atomic() test. 

zero_dextrous1([], _).
zero_dextrous1([State|Rest], M) :- member(t(State,0,_,r,_), M), !, zero_dextrous1(Rest, M). 

first_item(I, _, I) :- is_input(I). 
first_item([I|_], l, I) :- is_input(I).
first_item(Item, r, I) :- reverse(Item, RevItem), RevItem = [I|_], is_input(I). 
first_item(grp(_Item,N), _, 0) :- N == 0. 
first_item(grp([],_Num), _, 0).
first_item(grp(Item,Num), l, I) :- ground(Num), safe(Num), Num1 is Num, Num1 > 0, Item \= [], Item = [I|_]. % Not sure why we need to work out Num1 explicitly
first_item(grp(Item,Num), l, I) :- ground(Num), \+ safe(Num), Item \= [], Item = [I|_].
first_item(grp(Item,Num), r, I) :- ground(Num), safe(Num), Num1 is Num, Num1 > 0, Item \= [], reverse(Item, RevItem), RevItem = [I|_]. % Not sure why we need to work out Num1 explicitly
first_item(grp(Item,Num), r, I) :- ground(Num), \+ safe(Num), Item \= [], reverse(Item, RevItem), RevItem = [I|_]. 
first_item(grp(Item,Num), l, I) :- \+ ground(Num), Item \= [], Item = [I|_].
first_item(grp(Item,Num), r, I) :- \+ ground(Num), Item \= [], reverse(Item, RevItem), RevItem = [I|_].

halt_transition(States, Symbols, Dirs, M, _Config, NewMachine) :-
    M = machine(List1, List2, List3), length(List1,L), L is (States * Symbols) - 1, !, 
    states_list(States, StatesList), 
    symbols_list1(Symbols, SymbolsList),
    once( missing(StatesList, SymbolsList, List1, NewState, NewSymbol) ), 
    halt_trans(Dirs, abs, t(NewState, NewSymbol, NewOut, NewDir, NewNewState)),
    append(List1, [t(NewState, NewSymbol, NewOut, NewDir, NewNewState)], NewList), % Makes it hard to have zero_dextrous test here - don't want further execution ... 
    NewMachine = machine(NewList, List2, List3), !.

missing(StatesList, SymbolsList, Transitions, State, Symbol) :- member(State, StatesList), member(Symbol, SymbolsList), \+ member(t(State, Symbol, _, _, _), Transitions).

looping(Config, Inputs) :- member(history(History), Inputs), set_type(Inputs, Type), history_index(Type, Config, Index), Config = config(_, State, _, Dir, _), lookup_history(Type, State, Dir, Index, s(_Hops, Config, _, _), History). %% history lookup 

% Only works if both Config and Target are either both ground or both variable. Could make this more general but doesn't seem to be much point. 
reached(_Names, Config, Mode, Target) :- \+ member(Mode, [naive]), \+ (ground(Config), ground(Target)), equiv_config(Config, Target).
reached(_Names, Config, Mode, Target) :- \+ member(Mode, [naive]), ground(Config), ground(Target), Config == Target. 
reached(_Names, Config, Mode, Target) :- member(Mode, [naive]), Config == Target. 

flatten(config(Left, State, Item, Dir, Right), config(NewLeft, State, NewItem, NewDir, NewRight)) :-
     flatten_tape(left, Left, NLeft), flatten_tape(right, Right, NRight), flatten_tape(right, [Item], NItem), 
     balance_config(config(NLeft, State, NItem, Dir, NRight), config(NewLeft, State, NewItem, NewDir, NewRight)).

balance_config(config(Left, State, Item, Dir, Right), config(NewLeft, State, NewItem, Dir, NewRight)) :-
    Dir = l, !, append([I], Rest, Item), length([I], 1), NewLeft = Left, NewItem = I, append(Rest, Right, NewRight).

balance_config(config(Left, State, Item, Dir, Right), config(NewLeft, State, NewItem, Dir, NewRight)) :-
    Dir = r, !, append(Rest, [I], Item), length([I], 1), append(Rest, Left, NewLeft), NewItem = I, NewRight = Right.

next_config(_States, _Symbols, _Dirs, M, Config, Mode, _Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, simple) :-
     Mode = naive, !, 
     Config = config(Left, State, Item, _Dir, Right), 
     simple_transition(M, State, Item, NewState, OutItem, OutDir, Steps), !, 
     updatetape(Mode, Left, OutItem, Right, OutDir, NewLeft, NewItem, NewRight, _Moves),
     NewHops is Hops + Steps,
     NewConfig = config(NewLeft, NewState, NewItem, l, NewRight),
     NewM = M,
     updateinputs(Mode, Hops, OutDir, 1, naive, Inputs, NewConfig, NewInputs).

next_config(_States, _Symbols, _Dirs, M, Config, Mode, _Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, modulus) :-
     member(Mode, [flex]), 
     ( member(accel, Inputs); (\+ member(accel, Inputs),member(ocelot,Inputs)); (\+ member(accel, Inputs),\+member(ocelot,Inputs), member(otter,Inputs)); (\+ member(accel, Inputs),\+member(ocelot,Inputs),\+ member(otter,Inputs), member(otter(_OtterType), Inputs)) ),

     member(mods(Mods), Inputs), member(initials(Progs, Regs), Inputs),
     modulus_exponents(Config, Exponents), Exponents \= [], !, % So we have some moduli ... 
      % format("% Moduli found~n", []), 
      member(variable_names(Names), Inputs), 

      % member(diffs(LDiffs, ItemDiff, RDiffs), Inputs), 
      
      find_mod(Mods, Progs, Regs, Exponents, Names, NewMods),
      % format("% Moduli located~n", []), 
      % ( \+ compatible_diffs(NewMods, diffs(LDiffs, ItemDiff, RDiffs)) -> (format("% Moduli ~k not compatible with diffs ~k ~k ~k , so giving up otter proof attempt~n", [NewMods,LDiffs,ItemDiff,RDiffs]), fail) ; true ), % Do this check as part of halt_execution to allow for reconjecturing??
     %  The above check is now done as part of halt_execution, so we can assume this test succeeds if we get here. 
     
     member(pos(Pos), Inputs),
     % format("% About to rewrite moduli~n", []),
     % writeln(NewMods+Config+Hops+Pos+Names), 
     rewrite_modulus(NewMods, Config, Hops, Pos, 0, Names, NewConfig, NewHops, NewPos, _), !,
     format("% Old Hops rewritten to NewHops: from ", []), write(Hops), format(" to ", []), write(NewHops), format(" with NewMods ", []), write(NewMods), format(" and Names ", []), writeln(Names), 
     NewM = M,
     delete(Inputs, mods(Mods), Inputs1), append([mods(NewMods)], Inputs1, Inputs2),
     delete(Inputs2, pos(Pos), Inputs3), append([pos(NewPos)], Inputs3, Inputs4), 
     % format("% Moduli done so moving on with ", []), writeln(NewConfig),
     NewInputs = Inputs4, !.

next_config(_States, _Symbols, _Dirs, M, Config, Mode, Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, ocelot(Num)) :-
     member(ocelot, Inputs), \+ member(ignorenextocelot, Inputs), 
     member(Mode, [flex]), 
     M = machine(_, _, Otters), % writeln(Otters), 
     member(variable_names(Names), Inputs), 
     member(ocelotstart(OcelotBound), Inputs),

     \+ (ground(Hops), safe(Hops), Hops < OcelotBound), % Only apply otter once a certain number of steps has been reached.

     length(Otters, Otts), NextOtter is Otts+1, 
     member(o(Num,Transition), Otters), 
     ( Type = verify -> permitted_otter(M, NextOtter, Num); true ), % For machine M, otter Num is permissible in a proof attempt for otter NextOtter
     ( Type = eval -> allowed_otter(M, Num); true ), % For machine M, allow use of otter Num in evaluation 
     % format(" Trying otter ~d ... ~n", [Num]),
     apply_otter(Num, Transition, Config, Names, NewConfig, Leaps, Moves), % If we can do it, do it. Otherwise try another Transition, until there are no options left, in which case the ocelot fails.
     % format("Otter applied at ", []), writeln(Hops),
     simplify_expression(Hops, SimpleHops), simplify_expression(Leaps, RealLeaps),
     % format("Simplified 1~n", []), 
     % format("% Otter ~k successfully applied to ~k at ~k to get ~k and ~k~n", [Num, Config, Hops, NewConfig, Leaps]),
     ( reasonable_config(NewConfig) -> true; (format("% ocelot ~k at ~k is not reasonable and so not applied to ", [Num,Hops]), write_term(NewConfig, [variable_names(Names)]),nl,fail) ), % fail when the ocelot produces a configuration containing a term like 5/3. Monster 74 crashes without this ...
     % format("Reasoned 1~n", []), 
     % format("Otter ~k successfully applied to ~k at ~k to get ~k and ~k~n", [Num, Config, Hops, NewConfig, Leaps]),
     % format("Otter ~k successfully applied at ~k to ", [Num, Hops]), write_term(Config, [variable_names(Names)]), format(" to get ", []), write_term(NewConfig, [variable_names(Names)]), format(" and ~k~n", [Leaps]), 
     !, simplify_expression(Hops, SimpleHops), simplify_expression(Leaps, RealLeaps),

     simplify_expression(SimpleHops + RealLeaps, NewHops),

     ( member(otrace, Inputs ) -> 
       (
	   format("% Ocelot ~d: Hops: ", [Num]), print_bignum(SimpleHops),
   	   format(" Leaps: ", []), print_bignum(RealLeaps),
      	   format(" NewHops: ", []), print_bignum(NewHops), member(steps(Steps), Inputs),
	   format(" Steps: ~d", [Steps]), 
	   format(" ", []),
	   display_config(Config, normal, []), format(" ++> ", []), flush_output, 
  	   display_config(NewConfig, normal, []), nl, flush_output
          ) ; true ) , 

     Config = config(_, _, Item, _, _), Item = grp(_I,N), ( (\+ ground(N)) -> append(Inputs, [ignorenextocelot], Inputs1); Inputs1 = Inputs ), 
     
     NewConfig = config(_Left, _State, _Item, OutDir, _Right), 
     update_ocelots(Num, RealLeaps, Inputs1, NInputs),
     updateinputs(Mode, Hops, OutDir, Moves, ocelot(Num), NInputs, NewConfig, NewInputs), !, 
     NewM = M, !. % no change to machine for this step

next_config(_States, _Symbols, _Dirs, M, Config, Mode, _CompType, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, otter) :-
     member(ocelot, Inputs), \+ member(ignorenextocelot, Inputs), 
     member(Mode, [flex]), 
     % M = machine(_, _, Otters), % writeln(Otters), 

     (member(otter, Inputs); (\+ member(otter, Inputs), member(otter(OtterType), Inputs) ) ), % Keep the otter and ocelot independent, so that when searching for a proof, the ocelot can be used but no search is made for new otters.
     \+ member(ignorenextotter, Inputs), % To allow verification but when the final config is the current step. So this will avoid a loop. 
     member(Mode, [flex]),  

     ( \+ member(otter(OtterType), Inputs) -> OtterType = multi; true ), % Set default to multilinear. Can use otter(uni) if unilinear only is desired.
     
     Config = config(Left, State, Item, Dir, Right),
     member(history(History), Inputs),
     set_type(Inputs, Type), 
     history_index(Type, Config, Index),
     lookup_history(Type, State, Dir, Index, s(Hops1, Config1, _, _), History), Hops1 < Hops, % Hops1 #< Hops, %% history lookup -- could this be just < rather than #<??

     Config1 = config(Left1, State, Item1, Dir, Right1), 
     same_shape(config(Left1, State, Item1, Dir, Right1), config(Left, State, Item, Dir, Right)),
     % regression(config(Left1, State, Item1, Dir, Right1), config(Left, State, Item, Dir, Right), RealConfig1, LDiffs1, ItemDiff1, RDiffs1),  

     candidate_regression(Config1, Config, RealConfig1), 
     
     % format("% Partial regression found ~k->~k~n", [Hops, Hops1]), 
     
     lookup_history(Type, State, Dir, Index, s(Hops2,Config2, _, _), History), Hops2 < Hops1, % Hops2 #< Hops1, %% history lookup -- could this be just < rather than #<??
     Config2 = config(Left2, State, Item2, Dir, Right2), 
     same_shape(config(Left2, State, Item2, Dir, Right2), config(Left1, State, Item1, Dir, Right1)),
     
     % regression(config(Left2, State, Item2, Dir, Right2), config(Left1, State, Item1, Dir, Right1), RealConfig2, LDiffs2, ItemDiff2, RDiffs2),

     candidate_regression(Config2, Config1, RealConfig2),

     % format("% Second Partial regression found ~k->~k~n", [Hops1, Hops2]), 
     
     % LDiffs1 == LDiffs2, ItemDiff1 == ItemDiff2, RDiffs1 == RDiffs2, % This means progressions must be only of the form (1,N), not (K,N) for K > 1. So this only finds monolinear otters. But for multilinear otters we need four instances, not just 3. 

     % linear_otter_pattern(Config, RealConfig1, RealConfig2, RealLDiffs, RealItemDiff, RealRDiffs),
     
     linear_otter_pattern(OtterType, Config, RealConfig1, RealConfig2, Hops2, Type, Index, History, RealLDiffs, RealItemDiff, RealRDiffs, Linear, Hops3, Config3), 
     
     %      format("% Regression ~k:", [Hops2]), display_config(Config2, normal, []),
     ( Linear = uni -> ( format("% Regression (uni) ", []), print_bignum(Hops2), format(":", []), display_config(Config2, normal, []),
			 simplify_expression(Hops1-Hops2, D2),      simplify_expression(Hops-Hops1, D1), 
			 format(" -> +~k:", [D2]), display_config(Config1, normal, []), 
			 format(" -> +~k:", [D1]), display_config(Config, normal, []), nl,
		         OldHops = Hops2 ) ; true ),
     
     ( Linear = multi -> ( format("% Regression (multi) ", []), print_bignum(Hops3), format(":", []), display_config(Config3, normal, []),
			 simplify_expression(Hops2-Hops3, D3), simplify_expression(Hops1-Hops2, D2),      simplify_expression(Hops-Hops1, D1), 
			 format(" -> +~k:", [D3]), display_config(Config2, normal, []),
 			 format(" -> +~k:", [D2]), display_config(Config1, normal, []), 
			 format(" -> +~k:", [D1]), display_config(Config, normal, []), nl,
			 OldHops = Hops2 ) ; true ), % OldHops really shouldn't be Hops3 as we give apply_otter Config2 in both cases ... 
          
     diff_counters(RealLDiffs, RealItemDiff, RealRDiffs, Progressors, Regressors), length(Progressors, Progs), length(Regressors, Regs),

     % format(" Progressors: ~k, Regressors: ~k~n", [Progs, Regs]), 

     ( (member(otrace, Inputs), Linear = uni ) -> 
	 ( format("% Otter Observed (unilinear): ~k ~k ~k Diff1 is ~k Diff2 is ~k ", [Hops2, Hops1, Hops, D2, D1]), 
	   display_config(config(Left2, State, Item2, Dir, Right2), normal, []), format(" + ", []), 
	   display_config(config(Left1, State, Item1, Dir, Right1), normal, []), format(" + ", []), 
	   display_config(config(Left, State, Item, Dir, Right), normal, []), % Original Config
           format(" Progressors: ~k, Regressors: ~k~n", [Progs, Regs]), 
           true									
          ) ; true ) , 

     ( (member(otrace, Inputs), Linear = multi ) -> 
       ( format("% Otter Observed (multilinear): ~k ~k ~k ~k Diff1 is ~k Diff2 is ~k Diff3 is ~k", [Hops3, Hops2, Hops1, Hops, D3, D2, D1]),
	   Config3 = config(Left3, _, Item3, _, Right3), 
	   display_config(config(Left3, State, Item3, Dir, Right3), normal, []), format(" + ", []),
  	   display_config(config(Left2, State, Item2, Dir, Right2), normal, []), format(" + ", []), 
	   display_config(config(Left1, State, Item1, Dir, Right1), normal, []), format(" + ", []), 
	   display_config(config(Left, State, Item, Dir, Right), normal, []), % Original Config
           format(" Progressors: ~k, Regressors: ~k~n", [Progs, Regs]), 
           true									
          ) ; true ) , 

     otters_in_machine(M, Number), NewNumber is Number + 1,
     % format("% Verifying ... ~n", []), 
     verify_otter(M, NewNumber, Mode, Config, RealLDiffs, RealItemDiff, RealRDiffs, Progressors, Regressors, simple, Linear, Hops2, Shape_Computation, Otter_Transition), % We now assume otter -> verify (why would it be anything else?) % Trying this to aovoid overshooting ...
     !, % Can commit now ...
     % format("% Verified~n", []), 
     member(variable_names(Names), Inputs),
     member(ocelotstart(OcelotBound), Inputs), 
     format("% Otter found -- checking whether to apply it to ", []), write(Config2), format(" at ", []), print_bignum(Hops), format(" ... ~n", []), flush_output, 
     ( (ground(Hops), safe(Hops), Hops < OcelotBound) -> (format("% Otter not applied at ", []), print_bignum(Hops), format(" due to early constraint of ~k~n", [OcelotBound]), flush_output, Leaps = 0, Moves = 0, NewConfig = Config, NewHops = Hops )
                                                                      ; ( apply_otter(0, Otter_Transition, Config2, Names, NewConfig, Leaps, Moves ) -> ( simplify_expression(OldHops + Leaps, NewHops), format("% Otter applied to get to ", []), print_bignum(NewHops), nl, flush_output, ttyflush) ;
                                                                                                                                                    ( format("% Otter not applied at ", []), print_bignum(Hops), format(" to avoid loop~n", []), Leaps = 0, Moves = 0, NewConfig = Config, NewHops = Hops), flush_output ) ),
     % The current Config could be the final instance of the otter, and so the constraints may not be satisified ... But if it is the final one, there is no point in applying the otter! So don't apply the otter and make a note to ignore it next time around (otherwise we get a loop). Also for variable case we need to apply it to the oldest configuration ... 
     !, % Only now can commit to this case. 
     % writeln(NewConfig), flush_output,
     % format("Otter done~n", []),     flush_output, ttyflush, 

     append([ignorenextotter,ignorenextocelot], Inputs, Inputs1), % Stop finding the same otter at a later place, eg monster 18 117-120-123 otters to 126 and then finds 120-123-126
     % format("Checking ~n", []),      flush_output, ttyflush, 
     ( (member(otrace, Inputs1),member(verify, Inputs1) ) -> (format("% Final otter is ~d:", [NewHops]), display_config(NewConfig, normal, []), nl, ttyflush); true), 
     ( member(ocelot, Inputs1) -> update_machine(M, Hops, Otter_Transition, NewM, OtterStatus); (NewM = M, OtterStatus = new)),      
     ( member(predict, Inputs1) -> check_predictions(Hops, Inputs1, NewConfig, Inputs2); Inputs2 = Inputs1),
     % format("Nesting? ~n", []),      flush_output,  ttyflush, 
     nested_otters(Shape_Computation, Nested), 
     length(Shape_Computation, OtterProofLength), 
     % ( (ground(Hops1-Hops2), ground(Hops-Hops1), OtterStatus == new)  -> (D1 is Hops1 - Hops2, D2 is Hops - Hops1, update_otters(Leaps, 0, Nested, OtterProofLength, D1, D2, Inputs2, Inputs3)); Inputs3 = Inputs2 ),
     % format("Updating otters~n", []),      flush_output, 
     ( (ground(D2), ground(D1), OtterStatus == new)  -> ( update_otters(Leaps, 0, Nested, OtterProofLength, D2, D1, Linear, Inputs2, Inputs3)); Inputs3 = Inputs2 ),

     NewConfig = config(_,_,_,OutDir,_),
     % format("Updating inputss~n", []),      flush_output,      
     updateinputs(Mode, Hops, OutDir, Moves, otter(Progs,Regs), Inputs3, NewConfig, NewInputs),
     % format("Updated inputss~n", []),      flush_output, 
     !. 

next_config(_States, _Symbols, _Dirs, M, Config, Mode, _Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, expansion(ExpNum)) :-
     member(Mode, [flex]), member(accel, Inputs), \+ member(ignorenextacc, Inputs), 

     ( member(ignorenextotter, Inputs) -> delete(Inputs, ignorenextotter, Inputs1) ; Inputs1 = Inputs ), % clean up otter marker, now that we are past where it is needed.
     ( member(ignorenextocelot, Inputs1) -> delete(Inputs1, ignorenextocelot, Inputs2) ; Inputs2 = Inputs1 ), % same for ocelot marker, now that we are past where it is needed.
     ( member(ignorenextlemma, Inputs2) -> delete(Inputs2, ignorenextlemma, Inputs3) ; Inputs3 = Inputs2 ), % and yet again for the lemma marker, now that we are past where it is needed.

     member(expansionstart(ExpansionBound), Inputs), 
     ( (ground(Hops), safe(Hops), Hops < ExpansionBound) ->  (format("% Expansion ignored at ", []), write_term(Hops), format(" due to early constraint of ~n", [ExpansionBound]),fail) ; true ), % Only apply expansion once a certain number of steps has been reached. 

     rotate_for_accel(Config, RAConfig), 
     RAConfig = config(_Left, State, Item, Dir, _Right), 
     Item = grp(I, Number),
      number_of_states(M, States), 
      ( variable(Number); (ground(Number), N1 is Number, length(I,L), L*N1 > States ) ), % Only apply if Number is a variable, or ground and at least the number of states (so it is sensible to try an expansion).

     expanded(I, States, [], ExpI), 
     complex_transition(M, State, ExpI, Dir, NewM, NewState, OutItem, OutDir, Steps), % Note that we must have State = NewState for this to be an acceleration transition ... 
     classify_transition(trans(State, ExpI, Dir, NewState, OutItem, OutDir, Steps), acceleration), !, % If this fails, we may retry if there is another expansion. If not, there is no acceleration transition.

     updatetapeflex(RAConfig, Mode, trans(State, ExpI, Dir, NewState, OutItem, OutDir, Steps), NLeft1, NItem, NewDir, NRight1, Leaps, Moves),

     check_blank(NLeft1, NLeft),
     check_blank(NRight1, NRight),

     reconfigure(config(NLeft, NewState, NItem, NewDir, NRight), NConfig), 
     simplify_expression(Hops + Leaps, NHops), !, 

     length(I, N), length(ExpI, EN), ExpNum is EN//N, 
     
     ( member(variable_names(Names), Inputs3) -> true; Names = [] ),
     ( member(rotate, Inputs3) -> CMode = rotate; CMode = plain),

     ( member(compress, Inputs3) -> (compress_config(CMode, NConfig, NewishConfig)) ; NewishConfig = NConfig ),

     !,

     member(pos(Pos), Inputs3),
     ( member(mods(Mods), Inputs3) -> (rewrite_modulus(Mods, NewishConfig, NHops, Pos, Moves, Names, NewConfig, NewHops, NewPos, NewMoves)); (NewConfig = NewishConfig, NewHops = NHops, NewPos = Pos, NewMoves = Moves) ), 
     ( member(ctrace, Inputs3) -> ( NConfig \== NewishConfig -> (format("% ~d: compressed(accel) ", [NewHops]), write_term(NConfig,[]), format(" **> ", []), write_term(NewishConfig,[]),nl); true
				  ) ; true ), 

     delete(Inputs3, pos(Pos), Inputs4), append([pos(NewPos)], Inputs4, Inputs5), 
     updateinputs(Mode, Hops, OutDir, NewMoves, expansion(ExpNum), Inputs5, NewConfig, NewInputs),!,

     ( member(acctrace, Inputs5) ->
       ( ((length(ExpI, L1), length(I, L2), L2 < L1)) -> ( format("% Acctrans (~k --> ~k): ", [ExpI,OutItem]), format(" Hops: ~k Leaps: ~k NewHops: ~k ", [Hops, Leaps, NewHops]), display_config(Config, normal, []), format(" ++> ", []), display_config(NewConfig, normal, []), nl ) ; true )
     ; true ),
     !. 

next_config(_States, _Symbols, _Dirs, M, Config, Mode, Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, modify) :-
     member(Mode, [flex]), % Intended to avoid overshooting targets in verify mode
     Type == verify, member(modify, Inputs), 
     Config = config(_Left, _State, Item, InDir, _Right), 
     Item = grp(I, Number),
     length(I, K), K > 1, Number == 1, !, % So it is very much a specific case ... 
     
     % format("Applying modify transition ... ~n", []),
     
     split_up_item(I, InDir, NewItem, Rest), 

     % format("Splitting done ~n", []),
     
     add_to_config(Config, NewItem, Rest, InDir, OutDir, NConfig), 

     % format("Adding done ~n", []),
     
     NConfig = config(NLeft1, NewState, NItem, NewDir, NRight1), 
     
     check_blank(NLeft1, NLeft),
     check_blank(NRight1, NRight),

     NewHops = Hops, Moves = 0, Inputs3 = Inputs, NewConfig = config(NLeft, NewState, NItem, NewDir, NRight), NewM = M, 
     updateinputs(Mode, Hops, OutDir, Moves, modify, Inputs3, NewConfig, NewInputs),
     % format("Moving on with ", []), writeln(NewConfig), 
     !. 

next_config(_States, _Symbols, _Dirs, M, Config, Mode, _Type, Hops, Inputs, NewM, NewConfig, NewHops, NewInputs, complex(TransType)) :-
     member(Mode, [flex]), % Default case ... 

    ( member(ignorenextotter, Inputs) -> delete(Inputs, ignorenextotter, Inputs1) ; Inputs1 = Inputs ), % clean up otter marker, now that we are past where it is needed.
    ( member(ignorenextocelot, Inputs1) -> delete(Inputs1, ignorenextocelot, Inputs2) ; Inputs2 = Inputs1 ), % same for ocelot marker, now that we are past where it is needed.
    ( member(ignorenextacc, Inputs) -> delete(Inputs, ignorenextacc, Inputs3) ; Inputs3 = Inputs2 ), % and again for new acceleration case ... 

     Config = config(_Left, State, Item, Dir, _Right), 
     Item = grp(I, _Number),  

     complex_transition(M, State, I, Dir, NewM, NewState, OutItem, OutDir, Steps), !, 
     % Type == eval -> !; true), % Only commit in evaluation case to allow verify case to use later modify option ... 
     classify_transition(trans(State, I, Dir, NewState, OutItem, OutDir, Steps), TransType), 
     updatetapeflex(Config, Mode, trans(State, I, Dir, NewState, OutItem, OutDir, Steps), NLeft1, NItem, NewDir, NRight1, Leaps, Moves),

     check_blank(NLeft1, NLeft),
     check_blank(NRight1, NRight),

     set_rotation(Inputs3, CMode), 
     NConfig = config(NLeft, NewState, NItem, NewDir, NRight), 
     compression(CMode, NConfig, Inputs3, NewConfig), 

     simplify_expression(Hops + Leaps, NewHops), !, 
     % Type = eval -> !; true ), % May not want to commit in verify case if there is another option ... !, 
     ( member(ctrace, Inputs3) -> ( NConfig \== NewConfig -> (format("% ~d: compressed(flex) ", [Hops]), write_term(NConfig,[]), format(" **> ", []), write_term(NewConfig,[]),nl); true ) ; true ), 
     updateinputs(Mode, Hops, OutDir, Moves, complex(TransType), Inputs3, NewConfig, NewInputs). 


split_up_item(I, l, NewItem, Result) :- append(First, Others, I), length(First, 1), groupify(Others, Result), NewItem = grp(First,1).
split_up_item(I, r, NewItem, Result) :- append(Others, Last, I), length(Last, 1), groupify(Others, Rest), reverse(Rest, Result), NewItem = grp(Last,1).

groupify([], []). 				  
groupify([I|Rest], [grp([I],1)|Result]) :- groupify(Rest, Result). 

add_to_config(Config, NewItem, Rest, l, l, NewConfig) :-    % Add to Right
    Config = config(Left, State, _Item, _Dir, Right), append(Rest, Right, NewRight), NewConfig = config(Left, State, NewItem, l, NewRight).
add_to_config(Config, NewItem, Rest, r, r, NewConfig) :-    % Add to Left
    Config = config(Left, State, _Item, _Dir, Right), append(Rest, Left, NewLeft),   NewConfig = config(NewLeft, State, NewItem, r, Right).

compatible_diffs([], _).
compatible_diffs([Mod|RestMods], Diffs) :-
    Diffs = diffs(LDiffs, ItemDiff, RDiffs),
    Mod = mod(Var, N, Value),
    reverse(LDiffs, RevLDiffs), append(RevLDiffs, [ItemDiff], Temp), append(Temp, RDiffs, AllDiffs),
    classify_diffs(AllDiffs, PosDiffs, NegDiffs),
    find_diff(Var, PosDiffs, NegDiffs, VarDiff),
    compatible_values(VarDiff, N, Value),
    compatible_diffs(RestMods, Diffs).

classify_diffs([], [], []).
classify_diffs([m(L,K)|RestDiffs], PosDiffs, NegDiffs) :- L == 1, K == 0, !, classify_diffs(RestDiffs, PosDiffs, NegDiffs). 
classify_diffs([m(L,K)|RestDiffs], [m(L,K)|PosDiffs], NegDiffs) :- (K > 0; L > 1), !, classify_diffs(RestDiffs, PosDiffs, NegDiffs).
classify_diffs([m(L,K)|RestDiffs], PosDiffs, [m(L,K)|NegDiffs]) :- K < 0, classify_diffs(RestDiffs, PosDiffs, NegDiffs).  % K < 0 case

compatible_values(m(L,K), N, _Value) :- 1 is L mod N, 0 is K mod N, !. % L*X+K mod N = X mod N, so the value doesn't matter
compatible_values(m(L,K), N, Value)  :- Value is (L*Value + K) mod N, !. % L*X+K mod N = X mod N, the value matters and works. 
compatible_values(m(L,_K), N) :- 0 is L mod N. % L*X+K mod N = K mod N so it is independent of X. 

% Assume single mod for now ... need to include a check for this!  Happens in 216, 236
reset_diffs(Mods, LDiffs, ItemDiff, RDiffs, NewLDiffs, NewItemDiff, NewRDiffs) :-
    % format("% MOds are ~k~n", [Mods]), 
    Mods = [mod(Var, N, _Value)], % single mod only! Can have multiple unilinear progressive variables though (just only one mod). 
    reverse(LDiffs, RevLDiffs), append(RevLDiffs, [ItemDiff], Temp), append(Temp, RDiffs, AllDiffs),
    classify_diffs(AllDiffs, PosDiffs, NegDiffs),
    find_diff(Var, PosDiffs, NegDiffs, VarDiff),
    % format("% VarDiff is ~k, N is ~d~n", [VarDiff,N]), 
    VarDiff = m(L,K), 
    find_factor(N, L, K, Factor), % Factor to remove all incompatibilities with Var
    apply_factor(Factor, LDiffs, ItemDiff, RDiffs, NewLDiffs, NewItemDiff, NewRDiffs). 

find_factor(N, L, K, Factor) :- L = 1, K > 0, !, Factor is lcm(K,N)//K. % unilinear case. Only case for now we can be sure of!

apply_factor(Factor, LDiffs, ItemDiff, RDiffs, NewLDiffs, NewItemDiff, NewRDiffs) :-
    apply_factor_to_diffs(Factor, LDiffs, NewLDiffs),
    apply_factor_to_diffs(Factor, [ItemDiff], [NewItemDiff]), 
    apply_factor_to_diffs(Factor, RDiffs, NewRDiffs).

apply_factor_to_diffs(_, [], []).
apply_factor_to_diffs(F, [m(L,K)|Rest], [m(NewL,NewK)|Result]) :- NewL is L^F, NewK is F*K, apply_factor_to_diffs(F, Rest, Result). 

output_shape_computation(_, _, _, []).
output_shape_computation(M, Mode, Inputs, [s(Hops, Config, Pos, Step)|Rest]) :- output_config(M, Config, Mode, Hops, [pos(Pos)|Inputs], Step), nl, ttyflush, output_shape_computation(M, Mode, Inputs, Rest). 

same_otter_config(config(Left1, State1, Item1, Dir1, Right1), config(Left2, State2, Item2, Dir2, Right2)) :-
    State1 == State2, Dir1 == Dir2, same_otter_tape(Left1, Left2), same_otter_tape([Item1], [Item2]), same_otter_tape(Right1, Right2).

same_shape(config(Left1, State1, Item1, Dir1, Right1), config(Left2, State2, Item2, Dir2, Right2)) :-
     State1 == State2, Dir1 == Dir2, same_shape2(Left1, Left2), same_shape2([Item1], [Item2]), same_shape2(Right1, Right2).

same_shape2([], _).
same_shape2([grp(I1,_N1)|Rest1], [grp(I2,_N2)|Rest2])  :- I1 == I2, !, same_shape2(Rest1, Rest2). 
same_shape2([grp(I1, N1)|Rest1], [grp(_I2,_N2)|Rest2]) :- same_shape2([grp(I1,N1)|Rest1], Rest2).

same_otter_tape([], []).
same_otter_tape([Item1|Rest1], [Item2|Rest2]) :- ground(Item1), ground(Item2), Item1 == Item2, !, same_otter_tape(Rest1, Rest2).
same_otter_tape([grp(I1,N1)|Rest1], [grp(I2,N2)|Rest2]) :- I1 == I2, same_variable_expression(N1,N2), same_otter_tape(Rest1, Rest2). % This is basically saying N1 and N2 are equivalent when variables are involved, eg Y1//2 and Y2//2. 

% Hacky but will do for now. 
same_variable_expression(E1,E2) :- copy_term_nat(E1, NewE1), copy_term_nat(E2, NewE2), \+ \+ NewE1 = NewE2. 

equiv_config(Config1, Config2) :-
    Config1 = config(_Left1, State, _Item1, _Dir1, _Right1),
    Config2 = config(_Left2, State, _Item2, _Dir2, _Right2), % Fail quickly if the states differ.  
    flattenish(Config1, C1), flattenish(Config2, C2), exact_config(C1, C2), !. % Hacky version for monster 72 issue. 
equiv_config(Config1, Config2) :-
    Config1 = config(_Left1, State, _Item1, _Dir1, _Right1),
    Config2 = config(_Left2, State, _Item2, _Dir2, _Right2), % Fail quickly if the states differ.
    variant_config(Config1, VarConfig1), flattenish(VarConfig1, Flat1), 
    variant_config(Config2, VarConfig2), flattenish(VarConfig2, Flat2),
    exact_config(Flat1, Flat2), !. 

flattenish(Config, Flat) :-
    Config = config(Left, State, Item, l, Right), !, 
    new_leftify(Left, NLeft), 
    flattenish_tape(NLeft, NewLeft1),
    new_leftify(NewLeft1, NewLeft), 
    flattenish_tape([Item|Right], Right2),
    front_item(Right2, NewItem, NewRight),
    Flat = config(NewLeft, State, NewItem, l, NewRight), !. 

flattenish(Config, Flat) :-
    Config = config(Left, State, Item, r, Right), !, 
    new_leftify([Item|Left], NLeft), 
    flattenish_tape(NLeft, NLeft2),
    new_leftify(NLeft2, NewLeft2), 
    front_item(NewLeft2, NewItem, NewLeft), 
    flattenish_tape(Right, NewRight),
    Flat = config(NewLeft, State, NewItem, l, NewRight), !.

flattenish_tape([], []).
flattenish_tape(Tape, Tape) :- length(Tape, 1), !. 
flattenish_tape(Tape, FlatTape) :-
    Tape = [Item1|Rest1], Rest1 = [Item2|Rest2], Item1 = grp(I1, N1), Item2 = grp(I2, N2),
    %     ground(N1), ground(N2), RealN1 is N1, RealN2 is N2, member(RealN1, [1,2]), member(RealN2, [1,2]), !,
    ground(N1), ground(N2), RealN1 is N1, RealN2 is N2, between(1, 10, RealN1), between(1, 10, RealN2), !, 
    make_item(I1, N1, I2, N2, I3), append([grp(I3,1)], Rest2, Tape1),
    flattenish_tape(Tape1, FlatTape).

flattenish_tape(Tape, FlatTape) :-
    Tape = [Item1|Rest1], !, 
    flattenish_tape(Rest1, Result1),
    append([Item1], Result1, FlatTape). 

%I3 is the flattened version of [grp(I1,N1),grp(I2,N2)]
make_item(I1, N1, I2, N2, I3) :-
    ungroup(I1, N1, I1, Temp1),
    ungroup(I2, N2, I2, Temp2),
    append(Temp1, Temp2, I3). 

ungroup(_I, 1, SoFar, SoFar).
ungroup(I, N, SoFar, List) :- N > 1, !, N1 is N-1, append(SoFar, I, NewSoFar), ungroup(I, N1, NewSoFar, List). 
    
% make_item(I1, 1, I2, 1, I3) :- append(I1, I2, I3).
% make_item(I1, 1, I2, 2, I3) :- append(I1, I2, Temp), append(Temp, I2, I3).
% make_item(I1, 2, I2, 1, I3) :- append(I1, I1, Temp), append(Temp, I2, I3). 
% make_item(I1, 2, I2, 2, I3) :- append(I1, I1, Temp1), append(I2, I2, Temp2), append(Temp1, Temp2, I3). 

front_item([Item|Rest], grp(I,N), Rest) :- Item = grp(I,N), variable(N), !.
front_item([Item|Rest], grp(I,N), Rest) :- Item = grp(I,N), length(I, 1), 1 is N, !. 
front_item([Item|Rest], grp(I,1), [grp(I,N1)|Rest]) :- Item = grp(I,N), length(I, 1), N1 is N-1, !.
front_item([Item|Rest], grp(I1,1), [grp(I2,1)|Rest]) :- Item = grp(I,N), 1 is N, !, append(I1,I2,I), length(I1,1).
front_item([Item|Rest], grp(I1,1), Result) :- Item = grp(I,N), N1 is N-1, !, append(I1,I2,I), length(I1,1), append([grp(I2,1),grp(I,N1)], Temp), append(Temp, Rest, Result). 

variant_config(Config, VariantConfig) :- compress_config(plain, Config, VariantConfig). % Could we use rotate?
variant_config(Config, VariantConfig) :-
    Config = config(Left, State, Item, Dir, Right),
    new_leftify(Left, RealLeft), rotate(RealLeft, VarLeftTemp), new_leftify(VarLeftTemp, VarLeft),
    rotate(Right, VarRight), 
    VariantConfig = config(VarLeft, State, Item, Dir, VarRight).
variant_config(Config, VariantConfig) :- rotate_for_accel(Config, VariantConfig).
% New case for monster 240
variant_config(Config, VariantConfig) :- modify_config(Config, VariantConfig).

modify_config(Config, NewConfig) :-
     Config = config(_Left, _State, Item, InDir, _Right), 
     Item = grp(I, Number),
     length(I, K), K > 1, Number == 1, !, % So it is very much a specific case ... 
     split_up_item(I, InDir, NewItem, Rest), 
     add_to_config(Config, NewItem, Rest, InDir, OutDir, NConfig), 
     NConfig = config(NLeft1, NewState, NItem, OutDir, NRight1), 
     check_blank(NLeft1, NLeft),
     check_blank(NRight1, NRight),
     compress_config(rotate, config(NLeft, NewState, NItem, OutDir, NRight), NewConfig). 

rotate_for_accel(Config, Config). % Allow no rotation for simplicity at upper level. 
rotate_for_accel(Config, RAConfig) :-
    Config = config(Left, State, Item, l, Right),
    rotate([Item|Right], NewRight),
    NewRight = [NewItem|RestNewRight],
    RAConfig = config(Left, State, NewItem, l, RestNewRight).

rotate_for_accel(Config, RAConfig) :-
    Config = config(Left, State, Item, r, Right),
    new_leftify([Item|Left], RealLeft), rotate(RealLeft, NLeft), new_leftify(NLeft, NewLeft),
    NewLeft = [NewItem|RestNewLeft],
    RAConfig = config(RestNewLeft, State, NewItem, r, Right).
    
exact_config(config(Left1, State1, Item1, Dir1, Right1), config(Left2, State2, Item2, Dir2, Right2)) :-
     State1 == State2, Dir1 == Dir2, 
     exact_tape(Left1, Left2), exact_tape([Item1], [Item2]), exact_tape(Right1, Right2).

exact_tape([], []).
exact_tape([grp(I1,N1)|Rest1], [grp(I2,N2)|Rest2]) :-
     ground(N1), ground(N2), I1 == I2, N is N1, N is N2, !, 
     exact_tape(Rest1, Rest2). 
exact_tape([grp(I1,N1)|Rest1], [grp(I2,N2)|Rest2]) :-
     variable(N1), variable(N2), I1 == I2, RealN1 = N1, RealN2 = N2, simplify_expression(RealN1, R1), simplify_expression(RealN2, R2), R1 == R2, !, 
     exact_tape(Rest1, Rest2). 

% The second argument below should be the newer configuration ... 

% candidate_regression(Config1, Config, LDiffs1Raw, ItemDiff1Raw, RDiffs1Raw),
candidate_regression(config(Left1, State1, Item1, Dir1, Right1), config(Left2, _State2, Item2, _Dir2, Right2), RealConfig1) :- 
    changes(Left1, Left2, RealLeft1, LDiffs), changes(Right1, Right2, RealRight1, RDiffs), changes([Item1], [Item2], [RealItem1], [ItemDiff]),
    RealConfig1 = config(RealLeft1, State1, RealItem1, Dir1, RealRight1), 
    regressor_list(LDiffs,  ItemDiff, RDiffs,  Regressors), length(Regressors, R), R >=1, % At least one difference is negative
    progressor_list(LDiffs, ItemDiff, RDiffs, Progressors), length(Progressors, P), P >=1, % At least one difference is negative -- weird case in Dragon 77 otherwise of "regressor only"
    true.

% The second argument below should be the newer configuration ... 
regression(config(Left1, State1, Item1, Dir1, Right1), config(Left2, _State2, Item2, _Dir2, Right2), config(RealLeft1, State1, Item1, Dir1, RealRight1), LDiffs, ItemDiff, RDiffs) :- 
     changes(Left1, Left2, RealLeft1, LDiffs), changes(Right1, Right2, RealRight1, RDiffs), changes([Item1], [Item2], _, [ItemDiff]),
     regressor_list(LDiffs, ItemDiff, RDiffs, Regressors), length(Regressors, L), L >=1. % At least one difference is negative

changes([], Rest, RealRest, Diffs) :- changes1(Rest, RealRest, Diffs). 
% changes([grp(I1,N1)|R1], [grp(I2,N2)|R2], [grp(I1,N1)|RealOne], [m(1,L)|Rest]) :- I1 == I2, L #= N2 - N1, ground(L), !, changes(R1, R2, RealOne, Rest). % Need difference to be an integer ...
changes([grp(I1,N1)|R1], [grp(I2,N2)|R2], [grp(I1,N1)|RealOne], [m(1,L)|Rest]) :- I1 == I2, L is N2 - N1, !, changes(R1, R2, RealOne, Rest). % Need difference to be an integer ... 
changes([grp(I1,N1)|R1], [grp(I2,N2)|R2], [grp(I2,0)|RealOne], [m(1,N2)|Rest]) :- I1 \== I2, !, changes([grp(I1,N1)|R1], R2, RealOne, Rest). % Do we need N2 to be ground? 

changes1([], [], []).
changes1([grp(I,N)|Rest], [grp(I,0)|RealRest], [m(1,N)|Diffs]) :- changes1(Rest, RealRest, Diffs). 

linear_otter_pattern(_OtterType, Config, Config1, Config2, Hops2, _Type, _Index, _History, RealLDiffs, RealItemDiff, RealRDiffs, uni, Hops2, Config2) :-
    % Multilinear includes linear, so do this in either case. 
    Config = config(Left, _State, Item, _Dir, Right),
    Config1 = config(Left1, _State1, Item1, _Dir1, Right1),
    Config2 = config(Left2, _State2, Item2, _Dir2, Right2),
    % format("% ~k: Finding unilinear diffs ~n", [OtterType]), 
    linear_diffs(uni, Left, Left1, Left2, RealLDiffs),
    linear_diffs(uni, Right, Right1, Right2, RealRDiffs),
    linear_diffs(uni, [Item], [Item1], [Item2],[RealItemDiff]), !, % Don't search for multilinear if we have already found unilinear ... 
    % format("% Found~n", []), 
    true. 

% No unilinear pattern, so need to look for a 4th for a multilinear pattern.
linear_otter_pattern(multi, Config, Config1, Config2, Hops2, Type, Index, History, RealLDiffs, RealItemDiff, RealRDiffs, multi, Hops3, RealConfig3) :-
    Config = config(Left, State, Item, Dir, Right),
    Config1 = config(Left1, _State1, Item1, _Dir1, Right1),
    Config2 = config(Left2, _State2, Item2, _Dir2, Right2),

    % format("% Finding multilinear diffs ~n", []), 
    
    linear_diffs(multi, Left, Left1, Left2, RealLDiffs),
    linear_diffs(multi, Right, Right1, Right2, RealRDiffs),
    linear_diffs(multi, [Item], [Item1], [Item2],[RealItemDiff]),

    % format("% Multilinear diffs found ", []), writeln(RealLDiffs+RealItemDiff+RealRDiffs), 
    
    lookup_history(Type, State, Dir, Index, s(Hops3,Config3, _, _), History), Hops3 < Hops2, 
    Config3 = config(Left3, State, Item3, Dir, Right3), 
    same_shape(config(Left3, State, Item3, Dir, Right3), config(Left2, State, Item2, Dir, Right2)),
     
    candidate_regression(Config3, Config2, RealConfig3),

    % format("% Candidate regression at ~k~n", [Hops3]), 

    linear_diffs(multi, Left1, Left2, Left3, RealLDiffs),
    linear_diffs(multi, Right1, Right2, Right3, RealRDiffs),
    linear_diffs(multi, [Item1], [Item2], [Item3],[RealItemDiff]),

    % format("% Diffs work~n", []), 
    
    append(RealLDiffs, [RealItemDiff], Temp), append(Temp, RealRDiffs, AllDiffs), 
    multilinear(AllDiffs), 
    true. 

unilinear([]).
unilinear([m(K,_N)|Rest]) :- K == 1, unilinear(Rest).
% unilinear(Diffs) :- \+ multilinear(Diffs). % ??

multilinear(Diffs) :- member(m(K,N), Diffs), K > 1, N >= 0. 


% m(K2,N2) is the older difference, m(K1,N1) the newer difference etc. 
linear_diffs(_, [], [], [], []).
linear_diffs(Kind, [grp(I,N)|Tape], [grp(I,N1)|Tape1], [grp(I,N2)|Tape2], [m(K,M)|Result]) :-
	N < N1, N1 < N2, Diff1 is N - N1, Diff2 is N1 - N2, Diff1 == Diff2, !, % regressive case 										   
	K is 1, M is Diff1, 
	linear_diffs(Kind, Tape, Tape1, Tape2, Result). 
linear_diffs(Kind, [grp(I,N)|Tape], [grp(I,N1)|Tape1], [grp(I,N2)|Tape2], [m(K,M)|Result]) :-
        N == N1, N1 == N2, !, % Constant case (vacuously progressive)
	K is 1, M is 0, 
	linear_diffs(Kind, Tape, Tape1, Tape2, Result). 
linear_diffs(Kind, [grp(I,N)|Tape], [grp(I,N1)|Tape1], [grp(I,N2)|Tape2], [m(K,M)|Result]) :-
        N > N1, N1 > N2, Diff1 is N - N1, Diff2 is N1 - N2, 0 is Diff1 mod Diff2, !, % Constant case (vacuously progressive)
	K is Diff1 // Diff2, (Kind == uni -> K is 1; true ), % Allows for both unilinear and multilinear
	M is N1 - K*N2, M is N - K*N1, % Check that both differences "work"
	linear_diffs(Kind, Tape, Tape1, Tape2, Result). 
								       
% regressive([m(_, LL)|_Diffs]) :- copy_term_nat(LL, RealLL), RealLL #< 0, !.
regressive([m(_, LL)|_Diffs]) :- LL < 0, !.
regressive([m(_, _LL)|Diffs]) :- regressive(Diffs).

diff_counters(LDiffs, ItemDiff, RDiffs, Progressors, Regressors) :-
    regressor_list(LDiffs, ItemDiff, RDiffs, Regressors),
    progressor_list(LDiffs, ItemDiff, RDiffs, Progressors).

progressive(config(Left1, State, Item1, Dir, Right1), config(Left2, State, Item2, Dir, Right2)) :-
     changes(Left1, Left2, _RealLeft1, LDiffs),    
     changes(Right1, Right2, _RealRight1, RDiffs),  
     changes([Item1], [Item2], _, [ItemDiff]),
     append(LDiffs, [ItemDiff|RDiffs], List), 
     progressive_list(List). 

progressive_list([]).
progressive_list([m(N,K)|Rest]) :- ground(N), ground(K), N1 is N, K1 is K, N1 >= 0, K1 >= 0, !, progressive_list(Rest).
progressive_list([m(N,K)|Rest]) :- ground(N), ground(K), N1 is N, K1 is K, N1 > 1,  K1 < 0,  !, progressive_list(Rest). % Weird, but I guess correct ...  

real_progression([], [], [], [], []).
real_progression([grp(I,N0)|R0], [grp(I,N1)|R1], [grp(I,N2)|R2], [grp(I,N3)|R3], [Diff|Rest]) :-
	real_progression1(N0, N1, N2, N3, Diff), 
	real_progression(R0, R1, R2, R3, Rest). 	

real_progression1(N0, N1, N2, N3, m(1,0)) :- ground(N0), ground(N1), ground(N2), ground(N3), N1 is N2, N2 is N3, N1 is N0, !. 
real_progression1(N0, N1, N2, N3, m(1,L)) :- ground(N0), ground(N1), ground(N2), ground(N3), N3 > N2, N2 > N1, N1 > N0, L is N1 - N0, L is N2 - N1, L is N3 - N2, !. % linear progression
real_progression1(N0, N1, N2, N3, m(K,L)) :- ground(N0), ground(N1), ground(N2), ground(N3), N3 > N2, N2 > N1, N1 > N0, N3 - N2 > N2 - N1, N2 - N1 > N1 - N0, 0 is (N3-N2) mod (N2-N1), !, 
					     K is (N3-N2) // (N2-N1), K is (N2-N1) // (N1-N0), K is (N3-N1) // (N2-N0), L is N1 - K*N0, L >= 0, !. 

regression_counters([L1|Left], [LDiff|LDiffs], Right, RDiffs, SoFar, Counts) :-  regressors(SoFar, L1, LDiff, NewSoFar), regression_counters(Left, LDiffs, Right, RDiffs, NewSoFar, Counts). 
regression_counters([], [], [R1|Right], [RDiff|RDiffs], SoFar, Counts) :-        regressors(SoFar, R1, RDiff, NewSoFar), regression_counters([], [], Right, RDiffs, NewSoFar, Counts). 
regression_counters([], [], [], [], Counts, Counts). 

regressors(List, _Item, Diff, List) :-  Diff = m(_K,L), L >= 0. % Check for variables?
regressors(List, Item, Diff, [reg(Num, LL)|List]) :- Item = grp(_I,Num), Diff = m(_K,L), L < 0, LL is 0 - L. % Check for variables?

eval_regs([], []).
eval_regs([reg(Num,LL)|Rest], [Count|Result]) :- ground(Num), ground(LL), Count is Num // LL, eval_regs(Rest, Result). 

simple_transition(M, State, Item, NewState, NewItem, Dir, 1) :- \+ halt_state(State), M = machine(TransList, _, _), \+ atomic(TransList), member(t(State, Item, NewItem, Dir, NewState), TransList), !. 
simple_transition(M, State, Item, NewState, NewItem, Dir, 1) :- \+ halt_state(State), \+ (M = machine(_TransList, _, _)), \+ atomic(M), member(t(State, Item, NewItem, Dir, NewState), M), !.
simple_transition(riemann, State, Item, NewState, NewItem, Dir, 1)  :- \+ halt_state(State),  riemann(State, Item, NewItem, Dir, NewState), !. 
simple_transition(goldbach, State, Item, NewState, NewItem, Dir, 1) :- \+ halt_state(State), goldbach(State, Item, NewItem, Dir, NewState), !. 
simple_transition(zermelo, State, Item, NewState, NewItem, Dir, 1)  :- \+ halt_state(State),  zermelo(State, Item, NewItem, Dir, NewState), !. 

complex_transition(M, State, Item, InDir, NewM, NewState, OutItem, OutDir, Steps) :-
    \+ halt_state(State), M = machine(_, MacroList, _), member(trans(State, Item, InDir, NewState, OutItem, OutDir, Steps), MacroList), !, NewM = M.

complex_transition(M, State, Item, InDir,  NewM, NewState, OutItem, OutDir, Steps) :-
    \+ halt_state(State), !, %  M = machine(_, MacroList, _), \+ member(trans(State, Item, InDir, _NewState, _OutItem, _OutDir, _Steps), MacroList),
    length(Item, Len),
    number_of_states(M, Num), B is truncate(Num * Len * 2^Len), 
    find_transition(M, State, Item, InDir, B, NewM, NewState, OutItem, OutDir, Steps), !. 

new_transition(States, Symbols, _Dirs, M, Config, t(State, Item, 1, r, HaltState), NewM) :-
    number_of_states_used(M, States), number_of_symbols_used(M, Symbols), % So M is "full" ... 
    M = machine(Transitions, List2, List3), 
    Config = config(_Left, State, Item, _Dir, _Right), 
    halt_state(HaltState), 
    Trans =  t(State, Item, 1, r, HaltState), % New halt transition ... 
    append(Transitions, [Trans], NewTransitions), 
    \+ zero_dextrous(States, NewTransitions), % Make sure the new machine is not 0-dextrous ... 
    NewM = machine(NewTransitions, List2, List3).

new_transition(States, Symbols, Dirs,  M, Config, t(State, Item, Out, OutDir, NewState), NewM) :-
    % No need to be exclusive here --- we want this case to work even if the one above does ... 
    M = machine(Transitions, List2, List3), % write(Config), nl, 
    Config = config(_Left, State, Item, _Dir, _Right), 
    newstate(States, Symbols, Dirs, Transitions, NewState, Out, OutDir), 
    Trans =  t(State, Item, Out, OutDir, NewState), 
    append(Transitions, [Trans], NewTransitions), 
    \+ zero_dextrous(States, NewTransitions), % Make sure the new machine is not 0-dextrous ... 
    add_halt_trans(States, Symbols, Dirs, NewTransitions, NewTrans), % If the new machine has only one available slot, add the halt transition now. 
    NewM = machine(NewTrans, List2, List3).

newstate(States, Symbols, Dirs, List, NewState, Output, Dir) :-
    dirs_list(Dirs, abs, DirList), % Compatibility hack for now ...
    symbols_list(Symbols, List, SymbolsList), 
    legitimate_list(States, List, StateList), 
    !, 
    member(NewState, StateList), member(Output, SymbolsList), member(Dir, DirList). 

add_halt_trans(States, Symbols, _Dirs, Trans, Trans) :-
    length(Trans, L), Full is States * Symbols - 1, L < Full, !. 
add_halt_trans(States, Symbols, Dirs, Trans, NewTrans) :-
    !, % length(Trans, L), Full is States * Symbols - 1, L == Full,
    states_list(States, StatesList),
    symbols_list1(Symbols, SymbolsList),
    once( missing(StatesList, SymbolsList, Trans, NewState, NewSymbol) ), 
    halt_trans(Dirs, abs, t(NewState, NewSymbol, NewOut, NewDir, NewNewState)),
    append(Trans, [t(NewState, NewSymbol, NewOut, NewDir, NewNewState)], NewTrans).

find_transition(M, State, Item, l, Bound, NewM, NewState, OutItem, OutDir, Steps) :-
    Item = [I|Rest], append(Rest, [right_end], NewRest), 
    wild_wombat(config([left_end], State, I, l, NewRest), M, Bound, [pos(0)], 0, NewState, OutItem, OutDir, Steps),
    M = machine(TransList, MacroList, List),
    add_to_list(trans(State, Item, l, NewState, OutItem, OutDir, Steps), MacroList, NewMacroList),
    NewM = machine(TransList, NewMacroList, List). 

find_transition(M, State, Item, r, Bound, NewM, NewState, OutItem, OutDir, Steps) :-
    splitlast(Item, L1, [I]), reverse(L1, Left), !, append(Left, [left_end], NewLeft), 
    wild_wombat(config(NewLeft, State, I, r, [right_end]), M, Bound, [pos(0)], 0, NewState, OutItem, OutDir, Steps),
    M = machine(TransList, MacroList, List), 
    add_to_list(trans(State, Item, r, NewState, OutItem, OutDir, Steps), MacroList, NewMacroList),
    NewM = machine(TransList, NewMacroList, List). 

wild_wombat(config(Left, State, Item, _Dir, Right), _M, _Bound, _Inputs, Hops, NewState, OutItem, OutDir, Hops) :-
    halt_state(State), !, NewState = State, append(Left, [Item], Temp), append(Temp, Right, OutI), clean_tape(OutI, OutItem), OutDir = r.

wild_wombat(config(Left, _State, Item, Dir, Right), _M, Bound, _Inputs, Hops, loop, OutItem, Dir, Hops) :-
    Hops >= Bound, !, append(Left, [Item], Temp), append(Temp, Right, OutI), clean_tape(OutI, OutItem).

wild_wombat(config(Left, State, Item, Dir, Right), _M, _Bound, _Inputs, Hops, State, OutItem, OutDir, Hops) :-
    out_of_bounds(Left, Item, Right, Dir, OutItem, OutDir), !. % This is normal termination. 

wild_wombat(config(Left, State, Item, _Dir, Right), M, Bound, Inputs, Hops, NewState, OutItem, OutDir, NewHops) :-
    % \+ halt_state(State), Hops < Bound, \+ out_of_bounds(Left, Item, Right, Dir, _, _), !, 
    simple_transition(M, State, Item, NState, NItem, NDir, Steps), 
    updatetape(naive, Left, NItem, Right, NDir, NLeft, NewItem, NRight, _Moves), 
    NewConfig = config(NLeft, NState, NewItem, NDir, NRight), 
    Hops1 is Hops + Steps, 
    wild_wombat(NewConfig, M, Bound, Inputs, Hops1, NewState, OutItem, OutDir, NewHops).
    
out_of_bounds([], left_end, Right, l, OutItem, l) :- clean_tape(Right, OutItem).
out_of_bounds(Left, right_end, [], r, OutItem, r) :- reverse(Left, New), clean_tape(New,OutItem). 

clean_tape([], []).
clean_tape([I|Rest], Result) :- I == left_end,  !, clean_tape(Rest, Result). 
clean_tape([I|Rest], Result) :- I == right_end, !, clean_tape(Rest, Result). 
clean_tape([I|Rest], [I|Result]) :- clean_tape(Rest, Result). 

updatetape(Mode, Left, Item, Right, Dir, NewLeft, NewItem, NewRight, Move) :-
     Dir == l, !, 
     append([Item], Right, NRight), check_blank(NRight, NewRight), 
     next_item(Mode, Left, NewItem, NLeft), 
     check_blank(NLeft, NewLeft), 
     Move is 0 - 1. 

updatetape(Mode, Left, Item, Right, Dir, NewLeft, NewItem, NewRight, 1) :-
     Dir == r, !, 
     append([Item], Left, NLeft), check_blank(NLeft, NewLeft), 
     next_item(Mode, Right, NewItem, NRight),
     check_blank(NRight, NewRight).

updatetapeflex(Config, Mode, trans(State, I1, Dir, NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I2, Number), I1 == I2, 
     State == NewState, Dir == l, OutDir == r,  !, % Holkner case 1

     squash_item(grp(OutI,Number), NItem), 
     add_item(NItem, Left, NewLeft), 
     next_item(Mode, Right, NewItem, NewRight),
     NewDir = l,
     length(I1, N),

     set_leaps_moves(l,r,Number, N, Steps, Leaps, Moves).

updatetapeflex(Config, Mode, trans(State, I1, Dir, NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I2, Number), I1 == I2, % integer(Number), %% will work for variables too
     State == NewState, Dir == r, OutDir == l,  !, % Holkner case 2

     squash_item(grp(OutI,Number), NItem), 
     add_item(NItem, Right, NewRight), 
     
     next_item(Mode, Left, NewItem, NewLeft),
     NewDir = r,
     length(I1, N),

     set_leaps_moves(r,l,Number, N, Steps, Leaps, Moves). 

% New acceleration cases here ... 
updatetapeflex(Config, Mode, trans(State, I1, Dir, NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     State == NewState, Dir == l, OutDir == r, % Holkner case 1
     Item = grp(I2, Number), length(I1, L1), length(I2, L2), L1 > L2, K is L1//L2, % So if it is an acceleration case, we must have that I1 is an expansion of I2, and so we know L1 must be a multiple of L2. 
     !, 
     safe_squash(OutI, N, NewI), % Will bind N and NewI to appropriate values so that OutI = (NewI)^N. If N = 1 and NewI = OutI, no squashing has occurred ... In any case, length(OutI) is N*length(NewI).
     set_exponent(N, Number, K, Exp1), simplify_expression(Exp1, Exp), 
     set_modulus(Number, K, Mod), simplify_expression(Mod, RealMod),
     
     add_item(grp(NewI, Exp), Left, NewLeft),
     
     ( (ground(Mod), RealMod == 0) -> next_item(Mode, Right, NewItem, NewRight) ; (NewItem = grp(I2,RealMod), NewRight = Right) ), % If N*(Number mod K) is 0, move to next item in Right. Otherwise leave Item alone. 

     NewDir = l,
     set_leaps_acc(Number, K, Steps, Leaps),
     set_moves_acc(l, r, Number, K, L1, Moves).

updatetapeflex(Config, Mode, trans(State, I1, Dir, NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right),
     State == NewState, Dir == r, OutDir == l,  % Holkner case 2
     Item = grp(I2, Number), length(I1,L1), length(I2, L2), L1 > L2, K is L1//L2, % So if it is an acceleration case, we must have that I1 is an expansion of I2, and so we know L1 must be a multiple of L2.
     !, 
     
     safe_squash(OutI, N, NewI), % Will bind N and NewI to appropriate values so that OutI = (NewI)^N. If N = 1 and NewI = OutI, no squashing has occurred ... In any case, length(OutI) is N*length(NewI).
     set_exponent(N, Number, K, Exp1), simplify_expression(Exp1, Exp), 
     set_modulus(Number, K, Mod), simplify_expression(Mod, RealMod), 

     add_item(grp(NewI, Exp), Right, NewRight),

     ( (ground(Mod), RealMod == 0) -> next_item(Mode, Left, NewItem, NewLeft) ; (NewItem = grp(I2,RealMod), NewLeft = Left) ), % If N*(Number mod K) is 0, move to next item in Left. Otherwise leave Item alone.  

     NewDir = r,
     set_leaps_acc(Number, K, Steps, Leaps),
     set_moves_acc(r, l, Number, K, L1, Moves). 

updatetapeflex(Config, Mode, trans(State, I, Dir, _NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number), %% (State \== NewState; (State == NewState, Dir == r)), 
     ground(Number), 1 is Number, OutDir == r,  !, 

     add_item(grp(OutI, Number), Left, NewLeft), 
     next_item(Mode, Right, NewItem, NewRight),

     NewDir = l,
     Leaps = Steps, 
     length(I, L), 
     set_moves(Dir, OutDir, L, Moves).

updatetapeflex(Config, Mode, trans(State, I, Dir, _NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number), %% (State \== NewState; (State == NewState, Dir == l)), 
     ground(Number), 1 is Number, OutDir == l,  !, 
     add_item(grp(OutI, Number), Right, NewRight),
     next_item(Mode, Left, NewItem, NewLeft),

     NewDir = r,
     Leaps = Steps, 
     length(I, L), 
     set_moves(Dir, OutDir, L, Moves).

updatetapeflex(Config, Mode, trans(State, I, Dir, _NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number),   % ( (ground(Number), NTemp is Number, NTemp > 1) ; variable(Number) ),    
     Dir == r, OutDir = r, OutI == I, !, 
     add_item(grp(I, Number), Left, NewLeft), 
     next_item(Mode, Right, NewItem, NewRight),  

     NewDir = l,
     Leaps = Steps, 
     Moves = 1. 

updatetapeflex(Config, Mode, trans(State, I, Dir, _NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number),   % ( (ground(Number), NTemp is Number, NTemp > 1) ; variable(Number)),  % format("Case 6~n", []), display(I), display(OutI), nl,  
     Dir = r, OutDir = r, OutI \== I, !, 

     simplify_expression(Number-1, N1), 
     add_item(grp(I, N1), Left, NLeft),
     squash_item(grp(OutI,1), NewOut), 
     add_item(NewOut, NLeft, NewLeft), 
     next_item(Mode, Right, NewItem, NewRight),  

     NewDir = l, 
     Leaps = Steps,
     Moves = 1. 

updatetapeflex(Config, Mode, trans(State, I, Dir, _NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number),  % ( (ground(Number), NTemp is Number, NTemp > 1) ; variable(Number) ), 
     Dir = l, OutDir = l, OutI == I, !, 

     add_item(grp(I, Number), Right, NewRight), 
     next_item(Mode, Left, NewItem, NewLeft),  

     NewDir = r,
     Leaps = Steps, 
     Moves = -1. 

updatetapeflex(Config, Mode, trans(State, I, Dir, _NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number), % ( (ground(Number), NTemp is Number, NTemp > 1) ; variable(Number)), 
     Dir = l, OutDir = l, OutI \== I, !, 

     simplify_expression(Number-1, N1), 
     add_item(grp(I, N1), Right, NRight),
     squash_item(grp(OutI,1), NewOut), 
     add_item(NewOut, NRight, NewRight),
     next_item(Mode, Left, NewItem, NewLeft),  

     NewDir = r,
     Leaps = Steps, 
     Moves = -1. 

updatetapeflex(Config, _Mode, trans(State, I, Dir, NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number), % ( (ground(Number), NTemp is Number, NTemp > 1) ; variable(Number) ), 
     State \== NewState, Dir == l, OutDir == r, !, 

     simplify_expression(Number-1, N1), 
     NewItem = grp(I, N1),
     squash_item(grp(OutI,1), NItem), 
     add_item(NItem, Left, NewLeft), 
     NewDir = l, 
     NewRight = Right,
     Leaps = Steps, 
     length(I, N), 
     Moves = N.
      
updatetapeflex(Config, _Mode, trans(State, I, Dir, NewState, OutI, OutDir, Steps), NewLeft, NewItem, NewDir, NewRight, Leaps, Moves) :-
     Config = config(Left, State, Item, Dir, Right), 
     Item = grp(I, Number), % ( (ground(Number), NTemp is Number, NTemp > 1) ; variable(Number) ), 
     State \== NewState, Dir == r, OutDir == l, !, 

     simplify_expression(Number-1, N1), 
     NewItem = grp(I, N1),
     squash_item(grp(OutI,1), NItem),
     add_item(NItem, Right, NewRight), 
     
     NewDir = r,
     NewLeft = Left, 
     Leaps = Steps,
     length(I, N), 
     Moves = -N.

updateinputs(Mode, Hops, Dir, Moves, Used, Inputs, NewConfig, NewInputs) :-
     delete(Inputs, used(_), NInputs),
     append(NInputs, [used(Used)], Inputs0),
     % format("Updating history~n", []), 
     update_history(Hops, Used, Inputs0, NewConfig, Inputs1), !,
     % format("Updating poss~n", []), 
     update_pos(Mode, Inputs1, Dir, Moves, Inputs2), !,
     % format("Updating steps~n", []), 
     update_steps(Inputs2, Inputs3), !,
     % format("Updating progregs~n", []), 
     update_progreg(Used, Inputs3, Inputs4), !, 
     NewInputs = Inputs4.

update_history(Hops, Used, Inputs, NewConfig, NewInputs) :-
     member(history(History), Inputs), member(pos(Current), Inputs), member(now(Now), Inputs),
     set_type(Inputs, Type), 
     Now = config(_, State, _, Dir, _), 
     history_index(Type, Now, Index), 
     add_to_history(Type, State, Dir, Index, s(Hops,Now,Current,Used), History, NewHistory), !, % history update
     delete(Inputs, history(History), Inps), 
     delete(Inps, now(Now), Is), 
     append(Is, [now(NewConfig),history(NewHistory)], NewInputs), !. 

update_history(_Hops, _Used, Inputs, _NewConfig, Inputs) :- \+ (member(history(_History), Inputs), member(now(_Now), Inputs)).

set_type(Inputs, trie(K)) :- member(trie(K), Inputs). 
set_type(Inputs, newtrie(K,L)) :- member(newtrie(K,L), Inputs), \+ member(trie(_), Inputs). 
set_type(Inputs, list(K)) :- member(list(K), Inputs), \+ member(newtrie(_,_), Inputs), \+ member(trie(_), Inputs). 
set_type(Inputs, list) :- \+ member(list(_), Inputs), \+ member(newtrie(_,_), Inputs), \+ member(trie(_), Inputs). 

initial_history(list, _, _, []).
initial_history(list(_), _, _, []).
initial_history(trie(_), States, Directions, History) :- empty_dir_list(Directions, DList), empty_state_list(States, DList, History).
initial_history(newtrie(_,_), States, Directions, History) :- empty_dir_list(Directions, DList), empty_state_list(States, DList, History).

empty_dir_list(2, [tr(l,[]),tr(r,[])]). % Only do two for now.

empty_state_list(2, DList, [tr(a,DList),tr(b,DList)]). 
empty_state_list(3, DList, [tr(a,DList),tr(b,DList),tr(c,DList)]). 
empty_state_list(4, DList, [tr(a,DList),tr(b,DList),tr(c,DList),tr(d,DList)]). 
empty_state_list(5, DList, [tr(a,DList),tr(b,DList),tr(c,DList),tr(d,DList),tr(e,DList)]). 
empty_state_list(6, DList, [tr(a,DList),tr(b,DList),tr(c,DList),tr(d,DList),tr(e,DList),tr(f,DList)]). 
empty_state_list(7, DList, [tr(a,DList),tr(b,DList),tr(c,DList),tr(d,DList),tr(e,DList),tr(f,DList),tr(g,DList)]). 
empty_state_list(8, DList, [tr(a,DList),tr(b,DList),tr(c,DList),tr(d,DList),tr(e,DList),tr(f,DList),tr(g,DList),tr(h,DList)]). 

% Trie structure is ... [tr(a,A),tr(b,B),tr(c,C),tr(d,D),tr(e,E)]
% A is [tr(l,Left),tr(r,Right)]
% Left is [tr(0,Zero),tr(1,One),tr(2,Two)]

history_index(list(_),  _, []) :- !. 
history_index(list,  _, []) :- !. 
history_index(trie(_),  Config, I) :-
	Config = config(_, _, Item, _, _), Item = grp(I,_), !. 
history_index(newtrie(_,L), Config, Index) :-
	Config = config(Left, _, Item, _, Right), Item = grp(I,_), 
	shapelist(L, 0, Left, [], LS), !, 
	shapelist(L, 0, Right, [], RS), !, 
	append(I, LS, Temp), append(Temp, RS, Index), !. 

shapelist(_, _, [], SoFar, SoFar) :- !. 
shapelist(Limit, Length, _, SoFar, SoFar) :- Length >= Limit, !. 
shapelist(Limit, Length, [grp(I,_)|Rest],SoFar, Result) :- Length < Limit, !, append(SoFar, I, NewSoFar), length(I, N), NewLength is Length + N, shapelist(Limit, NewLength, Rest, NewSoFar, Result).

lookup_history(list,    _, _, _, s(Hops, Config, Pos, Used), History) :- member(s(Hops, Config, Pos, Used), History). % For history as a list. 
lookup_history(list(_), _, _, _, s(Hops, Config, Pos, Used), History) :- member(s(Hops, Config, Pos, Used), History). % For history as a list. 
lookup_history(trie(_), State, Dir, Item, Step, History) :- % For history as a trie.
     member(tr(State, SList), History), !, % History is of the form [tr(a,A),tr(b,B),...]		 
     member(tr(Dir, DList), SList), !,  % SList is of the form [tr(l,L),tr(r,R)]	
     itemlist(Item, Step, DList). % DList is of the form [tr(0,Zero),tr(1,One),...]					

lookup_history(newtrie(_,_), State, Dir, Item, Step, History) :- % For history as a trie.
     member(tr(State, SList), History), !, % History is of the form [tr(a,A),tr(b,B),...]		 
     member(tr(Dir, DList), SList), !,  % SList is of the form [tr(l,L),tr(r,R)]	
     itemlist(Item, Step, DList). % DList is of the form [tr(0,Zero),tr(1,One),...]					

add_to_history(list, _, _, _, s(Hops,Now,Current,Used), History, NewHistory) :- 
     append([s(Hops,Now,Current,Used)], History, NewHist), !, 
     trim_to_size(list, NewHist, NewHistory), true. % history update.
add_to_history(list(K), _, _, _, s(Hops,Now,Current,Used), History, NewHistory) :- 
     append([s(Hops,Now,Current,Used)], History, NewHist), !, 
     trim_to_size(list(K), NewHist, NewHistory), true. % history update.
add_to_history(Type, State, Dir, Item, Step, History, NewHistory) :- % For history as a trie.
     member(Type, [newtrie(_,_), trie(_)]), 
     member(tr(State, SList), History), !, % History is of the form [tr(a,A),tr(b,B),...]		 
     member(tr(Dir, DList), SList), !,  % SList is of the form [tr(l,L),tr(r,R)]
     add_to_itemlist(Type, Item, Step, DList, NewDList), !, % DList is of the form [tr(0,Zero),tr(1,One),...]
     delete(SList, tr(Dir, DList), SListTemp), append([tr(Dir,NewDList)], SListTemp, NewSList), 
     delete(History, tr(State, SList), HistTemp), append([tr(State, NewSList)], HistTemp, NewHistory),!. 

itemlist([], Step, List) :- extract_step(Step, List). 
itemlist([I|Rest], Step, List) :- member(tr(I, IList), List), !, itemlist(Rest, Step, IList). 
itemlist([I|_Rest], Step, List) :- \+ member(tr(I, _IList), List), !, extract_step(Step, List). 

add_to_itemlist(trie(K), [], Step, List, NewIList) :- 
	append([Step], List, New), !, trim_to_size(trie(K), New, NewIList).
add_to_itemlist(trie(K), [I|Rest], Step, List, NewList) :- 
	member(tr(I, IList), List), !, 
	add_to_itemlist(trie(K), Rest, Step, IList, NewIList),
	delete(List, tr(I, IList), ListTemp), append([tr(I,NewIList)], ListTemp, NewList). 
add_to_itemlist(trie(_), [I|_Rest], Step, List, NewList) :- 
	\+ member(tr(I, _IList), List), !, append([tr(I,[Step])], List, NewList). 
add_to_itemlist(newtrie(K,L), [], Step, List, NewIList) :- 
	append([Step], List, New), !, trim_to_size(newtrie(K,L), New, NewIList).
add_to_itemlist(newtrie(K,L), [I|Rest], Step, List, NewList) :- 
	member(tr(I, IList), List), !, % format("Adding ~k~n", [I]), ttyflush, 				
	add_to_itemlist(newtrie(K,L), Rest, Step, IList, NewIList),
	delete(List, tr(I, IList), ListTemp), append([tr(I,NewIList)], ListTemp, NewList). 
add_to_itemlist(newtrie(K,L), [I|Rest], Step, List, NewList) :- 
	\+ member(tr(I, _IList), List), !, % format("Adding new ~k~n", [I]), ttyflush, 				
	add_to_itemlist(newtrie(K,L), Rest, Step, [], TList), !, append([tr(I,TList)], List, NewList). 

extract_step(Step, [Step|_List]) :- Step = s(_,_,_,_).
extract_step(Step, [Step1|_List]) :- Step1 = tr(_, Rest), extract_step(Step, Rest). 
extract_step(Step, [_|List]) :- extract_step(Step, List). 

trim_to_size(Type, History, History) :- length(History, Len), history_memory(Type, Size), Len =< Size, !. 
trim_to_size(Type, History, Trimmed) :- length(History, Len), history_memory(Type, Size), Len > Size, !, append(Trimmed, _, History), length(Trimmed, Size). 

display_history(_, []). 
display_history(N, [s(Hops, Config, Pos)|Rest]) :- 
      output_blanks(N), 
      format("~d: ", [Hops]), display_config(Config, normal, []), format(" Pos: ~d~n", [Pos]), 
      display_history(N, Rest).
display_history(N, [s(Hops, Config, Pos, Used)|Rest]) :- 
      output_blanks(N), 
      format("~d: ", [Hops]), display_config(Config, normal, []), format(" Pos: ~d    Used: ~k~n", [Pos,Used]), 
      display_history(N, Rest).
display_history(N, [tr(I, List)|Rest]) :- 
      N1 is N+1, output_blanks(N), 
      format("~k: ~n", [I]), 
      display_history(N1, List), display_history(N, Rest).

update_steps(Inputs, NewInputs) :- member(steps(S), Inputs), !, delete(Inputs, steps(S), Inputs1), simplify_expression(S+1, S1), append([steps(S1)], Inputs1, NewInputs). 
update_steps(Inputs, Inputs). 

update_otters(Leaps, ExtraSteps, Nested, ProofLength, Diff1, Diff2, Linear, Inputs, NewInputs) :-
     member(otters(Otters), Inputs), NewOtters is Otters + 1,
     member(multilinearotters(MLOtters), Inputs), ( Linear = multi -> NewMLOtters is MLOtters + 1 ; NewMLOtters = MLOtters ), 
     member(ottersnested(OttersNested), Inputs), NewOttersNested is OttersNested + Nested, 
     member(ottersteps(OtterSteps), Inputs), ( ground(Leaps) -> simplify_expression(OtterSteps + Leaps, NewOtterSteps); NewOtterSteps = OtterSteps ), 
     member(otterjumps(OtterJumps), Inputs), ( ground(Leaps) -> simplify_expression(OtterJumps + Leaps + ExtraSteps, NewOtterJumps); NewOtterJumps = OtterJumps ),  
     member(otterproofs(OtterProofs), Inputs), append(OtterProofs, [o(NewOtters,ProofLength)], NewOtterProofs),
     member(otterdiffs(OtterDiffs), Inputs), append(OtterDiffs, [o(NewOtters,d(Diff1,Diff2))], NewOtterDiffs),
     member(indocelotsteps(OcelotList), Inputs), member(ocelots(Ocelots), Inputs), ground(Leaps), !,
     NewOcelots is Ocelots + 1,
     length(OcelotList, N), Num is N+1, 
     update_ind_ocelots(Num, Leaps, OcelotList, NewOcelotList),

     delete(Inputs, otters(Otters), Inputs1), 
     delete(Inputs1, ottersnested(OttersNested), Inputs2), 
     delete(Inputs2, ottersteps(OtterSteps), Inputs3), 
     delete(Inputs3, otterjumps(OtterJumps), Inputs4),
     delete(Inputs4, otterproofs(OtterProofs), Inputs5),
     delete(Inputs5, otterdiffs(OtterDiffs), Inputs6),
     delete(Inputs6, ocelots(Ocelots), Inputs7),
     delete(Inputs7, indocelotsteps(OcelotList), Inputs8),
     delete(Inputs8, multilinearotters(MLOtters), Inputs9),
     append([ocelots(NewOcelots),indocelotsteps(NewOcelotList),otters(NewOtters),multilinearotters(NewMLOtters),ottersnested(NewOttersNested),ottersteps(NewOtterSteps),otterjumps(NewOtterJumps),otterproofs(NewOtterProofs),otterdiffs(NewOtterDiffs)], Inputs9, NewInputs),!.
update_otters(_,_,_,_,_,_,_, Inputs, Inputs). 

update_ocelots(Num, Leaps, Inputs, NewInputs) :-
     member(ocelots(Ocelots), Inputs), ground(Leaps), 
     member(ocelotsteps(OcelotSteps), Inputs), member(indocelotsteps(OcelotList), Inputs), !, 
     NewOcelots is Ocelots + 1,
     % NewOcelotSteps is OcelotSteps + Leaps,
     simplify_expression(OcelotSteps + Leaps, NewOcelotSteps), 
     update_ind_ocelots(Num, Leaps, OcelotList, NewOcelotList),
     delete(Inputs, ocelots(Ocelots), Inputs1), 
     delete(Inputs1, ocelotsteps(OcelotSteps), Inputs2),
     delete(Inputs2, indocelotsteps(OcelotList), Inputs3), 
     append([ocelots(NewOcelots),ocelotsteps(NewOcelotSteps),indocelotsteps(NewOcelotList)], Inputs3, NewInputs).
update_ocelots(_Num, _Leaps, Inputs, NewInputs) :-
     member(ocelots(Ocelots), Inputs), 
     member(ocelotproofs(OcelotProofs), Inputs), !, 
     NewOcelots is Ocelots + 1,
     NewOcelotProofs is OcelotProofs + 1, 
     delete(Inputs, ocelots(Ocelots), Inputs1), 
     delete(Inputs1, ocelotproofs(OcelotProofs), Inputs2), 
     append([ocelots(NewOcelots),ocelotproofs(NewOcelotProofs)], Inputs2, NewInputs).
update_ocelots(_, _, Inputs, Inputs).

update_progreg(Used, OldInputs, NewInputs):-
    Used = otter(Progs, Regs), !, member(ottercounts(CurrProgs, CurrRegs), OldInputs), delete(OldInputs, ottercounts(CurrProgs, CurrRegs), TempInputs), update_progregmax(CurrProgs, CurrRegs, Progs, Regs, NewProgs, NewRegs), append([ottercounts(NewProgs, NewRegs)], TempInputs, NewInputs). 
update_progreg(Used, Inputs, Inputs):- Used \== otter(_,_), !.

update_progregmax(CurrProgs, CurrRegs, Progs, Regs, NewP, NewR) :- NewP is max(CurrProgs, Progs), NewR is max(CurrRegs, Regs). 

update_ind_ocelots(Num, Leaps, OcelotList, NewOcelotList) :-
    member(o(Num, Times, Ocelots), OcelotList), !, % ocelot has been used before, so add this to the sum so far for it.
    % NewOcelots is Ocelots + Leaps,
    simplify_expression(Ocelots + Leaps, NewOcelots), 
    NewTimes is Times + 1, 
    delete(OcelotList, o(Num, Times, Ocelots), NOcelotList),
    append([o(Num, NewTimes, NewOcelots)], NOcelotList, NewOcelotList). 
update_ind_ocelots(Num, Leaps, OcelotList, NewOcelotList) :-
    % \+ member(o(Num, _Times, _Ocelots), OcelotList), !, % ocelot has not been used before, so add this as the initial sum.
    append([o(Num, 1, Leaps)], OcelotList, NewOcelotList). 

update_lemmas(Lemma, Inputs, NewInputs) :-
    member(lemmas(OldLemmas), Inputs), delete(Inputs, lemmas(OldLemmas), Inputs1),
    append([Lemma], OldLemmas, NewLemmas), append([lemmas(NewLemmas)], Inputs1, NewInputs). 

update_pos(Mode, Inputs, _Dir, Num, Inputs1) :-
      \+ member(Mode, [naive]), member(pos(Current), Inputs), !, 
      delete(Inputs, pos(Current), Is),
      simplify_expression(Current + Num, NewCurrent), % format("% NewCurrent is ", []), writeln(NewCurrent), 
      append([pos(NewCurrent)], Is, Inputs1). 
update_pos(_Mode, Inputs, Dir, _Num, Inputs1) :-
      member(pos(Current), Inputs), !, % member(Mode, [naive]), 
      delete(Inputs, pos(Current), Is),
      set_new_current(Current, Dir, 1, NewCurrent), 
      append([pos(NewCurrent)], Is, Inputs1). 
update_pos(Inputs, _Dir, _Num, Inputs).

update_machine(M, _Hops, Transition, NewM, new) :-
    M = machine(Trans, Macro, Ocelots),
    new_otter(Transition, Ocelots), !, 
    length(Ocelots, L), L1 is L+1,
    append(Ocelots, [o(L1,Transition)], NewOcelots),
    NewM = machine(Trans, Macro, NewOcelots). 
update_machine(M, Hops, _Transition, M, old) :- format("% Otter transition found at ~k not added due to being previously known~n", [Hops]). % Transition = o(Num, _), display_otters([Transition], Num). 

new_otter(_Transition, []).
new_otter(o(_Num, too_hard), _) :- fail. % !!!
new_otter(Transition, Ocelots) :-
    Ocelots \== [], Transition = oo(Initial, _Diffs, _, _, _, _, _, _, _),
    \+ ( member(o(_Num, Ocelot), Ocelots), Ocelot = oo(Initial1, _Diffs1, _, _, _, _, _, _, _), same_otter_config(Initial1, Initial) ). 

trim_diffs(Config, Diffs, Trim) :-
    Config = config(Left, _State, _Item, _Dir, Right),
    Diffs = diffs(LDiffs, ItemDiff, RDiffs),
    trim_diffs1(Left, LDiffs, TrimLDiffs),
    trim_diffs1(Right, RDiffs, TrimRDiffs),
    Trim = diffs(TrimLDiffs, ItemDiff, TrimRDiffs). 

trim_diffs1(Tape, Diffs, TrimDiffs) :- length(Tape, L), length(Diffs, D), L =< D, !, append(TrimDiffs, _, Diffs), length(TrimDiffs, L). % Get first L elements of Diffs
trim_diffs1(_Tape, Diffs, Diffs) :-     !. % Otherwise, get all the Diffs. This case is for padding. 

set_new_current(Current, l, Leap, NewCurrent) :- !, simplify_expression(Current - Leap, NewCurrent). 
set_new_current(Current, r, Leap, NewCurrent) :- !, simplify_expression(Current + Leap, NewCurrent).

otters_in_machine(M, Number) :- M = machine(_, _, Otters), length(Otters, Number). 

output_status(M, Config, Mode, Hops, Inputs, NewInputs, Used) :-  yes_to_output(Config, Hops, Inputs, NewInputs), !, output_config(M, Config, Mode, Hops, NewInputs, Used), nl, flush_output. 
output_status(_M, _Config, _Mode, _Hops, Inputs, Inputs, _Used).

yes_to_output(_Config, _Hops, Inputs, Inputs) :- member(trace, Inputs),!.
yes_to_output(Config, _Hops, Inputs, Inputs)  :- member(watch(State), Inputs), Config = config(_Left, State, _Item, _Dir, _Right), !. 
yes_to_output(Config, _Hops, Inputs, Inputs)  :- member(watch(State, Item), Inputs), Config = config(_Left, State, Item, _Dir, _Right), !. 
yes_to_output(Config, _Hops, Inputs, Inputs)  :- member(match(Pattern), Inputs), match_config(Pattern, Config), !. 
yes_to_output(_Config, Hops, Inputs, Inputs)  :- member(trace(Number), Inputs), Hops >= Number, !.
yes_to_output(Config, _Hops, Inputs, Inputs)  :- member(rend, Inputs), Config = config(_Left, _State, _Item, _Dir, []), !. 
yes_to_output(Config, _Hops, Inputs, Inputs) :-  member(lend, Inputs), Config = config([], _State, _Item, _Dir, _Right), !. 
yes_to_output(_Config, Hops, Inputs, NewInputs) :- member(over(Number), Inputs), Hops >= Number, !, delete(Inputs, over(Number), Inputs1), member(every(Every), Inputs1), NewOver is Number + Every, append([over(NewOver)], Inputs1, NewInputs).  

output_config(M, Config, Mode, Hops, Inputs, Used) :- member(flatout, Inputs), flatten(Config, FlatConfig), output_config1(FlatConfig, Mode, Hops, Inputs, Used), output_nonzeroes(M, FlatConfig).
output_config(_M, Config, Mode, Hops, Inputs, Used) :- output_config1(Config, Mode, Hops, Inputs, Used).

output_config1(Config, Mode, Hops, Inputs, Used) :-
      Config = config(Left, State, Item, Dir, Right), !,
      count_ones(Config, Ones), member(pos(Pos), Inputs), member(variable_names(Names), Inputs),
      ( member(starttime(T1), Inputs) -> Time = T1; Time = 0 ), 
      prettyprint(Names, State, Left, Item, Dir, Pos, Mode, Right, Hops, Ones, Used, Time),
      ( member(shapeout, Inputs) -> (extract_shape(Config, Shape), format(" Shape: ", []), display_config(Shape, normal, []) ) ; true ), 
      !.

output_nonzeroes(M, Config) :- count_nonzeroes(M, Config, Profile), format("	Profile ", []), output_nonzeroes1(Profile). 

output_nonzeroes1([]).
output_nonzeroes1([count(I,Num)|Rest]) :- format("#~d: ~d ", [I, Num]), output_nonzeroes1(Rest). 

count_nonzeroes(M,config(Left, _State, Item, _Dir, Right), Profile) :-
     number_of_symbols(M, N), 
     initialise_counts(N, Counts0), 
     count_nonzeroes1(N, Left, Counts0, Counts1), count_nonzeroes1(N, [Item], Counts1, Counts2), count_nonzeroes1(N, Right, Counts2, Counts3), 
     Profile = Counts3.

count_nonzeroes1(_, [], Counts, Counts).
count_nonzeroes1(N, [Item|Rest], Counts, NewCounts)       :- is_blank(Item), !, count_nonzeroes1(N, Rest, Counts, NewCounts).
count_nonzeroes1(N, [Item|Rest], Counts, NewCounts)       :- is_input(Item), !, count_item(Item, Counts, Counts1), count_nonzeroes1(N, Rest, Counts1, NewCounts). 
count_nonzeroes1(N, [grp(I,Num)|Rest], Counts, NewCounts) :- initialise_counts(N, Initial), count_nonzeroes1(N, I, Initial, Count1), multiply_counts(Num, Count1, Count2), add_counts(Counts, Count2, Counts3), count_nonzeroes1(N, Rest, Counts3, NewCounts).

count_item(Item, Counts, NewCounts) :- member(count(Item, Count), Counts), delete(Counts, count(Item, Count), Counts1), NewCount is Count + 1, append([count(Item, NewCount)], Counts1, NewCounts).

multiply_counts(_N, [], []).
multiply_counts(N, [count(I,Num)|Rest], [count(I,NewNum)|Result]) :- NewNum is N*Num, multiply_counts(N, Rest, Result). 

add_counts([], Counts, Counts). 
add_counts([count(I,Num)|Rest], Counts, NewCounts) :- add_counts1(I, Num, Counts, Counts1), add_counts(Rest, Counts1, NewCounts). 

add_counts1(I, Num, Counts, NewCounts) :- member(count(I,N), Counts), delete(Counts, count(I,N), Counts2), NewN is N+Num, append([count(I,NewN)], Counts2, NewCounts). 

initialise_counts(2, [count(0,0),count(1,0)]).
initialise_counts(N, Counts) :- N > 2, !, N1 is N-1, initialise_counts(N1, Counts1), append(Counts1, [count(N1,0)], Counts). 

display_config(config(Left, State, Item, Dir, Right), Mode, Names) :-
     % (Names1 = [] -> (term_variables(config(Left, State, Item, Dir, Right), Vs), name_variables(normal, 1, Vs, [], Names)) ; Names = Names1 ), 
     reverse(Left, RevLeft),
     pprint(Names, Mode, RevLeft), ttyflush, format("{~k}", [State]), ttyflush, pprint(Names, Mode, [Item]), ttyflush, format("{~k}", [Dir]), ttyflush, pprint(Names, Mode, Right), true. 

new_leftify(Tape, Left) :- reverse(Tape, Rev), reverse_items(Rev, Temp), reverse(Temp, Left). 

reverse_items([], []).
reverse_items([Item|Rest], [Item|Result]) :- is_input(Item), reverse_items(Rest, Result).
reverse_items([Item|Rest], [grp(RevI,Number)|Result]) :- Item = grp(I,Number), reverse(I, RevI), reverse_items(Rest, Result).

display_trans([]) :- format("% No more transitions~n", []).
display_trans([Trans|Rest]) :-
      Trans = trans(State, In, InDir, NewState, Out, OutDir, Steps),
      format("% Trans: ~k ", [State]), display_item(In), format(" ~k -> ~k ", [InDir,NewState]), display_item(Out), format(" ~k Steps: ~d~n", [OutDir,Steps]),
      display_trans(Rest). 

display_otters([], _).
display_otters([Otter|Rest], N) :-
       Otter = o(ONum, oo(InitConfig, Diffs, FinalConfig, constraints(Mins,Mods), Leaps, Moves, Names, Hops, Transitions)), !, 
       Mins = mins(_X, Xmin, _Y, Ymin),
       % format("Classifying Diffs ", []), writeln(Diffs), 
       classify_otter_diffs(Diffs, Linear), 
       format("Otter ~d (~k): ", [ONum,Linear]), ttyflush, display_config(InitConfig, normal, Names), ttyflush, 
       format(" ++> ", []), display_config(FinalConfig, normal, Names), ttyflush,
       format(" Found: ", []),  print_bignum(Hops), ttyflush, 
       format(" Diffs: ~k", [Diffs]), ttyflush, 
       format(" Mins Xs: ~k Ys: ~k", [Xmin,Ymin]),
       format(" Mods ", []), write_term(Mods, [variable_names(Names)]), 
       display_leaps(Leaps, Names), display_moves(Moves, Names), format(" Trans: ", []), writeln(Transitions),
       N1 is N+1, 
       display_otters(Rest, N1).
display_otters([Otter|Rest], N) :-
       Otter = o(ONum, too_hard), !, 
       format("Otter ~d: Too hard to work out!~n", [ONum]), ttyflush, 
       N1 is N+1, 
       display_otters(Rest, N1).

display_first_otter([]). 
display_first_otter(Otters) :-
    Otters \= [], 
    extract_first_hops(Otters, Firsts), sort(Firsts, SFirsts), SFirsts = [FirstOne|_], 
    format("First otter detected starting at ~k~n", [FirstOne]). 

extract_first_hops([], []).
extract_first_hops([Otter|Rest], [Hops|RestFirsts]) :-
    Otter = o(_, oo(_InitConfig, _Diffs, _FinalConfig, _Constraints, _Leaps, _Moves, _Names, Hops, _Transitions)), !, 
    extract_first_hops(Rest, RestFirsts). 
extract_first_hops([Otter|Rest], [too_hard|RestFirsts]) :-
    Otter = o(_, too_hard), !, 
    extract_first_hops(Rest, RestFirsts). 

classify_otter_diffs(Diffs, multi) :- Diffs = diffs(LDiffs, ItemDiff, RDiffs), append(LDiffs, [ItemDiff], Temp), append(Temp, RDiffs, AllDiffs), member(m(K,_N), AllDiffs), K > 1, !.
classify_otter_diffs(_Diffs, uni). 

display_leaps(Leaps, _Names) :- ground(Leaps), !, L is Leaps, format(" in ~d steps", [L]).  
display_leaps(Leaps, Names) :- format(" in ", []), write_term(Leaps, [numbervars(true), variable_names(Names)]), format(" steps", []). 

display_moves(Moves, _Names) :- ground(Moves), !, M is Moves, format(" movement ~d", [M]).  
display_moves(Moves, Names) :- format(" movement ", []), write_term(Moves, [numbervars(true), variable_names(Names)]).

display_item([]).
display_item([A|Rest]) :- display(A), display_item(Rest).

count_ones(config(Left, _State, Item, _Dir, Right), Ones) :- count_ones1(Left, C1), count_ones1([Item], C2), count_ones1(Right, C3), Ones is C1 + C2 + C3. 
count_ones1([], 0).
count_ones1([Item|Rest], Count) :- is_blank(Item), !, count_ones1(Rest, Count).
count_ones1([Item|Rest], Count) :- is_input(Item), !, count_ones1(Rest, Count1), Count is Count1 + 1. 
count_ones1([grp(I,N)|Rest], Count) :- integer(N), !, count_ones1(I, C), count_ones1(Rest, Count1), Count is Count1 + N*C. 
count_ones1([grp(_I,_N)|Rest], Count1) :- count_ones1(Rest, Count1).

% Compression

set_rotation(Inputs, rotate) :- member(rotate, Inputs), !.
set_rotation(_, plain).

compression(CMode, Config, Inputs, NewConfig) :- member(compress, Inputs), !, compress_config(CMode, Config, NewConfig), !.
compression(_CMode, Config, _Inputs, Config) :- !. 

compress_config(Mode, config(Left, State, Item, l, Right), config(NewLeft, State, NewItem, l, NewRight)) :-
       new_leftify(Left, NLeft), compresstape(Mode, NLeft, NLeft2),  new_leftify(NLeft2, NewLeft), 
       compresstape(Mode, [Item|Right], NRight), !, 
       append([NewItem], NewRight, NRight).

compress_config(Mode, config(Left, State, Item, r, Right), config(NewLeft, State, NewItem, r, NewRight)) :-
       new_leftify([Item|Left], NLeft), compresstape(Mode, NLeft, NLeft2), new_leftify(NLeft2, NLeft1), 
       append([NewItem], NewLeft, NLeft1), 
       compresstape(Mode, Right, NewRight), !. 

compresstape(Mode, Tape, NewTape) :-
    	new_squish_tape(Tape, Tape1), !, squash_tape(Tape1, Tape2), !, merge_tape(Tape2, Tape3), !,
	(Mode = rotate -> rotate_to_smaller(Tape3, Tape4); Tape4 = Tape3), 
        NewTape = Tape4.

rotate_to_smaller([], []).
rotate_to_smaller(Tape, Tape) :- ground(Tape), !. 
rotate_to_smaller(Tape, Tape2) :- \+ ground(Tape), length(Tape, N), rotate(Tape, Tape2), length(Tape2, L), L < N.
rotate_to_smaller(Tape, Tape) :- !. % All smaller rotations found by now, so nothing to do.

% rotate(Tape, Tape).
rotate(Tape, Tape) :- ground(Tape). 
rotate(Tape, NewTape) :- \+ ground(Tape), rotation([], Tape, Tape1), new_squish_tape(Tape1, Tape2), squash_tape(Tape2,Tape3), merge_tape(Tape3, Tape4), NewTape = Tape4. 

rotation(Previous, [], Previous).
rotation(Previous, [grp(I,N)|Rest], Result) :-
    length(I, 1), !, % No point unless I is at least length 2 ... 
    append(Previous, [grp(I,N)], NewPrevious), 
    rotation(NewPrevious, Rest, Result). 
rotation(Previous, [grp(I,N)|Rest], Result) :-
    length(I, M), M > 1, ground(N), !, % 1 is N,  !, % Also no point if N is 1 ... 
    append(Previous, [grp(I,N)], NewPrevious), 
    rotation(NewPrevious, Rest, Result). 
rotation(Previous, [grp(I,N)|Rest], Result) :-
     length(I, M), M > 1, \+ ground(N), % \+ (ground(N), 1 is N), % allow 'no change' case here
     % append(I1, I2, I), length(I1, N1), length(I2, N2), N1 > 0, N2 > 0, % So it is a 'real' split ...
     append(Previous, [grp(I,N)], NewPrevious), 
     rotation(NewPrevious, Rest, Result). 
rotation(Previous, [grp(I,N)|Rest], Result) :-
    length(I, M), M > 1, \+ ground(N), % \+ (ground(N), 1 is N), 
    append(I1, I2, I), length(I1, N1), length(I2, N2), N1 > 0, N2 > 0, % So it is a 'real' split ...
    append(I2, I1, NewI), simplify_expression(N-1, NewN), % NewN = N - 1, 
    append(Previous, [grp(I1,1),grp(NewI, NewN),grp(I2,1)], NewPrevious), 
    rotation(NewPrevious, Rest, Result). 

merge_tape(Tape, Tape) :- length(Tape, N), N < 2, !. 
merge_tape([Item|Rest], Result) :-
        length([Item|Rest], N), N >= 2, 
	Item = grp(I,N1),
	Rest = [Item2|Rest2],
	Item2 = grp(I,N2), !,
	simplify_expression(N1+N2, NewN), 
	merge_tape([grp(I,NewN)|Rest2], Result). 
merge_tape([Item|Rest], [Item|Result]) :-
        length([Item|Rest], N), N >= 2,
	Item = grp(I,_N1),
	Rest = [Item2|Rest2],
	% ( Item2 \== grp(I,_); ( Item2 = grp(I,N2), \+ ( ground(N1), ground(N2) ) ) ), !,
	Item2 \== grp(I,_), !, 
	merge_tape([Item2|Rest2], Result  ). 

squash_tape([], []) :- !. 
squash_tape([Item|Rest], [NewItem|Result]) :- squash_item(Item, NewItem), !, squash_tape(Rest, Result). 

squash_item(grp(I,Num), grp(L, NewNum)) :-  ground(Num), squash(I, K, L), !, NewNum is K*Num. 
squash_item(grp(I,Num), grp(L, NewNum)) :-  squash(I, K, L), !, NewNum = K*Num. % \+ ground(Num)
squash_item(grp(I,Num), grp(I, Num)). % Assume other cases failed ... 
	
% squash(List, K, NewList)
% Can squash List into K copies of NewList. So squash([1,1,1], 3, [1]) and squash([0,1,0,1], 2, [0,1]) both hold. 

safe_squash(List, K, NewList) :- squash(List, K, NewList), !.
safe_squash(List, 1, List). % Only if previous case failed ... 

squash(List, K, NewList) :-
      length(List, N), N > 1, % can't squash anything smaller
      sublists(N, NList), member(M, NList),
      all_sublists_same(List, M, NewList),
      K is N // M, !. 

all_sublists_same(List, M, One) :- split(List, M, [One|Rest]), all_same(One, Rest).

split(List, M, [List]) :-  length(List, N), N =< M, !. 
split(List, M, [First|Lists]) :-  !, append(First, Rest, List), length(First, M), split(Rest, M, Lists). 

all_same(One, [One]) :- !. 
all_same(One, Rest) :- length(Rest, N), N > 1, Rest = [First|Others], One == First, all_same(One, Others).

% sublists(N,M)
% For a list of length N, consider only sublists of length M. There are more compact ways to do this, but this keeps it simple!
% 30 is probably excessive ... 
sublists(2,[1]).
sublists(3,[1]).
sublists(4,[1,2]).
sublists(5,[1]).
sublists(6,[1,2,3]).
sublists(7,[1]).
sublists(8,[1,2,4]).
sublists(9,[1,3]).
sublists(10,[1,2,5]).
sublists(11,[1]).
sublists(12,[1,2,3,4,6]).
sublists(13,[1]).
sublists(14,[1,2,7]).
sublists(15,[1,3,5]).
sublists(16,[1,2,4,8]).
sublists(17,[1]).
sublists(18,[1,2,3,6,9]).
sublists(19,[1]).
sublists(20,[1,2,4,5,10]).
sublists(21,[1,3,7]).
sublists(22,[1,2,11]).
sublists(23,[1]).
sublists(24,[1,2,3,4,6,8,12]).
sublists(25,[1,5]).
sublists(26,[1,2,13]).
sublists(27,[1,3,9]).
sublists(28,[1,2,4,7,14]).
sublists(29,[1]).
sublists(30,[1,2,3,5,6,10,15]).

new_squish_tape([], []) :- !. 
new_squish_tape(Tape, Tape) :- length(Tape, 1), Tape = [grp(I,N)], ground(N), I \== [], N1 is N, N1 > 0, !. 
new_squish_tape(Tape, Tape) :- length(Tape, 1), Tape = [grp(I,N)], variable(N), I \== [], !. 
new_squish_tape(Tape, Result) :-
    length(Tape, N), N > 1, !, 
    purify_tape(Tape, Tape1), dominants(Tape1, Dominants), squish_to_dominants(Dominants, Tape1, Tape2), squish_rest(Tape2, Tape3), Result = Tape3. 

squish_after_dominants([], []) :- !.
squish_after_dominants(Tape, Tape) :- length(Tape,1), !. 
squish_after_dominants(Tape, NewTape) :- 
    % length(Tape, N), N > 1,
    Tape = [Item|_Rest], Item = grp(_I,Num), ground(Num),
    % Find appropriate pattern, if any ...   %% Sort out this case for variables ... 
    pattern_size(Size),
    next_items(Size, Tape, List1, Rest1, [ground]),  
    next_items(Size, Rest1, List2, Rest2, [ground]), 
    next_items(Size, Rest2, List3, _Rest3, [ground]), 
    List1 == List2, List2 == List3, !, 
    squish_to_pattern(grp(List1,0), Rest2, List1, grp(List1, Extra), NewRest), %% What about variables??
    squish_after_dominants(NewRest, NewSquish), !, simplify_expression(Extra+2, NewN), append([grp(List1,NewN)], NewSquish, NewTape).

squish_after_dominants(Tape, NewTape) :- 
    % length(Tape, N), N > 1,
    Tape = [Item|Rest], squish_after_dominants(Rest, NewSquish), append([Item], NewSquish, NewTape), !.

squish_rest(Tape, NewTape) :- predominants(Tape, [], Prev, Post), squish_after_dominants(Prev, NewPrev), squish_next(NewPrev, Post, NewTape).

squish_next(Prev, [], Prev).
squish_next(Prev, [Item|Rest], Result) :- append(Prev, [Item], NewPrev), squish_rest(Rest, RestResult), append(NewPrev, RestResult, Result). 

% predominants(Dominants, Tape, PreDom, Rest)
% Divide Tape into PreDom, part before any Dominants, and then the Rest.
predominants([], SoFar, SoFar, []).
predominants([Item|Tape], SoFar, SoFar, [Item|Tape]) :- dominant_item(Item, _), !. % SoFar is what we want, Rest is [Item|Tape]
predominants([Item|Tape], SoFar, PreDom, Rest) :- append(SoFar, [Item], NewSoFar), predominants(Tape, NewSoFar, PreDom, Rest). 
    
purify_tape([], []) :- !. 
purify_tape(Tape, Result) :- Tape = [Item|Rest], Item = grp([], _N), purify_tape(Rest, Result), !. 
purify_tape(Tape, Result) :- Tape = [Item|Rest], Item = grp(_I, N), ground(N), 0 is N, purify_tape(Rest, Result), !. 
purify_tape(Tape, [Item|Result]) :- Tape = [Item|Rest], purify_tape(Rest, Result). % Item = grp(I,N), I \== [], \+ (ground(N), 0 is N), 

squish_to_dominants(_, [], []) :- !. 
squish_to_dominants([], Tape, Tape) :- !.
squish_to_dominants([Dominant|Rest], Tape, NewTape) :- squish_to_dominant(Dominant, Tape, Tape1), squish_to_dominants(Rest, Tape1, NewTape).

squish_to_dominant(_, [], []). 
squish_to_dominant(Dominant, Tape, NewTape) :-
        length(Dominant, Size),
	next_items(Size, Tape, I2, Rest1, [ground]),
	I2 == Dominant, dominant_free(Size, Tape), % no dominants in next Size symbols on Tape
	squish_to_pattern(grp(Dominant,1), Rest1, Dominant, grp(Dominant, NewN), NewRest), %% What about variables??
	append([grp(Dominant,NewN)], NewRest, NewTape), !.
squish_to_dominant(Dominant, Tape, NewTape) :- 
	Tape = [grp(Dominant,Number)|Rest], nonground(Number, _), !, 
	squish_to_pattern(grp(Dominant,Number), Rest, Dominant, grp(Dominant, NewN), NewRest),
	append([grp(Dominant,NewN)], NewRest, NewTape), !.
% Give up and move on .... 
squish_to_dominant(Dominant, Tape, [Item|NewTape]) :- 
        Tape = [Item|Rest], !,
	squish_to_dominant(Dominant, Rest, NewTape). 

rotation_base(I, I). 
rotation_base(I, Rot) :- length(I, L), L > 1, rotation_base1(I, Rot).

rotation_base1(I, RotI) :- append(I1, I2, I), length(I1, L1), length(I2, L2), L1 > 0, L2 > 0, append(I2,I1,RotI).

dominant_free(_Size, []).
dominant_free(Size, [Item|_]) :- \+ dominant_item(Item, _), Item = grp(I, N), length(I, L), Size =< L*N, !. % If this is a dominant, then fail. So we only get further if this is ground. % Item covers the next Size items, and it is not dominant, so done. 
dominant_free(Size, [Item|Rest]) :- \+ dominant_item(Item, _), Item = grp(I, N), length(I, L), NewSize is Size - L*N, dominant_free(NewSize, Rest). % Need to check further in ... % Size > L*N
        
pattern_size(N) :- between(1,30,N). % May need more? 

dominants([], []).
dominants([Item|Rest], [Pattern|Dominants]) :- dominant_item(Item, Pattern), dominants(Rest, Dominants). 
dominants([Item|Rest], Dominants) :- \+ dominant_item(Item, _),  dominants(Rest, Dominants). 

dominant_item(Item, I) :- Item = grp(I, Number), ground(Number), N1 is Number, N1 > 20, !. % Experiment with this value ...
dominant_item(Item, I) :- Item = grp(I, N), variable(N). % ???

squish_to_pattern(grp(Pattern,Number), Tape, Pattern, Item, NewTape) :-
    Tape = [grp(Pattern, N)|Rest], % nonground(N,_), % I \== Pattern, 
    simplify_expression(Number+N, N1), !, 
    squish_to_pattern(grp(Pattern,N1), Rest, Pattern, Item, NewTape). 
squish_to_pattern(grp(Pattern,Number), Tape, Pattern, Item, NewTape) :-
    Tape = [grp(_I, N)|_Rest], ground(N), % I \== Pattern, 
    length(Pattern, L), 
    next_items(L, Tape, List, NTape, [ground]),
    List == Pattern, % keep going --- need to differentitate here between ground and variables.
    simplify_expression(Number+1, N1), !, 
    squish_to_pattern(grp(Pattern,N1), NTape, Pattern, Item, NewTape). 
squish_to_pattern(SoFar, Tape, _Pattern, SoFar, Tape) :- !. % time to stop, including when there is a variable (and hence next_items fails ... 

next_items(_, [], [], [], _).
next_items(N, Tape, List, Rest, Options)  :- Tape = [grp(_I,Number)|Rest1], ground(Number), 0 is Number, !, next_items(N, Rest1, List, Rest, Options), !. 
next_items(N, Tape, List, Rest, _Options) :- Tape = [grp(I,Number)|Rest1],  ground(Number), length(I,L), N =< L, !, append(I1, I2, I), length(I1, N), List = I1, N1 is Number-1, add_item(grp(I,N1), Rest1, T1), add_item(grp(I2,1), T1, T2), Rest = T2, !. 
next_items(N, Tape, List, Rest, Options)  :- Tape = [grp(I,Number)|Rest1], ground(Number), length(I,L), !, NewN is N - L, N1 is Number-1, add_item(grp(I,N1), Rest1, T1),!, next_items(NewN, T1, List2, Rest2, Options), append(I, List2, List), Rest = Rest2. % N > L,
next_items(N, Tape, List, Rest, Options) :-  Tape = [grp(I,Number)|Rest1], variable(Number), \+ member(ground, Options), length(I,L), N =< L, !, append(I1, I2, I), length(I1, N), List = I1, N1 = Number-1, add_item(grp(I,N1), Rest1, T1), add_item(grp(I2,1), T1, T2), Rest = T2. 
next_items(N, Tape, List, Rest, Options) :-  Tape = [grp(I,Number)|Rest1], variable(Number), \+ member(ground, Options), length(I,L), !, NewN is N - L, N1 = Number-1, add_item(grp(I,N1), Rest1, T1), next_items(NewN, T1, List2, Rest2, Options), append(I, List2, List), Rest = Rest2. % N > L

%% This can be simplified ... but needs to allow for variable length padding in the shape computation -- maybe we don't need padding -- just left empty, right empty or neither ... 
padding(Difference, Original, _MinPos, _MaxPos, LDiffs, RDiffs, _Count, _Linear, Original, Original, LDiffs, RDiffs) :-
    % RealDifference #= Difference, ground(RealDifference), 0 is RealDifference, !. %format("No Padding~n", []). This allows for case like X -(X-1).
    Difference == 0, !. %format("No Padding~n", []). This allows for case like X -(X-1). 
padding(Difference, Original, MinPos, MaxPos, LDiffs, RDiffs, Count, _Linear, PaddedOriginal, FinalPaddedOriginal, NewLDiffs, NewRDiffs) :-
    ground(Difference), Difference > 0, !, 
    Original = config(Left, State, Item, Dir, Right),
    tape_lengths(Original, LeftLength, RightLength),
    % format("Inputs are ", []), write(Original), format(" with ", []), write(MinPos), format(" and ", []), write(LeftLength), format(" and ", []), write(MaxPos), format(" and ", []), write(RightLength), nl, 
    % simplify_expression(0 - MinPos - LeftLength,
    % simplify_expression(MaxPos - RightLength, NRight), % Needa more nuance here ... 
    % % set_nright(Dir, Item, MaxPos, RightLength, NRight),

    set_effects(Dir, MaxPos, MinPos, MaxEffect, MinEffect),
    simplify_expression(0 - MinEffect - LeftLength, NLeft),
    simplify_expression(MaxEffect - RightLength, NRight), 
    
    % format(" Padding with ", []), write(NLeft), format(" left and ", []), write(NRight), format(" right~n", []), 
    pad_tape(fixed, NLeft,  Left,  LDiffs, Count, PadLeft,  FinalPadLeft,  NewLDiffs),
    pad_tape(fixed, NRight, Right, RDiffs, Count, PadRight, FinalPadRight, NewRDiffs),
    PaddedOriginal = config(PadLeft, State, Item, Dir, PadRight), % writeln(PaddedOriginal), 
    FinalPaddedOriginal = config(FinalPadLeft, State, Item, Dir, FinalPadRight).

% Need new case for variable length padding for multilinear case ... 

padding(Difference, Original, MinPos, MaxPos, LDiffs, RDiffs, Count, _Linear, PaddedOriginal, FinalPaddedOriginal, NewLDiffs, NewRDiffs) :-
    variable(Difference), !, % Only possible for multilinear case ... 
    Original = config(Left, State, Item, Dir, Right),
    tape_lengths(Original, LeftLength, RightLength),
    % format("Inputs are ", []), write(Original), format(" with ", []), write(MinPos), format(" and ", []), write(LeftLength), format(" and ", []), write(MaxPos), format(" and ", []), write(RightLength), nl, 
    % simplify_expression(0 - MinPos - LeftLength,
    % simplify_expression(MaxPos - RightLength, NRight), % Needa more nuance here ... 
    % % set_nright(Dir, Item, MaxPos, RightLength, NRight),

    set_effects(Dir, MaxPos, MinPos, MaxEffect, MinEffect),
    simplify_expression(0 - MinEffect - LeftLength, NLeft),
    simplify_expression(MaxEffect - RightLength, NRight), 
    
    % format(" Padding with ", []), write(NLeft), format(" left and ", []), write(NRight), format(" right~n", []), 
    pad_tape(variable, NLeft,  Left,  LDiffs, Count, PadLeft,  FinalPadLeft,  NewLDiffs),
    pad_tape(variable, NRight, Right, RDiffs, Count, PadRight, FinalPadRight, NewRDiffs),
    PaddedOriginal = config(PadLeft, State, Item, Dir, PadRight), % writeln(PaddedOriginal), 
    FinalPaddedOriginal = config(FinalPadLeft, State, Item, Dir, FinalPadRight).

% padding(Difference, Original, MinPos, MaxPos, LDiffs, RDiffs, NewOriginal, NewLDiffs, NewRDiffs) :-
%     Difference < 0, !, 
%     ... cross that bridge when we come to it

set_nright(r, _, MaxPos, RightLength, NRight) :- NRight = MaxPos - RightLength. % This was previously everything ... 
set_nright(l, Item, MaxPos, RightLength, NRight) :- Item = grp(_I, N), ground(N), NRight = MaxPos - RightLength.
set_nright(l, Item, MaxPos, RightLength, NRight) :- Item = grp(_I, N), variable(N), NRight = MaxPos + 1 - RightLength. % Or when RightLength is variable? Or when MaxPos is variable?

set_effects(l, MaxPos, MinPos, MaxEffect, MinEffect) :- !, MinEffect = MinPos, simplify_expression(MaxPos+1, MaxEffect).
set_effects(r, MaxPos, MinPos, MaxEffect, MinEffect) :- !, MaxEffect = MaxPos, simplify_expression(MinPos-1, MinEffect).

tape_lengths(Config, LeftLength, RightLength) :-
    Config = config(Left, _State, Item, Dir, Right),
    tape_size(Left, LeftSize), tape_size(Right, RightSize), tape_size([Item], ItemSize),
    config_sum(LeftSize, ItemSize, RightSize, Dir, LeftLength, RightLength).

config_sum(LeftSize, ItemSize, RightSize, l, LeftSize, RightLength) :- simplify_expression(ItemSize + RightSize, RightLength). 
config_sum(LeftSize, ItemSize, RightSize, r, LeftLength, RightSize) :- simplify_expression(ItemSize + LeftSize, LeftLength). 

pad_tape(_, N, Tape, Diffs, _Count, Pad, FinalPad, NewDiffs) :-
    % RealN #= N, ground(RealN), RealN > 0, !,
    ground(N), simplify_expression(N, RealN), ground(RealN), RealN > 0, !,
    inputs(RealN, 0, List), 
    append(Tape, [grp(List,1)], Pad), append(Tape, [blank], FinalPad), append(Diffs, [m(0,0)], NewDiffs). % was grp(List, Count) instead of blank ... 
% May need this for variable length padding .... 
pad_tape(variable, N, Tape, Diffs, _Count, Pad, FinalPad, NewDiffs) :-
    simplify_expression(N, RealN), variable(RealN), copy_term_nat(RealN, CopyN), CopyN #> 0, !,
    append(Tape, [grp([0],RealN)], Pad), append(Tape, [blank], FinalPad), append(Diffs, [m(0,0)], NewDiffs). % New case to add "blank" for padding rather than a specific value. This simplifies multilinear case greatly. Note that blank has relative difference m(0,0). 
pad_tape(_, _N, Tape, Diffs, _Count, Tape, Tape, Diffs).

inputs(0, _, []).
inputs(N, I, [I|Rest]) :- N > 0, !, N1 is N-1, inputs(N1, I, Rest). 

regressor_list(LDiffs, ItemDiff, RDiffs, Regressors) :- append(LDiffs, [ItemDiff], Temp), append(Temp, RDiffs, Diffs), find_regressors(Diffs, Regressors).

find_regressors([], []).
find_regressors([Diff|Diffs], [m(N,K)|Result]) :-   Diff = m(N, K), K < 0, !, find_regressors(Diffs, Result). 
find_regressors([_Diff|Diffs], Result) :-           find_regressors(Diffs, Result). 

regressor_values([], []).
regressor_values([m(_N,K)|Rest], [Value|Result]) :- Value is 0-K, regressor_values(Rest, Result). 

progressor_list(LDiffs, ItemDiff, RDiffs, Progressors) :- append(LDiffs, [ItemDiff], Temp), append(Temp, RDiffs, Diffs), find_progressors(Diffs, Progressors).

find_progressors([], []).
find_progressors([Diff|Diffs], [m(N,K)|Result]) :- Diff = m(N, K), K > 0, !, find_progressors(Diffs, Result).
find_progressors([Diff|Diffs], [m(N,K)|Result]) :- Diff = m(N, K), N > 1, K == 0, !, find_progressors(Diffs, Result). % Weird case! 
find_progressors([Diff|Diffs], Result) :-     Diff = m(N, K), N >= 1, K =< 0, find_progressors(Diffs, Result). 

find_mins(Shape_Computation, Transitions, Names, P, Regressors, machine(_Raw, Extended, _Otter), Xmins, Ymins) :- 
    regressor_values(Regressors, Ymins0),
    make_list(P, 0, Xmins0),
    find_mins1(Shape_Computation, Transitions, Names, Extended, Xmins0, Ymins0, Xmins, Ymins).
    
find_mins1(SC, _, _Names,  _Extended, XminsSoFar, YminsSoFar, XminsSoFar, YminsSoFar) :- length(SC, L), L =< 1,!. % Don't need to check the target as no transition is applied to it. 
find_mins1([Step|Rest], [_Trans|Transitions], Names, Extended, XminsSoFar, YminsSoFar, Xmins, Ymins) :-
    % Only need to check cases where there is a variable and either a normal or otter transition. 
    Step = s(_S, Config, _, _Used),
    Config = config(_, _State, Item, _InDir, __), Item = grp(_I,N), \+ variable(N), !, % So nothing to check here.
    find_mins1(Rest, Transitions, Names, Extended, XminsSoFar, YminsSoFar, Xmins, Ymins).
find_mins1([Step|Rest], [Trans|Transitions], Names, Extended, XminsSoFar, YminsSoFar, Xmins, Ymins) :-
    % Only need to check cases where there is a variable and either a normal or otter transition. 
    Step = s(_S, _Config, _, _Used),
    member(Trans, [expansion, expansion(_), complex(acceleration), init, naive, cycle]), !, % Overkill apart from the first two ... 
    find_mins1(Rest, Transitions, Names, Extended, XminsSoFar, YminsSoFar, Xmins, Ymins).
find_mins1([Step|Rest], [Trans|Transitions], Names, Extended, XminsSoFar, YminsSoFar, Xmins, Ymins) :-
    % Only need to check cases where there is a variable and either a normal or otter transition. 
    Step = s(_S, Config, _, _Used),
    member(Trans, [complex(normal), otter, ocelot, ocelot(_OcelotNum), otter(_OtterNum)]), 
    Config = config(_, _State, Item, _InDir, __), Item = grp(_I,N), variable(N), % So need to check here.
    check_mins(N, Names, XminsSoFar, YminsSoFar, NewXminsSoFar, NewYminsSoFar), 
    find_mins1(Rest, Transitions, Names, Extended, NewXminsSoFar, NewYminsSoFar, Xmins, Ymins).

check_mins(N, Names, XminsSoFar, YminsSoFar, NewXminsSoFar, NewYminsSoFar) :-
    term_variables(N, NVars),  
    term_string(NVars, NString, [variable_names(Names)]), string_compose("[", String, "]", NString), % To work out which variables are involved
    copy_term(N, NNew, _), term_variables(NNew, Variables), constrain_expression(NNew, 1), % Need N to be at least 1 to apply transition ... but this needs to be the expression, not just the variables in it ... 
    minimal_value(String, Variables, XminsSoFar, YminsSoFar, NewXminsSoFar, NewYminsSoFar). 

minimal_value("", _, XminsSoFar, YminsSoFar, XminsSoFar, YminsSoFar). 
minimal_value(String, [V|Variables], XminsSoFar, YminsSoFar, Xmins, Ymins) :-
    variable_name(Name), next_var_name(Name, String, RestString), 
    check_minimum(Name, V, XminsSoFar, YminsSoFar, NewXminsSoFar, NewYminsSoFar),
    minimal_value(RestString, Variables, NewXminsSoFar, NewYminsSoFar, Xmins, Ymins). 

check_minimum_var(V, MinSoFar, NewMin) :- fd_dom(V, Dom) , Dom = Min.._, Min \== inf, NewMin is max(MinSoFar, Min). 
check_minimum_var(V, MinSoFar, NewMin) :- fd_dom(V, Dom) , Dom = Min.._, Min == inf,  NewMin is MinSoFar. 

classify_transition(trans(_State, _I, l, _NewState, _Out, l, _Steps), normal).
classify_transition(trans(_State, _I, r, _NewState, _Out, r, _Steps), normal).
classify_transition(trans(State, _I, l, NewState, _Out, r, _Steps), normal) :- State \= NewState.
classify_transition(trans(State, _I, r, NewState, _Out, l, _Steps), normal) :- State \= NewState. 
classify_transition(trans(State, _I, l, State, _Out, r, _Steps), acceleration).
classify_transition(trans(State, _I, r, State, _Out, l, _Steps), acceleration).

dynamic_config(PaddedOriginal, FinalPaddedOriginal, LDiffs, RDiffs, PaddedDynamic, FinalPaddedDynamic, NewLDiffs, NewRDiffs) :-
    PaddedOriginal = config(Left, State, Item, InDir, Right),
    FinalPaddedOriginal = config(FinalLeft, State, Item, InDir, FinalRight),
    dynamic_tape(Left, LDiffs, DynamicLeft, NewLDiffs), % format("Dynamic 1: ", []), writeln(Left+LDiffs+DynamicLeft+NewLDiffs), 
    dynamic_tape(FinalLeft, LDiffs, DynamicFinalLeft, NewLDiffs), % format("Dynamic 2: ", []), writeln(FinalLeft+LDiffs+DynamicFinalLeft+NewLDiffs), 
    dynamic_tape(Right, RDiffs, DynamicRight, NewRDiffs), % format("Dynamic 3: ", []), writeln(Right+RDiffs+DynamicRight+NewRDiffs), 
    dynamic_tape(FinalRight, RDiffs, DynamicFinalRight, NewRDiffs), % format("Dynamic 4: ", []), writeln(FinalRight+RDiffs+DynamicFinalRight+NewRDiffs), 
    PaddedDynamic = config(DynamicLeft, State, Item, InDir, DynamicRight),
    FinalPaddedDynamic = config(DynamicFinalLeft, State, Item, InDir, DynamicFinalRight).

dynamic_tape(Tape, Diffs, DTape, DDiffs) :-
    reverse(Tape, RevTape),
    reverse(Diffs, RevDiffs),
    dynamic_tape1(RevTape, RevDiffs, RevDTape, RevDDiffs),
    reverse(RevDTape, DTape),
    reverse(RevDDiffs, DDiffs).

dynamic_tape1([], [], [], []).
dynamic_tape1([Item|IRest], [Diff|DRest], [Item|IRest], [Diff|DRest]) :-  dynamic_diff(Diff), !. % dynamic, so stop.
dynamic_tape1([_Item|IRest], [Diff|DRest], TapeResult, DiffsResult) :-    static_diff(Diff), dynamic_tape1(IRest, DRest, TapeResult, DiffsResult). % static, so keep looking for dynamic part

dynamic_diff(Diff) :- \+ static_diff(Diff).

static_diff(m(1,0)).
static_diff(m(0,0)). 

dynamic_static_tape(Tape, Diffs, Dynamic, Static, DDiffs, SDiffs) :-
    dynamic_tape(Tape, Diffs, Dynamic, DDiffs), % Finds minimal prefix of Tape containing all dynamic blocks
    append(Dynamic, Static, Tape),
    append(DDiffs, SDiffs, Diffs). 

final_configuration_new(Original, Count, LDiffs, ItemDiff, RDiffs, MinEffect, MaxEffect, NewOriginal, NewFinal) :-
    Original = config(Left, State, Item, Dir, Right), 
    % format("Config is ", []), writeln(Original), 
    % Need to allow measurement from position 0 right, which depends on Dir
    set_initial_sizes(Dir, Item, LeftSize, RightSize),
    % format("Sizes are ", []), writeln(LeftSize+RightSize), 
    simplify_expression(0 - MinEffect, LeftMax),
    simplify_expression(MaxEffect, RightMax), 

    dynamic_static_tape(Left,  LDiffs, DynamicLeft,  StaticLeft,  DLDiffs, SLDiffs),
    dynamic_static_tape(Right, RDiffs, DynamicRight, StaticRight, DRDiffs, SRDiffs), 

    tape_size(DynamicLeft, DLSize), tape_size(DynamicRight, DRSize), 

    simplify_expression(DLSize + LeftSize,  LSize),
    simplify_expression(DRSize + RightSize, RSize), 
    % format("Trimming left ", []), writeln(Left+LDiffs+LeftSize+LeftMax), 
    trim_or_pad(StaticLeft,  SLDiffs, LSize,  LeftMax,  SLeft,  SLeftDiffs),
    % writeln(RealLeft+RealLDiffs), 
    % format("Trimming right ", []), writeln(Right+RDiffs+RightSize+RightMax), 
    trim_or_pad(StaticRight, SRDiffs, RSize, RightMax, SRight, SRightDiffs),
    % writeln(RealRight+RealRDiffs), 

    append(DynamicLeft,  SLeft,  RealLeft),
    append(DynamicRight, SRight, RealRight), 

    append(DLDiffs, SLeftDiffs,  RealLDiffs),
    append(DRDiffs, SRightDiffs, RealRDiffs), 
    
    NewOriginal = config(RealLeft, State, Item, Dir, RealRight),
    apply_k(NewOriginal, RealLDiffs, ItemDiff, RealRDiffs, Count, NewFinal), !.

% Must not exclude dynamic blocks, even if outside the interval!!  So start at last dynamic block or empty ... 

trim_or_pad([], _, Size, Max, [blank], []) :- \+ exceeds(Size, Max), !. % If Current Size is still strictly less than Max, then add blank. 
trim_or_pad([], _, _Size, _Max, [], []). % Otherwise nothing. 
trim_or_pad([Item|Rest], [Diff|Diffs], Size, Max, [Item|Tape], [Diff|RealDiffs]) :-
    % include Item if it is dynamic or (static and) within LeftMax. Otherwise stop here and omit it and the rest of the tape.
    dynamic_diff(Diff), !,
    item_size(Item, ItemSize), 
    simplify_expression(Size + ItemSize, NewSize),
    trim_or_pad(Rest, Diffs, NewSize, Max, Tape, RealDiffs). 
trim_or_pad([Item|Rest], [Diff|Diffs], Size, Max, [Item|Tape], [Diff|RealDiffs]) :-
    % Diff must be static so check size and include if Max > Size. 
    item_size(Item, ItemSize),
    \+ exceeds(Size, Max), !, % ie not Size >= Max, so Max > Size
    simplify_expression(Size + ItemSize, NewSize),
    trim_or_pad(Rest, Diffs, NewSize, Max, Tape, RealDiffs). 
trim_or_pad([_Item|_Rest], [_Diff|_Diffs], _Size, _Max, [], []) :- !. 
    % Diff must be static and outside maximum, so discard this and anything remaining. 

set_initial_sizes(l, Item, LeftSize, RightSize) :- tape_size([Item], ItemSize), LeftSize = 0, RightSize = ItemSize. 
set_initial_sizes(r, Item, LeftSize, RightSize) :- tape_size([Item], ItemSize), LeftSize = ItemSize, RightSize = 0. 

padding_new(Config, LeftInterval, RealLeft, RightInterval, RealRight, NewConfig) :-
    Config = config(Left, State, Item, Dir, Right),
    pad_new1(LeftInterval, RealLeft, Left, NewLeft), writeln(LeftInterval+RealLeft+NewLeft), 
    pad_new1(RightInterval, RealRight, Right, NewRight), writeln(RightInterval+RealRight+NewRight), 
    NewConfig = config(NewLeft, State, Item, Dir, NewRight).

pad_new1(Interval, Real, Tape, NewTape) :- exceeds(Interval, Real), !, append(Tape, [blank], NewTape).
pad_new1(_Interval, _Real, Tape, Tape).

% % Real #>= Interval means padding. Real #< Interval means no padding. But don't want to influence variables, so need to stuff around with copies. 
% succeeds if T1 >= T2. Fails if T2 < T1. 
exceeds(T1, T2) :- simplify_expression(T1-T2, T), copy_term_nat(T, S), constrain_variables(S, 0), S #>= 0, term_variables(S, Vars), all_unbounded(Vars).

all_unbounded([]).
all_unbounded([V|Vars]) :- fd_dom(V, Dom), Dom = _..sup, !, all_unbounded(Vars). 

apply_k(Config, LDiffs, ItemDiff, RDiffs, K, General_Instance) :-
    Config = config(Left, State, Item, InDir, Right),
    apply_k_tape(Left, LDiffs, K, GILeft), apply_k_tape([Item], [ItemDiff], K, [GIItem]), apply_k_tape(Right, RDiffs, K, GIRight),
    General_Instance = config(GILeft, State, GIItem, InDir, GIRight).

apply_k_tape([], [], _, []).
apply_k_tape([Item|IRest], [Diff|DRest], K, [GI_Item|GIRest]) :-
    Item = grp(I,Num), apply_diff(Diff, Num, K, NewNum), GI_Item = grp(I, NewNum), !,
    apply_k_tape(IRest, DRest, K, GIRest). 
apply_k_tape([blank], _, _, []). % Nothing to add here ... should be the end of the tape after this anyway!

apply_diff(m(M,N), Num, _K, Num)   :- M == 1, N == 0, !.
apply_diff(m(M,N), Num, K, NewNum) :- M == 1, N is 1, !, NewNum = Num + K. % simplify_expression(Num + K, NewNum).  % 
apply_diff(m(M,N), Num, K, NewNum) :- M == 1, N > 1, !, NewNum = Num + N*K. % simplify_expression(Num + N*L, NewNum). % 
apply_diff(m(M,N), Num, K, NewNum) :- M == 1, -1 is N, !, simplify_expression(Num - K, NewNum). % NewNum = Num - K. % perhaps this is overkill ...
apply_diff(m(M,N), Num, K, NewNum) :- M == 1, N < -1, !, NewN is 0-N, NewNum = Num - NewN*K. % simplify_expression(Num - NewN*K, NewNum). % . % perhaps this is overkill ...
apply_diff(m(M,N), Num, K, NewNum) :- N \== 0, !, NewNum = (M^K)*Num + N*(M^K - 1)//(M - 1). 

% set_count(RegMins, RegVars, Regressors, CountSoFar, Count)
% RegMins is the minimum for each regressor, RegVars is the regressive variables, Regressors is the list of regressors
% Returns minimum formula for Count, which will need to be evaluated once the transition is applied. 

set_count([], _, _, CountsSoFar, Count) :- apply_mins(CountsSoFar, Count). 
set_count([Ymin|RestMins], [Y|RestVars], [m(_N,K)|RestRegs], CountsSoFar, Count) :-
    Reg is 0-K, 
    set_count1(Ymin, Y, Reg, CountNext),
    append(CountsSoFar, [CountNext], NewCountsSoFar), 
    set_count(RestMins, RestVars, RestRegs, NewCountsSoFar, Count). 

set_count1(Ymin, Y, Reg, Count) :- 0 is Reg - Ymin, Reg == 1, !, Count = Y. 
set_count1(Ymin, Y, Reg, Count) :- 0 is Reg - Ymin, Reg > 1, !, Count = Y//Reg. 
set_count1(Ymin, Y, Reg, Count) :- Reg == 1, simplify_expression(Y + 1 - Ymin, Count). % Count = Y + 1 - Ymin, Ymin \== Reg.
set_count1(Ymin, Y, Reg, Count) :- simplify_expression(Y + Reg - Ymin, Count1), Count = (Count1)//Reg.  % Ymin \== Reg, Reg > 1. 

apply_mins(List, Count) :- length(List, 1), List = [Count], !. % Only one element, so no minimum required.
apply_mins(List, Count) :- length(List, 2), List = [Count1,Count2], !, Count = min(Count1, Count2). % Exactly two elements.
apply_mins(List, Count) :- List = [Count1|Rest], apply_mins(Rest, Count2), Count = min(Count1, Count2). % More than two elements, so use nested mins.

identify_variables_diffs(Config, LDiffs, ItemDiff, RDiffs, VarDiffs) :-
    Config = config(Left, _State, Item, _Dir, Right),
    vars_diffs([], Left, LDiffs, VarDiffs1),
    vars_diffs(VarDiffs1, [Item], [ItemDiff], VarDiffs2),
    vars_diffs(VarDiffs2, Right, RDiffs, VarDiffs3),
    VarDiffs = VarDiffs3.

vars_diffs(SoFar, [], _, SoFar). % May have more diffs than items ... could "trim" these I guess ...
vars_diffs(SoFar, [Item|Rest], [_Diff|RestDiffs], Result) :-
    Item = grp(_I, N), integer(N), !, % Each item in the original shape is either a single variable or an integer. 
    vars_diffs(SoFar, Rest, RestDiffs, Result). 
vars_diffs(SoFar, [Item|Rest], [Diff|RestDiffs], Result) :-
    Item = grp(_I, N), var(N), !, % Each item in the original shape is either a single variable or an integer.
    append(SoFar, [diff(N, Diff)], NewSoFar), 
    vars_diffs(NewSoFar, Rest, RestDiffs, Result). 

isolate_variables_diffs([], ProgSoFar, ProgSoFar, RegSoFar, RegSoFar).
isolate_variables_diffs([Item|Rest], ProgSoFar, ProgResult, RegSoFar, RegResult) :-
    Item = diff(N, Diff), progressive_diff(Diff),
    append(ProgSoFar, [diff(N, Diff)], NewProgSoFar), 
    isolate_variables_diffs(Rest, NewProgSoFar, ProgResult, RegSoFar, RegResult).
isolate_variables_diffs([Item|Rest], ProgSoFar, ProgResult, RegSoFar, RegResult) :-
    Item = diff(N, Diff), regressive_diff(Diff),
    append(RegSoFar, [diff(N, Diff)], NewRegSoFar), 
    isolate_variables_diffs(Rest, ProgSoFar, ProgResult, NewRegSoFar, RegResult).

progressive_diff(m(K,N)) :- K >= 1, N > 0.
regressive_diff(m(_K,N)) :- N < 0. 

% This needs to know the status and analysis of Hops (ie Coefficients, Terms, Type), whether the otter is unilinear or multilinear, the Count, what the progressive and regressive variables are and their relative differences.
% Get first lot from classify_hops. Get linearity and count as arguments. Need to derive progressive and regressive variables from Original (config) and diffs. 

otter_steps(_Hops, _Coefficients, _Terms, Type, _Linear, Count, _Progressors, _Regressors, OtterSteps) :- Type = constant(C), !, simplify_expression(C*Count, OtterSteps). 
otter_steps(Hops, Coefficients, Terms, Type, Linear, Count, Progressors, Regressors, OtterSteps) :-
    Type = linear(_Variables), Linear = uni, !,
    append(Progressors, Regressors, Vars), 
    assemble_linear_coefficients(Coefficients, Terms, Vars, [], VarList),
    % format("Varlist is ", []), writeln(VarList), 
    sum_up_factors(VarList, 0, Result), prepare_result(Result, NewResult), 
    % simplify_expression(Hops + (Result/2)*(Count-1), Exp),
    % format("Calling simplify with ", []), writeln(Hops+NewResult+Count), 
    simplify_expression(Hops + NewResult*(Count-1), Exp), 
    OtterSteps = Count * Exp. 

% Stick to simple case here. Assume only one variable in Hops and a monoprogressive monoregressive pattern ...
otter_steps(_Hops, Coefficients, Terms, Type, Linear, Count, Progressors, Regressors, OtterSteps) :-
    Type = linear(Variables), Linear = multi, length(Variables, 1), length(Progressors, 1), length(Regressors, 1), !, % As above, single variable in Hops, monoprogressive monoregressive pattern. Assume the Hops is aX+c otherwise it is just the same formula as in unilinear case... aX+bY+c case doesn't seem too hard!
    assemble_linear_coefficients(Coefficients, Terms, Progressors, [], ProgVarList),
    ProgVarList = [coeff(X, A, m(M,N))], % Must have only one element ...
    % RegVarList = [coeff(Y, B, m(1,D))], % Must have only one element ... 
    get_constant(Coefficients, Terms, Constant), 
    M1 is M-1, Exp = M^Count, 
    % OtterSteps = A*X*Exp/M1 + A*N*Exp/(M1*M1) - A*X/M1 + Constant - A*M*N/(M1*M1), !,
    OtterSteps = (A*M1*X*Exp + A*N*Exp - A*M1*X - A*M*N)//(M1*M1) + Constant, !,
    true. 
% Stick to simple case here. Assume only one variable in Hops and a monoprogressive monoregressive pattern ... not sure this one ever occurs!
% otter_steps(Hops, Coefficients, Terms, Type, Linear, Count, Progressors, Regressors, OtterSteps) :- Type = quadratic(Variables), Linear = uni....
% Stick to simple case here. Assume only one variable in Hops and a monoprogressive monoregressive pattern ... need this one

otter_steps(_Hops, Coefficients, Terms, Type, Linear, Count, Progressors, Regressors, OtterSteps) :-
    Type = quadratic(Variables), Linear = multi, length(Variables, 1), length(Progressors, 1), length(Regressors, 1), !, % As above, single variable in Hops, monoprogressive monoregressive pattern. Assume the Hops is aX^2+bXc 
    assemble_quadratic_coefficients(Coefficients, Terms, Progressors, [], ProgVarList),
    % assemble_coefficients(Type, Linear, Coefficients, Terms, [], Regressors, RegVarList),
    ProgVarList = [coeff(X, A, B, m(M,N))], % Must have only one element ...
    get_constant(Coefficients, Terms, Constant), % Hold your breath! :-)

    quadratic_steps(A,B,M,N,X,Constant,Count,OtterSteps), !. 
    
otter_steps(_Hops, Coefficients, Terms, Type, Linear, Count, Progressors, Regressors, OtterSteps) :-
    Type = quadratic(Variables), Linear = multi, length(Variables, 2), length(Progressors, 2), length(Regressors, 1), !, % Case for two progressive variables and monoregressive.
    assemble_quadratic_coefficients(Coefficients, Terms, Progressors, [], ProgVarList),

    ProgVarList = [coeff(X1, A1, B1, m(M1,N1)), coeff(X2, A2, B2, m(M2,N2))], % Must have two elements ... 
    get_constant(Coefficients, Terms, Constant), % Hold your breath! :-)

    quadratic_steps(A1,B1,M1,N1,X1,Constant,Count,OtterSteps1),
    quadratic_steps(A2,B2,M2,N2,X2,0,Count,OtterSteps2), % Only count the constant term once!

    OtterSteps = OtterSteps1 + OtterSteps2, !. % Needs to be "pure" to do this, ie no X1*X2 term, ie easch term has at most one variable. 

% All cases below are too hard! 
otter_steps(_Hops, _Coefficients, _Terms, Type, _Linear, _Count, _Progressors, _Regressors, OtterSteps) :- Type = higher(_Variables), OtterSteps = 0. % !

quadratic_steps(A,B,M,N,X,Constant,Count,Steps) :-
    A == 0, M == 1, !, % Can have linear as part of a quadratic ... see Dragon 142 Otter 3

    T1 = B*X + Constant + (Count-1)*B*N//2, simplify_expression(T1, Temp), 
    Steps = Count * Temp, !. 

quadratic_steps(A,B,M,N,X,Constant,Count,Steps) :-
    M > 1, !, 
    M1 is M-1, Exp2 = M^(2*Count), Exp = M^Count, 

    Test is N/M1, ( integer(Test) -> true; format("% Conjecture failure with N and M-1 as ~k and ~k respectively~n", [N,M1]) ),

    format("% A is ~k, B is ~k, M is ~k, N is ~k~n", [A,B,M,N]), !, 
    
    N1 is A*M1*M1*M1, 
    N2 is 2*A*N*M1*M1, 
    N3 is A*N*N*M1, 

    N5 is (B*M1*M1 - 2*A*N*M1)*(M*M-1), 
    N6 is (B*N*M1 - 2*A*N*N)*(M*M-1), 

    N8 is (A*N*N - B*N*M1 + Constant*M1*M1)*M1*(M*M-1), 
    N4 = N1*X*X + N2*X + N3,
    N7 = N5*X + N6, 

    Denom2 is M1*M1*M1*(M*M-1), 
    OtterSteps9 = ((Exp2-1)*N4 + (Exp-1)*N7 + Count*N8)//Denom2, % It should be an integer, so we can use // to avoid issues with integers larger than floating point can handle ... 
    
    Steps = OtterSteps9, !, 
    true. 


assemble_fraction(Numerator, Denominator, Fraction) :- ground(Denominator), 1 is Denominator, !, Fraction = Numerator.
assemble_fraction(Numerator, Denominator, Fraction) :- Fraction = Numerator/Denominator.

prepare_result(Result, NewResult) :- ground(Result), 0 is Result mod 2, !, NewResult is Result/2.
prepare_result(Result, NewResult) :- NewResult = Result/2.

assemble_linear_coefficients(_Coefficients, _Terms, [], SoFar, SoFar).
assemble_linear_coefficients(Coefficients, Terms, [diff(Var, Diff)|Rest], SoFar, Result) :-
    find_linear_coefficient(Var, Coefficients, Terms, A),
    append(SoFar, [coeff(Var, A, Diff)], NewSoFar), !, 
    assemble_linear_coefficients(Coefficients, Terms, Rest, NewSoFar, Result). 

% We know each term must be a single variable as the pattern is unilinear
find_linear_coefficient(Var, [C|_RestCs], [Term|_RestTs], A) :- Term == [Var], !, A = C.
find_linear_coefficient(Var, [_C|RestCs], [Term|RestTs], A) :-  Term \== [], !, find_linear_coefficient(Var, RestCs, RestTs, A).
find_linear_coefficient(_Var, _, Ts, A):- Ts == [[]], !, A = 0. % If we get to the end, we must have that there is no coefficient in Hops for this variable, so the coefficient is 0. 

find_quadratic_coefficient(Var, [C|_RestCs], [Term|_RestTs], A) :-  Term == [Var,Var], !, A = C.
find_quadratic_coefficient(Var, [_C|RestCs], [Term|RestTs], A) :- Term \== [], !, find_quadratic_coefficient(Var, RestCs, RestTs, A).
find_quadratic_coefficient(_Var, _, Ts, A) :- Ts == [[]], !, A = 0. % If we get to the end, we must have that there is no coefficient in Hops for this variable, so the coefficient is 0. 

sum_up_factors([], Sum, RealSum) :- simplify_expression(Sum, RealSum), !. 
sum_up_factors([Item|Rest], Sum, Result) :-
    Item = coeff(_, A, m(_, N)), !, % unilinear so we know K must be 1 ...
    NewSum = Sum + A*N, % When N < 0, this is the regressive variables, so the same process will hold. 
    sum_up_factors(Rest, NewSum, Result). 

assemble_quadratic_coefficients(_Coefficients, _Terms, [], SoFar, SoFar).
assemble_quadratic_coefficients(Coefficients, Terms, [diff(Var, Diff)|Rest], SoFar, Result) :-
    find_linear_coefficient(Var, Coefficients, Terms, B),
    find_quadratic_coefficient(Var, Coefficients, Terms, A), 
    append(SoFar, [coeff(Var, A, B, Diff)], NewSoFar), !, 
    assemble_quadratic_coefficients(Coefficients, Terms, Rest, NewSoFar, Result).

% Identify the constant term
get_constant([C|_RestCs], [T|_RestTs], Constant) :-  T == [], !, Constant = C. % Found it!
get_constant([_C|RestCs], [_T|RestTs], Constant) :-  get_constant(RestCs, RestTs, Constant). % Not the constant term, so move on. 

divide_vars([], [], []).
divide_vars([V|Vars], [V|PVars], RVars) :-  prog_var(V), divide_vars(Vars, PVars, RVars). 
divide_vars([V|Vars], PVars, [V|RVars]) :-  reg_var(V),  divide_vars(Vars, PVars, RVars). 

prog_var(V) :- prog_vars(_, _,_, L), member(V, L), !.
reg_var(V) :- reg_vars(_, _,_, L), member(V, L), !. 

convert_number(String, Number) :-  string_concat(RealString, "*", String), !, convert_number1(RealString, Number).    % delete trailing "*"
convert_number(String, Number) :-  convert_number1(String, Number).    % if none, just process what is there. 

convert_number1(String, Number) :- String \== "", number_string(Number, String).
convert_number1("", 1). 

% find_b(String, B) :- string_compose(_, "+", BString, String), BString \== "", convert_number(BString, B). 
% find_b("", 0). % Should never have + and then nothing ... 

% % When all A's are 0, OtterSteps is Count * B.
% % Otherwise we find the progressor term P, which is (a1xn1 + a2xn2 + a3xn3)//2, and the variable term V, which his a1X1+a2X2+a3X3 and OtterSteps is then Count * (V + P*Count + B - P)
% set_otter_steps(As, B, _Progressors, _Regressors, _ProgVars, _RegVars, Count, OtterSteps) :-
%      all_zeroes(As), OtterSteps = B * Count.
% set_otter_steps(As, B, Progressors, Regressors, ProgVars, RegVars, Count, OtterSteps) :-
%      \+ all_zeroes(As),
%      sum_term(As, Progressors, Regressors, 0, S), 
%      variable_term(As, ProgVars, RegVars, 0, V),
%      T is B - S,
%      %      OtterSteps = Count * (V + S*Count + T).
%      simplify_expression(V + S*Count + T, E),
%      OtterSteps = Count * E. 
% 
% sum_term([], _, _, SoFar, Result) :- Result is SoFar//2. 
% sum_term([0|RestAs], [_|RestProgressors], Regressors, SoFar, Result) :-
%      !, sum_term(RestAs, RestProgressors, Regressors, SoFar, Result). 
% sum_term([A|RestAs], [Progressor|RestProgressors], Regressors, SoFar, Result) :-
%      A \== 0, Progressor = m(N,K), N == 1, !, % Not sure what happens if N > 1 !!
%      NewSoFar is A*K + SoFar, 
%      sum_term(RestAs, RestProgressors, Regressors, NewSoFar, Result). 
% sum_term([0|RestAs], [], [_Regressor|RestRegressors], SoFar, Result) :-
%      !, sum_term(RestAs, [], RestRegressors, SoFar, Result). 
% sum_term([A|RestAs], [], [Regressor|RestRegressors], SoFar, Result) :-
%      A \== 0, Regressor = m(N,K), N == 1, !, % Not sure what happens if N > 1 !!
%      NewSoFar is A*K + SoFar, 
%      sum_term(RestAs, [], RestRegressors, NewSoFar, Result). 
% 
% variable_term([], _, _, SoFar, SoFar).
% variable_term([0|RestAs], [_|RestProgVars], RegVars, SoFar, Result) :-
%      !, variable_term(RestAs, RestProgVars, RegVars, SoFar, Result). 
% variable_term([A|RestAs], [ProgVar|RestProgVars], RegVars, SoFar, Result) :-
%      A == 1, SoFar == 0, !, 
%      NewSoFar = ProgVar, 
%      variable_term(RestAs, RestProgVars, RegVars, NewSoFar, Result). 
% variable_term([A|RestAs], [ProgVar|RestProgVars], RegVars, SoFar, Result) :-
%      A == 1, !, % SoFar \== 0, 
%      NewSoFar = SoFar + ProgVar, 
%      variable_term(RestAs, RestProgVars, RegVars, NewSoFar, Result). 
% variable_term([A|RestAs], [ProgVar|RestProgVars], RegVars, SoFar, Result) :-
%      SoFar == 0, !, % A > 1
%      NewSoFar = A*ProgVar, 
%      variable_term(RestAs, RestProgVars, RegVars, NewSoFar, Result). 
% variable_term([A|RestAs], [ProgVar|RestProgVars], RegVars, SoFar, Result) :-
%      !, % A > 1, SoFar \== 0, 
%      NewSoFar = SoFar + A*ProgVar, 
%      variable_term(RestAs, RestProgVars, RegVars, NewSoFar, Result). 
% variable_term([0|RestAs], [], [_|RestRegVars], SoFar, Result) :-
%      !, variable_term(RestAs, [], RestRegVars, SoFar, Result). 
% variable_term([A|RestAs],  [], [RegVar|RestRegVars], SoFar, Result) :-
%      A == 1, SoFar == 0, !, 
%      NewSoFar = RegVar, 
%      variable_term(RestAs, [], RestRegVars, NewSoFar, Result). 
% variable_term([A|RestAs],  [], [RegVar|RestRegVars], SoFar, Result) :-
%      A == 1, !, % SoFar \== 0,
%      NewSoFar = SoFar + RegVar,  
%     variable_term(RestAs, [], RestRegVars, NewSoFar, Result). 
% variable_term([A|RestAs],  [], [RegVar|RestRegVars], SoFar, Result) :-
%      SoFar == 0, !, % A > 1, 
%      NewSoFar = A*RegVar, 
%      variable_term(RestAs, [], RestRegVars, NewSoFar, Result). 
% variable_term([A|RestAs],  [], [RegVar|RestRegVars], SoFar, Result) :- 
%      !, % A > 1, SoFar \== 0, 
%      NewSoFar = SoFar + A*RegVar, 
%      variable_term(RestAs, [], RestRegVars, NewSoFar, Result). 
    
all_zeroes([]).
all_zeroes([0|Rest]) :- all_zeroes(Rest). 

% hops_expression("[]", _, "").
% hops_expression(ConstraintString, ExprVars, Expr) :-
%     ConstraintString \== "[]",
%     string_compose("[", Temp1, "]", ConstraintString), % get rid of leading "[" and trailing "]"
%     split_string(Temp1, ",", ",", StringList),
%     member(String, StringList),
%     string_compose("clpfd:(", Temp2, ")", String),
%     string_concat("RealHops#=", Expr0, Temp2), vars_in_string(Expr0, Vars), 
%     mapping_list(ExprVars, Vars, ToList), % Hacky! May need more! Otter found in monster 12 at 113 146 207 gives "RealHops#=4*C+17" for "X1", which crashes convert_value ... 
%     convert_value(Expr0, ToList, Expr).
% 
% vars_in_string(S, Vars) :- string_chars(S, List),  process_vars(List, Vars).
%
% process_vars([], []).
% process_vars([X|Rest], [S|Vars]) :-
%     member(X, ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']), !, 
%     string_chars(S, [X]), process_vars(Rest, Vars). 
% process_vars([_X|Rest], Vars) :- process_vars(Rest, Vars). 
% 
% mapping_list([], _, []).
% mapping_list([V1|Rest], [Next|VarRest], [to(Next,V1)|Result]) :- mapping_list(Rest, VarRest, Result). 

convert_value(ConstraintString, [], ConstraintString). 
convert_value(ConstraintString, [to(From, To)|Conversion], Value) :-
    convert_value1(ConstraintString, to(From, To), NewString),
    convert_value(NewString, Conversion, Value).

convert_value1(String, to(From, To), NewString) :-
    string_compose(S1, From, S2, String),
    string_compose(S1, To, S2, NewString). 

configuration_size(Config, LeftSize, ItemSize, RightSize) :- Config = config(Left, _, Item, _Dir, Right), tape_size(Left, LeftSize), tape_size(Right, RightSize), tape_size([Item], ItemSize).

tape_size([], 0).
tape_size([Item|Rest], Size) :- item_size(Item, ItemSize), tape_size(Rest, RestSize), Size = ItemSize + RestSize. 

item_size(I, 1) :- is_input(I).
item_size(grp(I,_N), 0) :- length(I, 0).
item_size(grp(I,N), Size) :- length(I, L), L > 0, ground(N), Size is L*N. 
item_size(grp(I,N), Size) :- variable(N), length(I, 1), Size = N.
item_size(grp(I,N), Size) :- variable(N), length(I, L), L > 1, Size = L * N. 

constrain_expression(Expression, Min) :- Expression #>= Min. 

% Ensure all variables have the constraint >= Min ...
constrain_variables(Term, _Min) :- ground(Term). 
constrain_variables(Term, Min) :- \+ ground(Term), term_variables(Term, Vars), all_vars(Vars, Min). % Hackers-R-Us ... 

all_vars([], _).
all_vars([X|Rest], Min) :- X #>= Min, all_vars(Rest, Min). % Only when necessary!

find_min_pos([], _Names, MinSoFar, MinSoFar, MinEffectSoFar, MinEffectSoFar).
find_min_pos([s(_, _Config, NewPos, _)|Rest], Names, MinSoFar, MinPos, MinEffectSoFar, MinEffect) :-
    minimum(MinSoFar, NewPos, NewMinSoFar),
    minimum(MinEffectSoFar, NewPos, NewMinEffectSoFar),
    find_min_pos(Rest, Names, NewMinSoFar, MinPos, NewMinEffectSoFar, MinEffect).

find_max_pos([], _Names, MaxSoFar, MaxSoFar, MaxEffectSoFar, MaxEffectSoFar).
find_max_pos([s(_, Config, NewPos, _)|Rest], Names, MaxSoFar, MaxPos, MaxEffectSoFar, MaxEffect) :-
    Config = config(_Left, _State, Item, _Dir, _Right), Item = grp(I,_N), length(I, L),
    set_new_max(NewPos, L, Max),
    maximum(MaxSoFar, NewPos, NewMaxSoFar),
    maximum(MaxEffectSoFar, Max, NewMaxEffectSoFar),
    find_max_pos(Rest, Names, NewMaxSoFar, MaxPos, NewMaxEffectSoFar, MaxEffect).

minimum(X, Y, Min) :- ground(X), ground(Y), Min is min(X,Y), !. 
minimum(X, Y, Min) :- \+ ground(X), ground(Y), Min = X, !. % Variables always exceed constants for this purpose. 
minimum(X, Y, Min) :- ground(X), \+ ground(Y), Min = Y, !. % Variables always exceed constants for this purpose. 
minimum(X, Y, Min) :- copy_term_nat(f(X,Y), f(NewX,NewY)), \+ \+ (NewX #> NewY, constrain_variables(f(NewX,NewY), 0)), !, Min = Y. % Assumes minimum so far is X with both being variable. 
minimum(X,_Y, Min) :- Min = X, !. 

maximum(X, Y, Max) :- ground(X), ground(Y), Max is max(X,Y), !.
maximum(X, Y, Max) :- \+ ground(X), ground(Y), Max = X, !. % Variables always exceed constants for this purpose.
maximum(X, Y, Max) :- ground(X), \+ ground(Y), Max = Y, !. % Variables always exceed constants for this purpose.
maximum(X, Y, Max) :- copy_term_nat(f(X,Y), f(NewX,NewY)), \+ \+ (NewY #> NewX, constrain_variables(f(NewX,NewY), 0)), !, Max = Y. % Assumes maximum so far is X with both being variable. 
maximum(X,_Y, Max) :- Max = X, !. 

neg_position(Pos) :- ground(Pos), P is Pos, P < 0, !. 
neg_position(Pos) :- \+ ground(Pos), termify(Pos, Terms), classify_terms(Terms, Simple, _Complex, _Ground), negatives(Simple). % Don't know how to do complex!

pos_position(Pos) :- ground(Pos), P is Pos, P > 0, !.
pos_position(Pos) :- \+ ground(Pos), termify(Pos, Terms), classify_terms(Terms, Simple, _Complex, _Ground), positives(Simple). % Don't know how to do complex!

negatives([]).
negatives([T|Rest]) :- term_val(T, V), V < 0, negatives(Rest). 

positives([]).
positives([T|Rest]) :- term_val(T, V), V > 0, positives(Rest). 

% Can ignore configurations when Pos is 0. 
separate_shape_computation([], NegSoFar, NegSoFar, PosSoFar, PosSoFar). 
separate_shape_computation([Step|Rest], NegSoFar, NegSC, PosSoFar, PosSC) :-
    Step = s(_, _, Pos, _), neg_position(Pos), !, 
    append(NegSoFar, [Step], NewNegSoFar), separate_shape_computation(Rest, NewNegSoFar, NegSC, PosSoFar, PosSC). 
separate_shape_computation([Step|Rest], NegSoFar, NegSC, PosSoFar, PosSC) :-
    Step = s(_, _, Pos, _), pos_position(Pos),!, 
    append(PosSoFar, [Step], NewPosSoFar), separate_shape_computation(Rest, NegSoFar, NegSC, NewPosSoFar, PosSC).
separate_shape_computation([_Step|Rest], NegSoFar, NegSC, PosSoFar, PosSC) :-
    separate_shape_computation(Rest, NegSoFar, NegSC, PosSoFar, PosSC).    % Steps at 0 are ignored, as are any which are "mixed". Will need to address this case if any arise. 

set_new_max(NewPos, L, NewPos) :- L = 1, !.
set_new_max(NewPos, L, Max) :- L > 1, MaxDiff is L - 1, simplify_expression(NewPos + MaxDiff, Max). 

simplify_transition(oo(Initial, Diffs, Final, Constraints, Steps, Moves, VarNames, Hops, Transitions), oo(Initial, Diffs, NewFinal, Constraints, Steps, Moves, VarNames, Hops, Transitions)) :-
    simplify_config(VarNames, Final, Temp1), simplify_config(VarNames, Temp1, Temp2), remove_zeroes(Temp2, NewFinal). % Has to be a better way!
simplify_transition(too_hard, too_hard).

simplify_config(_Names, Config, SimpleConfig) :-
    Config = config(Left, State, Item, Dir, Right),
    simplify_tape(Left, SimpleLeft),
    simplify_tape([Item], [SimpleItem]),
    simplify_tape(Right, SimpleRight),
    SimpleConfig = config(SimpleLeft, State, SimpleItem, Dir, SimpleRight).

% Simplifies exponents in tape blocks. Could also do some other clean-up if required.
simplify_tape([], []).
simplify_tape([grp(I,N)|Rest], [grp(I,N2)|Result]) :- simplify_expression(N,N2), simplify_tape(Rest, Result). 
 
remove_zeroes(Config, NewConfig) :-
    Config = config(Left, State, Item, Dir, Right),
    remove_zeroes_tape(Left, NewLeft),!, 
    remove_zeroes_tape([Item], NItem), process_item(NItem, NewItem), !, % Need to account for the case when NewItem is []. But don't reconfigure here -- only once the otter has been applied. 
    remove_zeroes_tape(Right, NewRight), !, 
    NewConfig = config(NewLeft, State, NewItem, Dir, NewRight).

process_item([], grp([],0)) :- !.  
process_item([NewItem], NewItem).

remove_zeroes_tape([], []).
remove_zeroes_tape([grp(_I,N)|Rest], Result) :- ground(N), 0 is N, !, remove_zeroes_tape(Rest, Result). % so delete it
remove_zeroes_tape([grp(I,N)|Rest], [grp(I,N)|Result]) :-  remove_zeroes_tape(Rest, Result). 

verify_otter(M, Number, Mode, Config, LDiffs, ItemDiff, RDiffs, Progressors, Regressors, Type, Linear, Hops, Shape_Computation, Otter_Transition) :-
    variable_bound(Linear, VarBound), % format("% Bound done~n", []), %% SHOULD SET DIFFERENT Bounds on Hops and Steps ...
    % writeln(Config+LDiffs+ItemDiff+RDiffs+Progressors+Regressors), 
    set_configs(Config, LDiffs, ItemDiff, RDiffs, InitConfig, FinalConfig, ProgVars, RegVars, ProgVarsInit, RegVarsInit, VarNames), !, % format("Configs done~n", []),
    length(Progressors, Progs), length(Regressors, Regs),
    % format("Searching ... ~n", []), 
    search_for_shape_computation(M, Number, otter, InitConfig, "otter", VarBound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, Type, Linear, Shape_Computation1, VHops, VStatus, VOutputs), !, % format("Search done~n", []), flush_output,
    % format("% VStatus is ~k~n", [VStatus]), 
    ( VStatus = target(_) ->
      ( (generate_transition(M, ProgVars, RegVars, VarNames, LDiffs, ItemDiff, RDiffs, VHops, VOutputs, Shape_Computation1, Number, Hops, Linear, Otter_Transition), Shape_Computation = Shape_Computation1) -> true; (format("% Transition not generated~n", []), Otter_Transition = too_hard) ); true ),
    ( VStatus = modulus(Mods) -> ( reset_diffs(Mods, LDiffs, ItemDiff, RDiffs, NewLDiffs, NewItemDiff, NewRDiffs) ->
				                                                                                    ( format("% Diffs reset to ", []), writeln(NewLDiffs+NewItemDiff+NewRDiffs),
   														      verify_otter(M, Number, Mode, Config, NewLDiffs, NewItemDiff, NewRDiffs, Progressors, Regressors, Type, Linear, Hops, Shape_Computation, Otter_Transition) ) % Perhaps insert something to stop modulus check?
				                                                                                    ; format("% Could not reset diffs, so abandoning attempt ~n", []),fail ) ; true ), !, 
    ( member(VStatus, [target(_), modulus(_)]) -> true ; format("% Giving up on this verification!~n", []), fail ). 
    
search_for_shape_computation(M, Number, otter, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, simple, Linear, Shape_Computation, VHops, VStatus, VOutputs) :-
    Attempt = 1, Options = [], Message = "trying next",
    shape_computation(Attempt, Options, Message, M, Number, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs), !.  

search_for_shape_computation(M, Number, otter, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs) :-
    Attempt = 2, Options = [accel], Message = "trying next",
    shape_computation(Attempt, Options, Message, M, Number, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs), !. 
% Seems to be necesasry to have plain (1), expansion only (2) and the lot (4), but not ocelot only (3). Pontentially could omit 2 which leads to more nested otters ... 
% search_for_shape_computation(M, Number, otter, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs) :-
%    Attempt = 3, Options = [ocelot], Message = "trying next",
%    shape_computation(Attempt, Options, Message, M, Number, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs), !. 
    
search_for_shape_computation(M, Number, otter, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs) :-
    Attempt = 4, Options = [ocelot,accel], Message = "trying next",
    shape_computation(Attempt, Options, Message, M, Number, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs), !. 

search_for_shape_computation(M, Number, otter, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs) :-
    Attempt = 5, Options = [ocelot,accel,modify], Message = "trying next",
    shape_computation(Attempt, Options, Message, M, Number, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs), !. 

shape_computation(Attempt, Options, _Message, M, Number, InitConfig, String, Bound, Mode, FinalConfig, ProgVarsInit, RegVarsInit, Progs, Regs, LDiffs, ItemDiff, RDiffs, VarNames, _, Linear, Shape_Computation, VHops, VStatus, VOutputs) :-
    append([mods([]),initials(ProgVarsInit,RegVarsInit),diffs(LDiffs,ItemDiff,RDiffs),variable_names(VarNames),trace,maxsteps(Bound),compress,history,list], Options, NewOptions), 
    format("% ~s ~d proof attempt ~k (~k): ", [String, Number, Attempt, Options]), display_config(InitConfig, normal, VarNames), format(" -->> " , []), display_config(FinalConfig, normal, VarNames), format(" Progressors: ~k, Regressors: ~k~n", [Progs, Regs]),
    ( member(ocelot, Options) -> (format("% Otter transitions are: ~n", []), M = machine(_, _, Otters), display_otters(Otters, 1) ) ; true ), % Note that we use ocelot but not otter in verifications, so we probably don't need to allow for variable Hops in otter searches ....
    HopsVarBound is 3*Bound, % Got to do something!
    emulate_general(M, InitConfig, HopsVarBound, Mode, verify, [targets([FinalConfig])], NewOptions, VHops, VStatus, VOutputs), !,
    % format("% Returned VStatus is ~k~n", [VStatus]), 
    ( VStatus = target(_) -> (
	  member(steps(Steps), VOutputs), 
          format("% ~s ~d verified (attempt ~d) in ~d steps~n", [String,Number,Attempt,Steps]),
	  produce_shape_computation(VHops, VOutputs, InitConfig, FinalConfig, VarNames, Linear, Shape_Computation) ) % , format("% Shape computation produced~n", []) )
    ; VStatus = modulus(Mods) -> ( format("% Moduli ~k not compatible with diffs ~k ~k ~k , so giving up otter proof attempt. Will attempt to remodulate.~n", [Mods,LDiffs,ItemDiff,RDiffs]) )  
                               ; ( format("% ~s ~d abandoned (~k) due to bound of ~k steps being exceeded (attempt ~d)~n", [String,Number,VStatus,Bound,Attempt]), fail )
    ).

produce_shape_computation(Hops, Outputs, InitConfig, FinalConfig, Names, _Linear, Shape_Computation) :-
    % Status = target(_), format("% ~s ~d verified (attempt ~d)~n", [String,Number,Attempt]), 
    ( member(mods(Mods), Outputs) -> true; Mods = []), 
    ( check_constraints(InitConfig, FinalConfig, Names, Mods) -> true ; (format("% Constraints not satisfied; Mods are ", []), write(Mods), format(" FinalConfig is ", []), write_term(FinalConfig, [variable_names(Names)]), nl, fail) ),
    member(history(History), Outputs), member(now(Target), Outputs), member(pos(Pos), Outputs),
    member(used(Trans), Outputs), % Sneaky addition! 
    Complete_History = [s(Hops, Target, Pos, Trans)|History], % adds final step into history to get the complete shape computation
    reverse(Complete_History, Shape_Computation). % First element of Shape_Computation is the original shape, and the final element is the target shape.

generate_transition(M, ProgVars, RegVars, VarNames, LDiffs, ItemDiff, RDiffs, Hops, VOutputs, Shape_Computation, Otter_Number, Otter_Hops, Linear, Otter_Transition) :-

    % Linear = uni, % Probably need a separate case for multilinear, although it will overlap a lot. Let's try for now and see!
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    % format("% Generating ... ~n", []), flush_output, 
    member(history(History), VOutputs), member(now(Target), VOutputs), member(pos(VPos), VOutputs),
    member(used(Trans), VOutputs), % Sneaky addition! 
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    Complete_History = [s(Hops, Target, VPos, Trans)|History], % adds final step into history to get the complete shape computation
    reverse(Complete_History, Shape_Computation), % First element of Shape_Computation is the original shape, and the final element is the target shape.

    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    Shape_Computation = [s(_, Original, _, _)|Inferred_Steps],
    constrain_variables(f(ProgVars, RegVars), 0), % Make sure all variables and Y are \geq 0 ... hack-a-saurus! Don't think this is needed anymore ... 
    member(variable_names(ShapeNames), VOutputs),
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    Names1 = ShapeNames, % Why anything else? 
    separate_shape_computation(Shape_Computation, [], NegSC, [], PosSC),
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output,
    % write(NegSC*Names1), nl,  flush_output,
    find_min_pos(NegSC, Names1, 0, _MinPos, 0, MinEffect),
    % write(MinEffect), nl,  flush_output,
    % write(PosSC*Names1), nl,  flush_output,
    find_max_pos(PosSC, Names1, 0, _MaxPos, 0, MaxEffect), 
    % write(MaxEffect), nl,  flush_output,
    
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    
    regressor_list(LDiffs, ItemDiff, RDiffs, Regressors), % length(Regressors, R), 
    progressor_list(LDiffs, ItemDiff, RDiffs, Progressors), length(Progressors, P), 
    reverse(History, RevHistory), 
    extract_applications(RevHistory, Applied_Transitions),
    member(machine(Raw, Extended, Otter), VOutputs), 
    find_mins(Shape_Computation, Applied_Transitions, Names1, P, Regressors, machine(Raw, Extended, Otter), ProgMins, RegMins),!,
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    set_count(RegMins, RegVars, Regressors, [], Count),
    % write(RegMins+RegVars+Regressors+Count), nl,  flush_output, 
    append(Names1, ['Count' = Count], Names2),

    % configuration_size(Original, LeftOriginal, ItemOriginal, RightOriginal),
    % configuration_size(Target, LeftTarget, ItemTarget, RightTarget),
    % % Difference = (LeftTarget + ItemTarget + RightTarget) - (LeftOriginal + ItemOriginal + RightOriginal),
    % % format("Target", []), write(Target), write(LeftTarget), format(" and ", []), write(ItemTarget), format(" and ", []), write(RightTarget), nl,
    % % format("Original", []), write(Original), write(LeftOriginal), format(" and ", []), write(ItemOriginal), format(" and ", []), write(RightOriginal), nl, 
    % simplify_expression((LeftTarget + ItemTarget + RightTarget) - (LeftOriginal + ItemOriginal + RightOriginal), Difference), 
    
    % format("% Pre-padding: ", []), write(Difference), format( " and ", []), write(Original),  format( " and ", []), write(MinPos),  format( " and ", []), write(MaxPos), nl, 
    % % writeln(Count), 
    % padding(Difference, Original, MinPos, MaxPos, LDiffs, RDiffs, Count, Linear, PaddedOriginal, FinalPaddedOriginal, NewLDiffs, NewRDiffs),
    % format("% Post-padding: ", []), write(PaddedOriginal+FinalPaddedOriginal), nl, 
    % % format("% Diffs are ", []), writeln(NewLDiffs+NewRDiffs), 

    % dynamic_config(PaddedOriginal, FinalPaddedOriginal, NewLDiffs, NewRDiffs, PaddedDynamic, FinalPaddedDynamic, NextLDiffs, NextRDiffs),
    % writeln(Count), 
    % format("% Dynamic part of the Original and Final are ", []), write(PaddedDynamic), format(" and ", []), write(FinalPaddedDynamic), format("Diffs "), write(NextLDiffs+ItemDiff+NextRDiffs), nl, 
    % format("Pre-final Count is ", []), writeln(Count), 
    %     final_configuration(PaddedDynamic, FinalPaddedDynamic, Count, NextLDiffs, ItemDiff, NextRDiffs, MinEffect, MaxEffect, Final_Original, Final_Config),

    % final_configuration_new(Original, FinalPaddedDynamic, Count, NextLDiffs, ItemDiff, NextRDiffs, MinEffect, MaxEffect, Final_Original, Final_Config),
    final_configuration_new(Original, Count, LDiffs, ItemDiff, RDiffs, MinEffect, MaxEffect, NewOriginal, NewFinal),     
    % writeln(Count), 
    % get_hops_expression2(Hops, Names2, HopsExpr, ExprVars, Affine),
    % format("% Hops expression is ~k ", [HopsExpr]), format(" while Hops is ~k~n", [Hops]), 
    % format("Simplifying ...~n", []),  flush_output, 
    % % To do this properly, we need to classify Hops as affine or not

    simplify_expression(Hops, SimpleHops),

    % format("% Calling classify_hops with ", []), write(SimpleHops), nl,  flush_output, 
    classify_hops(SimpleHops, Coefficients, Terms, Type),
    % format("Classified as", []), writeln(Coefficients+Terms), 
    % Need to find Progressors and Regressors from original and diffs.
    identify_variables_diffs(Original, LDiffs, ItemDiff, RDiffs, VarDiffs),
    % format("Identified~n", []), 
    isolate_variables_diffs(VarDiffs, [], ProgVarDiffs, [], RegVarDiffs),
    % format("Isolated~n", []),  flush_output, 
    % write(SimpleHops+Coefficients+Terms+Type+Linear+Count+ProgVarDiffs+RegVarDiffs+Names2), nl, flush_output, 
    otter_steps(SimpleHops, Coefficients, Terms, Type, Linear, Count, ProgVarDiffs, RegVarDiffs, OtterSteps),
    % format("Old Otter Steps ", []), write_term(OtterSteps, [variable_names(Names2)]), format(", new Otter Steps ", []), write_term(OtterStepsNew, [variable_names(Names2)]), nl,
    % format("% Otter Steps is ", []), write_term(OtterSteps, [variable_names(Names2)]), nl,
    % ( OtterSteps \== OtterStepsNew -> format("OTTER STEPS VARIANCE~n", []); true ), 
    
    % format("% Steps done ~n", []), flush_output, 
    
    OtterMoves = VPos * Count, % Simple as that!
    
    ( member(mods(Mods), VOutputs) -> true; Mods = []),
    mod_names(Mods, ModNames), find_names(Names2, ModNames, [], SubNames), modvars(Mods, SubNames, ModsVar), % hacky stuff to convert strings in Mods to real variables to simplify checking on application  ... 
    % format("M is ", []), writeln(M), 
    % format("Inferred Steps are ", []), writeln(Inferred_Steps), flush_output, 
    extract_transitions(M, Inferred_Steps, [], Ts), sort(Ts, Transitions), % format("% Transitions found are ", []), writeln(Transitions), % Need to add these into the otter transition ... 
    % flush_output, 
    % ( Linear = multi -> Raw_Otter_Transition = too_hard; Raw_Otter_Transition = oo(FinalPaddedDynamic, diffs(LDiffs, ItemDiff, RDiffs), Final_Config, constraints(mins(ProgVars,ProgMins,RegVars,RegMins), ModsVar), OtterSteps, OtterMoves, VarNames, Otter_Hops, Transitions) ), %ATTENTION!
    Raw_Otter_Transition = oo(NewOriginal, diffs(LDiffs, ItemDiff, RDiffs), NewFinal, constraints(mins(ProgVars,ProgMins,RegVars,RegMins), ModsVar), OtterSteps, OtterMoves, VarNames, Otter_Hops, Transitions), 
    % format(" Raw transition is ", []), write(Raw_Otter_Transition), format(", Names are ", []), writeln(ShapeNames), 
    simplify_transition(Raw_Otter_Transition, Otter_Transition),%ATTENTION!
    % format(" Simplified transition is ", []), write_term(Otter_Transition, [variable_names(ShapeNames)]), nl, flush_output, 
    % format("% (raw) Otter transition is ", []), write_term(Otter_Transition, [numbervars(true), variable_names(ShapeNames)]), nl,
    format("% Otter transition is ", []), display_otters([o(Otter_Number,Otter_Transition)], 1), flush_output,
    true. 

generate_transition(_M, _ProgVars, _RegVars, _VarNames, _LDiffs, _ItemDiff, _RDiffs, _Hops, _VOutputs, _Shape_Computation, _Otter_Number, _Otter_Hops, Linear, too_hard) :- 
    Linear = multi. % Probably need a separate case for multilinear, although it will overlap a lot with the above one for unilinear. 

set_configs(Config, LDiffs, ItemDiff, RDiffs, InitConfig, FinalConfig, ProgVars, RegVars, ProgVarsInit, RegVarsInit, Names3) :-
    Config = config(Left, State, Item, Dir, Right), 
    initial_final(Left, LDiffs, [], [], [], ProgVars1, RegVars1, [], [], ProgVarsInit1, RegVarsInit1, Names1, InitLeft, FinalLeft), 
    initial_final([Item], [ItemDiff], ProgVars1, RegVars1, Names1, ProgVars2, RegVars2, ProgVarsInit1, RegVarsInit1, ProgVarsInit2, RegVarsInit2, Names2, [InitItem], [FinalItem]), 
    initial_final(Right, RDiffs, ProgVars2, RegVars2, Names2, ProgVars3, RegVars3, ProgVarsInit2, RegVarsInit2, ProgVarsInit3, RegVarsInit3, Names3, InitRight, FinalRight),

    ProgVars = ProgVars3,
    RegVars  = RegVars3,
    ProgVarsInit = ProgVarsInit3,
    RegVarsInit  = RegVarsInit3, 
    InitConfig = config(InitLeft, State, InitItem, Dir, InitRight),
    FinalConfig = config(FinalLeft, State, FinalItem, Dir, FinalRight).

mod_names([], "").
mod_names([mod(Var,_,_)|Rest], Result) :- mod_names(Rest, Temp), string_concat(Var, Temp, Result). 

modvars([], _, []). 
modvars([mod(Var,N,Value)|Mods], Names, [mod(VarV,N,Value)|ModVars]) :-
    term_string(VarV, Var, [variable_names(Names)]),
    modvars(Mods, Names, ModVars).  

% s(Hops, Config, Pos, Application)
extract_applications([], []).
extract_applications([s(_,_,_,Trans)|Rest], [Trans|Result]) :- extract_applications(Rest, Result). 

extract_transitions(_, [], SoFar, SoFar). 
extract_transitions(M, [s(_,Config,_,Trans)|Rest], SoFar, Transitions) :-
    Config = config(_, State, Item, Dir, _),
    transitions(M, State, Item, Dir, Trans, New_Transitions),
    add_list_to_list(New_Transitions, SoFar, NewSoFar),
    extract_transitions(M, Rest, NewSoFar, Transitions). 

%  M = machine(_, MacroList, _), member(trans(State, Item, InDir, NewState, OutItem, OutDir, Steps), MacroList),
transitions(M, State, Item, _Dir, Trans, New_Transitions) :-
    member(Trans, [complex(_)]),
    Item = grp(I, _), length(I, 1), !, I = [Input],
    M = machine(TransList, _, _),
    member(t(State, Input, Out, OutDir, NewState), TransList),
    New_Transitions = [t(State, Input, Out, OutDir, NewState)].
transitions(M, State, Item, Dir, Trans, New_Transitions) :-
    member(Trans, [complex(_)]),
    Item = grp(I, _), length(I, N), N > 1, !, 
    extract_simple_transitions(M, I, State, Dir, New_Transitions). 
transitions(M, State, Item, Dir, Trans, New_Transitions) :-
    member(Trans, [expansion(E)]), % Need this case here ... !
    Item = grp(I, _), !, expand(I, E, NI), 
    extract_simple_transitions(M, NI, State, Dir, New_Transitions). 
transitions(_M, _State, _Item, _Dir, Trans, New_Transitions) :- member(Trans, [modulus,modify]), New_Transitions = [].
transitions(_M, _State, _Item, _Dir, Trans, New_Transitions) :- member(Trans, [otter]), New_Transitions = [otter]. % For now!
transitions(_M, _State, _Item, _Dir, Trans, New_Transitions) :- member(Trans, [ocelot(N)]), New_Transitions = [ocelot(N)]. % For now!

extract_simple_transitions(M, I, State, Dir, Transitions) :-
  initialise_config(State, I, Dir, InitConfig), 
  extract_simple_transitions1(M, InitConfig, [], Transitions). 

initialise_config(State, I, l, config([], State, Init, Right)) :- I = [Init|Right].
initialise_config(State, I, r, config(Left, State, Init, []))  :- reverse(I, RevI), RevI = [Init|Left].

%   extract_simple_transitions1(M, Config, SoFar, Transitions).
extract_simple_transitions1(_M, Config, SoFar, SoFar) :- Config = config(_Left, State, _, _Right), halt_state(State), !. 
extract_simple_transitions1(_M, Config, SoFar, SoFar) :-  Config = config(_Left, _State, Item, _Right), Item == end, !. 
extract_simple_transitions1(M, Config, SoFar, Result) :-
    Config = config(Left, State, Item, Right),
    % find transition, update config and continue.
    M = machine(TransList, _, _), member(t(State, Item, OutItem, Dir, NewState), TransList),
    add_to_list(t(State, Item, OutItem, Dir, NewState), SoFar, NewSoFar),
    change_config(Left, OutItem, Dir, Right, NewLeft, NewItem, NewRight),
    NewConfig = config(NewLeft, NewState, NewItem, NewRight), !, 
    extract_simple_transitions1(M, NewConfig, NewSoFar, Result). 

change_config([], Item, l, Right, [], end, NewRight) :- NewRight = [Item|Right], !. 
change_config(Left, Item, l, Right, NewLeft, NewItem, NewRight) :- Left = [NewItem|NewLeft], !, NewRight = [Item|Right]. 
change_config(Left, Item, r, [], NewLeft, end, []) :- NewLeft = [Item|Left], !.
change_config(Left, Item, r, Right, NewLeft, NewItem, NewRight) :- Right = [NewItem|NewRight], !, NewLeft = [Item|Left]. 

classify_hops(Hops, Coefficients, Terms, Type) :-
    terms_in_expression(Hops, ExpTerms),
    classify_terms_in_expression(ExpTerms, Coefficients, Terms),
    degree(Terms, Degree), 
    classify_polynomial(Coefficients, Terms, Degree, Type). 

classify_polynomial(Coefficients, Terms, 0, constant(C)) :- Terms = [[]], Coefficients = [C]. 
classify_polynomial(_Coefficients, Terms, 1, linear(Variables)) :- term_variables(Terms, Variables).
classify_polynomial(_Coefficients, Terms, 2, quadratic(Variables)) :- term_variables(Terms, Variables).
classify_polynomial(_Coefficients, Terms, N, higher(N, Variables)) :- N > 2, term_variables(Terms, Variables).
    
degree(ExpVarTerms, Degree) :- length(ExpVarTerms, N), length(Results, N), maplist(length, ExpVarTerms, Results), maximum_list_element(0, Results, Degree).

maximum_list_element(SoFar, [], SoFar).
maximum_list_element(MaxSoFar, [Item|Rest], Result) :- NewSoFar is max(MaxSoFar, Item), maximum_list_element(NewSoFar, Rest, Result). 

% Assumes previously simplified, so that X-(Y+1) is X+ -Y -1, so any negative variables are expressed as + -Y rather than -Y. 
terms_in_expression(Expression, [Expression]) :- var(Expression).
terms_in_expression(Expression, [Expression]) :- nonvar(Expression), \+ (Expression = _ + _), \+ (Expression = _ - _).
terms_in_expression(Expression, Factors) :- nonvar(Expression), Expression = E1 + E2, terms_in_expression(E1, T1), terms_in_expression(E2, T2), append(T1, T2, Factors).
terms_in_expression(Expression, Factors) :- nonvar(Expression), Expression = E1 - E2, terms_in_expression(E1, T1), terms_in_expression(E2, T2), negify(T2, Negs), eliminate_double_negatives(Negs, T3), append(T1, T3, Factors). 

classify_terms_in_expression([], [], []).
classify_terms_in_expression([Term|Rest], [Coefficient|RestCoeffs], [VarTerm|RestVarTerms]) :- factors_in_expression(Term, Coefficient, VarTerm), classify_terms_in_expression(Rest, RestCoeffs, RestVarTerms).

factors_in_expression(Term, Term, []) :- integer(Term), !.
factors_in_expression(Term, Constant, []) :- ground(Term), \+ integer(Term), !, simplify_expression(Term, Constant). % Just in case!
factors_in_expression(Term, 1, Terms) :- var(Term), !, Terms = [Term].
factors_in_expression(Term, -1,Terms) :- nonvar(Term), Term =.. [-|V], var(V), !, Terms = [V].
factors_in_expression(Term, C, Terms) :- nonvar(Term), Term = T1*T2, !, factors_in_expression(T1, C1, VT1), factors_in_expression(T2, C2, VT2), C is C1*C2, append(VT1,VT2,Terms).
factors_in_expression(Term, 1, Terms) :- nonvar(Term), Term = T1//N, integer(N), !, var(T1), Terms = [T1//N]. % Weird case forced by Dragon 222 ...
factors_in_expression(Term, 1, Terms) :- nonvar(Term), Term = T1 mod N, integer(N), !, Terms = [T1 mod N]. % Weird case forced by Dragon 222 ... 

multiply_terms([], SoFar, SoFar).
multiply_terms([T|Rest], SoFar, Result) :- NewSoFar is T*SoFar, multiply_terms(Rest, NewSoFar, Result). 

% Converts strings like "[X1,X2]" to a list of strings like ["X1","X2"]
convert_varstring(VarString, StringList) :-
    string_compose("[", Temp1, "]", VarString), % get rid of leading "[" and trailing "]"
    split_string(Temp1, ",", ",", StringList).

initial_final([], [], ProgVars, RegVars, Names, ProgVars, RegVars, ProgVarsInit, RegVarsInit, ProgVarsInit, RegVarsInit, Names, [], []).
initial_final([Item|Tape], [Diff|Diffs], ProgVars, RegVars, Names, NewProgVars, NewRegVars, ProgVarsInit1, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, [Item|InitTape], [Item|FinalTape]) :-
    Diff = m(1,0), % static item so no variables involved
    initial_final(Tape, Diffs, ProgVars, RegVars,  Names, NewProgVars, NewRegVars, ProgVarsInit1, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, InitTape, FinalTape).
initial_final([Item|Tape], [Diff|Diffs], ProgVars, RegVars, Names, NewProgVars, NewRegVars, ProgVarsInit1, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, [NewInitItem|InitTape], [NewFinalItem|FinalTape]) :-
    Diff = m(1,K), K < 0, K1 is 0-K, % regressor (linear only for now)
    Item = grp(I,Num),
    append(RegVars, [Y], RegVars1), %  RegVars = [Y|RegVarsRest], 
    NewInitItem = grp(I,Y),
    NewFinalItem = grp(I,Y-K1),
    next_name(reg, Names, N1), 
    append(Names, [N1=Y], Names1), append(RegVarsInit1, [Num], RegVarsInit2), 
    initial_final(Tape, Diffs, ProgVars, RegVars1, Names1, NewProgVars, NewRegVars, ProgVarsInit1, RegVarsInit2, ProgVarsInit, RegVarsInit, NewNames, InitTape, FinalTape).
initial_final([Item|Tape], [Diff|Diffs], ProgVars, RegVars, Names, NewProgVars, NewRegVars, ProgVarsInit1, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, [NewInitItem|InitTape], [NewFinalItem|FinalTape]) :-
    Diff = m(N,K), N == 1, K >= 1, % linear progressor (almost always will be)
    Item = grp(I,Num),
    append(ProgVars, [X], ProgVars1), % ProgVars = [X|ProgVarsRest], 
    NewInitItem = grp(I,X),
    NewFinalItem = grp(I,X+K),
    next_name(prog, Names, N1), 
    append(Names, [N1=X], Names1), append(ProgVarsInit1, [Num], ProgVarsInit2), 
    initial_final(Tape, Diffs, ProgVars1, RegVars, Names1, NewProgVars, NewRegVars, ProgVarsInit2, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, InitTape, FinalTape).
initial_final([Item|Tape], [Diff|Diffs], ProgVars, RegVars, Names, NewProgVars, NewRegVars, ProgVarsInit1, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, [NewInitItem|InitTape], [NewFinalItem|FinalTape]) :-
    Diff = m(N,K), N > 1, % non-linear progressor -- K can be 0 in this case as N > 1 ... 
    Item = grp(I,Num),
    append(ProgVars, [X], ProgVars1), % ProgVars = [X|ProgVarsRest], 
    NewInitItem = grp(I,X),
    simplify_expression(N*X+K, NewX), 
    NewFinalItem = grp(I,NewX),
    next_name(prog, Names, N1), 
    append(Names, [N1=X], Names1), append(ProgVarsInit1, [Num], ProgVarsInit2), 
    initial_final(Tape, Diffs, ProgVars1, RegVars, Names1, NewProgVars, NewRegVars, ProgVarsInit2, RegVarsInit1, ProgVarsInit, RegVarsInit, NewNames, InitTape, FinalTape).

% contains_nested(Shape_Computation, Step) :- member(Step, Shape_Computation), (Step = s(_, _, _, ocelot(_N)); Step = s(_, _, _, ocelot)). 

% nested_otters(Shape_Computation, Nested) :- findall(Step, contains_nested(Shape_Computation, Step), List), length(List, Nested).
nested_otters(Shape_Computation, Nested) :- nested_otters1(Shape_Computation, [], NestedSteps), length(NestedSteps, Nested). 

nested_otters1([], SoFar, SoFar).
nested_otters1([Step|Rest], SoFar, Result) :- (Step = s(_, _, _, ocelot(_N)); Step = s(_, _, _, ocelot)), !,  append(SoFar, [Step], NewSoFar), nested_otters1(Rest, NewSoFar, Result).
nested_otters1([_Step|Rest], SoFar, Result) :- nested_otters1(Rest, SoFar, Result). 



%% Need to be able to apply this when the Config is part of a shape computation, ie contains variables. 
apply_otter(_Number, Otter_Transition, Config, _Names, NewConfig, Leaps, Moves) :-

    % writeln(Config+Otter_Transition), flush_output, 
    
    copy_term_nat(Otter_Transition, Transition),
    Transition = oo(Initial, _, Final, constraints(Mins, Mods), Steps, BasicMoves, _, _, _),
    Initial = config(_InitialLeft, InitialState, InitialItem, InitialDir, _InitialRight),

    Config = config(_Left, State, Item, Dir, _Right), 

    % % Allow for variants of Config ...
    % variant_config(Config, VConfig),
    % VConfig = config(_Left, State, Item, Dir, _Right), 

    % format("State is ~k, InitialState is ~k~n", [State, InitialState]), flush_output, 
    % format("Matching with Dir ~k InitialDir ~k Item ", [Dir,InitialDir]), write(Item), format(" InitialItem ", []), write(InitialItem), format(" RealDir ~k~n", [RealDir]), 
    State == InitialState, dirs_match(Dir, InitialDir, Item, InitialItem, RealDir), % (Dir = InitialDir; ( Dir \= InitialDir, Item = grp(I, 1), length(I,1) ) ), % Direction doesn't matter if the item is a single character, meaning the exponent is just 1 (not a variable!)
    
    % format("Initial is ", []), write(Initial), format(" Final is ", []), write(Final), nl,
    % format("Config is  ", []), write(Config), nl,
    % format("Mins is  ", []), write(Mins), nl,

    % format("Initialised ... ", []), flush_output, ttyflush, 
    
    Mins = mins(ProgVars, Xmins, RegVars, Ymins), % convert_vars(ProgVars, ProgVarsList),
    stringify(ProgVars, ProgVarsList, ProgVarsNames), 
    stringify(RegVars, RegVarsList, RegVarsNames), 

    
    % Add Item to left or right as appropriate

    adjust_for_item(RealDir, Config, RealLeft, RealRight), !,
    % writeln(RealDir+Config+RealLeft+RealRight), 
    adjust_for_item(RealDir, Initial, RealInitialLeft, RealInitialRight), !,
    % writeln(RealDir+Initial+RealInitialLeft+RealInitialRight), 
    % format("Trying otter ~d for ", [Number]), 
    % format("Config is ", []), write(Config), nl,
    % format("Matching patterns left ... ", []), write(RealLeft), write(RealInitialLeft), write(ProgVarsList), write(Xmins), write(Final), nl, flush_output, 

    % format("Adjusted ... ", []), flush_output, ttyflush, 
    
    matches_pattern(RealLeft, RealInitialLeft, ProgVarsList, Xmins, Final, LeftExtra, MinVarsLeft), % Need to collect the constrainst from each individual match, and then check them collectively later (ie check_minima). 
    % format("Final is ", []), write(Final), nl, format("LeftExtra is ", []), write(LeftExtra), format("MinVarsLeft is ", []), write(MinVarsLeft), nl, 

    % format("Matching patterns right ... ", []), write(RealRight), write(RealInitialRight), write(ProgVarsList), write(Xmins), write(Final), nl, flush_output, 
    matches_pattern(RealRight, RealInitialRight, ProgVarsList, Xmins, Final, RightExtra, MinVarsRight), 
    % format("MinVarsRight is ", []), write(MinVarsRight), nl, 
    % format("Config ", []), write(Config), format(" matches patterns left and right ", []), format("LeftExtra is ", []), write(LeftExtra), format("RightExtra is ", []), write(RightExtra), format(" Final is ", []), write(Final), nl, 
    % format("Final is ", []), write(Final), nl, format("RightExtra is ", []), write(RightExtra), nl, flush_output, 

    % format("Matched ... ", []), flush_output, ttyflush, 
    
    append(MinVarsLeft, MinVarsRight, MinVars),
    % append(MinVarsLeft, MinVarsItem, TempVars), append(TempVars, MinVarsRight, MinVars), 
    append(ProgVarsList, RegVarsList, VarsList), append(ProgVarsNames, RegVarsNames, VarsNames), append(Xmins, Ymins, AllMins), 

    % format("Vars are ", []), write(MinVars),  write(VarsList), write(VarsNames), write(AllMins), write(Final), nl, 

    % format("Calling assign_minima with ", []), write(MinVars+VarsList+AllMins), nl, 
    assign_minima(MinVars, VarsList, VarsNames, AllMins, Final), % Why do we need to do this? Probably better when verifying otters to keep an explicit list of variables and mainatain the minima for these ... Need to add constraints arising from the matching of the instance to the pattern. 
    % format("Done minima~n", []), 
    % format("Final is ", []), write(Final), nl, flush_output, 
    
    ( unreasonable_term(Mins) -> fail; check_minima(Mins) ),  
    check_mods(Mods), % Can presumably only do this when Config is ground, ie not in a shape computation. Otherwise new variable inherits this constraint?
    % Transition now is applicable, so work out details

    % format("Done mods~n", []), flush_output, 
    % format("Steps is ", []), writeln(Steps), 
    % ( ground(Steps) -> Leaps is round(Steps); Leaps = Steps ),

    % format("Checked ... ", []), flush_output, ttyflush, 
    
    % ( ground(Steps) -> Leaps is Steps; Leaps = Steps ),
    % writeln(Steps), flush_output, 
    simplify_expression(Steps, Leaps), 
    % simplify_expression(Steps, Leaps1), format("Steps is ~k, Leaps is ~k~n", [Steps, Leaps1]), 
    % ( ground(Leaps1) -> ( Leaps is Leaps1, format("Leaps is ~k~n", [Leaps])) ; Leaps = Leaps1 ), % Steps should now be specified, but needs to be evaluated if ground.
    % ( ground(Leaps1) -> Leaps is round(Leaps1) ; Leaps = Leaps1 ), % Steps should now be specified, but needs to be evaluated if ground.

    % format("Leaps is ", []), writeln(Leaps), flush_output, 
    
    % RealLeaps #= Leaps, RealLeaps #> 0, % Clearly no point if it gets us nowhere ... do we need to make sure this is ground to do this? 
    % OldHops + RealLeaps #> Hops, % As we now apply this to the oldest otter, we also need to check that we get "far enough". This probably makes the earlier check redundant when OldHops = Hops ... do we need to make sure this is ground to do this?

    % format("Vars are ", []), write(MinVars),  write(VarsList), write(VarsNames), write(AllMins), nl, 
    % format("Config ", []), write(Config), format(" matches patterns left and right ", []), format("LeftExtra is ", []), write(LeftExtra), format("RightExtra is ", []), write(RightExtra), format(" Final is ", []), write(Final), nl, 
    % format("Simplified 1 ... ", []), flush_output, ttyflush, 
    
    %%% Work out Moves here ...
    % format("Simplifying ... ~n", []), flush_output, 
    simplify_expression(BasicMoves, Moves), % As for Steps. 

    % format("Simplified 2 ... ", []), flush_output, ttyflush, 
    
    add_extra(Final, LeftExtra, RightExtra, NFinal), % add in unchanged parts of the configuration -- may need to reconfigure, but the case below should catch it.
    % format("NFinal is ", []), write(NFinal), '
    % format("Done extra~n", []), flush_output, 
    eval_powers(NFinal, NewFinal), % Some exponents may need simplification if ground.

    % format("Processed ... ", []), flush_output, ttyflush, 
    
    % format("Done powers~n", []), 
    % format(" NewFinal is ", []), write(NewFinal), nl, 
    reconfigure(NewFinal, NewConfig), %% Need to check for Item with 0 power and reconfigure as necessary
    % format("% NewConfig is ", []), write_term(NewConfig, [variable_names(Names)]), nl, flush_output,

    % format("Reconfigured~n", []), flush_output, ttyflush, 
    
    !.

dirs_match(Dir1, Dir2, _, _, RealDir) :- Dir1 == Dir2, !, RealDir = Dir1. 
dirs_match(_Dir1, Dir2, Item1, _Item2, RealDir) :- Item1 = grp(I1,N1), ground(N1), length(I1,1), N1 == 1, !, RealDir = Dir2.
dirs_match(Dir1, _Dir2, _Item1, Item2, RealDir) :- Item2 = grp(I2,N2), ground(N2), length(I2,1), N2 == 1, !, RealDir = Dir1. 

check_minima(Mins) :- Mins = mins(ProgVars, Xmins, RegVars, Ymins), check_min_list(ProgVars, Xmins), check_min_list(RegVars,  Ymins).

check_min_list([], _).
check_min_list([Var|Rest], [Min|RestMins]) :- copy_term_nat(Var, NVar), RealVar #= NVar, RealVar #>= Min, check_min_list(Rest, RestMins). 

check_mods([]).
check_mods([mod(Var,N,Value)|Rest]) :- ground(Var), Value is Var mod N, check_mods(Rest).

adjust_for_item(l, Config, NewLeft, NewRight) :- Config = config(Left, _, Item, _, Right), !, NewLeft = Left, append([Item], Right, NewRight).
adjust_for_item(r, Config, NewLeft, NewRight) :- Config = config(Left, _, Item, _, Right), !, append([Item], Left,  NewLeft), NewRight = Right. 

eval_powers(Config, NewConfig) :-
    Config = config(Left, State, Item, Dir, Right),
    eval_tape(Left, NewLeft), eval_tape([Item], [NewItem]), eval_tape(Right, NewRight), 
    NewConfig = config(NewLeft, State, NewItem, Dir, NewRight).

eval_tape([], []).
eval_tape([grp(I,N)|Rest], [grp(I,NewN)|NewRest]) :- simplify_expression(N, NewN), eval_tape(Rest, NewRest).

mins(X, Xmin, Y, Ymin) :- X #>= Xmin, Y #>= Ymin. 

eval_steps(Steps, Leaps) :- ground(Steps), !, Leaps is Steps. % simplify_expression??
eval_steps(Steps, Leaps) :- Leaps = Steps. 

convert_vars([], []).
convert_vars([V|Vars], [String|Rest]) :- term_string(V, String), convert_vars(Vars, Rest). 

% matches_pattern(Tape, Pattern, Extra)
% True if Tape matches Pattern, with Extra after the Pattern. Pattern may include padding.

matches_pattern(Tape, Pattern, ProgVars, Xmins, Final, Extra, MinVars) :-
    remove_zeroes_tape(Tape, RealTape),
    matches_pattern1(RealTape, Pattern, ProgVars, Xmins, Final, Extra, [], MinVars). 

matches_pattern1(Extra, [], _, _, _, Extra, MinVars, MinVars). % Once the pattern is empty, any excess tape will be unchanged.
matches_pattern1([Item|Rest], [PatternItem|PatternRest], ProgVarList, Xmins, Final, Extra, MinSoFar, MinVars) :-
    subsumes_term(PatternItem, Item), ! ,
    Item = PatternItem, % Simple instance so unification is okay. Need to add the constaint that the Item exponent must be at least the minimum of the pattern exponent. 
    matches_pattern1(Rest, PatternRest, ProgVarList, Xmins, Final, Extra, MinSoFar, MinVars).

% % New case ... check this
matches_pattern1([Item|Rest], [PatternItem|PatternRest], ProgVarList, Xmins, Final, Extra2, MinSoFar, MinVars) :-
    Item = grp(I, N), PatternItem = grp(I, M), ground(M), ground(N), N1 is N, M1 is M, N1 > M1, !, % format("Case 1 ~n", []), % cases in which Pattern matches but does not subsume Item ...
    length(I, L), RealM is M*L, 
    next_items(RealM, [Item], _List, Extra1, []), append(Extra1, Rest, NewRest), 
    matches_pattern1(NewRest, PatternRest, ProgVarList, Xmins, Final, Extra2, MinSoFar, MinVars).

matches_pattern1([Item|Rest], [PatternItem|PatternRest], ProgVarList, Xmins, Final, Extra, MinSoFar, MinVars) :-
    Item = grp(I, N), PatternItem = grp(I, M), ground(M), variable(N), !, % cases in which Pattern matches but does not subsume Item ... 
    zeroable(PatternRest, ProgVarList, Xmins), % Need condition that PatternRest is zeroable to allow for extra in the Item part
    length(I, L), RealM is M*L, 
    next_items(RealM, [Item], _List, Extra1, []), append(Extra1, Rest, NewRest), 
    matches_pattern1(NewRest, PatternRest, ProgVarList, Xmins, Final, Extra, MinSoFar, MinVars).

matches_pattern1([Item|Rest], [PatternItem|PatternRest], ProgVarList, Xmins, Final, Extra, MinSoFar, MinVars) :-
    \+ (Item = PatternItem), % Doesn't have to match PatternItem if its minimum is zero ...
    pattern_minimum_zero(PatternItem, ProgVarList, Xmins), !, 
    matches_pattern1([Item|Rest], PatternRest, ProgVarList, Xmins, Final, Extra, MinSoFar, MinVars).
% matches_pattern1([], [PatternItem|PatternRest], ProgVarList, Xmins, Final, [], MinSoFar, MinVars) :-
%     PatternItem = grp(I, N), all_blank(I), ground(N), !, % Blank matches all padding patterns ...
%     matches_pattern1([], PatternRest, ProgVarList, Xmins, Final, [], MinSoFar, MinVars). 
% matches_pattern1([], [PatternItem|PatternRest], ProgVarList, Xmins, Final, [], MinSoFar, MinVars) :-
%     PatternItem = grp(I, N), all_blank(I), variable(N), term_variables(N, NVars), % Padding may have exponent which is an expression containing a variable ... 
% %    append(MinSoFar, NVars, Temp), sort(Temp, NewMinSoFar), !, % to deal with any duplicates .. note that this is the only case that changes MinVars.  
% %    matches_pattern1([], PatternRest, ProgVarList, Xmins, Final, [], NewMinSoFar, MinVars). 
%     matches_pattern1([], PatternRest, ProgVarList, Xmins, Final, [], MinSoFar, MinVars). 
matches_pattern1([], [PatternItem|PatternRest], ProgVarList, Xmins, Final, [], MinSoFar, MinVars) :-
    PatternItem = blank, !, % Blank matches all padding patterns ...
    matches_pattern1([], PatternRest, ProgVarList, Xmins, Final, [], MinSoFar, MinVars). 
matches_pattern1([], [PatternItem|PatternRest], ProgVarList, Xmins, Final, [], MinSoFar, MinVars) :-
    PatternItem = grp(I, N), \+ all_blank(I),  % Must do this to ensure that the variable must be 0 to match the empty tape, unless I is all blanks (like in padding) Must also make sure that some variable exists!
    term_variables(N, NVars), length(NVars, L), L > 0, length(Values, L), all_zeroes(Values), assign_vars(NVars, Values), !, % Otherwise ... 
    matches_pattern1([], PatternRest, ProgVarList, Xmins, Final, [], MinSoFar, MinVars). 

pattern_minimum_zero(PatternItem, ProgVarsList, Mins) :-
    PatternItem = grp(_I,N), var(N),
    term_string(N, NString), find_min(NString, ProgVarsList, Mins, Min),
    0 is Min,
    N = 0. % As in matching an empty tape, we need to make sure that the Pattern variable is set to zero in this case. 

zeroable([], _, _).
zeroable([Item|Rest], ProgVarList, Xmins) :- pattern_minimum_zero(Item, ProgVarList, Xmins), zeroable(Rest, ProgVarList, Xmins). 

assign_minima([], _, _, _, _). 
assign_minima([V|Rest], VarList, VarsNames, AllMins, Final) :-
    var(V), term_string(V, VString, [variable_names(VarsNames)]), find_min(VString, VarList, AllMins, Min),
    V = Min, format("MINIMA ISSUE!! ", []), fail, % WHY!! 
    assign_minima(Rest, VarList, VarsNames, AllMins, Final).
assign_minima([V|Rest], VarList, VarsNames, AllMins, Final) :-
    ground(V), assign_minima(Rest, VarList, VarsNames, AllMins, Final).

assign_vars([], _).
assign_vars([V|Rest], [Val|Values]):- V = Val, assign_vars(Rest, Values). 

find_min(N, [Var|_Vars], [Xmin|_Xmins], Xmin) :- N == Var, !.
find_min(N, [_Var|Vars], [_Xmin|Xmins], Min)  :- find_min(N, Vars, Xmins, Min). 

add_extra(Config, LeftExtra, RightExtra, NewConfig) :-
    Config = config(Left, State, Item, Dir, Right),
    append(Left, LeftExtra, NewLeft), append(Right, RightExtra, NewRight), 
    NewConfig = config(NewLeft, State, Item, Dir, NewRight). 

reconfigure(Config, NewConfig) :- Config = config(_Left, _State, Item, _Dir, _Right), Item = grp(I,_N), I == [], !, move_item(Config, NewConfig).
reconfigure(Config, Config) :-    Config = config(_Left, _State, Item, _Dir, _Right), Item = grp(I,N),  I \== [], \+ ground(N), !.
reconfigure(Config, Config) :-    Config = config(_Left, _State, Item, _Dir, _Right), Item = grp(_I,N), ground(N), \+ safe(N), !. % Not sure so don't do it.
reconfigure(Config, NewConfig) :- Config = config(_Left, _State, Item, _Dir, _Right), Item = grp(_I,N), 0 is N, !, move_item(Config, NewConfig). % Only way to get there is to be ground and safe .... 
reconfigure(Config, Config) :-    Config = config(_Left, _State, Item, _Dir, _Right), Item = grp(I,N),  I \== [], N1 is N, N1 > 0, !. % Only way to get there is to be ground and integer_safe .... 

move_item(Config, NewConfig) :-
    Config = config(Left, State, _Item, l, Right), !, 
    purify_tape(Left, PLeft), purify_tape(Right, PRight), 
    move_item1(PRight, NewItem, NewRight),    % not quite the same as next_item ...
    NewConfig = config(PLeft, State, NewItem, l, NewRight). 
move_item(Config, NewConfig) :-
    Config = config(Left, State, _Item, r, Right), !, 
    purify_tape(Left, PLeft), purify_tape(Right, PRight), 
    move_item1(PLeft, NewItem, NewLeft),     % not quite the same as next_item ...
    NewConfig = config(NewLeft, State, NewItem, r, PRight). 

move_item1([Item|NewTape], Item, NewTape).
move_item1([], grp(Blanks,1), []) :- blank_symbol(B), blanks(B, 1, Blanks). % If this happens, there is probably an error somewhere ... 

