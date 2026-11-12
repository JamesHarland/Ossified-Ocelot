% -*- Prolog -*-
% base_directory("C:/Users/User/OneDrive - RMIT University/Software/busybeaver/OtterPaper/"). % Home!
% base_directory("C:/Users/E24991/OneDrive - RMIT University/Software/busybeaver/OtterPaper/"). % Work!

base_directory(Name) :- absolute_file_name('../OtterPaper/', Absolute), atom_string(Absolute, Name). 
    
max_otter_proofs([], SoFar, SoFar).
max_otter_proofs([o(_,Steps)|Rest], SoFar, Max) :- NewSoFar is max(SoFar, Steps), max_otter_proofs(Rest, NewSoFar, Max). 

max_otter_diffs([], SoFar, SoFar).
max_otter_diffs([o(_Num, d(D1,D2))|Rest], SoFar, Result) :- NewSoFar is max(SoFar, D1+D2), max_otter_diffs(Rest, NewSoFar, Result). 

count_flat_otters([], SoFar, SoFar).
count_flat_otters([o(_Num, d(D1,D2))|Rest], SoFar, Result) :-   D1 == D2, !, NewSoFar is SoFar+1, count_flat_otters(Rest, NewSoFar, Result).
count_flat_otters([o(_Num, d(_D1,_D2))|Rest], SoFar, Result) :- count_flat_otters(Rest, SoFar, Result). 

% example:  measure(quick, "Results/", "-test26-8", measure).
measure(Monsters, Dir, Suffix, Options) :-
    ( member(Monsters, [test,quick,quick1,quick2,newquick,slow,newslow,extra,nutters,extras,new25,new26,new33,new34,new35,new43,new72,all,most,evalnew,allnew,safeish,full]) -> (string_concat(Monsters, Suffix, Temp), string_concat(Temp, ".csv", File) ) ; File = "special.csv" ),
    machines_list(Monsters, Options, MonsterList), 
    base_directory(Base), string_concat(Base, Dir, Dir1), 
    string_concat(Dir1, File, FileName), open(FileName, write, Stream),  format(Stream, "Number,Time,Otters,Multi,Ocelots,Otter Steps,Otter Max,Diff Max,Nested,Ocelot Steps,Ones,Hops,Steps,First,Flat,MaxProgs,MaxRegs~n", []), close(Stream),!,
    string_concat(Suffix, ".txt", SuffixName),  
    measure_machines(MonsterList, Dir1, SuffixName, Options, yes, FileName).

machines_list(Monsters, Options, MonsterList) :- member(all, Options), monsters(Monsters, MonsterList).
machines_list(Monsters, Options, MonsterList) :- \+ member(all, Options), monsters(Monsters, M1), findall(M, avoid(M,_), Avoid), findall(RealM, (member(RealM, M1), \+ member(RealM, Avoid)), MonsterList).

measure_machines(Monsters, Dir, Suffix, Options, Summary, SummaryFile) :- monsters(Monsters, List), member(N, List), measure_machine(N, Dir, Suffix, Options, Summary, SummaryFile), fail.
measure_machines(_Monsters, _Dir, _Suffix, _Options, _Summary, _).

monsters(test,     [1,2,3,4]).
monsters(oldquick, [1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,74,75,77,78,81,82,83,85,92,93,94,95,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115]).
monsters(oldquick1,[1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,74,75,78,81,82,83,85,92,93,94,95,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115]). % omits 67,68,77,78,81,99,100
monsters(quick2,   [1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,74,75,82,83,85,92,93,94,95,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115]). % omits 77,78,81
monsters(quick,    [1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,71,72,74,75,77,78,81,82,83,85,88,92,93,94,95,96,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,176,177,191]). % 71,72,88,96 and 98 now quick with multimeasure and also the 3x3 cases (!!) 
monsters(oldslow,  [70,71,72,76,79,80,84,86,87,88,89,90,91,96,97,98]).
monsters(slow,     [70,76,79,80,84,86,87,89,90,91,97,129,165]). 
monsters(nutters,  List) :- findall(M, nutter(M), List). % [5,36,73,127,128,130,132,133,134,135,136,137,147,153,173,182,183,184,206,207,208,209,211,214,215,224]).
monsters(extras,   [101,102,103,104,105,106,107,108,109,110,111,112,113,114,115]).
monsters(new33,    [116,117,118,119,120,121,122,123,124,125,126]). 
monsters(new25,    [127,128,129,130,131,132,133,134,135,136,137]). % These ones don't play nice!
monsters(new26,    [138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157]). 
monsters(new34,    [158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177]). 
monsters(new43,    [178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199]). 
monsters(new62,    [200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219]). 
monsters(new72,    [220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239]).
monsters(new35,    [240]).
monsters(all,      List) :- monsters(quick, L1), monsters(slow, L2), monsters(new, L3), append(L1, L2, Temp), append(Temp, L3, List).
monsters(full,     List) :- monsters(quick, L1), monsters(slow, L2), monsters(safeish, L3), append(L1, L2, Temp), append(Temp, L3, List).
monsters(most,     List) :- monsters(quick, L1), monsters(slow, L2), monsters(evalnew, L3), append(L1, L2, Temp), append(Temp, L3, List).
monsters(new,      List) :- findall(M, new(M), List).
monsters(safeish,  List) :- findall(M, safeish(M), List).
monsters(evalnew,  List) :- findall(M, evaluable(M), List).
monsters(allnew,   List) :- findall(M, new(M), List).
monsters(tortoise, List) :- findall(M, tortoise(M), List).
monsters(missing,  List) :- findall(M, (between(127,240,M), \+ safeish(M), \+ member(M, [129,165,176,177,184,191])), List). % Ones that are memory errors ...
monsters(L, L) :- \+ member(L, [test,quick,quick1,quick2,newquick,slow,newslow,extra,nutters,extras,new25,new26,new33,new34,new35,new43,new72,all,full,most,new,safeish,evalnew,tortoise,missing]).

new(M) :- between(127,240, M), \+ member(M, [165,176,177,178,191]). % latter are already in quick or slow 
evaluable(M) :- between(127,240,M), \+ avoid(M, _),      \+ member(M, [129,165,176,177,191]). % latter are already in quick or slow
safeish(M) :-   between(127,240,M), \+ avoid(M, memory), \+ avoid(M, too_big), \+ member(M, [129,165,176,177,191]). % latter are already in quick or slow
tortoise(M) :-  between(127,240,M), nutter(M). 

avoid(M, very_slow) :- nutter(M).
avoid(M, memory) :- memory(M).
avoid(M, too_big) :- too_big(M). 

clancy(M) :- memory(M).
clancy(M) :- too_big(M).

termite(M) :- between(1,126,M), M \== 36.
termite(M) :- member(M, [129,165,176,177,191]).

urchin(36).
urchin(M) :- between(127,240,M), \+ termite(M), \+ clancy(M). 

nutter(M) :-  member(M, [5,36,73,127,128,130,131,132,133,134,135,136,137,147,152,153,173,182,183,184,205,206,207,208,209,211,213,214,215,216,224,226,240]). 
memory(M) :-  member(M, [143,144,145,160,174,175,190,199,212,219,221,222,225,230,233,236]). % 213 does not hit memory limit with trie(5) but does with trie(25) which finds otter 7. Same with 216, ie memory limit with trie(25). Doesn't seem to find any more otters though. Take 216 out?
too_big(M) :- member(M, [138,139,140,141,142,146,148,149,150,151,154,155,156,157,158,159,161,162,163,164,166,167,168,169,170,171,172,178,179,180,181,185,186,187,188,189,192,193,194,195,196,197,198,200,201,202,203,204,210,217,218,220,223,227,228,229,231,232,234,235,237,238,239]).

% 213,226

terminates(List) :- monsters(quick, Q), monsters(slow, S), Others = [5,73], append(Q,S,Temp), append(Temp, Others, Temp2), sort(Temp2, List).
oversized(List) :- findall(M, memory(M), L1), findall(N, too_big(N), L2), append(L1, L2, Temp), sort(Temp, List).
rest(M) :- between(127,240,M), terminates(T), oversized(O), \+ member(M, T), \+ member(M, O).
unproven(List) :- findall(M, rest(M), L), append(L, [36], T), sort(T, List). 

sensible(List) :- monsters(quick, Q), monsters(slow, S), monsters(new, N), append(Q, S, Temp), append(Temp, N, All), sort(All, List).
sensible2(List) :- monsters(quick, Q), monsters(slow, S), monsters(safeish, N), append(Q, S, Temp), append(Temp, N, All), sort(All, List). 

% For "pure emulation" we don't use escape, blank, loop, search, or induction. So we delete these from emulate.pl
options(measure,         [noblank,accel,otter,ocelot,otrans,compress,trie(5),final,machine]) :- !.
options(unimeasure,      [noblank,accel,otter(uni),ocelot,otrans,compress,trie(5),final,machine]) :- !.
options(multimeasure,    [noblank,accel,otter(multi),ocelot,otrans,compress,trie(5),final,machine]) :- !.  % ocelotstart(150) or more is needed for 191. Otherwise there is a memory error!
options(safemulti,       [safe,noblank,accel,otter(multi),ocelot,otrans,compress,trie(5),final,machine]) :- !.  % ocelotstart(150) or more is needed for 191. Otherwise there is a memory error!
options(multimeasure(N), [noblank,accel,otter(multi),ocelot,otrans,compress,trie(N),final,machine]) :- !.  % See if trie(20) finds more multis than trie(5) ... seems to slow a few down. May need to experiment with this. 
options(eval,            [noblank,accel,otter,ocelot,induction,otrans,compress,trie(5),final,machine]) :- !.
options(publish,         [noblank,accel,otter,ocelot,otrans,compress,trie(5),final,full,machine]) :- !.
options(ostart(N),       [noblank,accel,otter,ocelot,otrans,ocelotstart(N),compress,trie(5),final,machine]) :- !. 
options(otter,           [noblank,accel,otter,ocelot,otrans,otrace,compress,trie(5),final,machine]) :- !.
options(otterm,          [noblank,accel,otter(multi),ocelot,otrans,otrace,compress,trie(5),final,machine]) :- !.  
options(trace,           [noblank,accel,otter,ocelot,otrans,otrace,compress,trie(5),trace,final,machine]) :- !. 
options(ctrace,          [noblank,accel,otter,ocelot,otrans,otrace,compress,trie(5),ctrace,final,machine]) :- !.  
options(pctrace,         [noblank,accel,otter,ocelot,otrans,otrace,compress,ctrace,final,machine]) :- !. 
options(plain,           [noblank,accel,otter,ocelot,otrans,otrace,compress,final,machine]) :- !. 
options(Other, Other). 

extra_options(191, [ocelotstart(150)]) :- !. % ocelotstart(150) or more is needed for 91. Otherwise there is a memory error!
extra_options(M, [maxsteps(10000)]) :- between(127,240,M), \+ member(M, [165,176,177,178,191]), !. % To allow for generating something for all cases. 
extra_options(_M, []).

measure_machine(Num, Dir, Suffix, Options, Summary, SummaryFile) :-
    format("Measuring ~d ", [Num]),  flush_output, 
    atom_number(List, Num), string_concat(List, Suffix, Name), string_concat(Dir, Name, FileName), atom_codes(File, FileName),
    options(Options, Options1), 
    monster(Num, M), bound(Num, Bound),
    ( (member(safe, Options1); member(Num, [191])) -> ( extra_options(Num, Extras), append(Options1, Extras, RealOptions) ) ; RealOptions = Options1 ),
    format("with options ~k ...", [RealOptions]), ttyflush, 
    get_time(T1),
    tell(File), !, 
    emulate_bb(M, Bound, flex, RealOptions, Ones, Hops, Status, Outputs), !, 
    get_time(T2), Time is T2-T1, format("took ~2f seconds~n", [Time]), flush_output, 
    told,
    process_status(Status, NewStatus), 
    format(" done(~k)~n",[NewStatus]), flush_output,
    ( Summary \= yes -> true ; ( open(SummaryFile, append, Stream),
				 member(otters(Otters), Outputs), member(multilinearotters(MLOtters), Outputs), member(ocelots(Ocelots), Outputs), member(ottersteps(OtterSteps), Outputs), member(ocelotsteps(OcelotSteps), Outputs), member(otterproofs(OtterProofs), Outputs),  member(ottersnested(OttersNested), Outputs),member(otterdiffs(OtterDiffs), Outputs), member(steps(Steps), Outputs), member(ottercounts(MaxProg,MaxReg),Outputs), 
				 max_otter_proofs(OtterProofs, 0, OtterMax),
 				 max_otter_diffs(OtterDiffs, 0, OtterDiffMax),
				 count_flat_otters(OtterDiffs, 0, Flat), 
				 member(machine(_,_,OtterTransitions), Outputs), extract_first_hops(OtterTransitions, Firsts), sort(Firsts, SFirsts), SFirsts = [FirstOne|_], 
				 format(Stream, "~d,~2f,~d,~d,~d,", [Num,Time,Otters,MLOtters,Ocelots]),
				 print_bignum(Stream, OtterSteps), format(Stream, ",", []), 
 				 format(Stream, "~d,", [OtterMax]),
 				 print_bignum(Stream, OtterDiffMax), format(Stream, ",", []), 
  				 format(Stream, "~d,", [OttersNested]),
				 print_bignum(Stream, OcelotSteps), format(Stream, ",", []), print_bignum(Stream, Ones), format(Stream, ",", []), print_bignum(Stream, Hops),
				 format(Stream, ",~d,", [Steps]),
 				 print_bignum(Stream, FirstOne), format(Stream, ",", []),
  				 format(Stream, "~d,~d,~d", [Flat,MaxProg,MaxReg]),
				 format(Stream, "~n", []),
				 close(Stream)
			       ) ),
    ( member(replay, RealOptions) ->  ( member(machine(List1,Trans1,Otters1), Outputs), 
					NewM = machine(List1,Trans1,Otters1),
					string_concat(Base, ".txt", FileName), string_concat(Base, "-replay.txt", NewFileName), atom_codes(NewFile, NewFileName),
					format("Replaying ~d ", [Num]), format("with options ~k ...", [RealOptions]), 
					get_time(T3),
					tell(NewFile),
					emulate_bb(NewM, Bound, flex, RealOptions, _Ones1, _Hops1, Status1, _Outputs1), !, 
					get_time(T4), Time2 is T4-T3, format("took ~2f seconds~n", [Time2]), flush_output, 
					told,
					process_status(Status1, NewStatus1), 
					format(" done(~k)~n",[NewStatus1]), flush_output 
				      ) ;  true ), 
    true. 

full :- measure(quick, "Otters/", "-o2.txt", otter), measure(slow, "Otters/", "-o2.txt", otter), measure(nutters, "Otters/", "-o2.txt", otter), true. 

process_status(halts, halts).
process_status(loops(_), loops).
process_status(about(_), abort).
process_status(going_steps(_), going_steps).
process_status(going_hops(_), going_hops).
process_status(going_big(_), going_big).
process_status(target(_), target). 

% bound(N,  tens(20)) :- between(1,36,N).
bound(N,  tens(20)) :- between(1,35,N).
% bound(36, tens(15)). % Use trie(50) and otter proof length 100 ... 
bound(362, tens(15)). % Use trie(50) and otter proof length 100 ... 
bound(36, tens(15)). % Use trie(50) and otter proof length 100 ... 
% bound(362, 50000). % Use trie(50) and otter proof length 100 ... 
bound(N,  tens(25)) :- between(37,46,N).
bound(47, tens(65)).
bound(N,  tens(220)) :- between(48,49,N).
bound(50, tens(710)).
bound(N,  tens(22)) :- between(51,57,N).
bound(N,  tens(28)) :- between(58,59,N).
bound(N,  tens(45)) :- between(60,61,N).
bound(N,  tens(125)) :- between(62,66,N).
bound(67, tens(930)).
bound(68, tens(1740)).
bound(69, tens(1770)).
bound(70, tens(2890)).
% bound(70, tens(200)). % For trace result ... 
bound(71, tens(21135)).
bound(72, tens(36550)).
bound(73, tens(10)).
bound(74, tens(55)).
bound(75, tens(285)).
bound(76, tens(880)).
bound(77, tens(1260)).
bound(78, tens(2610)).
bound(79, tens(4720)).
bound(80, tens(4750)).
bound(81, tens(13050)).
bound(82, tens(10)).
bound(83, tens(1430)).
bound(84, tens(1620)).
bound(85, tens(2000)).
bound(86, tens(7730)).
bound(87, tens(9130)).
bound(88, tens(9870)).
bound(89, tens(12075)).
bound(N,  tens(14080)) :- between(90,91,N).
bound(N,  tens(10)) :- between(92,94,N).
bound(95, tens(60)).
bound(96, tens(1650)).
bound(N,  tens(19870)) :- between(97,98,N).
bound(99, tens(10)).
bound(100, tens(95)).
bound(N, tens(20)) :- between(101,115,N).
bound(N, tens(1000)) :- between(116,126,N).
bound(N, tens(1000)) :- between(127,137,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(138, tens(100000)).
bound(139, tens(100000)).
bound(N, tens(1000)) :- between(140,142,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(143, tens(10000)).
bound(144, tens(1000000)).
bound(145, tens(100000)).
bound(N, tens(1000)) :- between(146,148,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(149, tens(100000)).
bound(150, tens(100000)).
bound(151, tens(1000)).
bound(152, tens(100000)).
bound(153, tens(1000000)).
bound(154, tens(1000)).
bound(155, tens(1000)).
bound(156, tens(100000)).
bound(157, tens(1000)).
bound(158, tens(1000)).
bound(159, tens(1000000)).
bound(N, tens(1000)) :- between(160,163,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(164, tens(100000)).
bound(N, tens(1000)) :- between(165,170,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(171, tens(100000)).
bound(172, tens(1000)).
bound(173, tens(10000)).
bound(N, tens(1000)) :- between(174,180,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(181, tens(100000)).
bound(182, tens(1000000)).
bound(183, tens(1000000)).
bound(184, tens(1000000)).
bound(185, tens(1000)).
bound(186, tens(10000000)).
bound(N, tens(100000)) :- between(187,188,N). 
bound(189, tens(1000)).
bound(190, tens(1000)).
bound(191, tens(10000)).
bound(192, tens(1000)).
bound(193, tens(1000000)).
bound(N, tens(100000)) :- between(194,198,N).
bound(199, tens(100000)).
bound(200, tens(100000)).
bound(201, tens(100000)).
% bound(N, tens(1000)) :- between(202,216,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(202, tens(1000)).
bound(203, tens(1000)).
bound(204, tens(100)).
bound(N, tens(50)) :- between(205,210,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(211, tens(10)).
bound(212, tens(10000)).
bound(213, tens(1000)).
bound(214, tens(100)).
bound(215, tens(100)).
bound(216, tens(10)).
bound(217, tens(100000)).
bound(N, tens(10000)) :- between(218,222,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(223, tens(100000000)).
bound(224, tens(10000)).
bound(225, tens(100000000)).
bound(226, tens(10000)).
bound(N, tens(10000)) :- between(224,226,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(227, tens(100000000)).
bound(228, tens(10000)).
bound(229, tens(100000)).
bound(230, tens(100000)).
bound(231, tens(100000000)).
bound(232, tens(10000)).
bound(233, tens(100000000)).
bound(N, tens(1000)) :- between(234,236,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(237, tens(100000)).
bound(N, tens(1000)) :- between(238,239,N). % Anyone's guess at this point! So get some initial results without too much pain ...
bound(240, tens(10000)).

% Hops = 35*_54440+_54440*(4*_54440)+77, Cs = [35,4,77], Ts = [[_54440],[_54440,_54440],[]], Type = quadratic([_54440]), Linear = multi, Count = _54642//3, PVars = [diff(_54440,m(4,16))], RVars = [diff(_54642,m(1,-3))], otter_steps_new(Hops, Cs, Ts, Type, Linear, Count, PVars, RVars, OtterSteps).

% Config = config([grp([1],1),grp([2],1),grp([3],_25516),blank],a,grp([2],1),l,[grp([3],_25560)]), LDiffs = [m(1,0),m(1,0),m(2,17)], ItemDiff = m(1,0), RDiffs = [m(1,-6)], Count = _25560//6, apply_k(Config, LDiffs, ItemDiff, RDiffs, Count, Final).

% 237 otter 3 Hops: 29*X1+9*((X1+1)//2*((X1+1)//2))+19*((X1+1)//2)+9*((3*X1+14)//2*((3*X1+14)//2))+19*((3*X1+14)//2)+140  --- maybe use (3X+14)//2 = X + 7 + X//2??

% 237 Otter 3 Hops: 75*X1+9*((X1+2)//2*((X1+2)//2))+19*((X1+2)//2)+9*((3*X1+11)//2*((3*X1+11)//2))+19*((3*X1+11)//2)+9*((9*X1+44)//2*((9*X1+44)//2))+19*((9*X1+44)//2)+9*((27*X1+137)//2*((27*X1+137)//2))+19*((27*X1+137)//2)+4533

% 209 Otter 101 attempt 5 these should match!
% (10)^{X1+1}0(011)^{Y1-1}01(011)^{2}{b}101{l}(01)^{2}(101)^{4}0(1)^{2}(01)^{3}(0)^{2}(1)^{X2+1} % Hops: 12*Y1+127 Ones: 22 Pos: -1 Transition: ocelot(2)
% (10)^{X1+1}001(101)^{Y1-1}(011)^{2}{b}101{l}010(110)^{4}10(1)^{2}(01)^{3}(0)^{2}(1)^{X2+1}

% Config1 = config([grp([0,1,1],2),grp([0,1],1),grp([0,1,1],Y1-1),grp([0],1),grp([1,0],X1+1)], b, grp([1,0,1],1), l, [grp([0,1],2),grp([1,0,1],4),grp([0],1),grp([1],2),grp([0,1],3),grp([0],2),grp([1],X2+1) ]).
% (10)^{X1+1}0(011)^{Y1-1}01(011)^{2} {b}101{l} (01)^{2}(101)^{4}0(1)^{2}(01)^{3}(0)^{2}(1)^{X2+1} % Hops: 12*Y1+127 Ones: 22 Pos: -1 Transition: ocelot(2)

% Config2 = config([grp([0,1,1],2),grp([1,0,1],Y1-1),grp([0,0,1],1),grp([1,0],X1+1)], b, grp([1,0,1],1), l, [grp([0,1,0],1),grp([1,1,0],4),grp([1,0],1),grp([1],2),grp([0,1],3),grp([0],2),grp([1],X2+1) ]).
% (10)^{X1+1}001(101)^{Y1-1}(011)^{2}{b}101{l}010(110)^{4}10(1)^{2}(01)^{3}(0)^{2}(1)^{X2+1}


% Item = grp([1, 0, 1], 1), Right = [grp([0, 1], 2), grp([1, 0, 1], 4), grp([0], 1), grp([1], 2), grp([0, 1], 3), grp([0], 2), grp([1],X2+1)

% Memory overflow examples are below. 
% 10*2^30023997515803303+(10*2^30023997515803303-10)-1 is like 10*X+ (10*X-10)-1 where X =  2^30023997515803303 and so this is 20*X-11

% 1843968*(4^705690409413879898948747927018492817235559114281541872571966543607442613122957723008966765919662356038372335051677929437809239293820594009122-1)+ -270480*(4^352845204706939949474373963509246408617779557140770936285983271803721306561478861504483382959831178019186167525838964718904619646910297004561-1)+ -79390171059061488631734141789580441939000400356673460664346236155837293976332743838508761165962015054316887693313767061753539420554816826026225)//405+2689194351269138930118023904350948640283673686450004447077133715487450551867050733407784133565097566894167252224741343045526955377504531444959279767604206165563018442843364889728815491341821372888051043096587500537254880364152449400501563517018211244689104084477528763202776178236002,

%  = 4^352845204706939949474373963509246408617779557140770936285983271803721306561478861504483382959831178019186167525838964718904619646910297004561, _ is S.

% 62694912000*(16^153845832845476374178681372717632470-1)+ -4998000000*(16^76922916422738187089340686358816235-1)+ -73557538829243391404182031330618024718750)//860625+511240470132634354624796730539038922249940016944922629907431532749124079,

% 6172588800*(9^240206320777082-1)+209018880*(9^120103160388541-1)+ -86089945366506188800)//40960+108185768514880691210125170160

% 1460721600*(9^29316842526415583090490254914579224724862463578882467875034896129555978020295445960-1)+485683200*(9^14658421263207791545245127457289612362431231789441233937517448064777989010147722980-1)+ -5229486772219165220255412408813992446985450495265155786405264710173007340738985930359910400)//40960+104490151551720966417158293391981284006803362195947005632421981512225540492851643982592979347368115654018169789386046229827612581308986234144419639122818042286481110383

% 3572160*(4^7631099368599988-1)+ -58560*(4^3815549684299994-1)+48762724965353923320)//405+218333639281110772870774983749147

% 50*4^3815549684299994+(38*4^3815549684299994-38)//3)

% Need to learn how to process the Hops from a SC like this 126*X1+9*((X1+1)//2*((X1+1)//2))+25*((X1+1)//2)+18*(X1*X1)+91*(X1//2)+9*(X1//2*(X1//2))+388

% 37*4^137469665091416877317864703160769+(11*4^137469665091416877317864703160769-11)//3)

% 15*4^8591854068213554832366543947543+(16*4^8591854068213554832366543947543-16)//3),

test(N) :- (memory(N); too_big(N)), measure([N], "Tests/", "-test26-memory", [all,noblank,accel,otter(multi),ocelot,otrans,compress,trie(5),final,machine]).

% 30*X1+50*X2+12*(X2*X2)+103 for Dragon 142 Otter 3 but transition not generated. 


% 22*X*3^Y/2 +22*8*3^Y/(2*2) -22*X/2 -22*3*8/(2*2)
% 22*X*3^Y/2 -22*X/2 +22*8*3^Y/(2*2) -22*3*8/(2*2)
% (22*X*3^Y -22*X)/2 +(22*8*3^Y -22*3*8)/(2*2)
% (22*2*X*3^Y -22*2*X)/(2*2) +(22*8*3^Y -22*3*8)/(2*2)
% (22*2*X*3^Y + 22*8*3^Y -22*2*X -22*3*8)/(2*2)

% (22*2*X*3^Y+22*8*3^Y-22*2*X-22*3*8)//(2*2)

% M1 is M-1, Exp = M^Count, O1 = A*X*Exp/M1 + A*N*Exp/(M1*M1) - A*X/M1 + Constant - A*M*N/(M1*M1), O2 = (A*M1*X*Exp + A*N*Exp - A*M1*X - A*M*N)//(M1*M1) + Constant, !,% (22*2*X*3^Y -22*2*X)/(2*2) +(22*8*3^Y -22*3*8)/(2*2)

% Mods	= [mod("X1", 2, 0)], Config = config([grp([3,2],_171944//2),grp([2],_171904+1),grp([2,3],1),grp([1],2)],b,grp([4],_171944 mod 2),l,[grp([3],_172004),grp([4],1),grp([3],1),grp([4],1),grp([3],1)]), Hops = 2*_171904+_171944-_171944 mod 2+13, Pos = _171904+1, Moves = _171944-_171944 mod 2, Names	= ['X1'=_171904, 'X2'=_171944, 'Y1'=_172004], 

% E = 2^118842243771396506390315925502+5*2^118842243771396506390315925502-5, S is E. 

% 171*9^14658421263207791545245127457289612362431231789441233937517448064777989010147722980+(162*9^14658421263207791545245127457289612362431231789441233937517448064777989010147722980-162)//8
% 2^680564733841876926926749214863536422910+5*2^680564733841876926926749214863536422910-5
% 282*9^120103160388541+(12*9^120103160388541-12)//8
% 39*4^4772185878+(43*4^4772185878-43)//3
% 14*4^246487616711044605846581178821+(14*4^246487616711044605846581178821-14)//3
% 2*2^170141183460469231731687303715884105725+6*2^170141183460469231731687303715884105725-6

% (1)^{X1+4}(101)^{X2//3+4}{b}(1)^{X2 mod 3}{l}(011111)^{Y1}(1)^{6}(011111)^{4}1 % Hops: 8*X1+X2-X2 mod 3+71 Ones: 27 Pos: X2-X2 mod 3+1 Transition: expansion(3) 
% % Old Hops rewritten to NewHops: from 8*_102402+_102448-_102448 mod 3+71 to 8*_102402+_102448-_102448 mod 3+71 with NewMods [mod(X1,2,1),mod(X2,3,0)] and Names [X1=_102402,X2=_102448,Y1=_102508]

%[mod(X1,2,1),mod(X2,3,0)]+config([grp([1,0,1],_102462//3+4),grp([1],_102416+4)],b,grp([1],_102462 mod 3),l,[grp([0,1,1,1,1,1],_102522),grp([1],6),grp([0,1,1,1,1,1],4),grp([1],1)])+(8*_102416+_102462-_102462 mod 3+71)+(_102462-_102462 mod 3+1)+[X1=_102416,X2=_102462,Y1=_102522]
%% Old Hops rewritten to NewHops: from 8*_102416+_102462-_102462 mod 3+71 to 8*_102416+_102462-_102462 mod 3+71 with NewMods [mod(X1,2,1),mod(X2,3,0)] and Names [X1=_102416,X2=_102462,Y1=_102522]
% (1)^{X1+4}(101)^{X2//3+4}{b}(1)^{X2 mod 3}{l}(011111)^{Y1}(1)^{6}(011111)^{4}1 % Hops: 8*X1+X2-X2 mod 3+71 Ones: 27 Pos: X2-X2 mod 3+1 Transition: modulus 

% Mods = [mod("X1",2,1),mod("X2",3,0)], C = config([grp([1,0,1],_102462//3+4),grp([1],_102416+4)],b,grp([1],_102462 mod 3),l,[grp([0,1,1,1,1,1],_102522),grp([1],6),grp([0,1,1,1,1,1],4),grp([1],1)]), Hops = (8*_102416+_102462-_102462 mod 3+71), Pos = (_102462-_102462 mod 3+1), Names = ['X1'=_102416,'X2'=_102462,'Y1'=_102522], rewrite_modulus(Mods, C, Hops, Pos, 0, Names, NewC, NewHops, NewPos, _). 

% Still need to check executions for 10000 steps  for  152, 213, 226
