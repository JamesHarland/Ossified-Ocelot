% -*- Prolog -*-
monster(1, [t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(a,3,1,l,a),t(b,0,3,l,a),t(b,1,1,r,z),t(b,2,2,r,b),t(b,3,2,l,a)]). % Michel 2x4 #a
monster(2, [t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,a),t(a,3,1,r,a),t(b,0,2,l,a),t(b,1,1,r,z),t(b,2,3,r,a),t(b,3,3,r,b)]). % Michel 2x4 #b
monster(3, [t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(a,3,1,l,a),t(b,0,3,l,a),t(b,1,1,r,z),t(b,2,2,r,b),t(b,3,2,r,a)]). % Michel 2x4 #c
monster(4, [t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,r,a),t(a,3,1,r,a),t(b,0,1,l,b),t(b,1,1,l,a),t(b,2,2,l,z),t(b,3,2,r,b)]). % Ligocki 2x4 #a reworked by me 
monster(5, [t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,1,l,c),t(b,0,1,l,a),t(b,1,2,r,b),t(b,2,1,r,b),t(c,0,1,r,z),t(c,1,2,l,a),t(c,2,0,l,c)]). % Brady #SB  ??? This is a tough one .... macro(3) works but
monster(6, [t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,1,l,a),t(b,0,2,l,c),t(b,1,0,r,c),t(b,2,1,r,b),t(c,0,1,r,z),t(c,1,2,l,a),t(c,2,1,r,b)]). % Brady #b macro(2)
monster(7, [t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,2,l,c),t(b,0,1,l,c),t(b,1,2,r,b),t(b,2,1,l,b),t(c,0,1,l,a),t(c,1,0,r,b),t(c,2,2,l,a)]). % Brady #c macro(2)
monster(8, [t(a,0,1,r,b),t(a,1,1,l,c),t(a,2,2,r,z),t(b,0,1,l,a),t(b,1,1,l,c),t(b,2,2,r,b),t(c,0,1,r,b),t(c,1,2,l,c),t(c,2,1,r,c)]). % Brady #d macro(2)
monster(9, [t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,2,r,c),t(b,0,1,l,c),t(b,1,1,r,z),t(b,2,1,l,a),t(c,0,1,r,a),t(c,1,2,l,b),t(c,2,1,l,c)]). % Souris #a macro(2)
monster(10,[t(a,0,1,r,b),t(a,1,1,l,b),t(a,2,2,l,a),t(b,0,1,l,a),t(b,1,1,r,c),t(b,2,1,r,z),t(c,0,0,l,a),t(c,1,2,r,c),t(c,2,1,l,c)]). % Souris #b macro(2)
monster(11,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,c),t(b,1,1,l,a),t(b,2,2,r,c),t(c,0,1,l,z),t(c,1,1,l,a),t(c,2,2,r,b)]). % Lafitte and Papazian #a  macro(2)
monster(12,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,2,r,b),t(b,0,1,l,c),t(b,1,0,l,b),t(b,2,1,r,a),t(c,0,1,r,a),t(c,1,2,l,c),t(c,2,1,r,c)]). % Lafitte and Papazian #b macro(2)
monster(13,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,b),t(b,1,1,l,a),t(b,2,2,r,c),t(c,0,1,r,z),t(c,1,1,l,c),t(c,2,2,r,b)]). % Laitte and Papazian #c macro(2)
monster(14,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,r,c),t(b,1,2,r,b),t(b,2,0,r,c),t(c,0,1,l,a),t(c,1,1,r,z),t(c,2,1,l,a)]). % Lafitte and Papazian #d macro(2)
monster(15,[t(a,0,1,r,b),t(a,1,2,l,z),t(a,2,2,l,c),t(b,0,1,l,c),t(b,1,2,r,b),t(b,2,1,l,b),t(c,0,1,l,a),t(c,1,2,r,c),t(c,2,2,l,a)]). % Lafitte and Papazian #e macro(2)
monster(16,[t(a,0,1,r,b),t(a,1,2,r,c),t(a,2,1,l,a),t(b,0,2,l,a),t(b,1,1,r,b),t(b,2,1,r,z),t(c,0,2,r,b),t(c,1,2,r,a),t(c,2,1,l,c)]). % Ligockis 3x3 #a macro(2) 4 work
monster(17,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,l,c),t(b,0,0,l,a),t(b,1,2,r,b),t(b,2,1,l,b),t(c,0,1,r,z),t(c,1,1,r,a),t(c,2,1,r,c)]). % Ligockis 3x3 #b macro(2) 1 work
monster(18,[t(a,0,1,r,b),t(a,1,1,l,c),t(b,0,1,r,c),t(b,1,1,r,b),t(c,0,1,r,d),t(c,1,0,l,e),t(d,0,1,l,a),t(d,1,1,l,d),t(e,0,1,r,z),t(e,1,0,l,a)]).
monster(19,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,1,l,d),t(d,0,1,r,a),t(d,1,1,l,e),t(e,0,1,r,z),t(e,1,0,l,c)]).
monster(20,[t(a,0,1,r,b),t(a,1,0,l,d),t(b,0,1,l,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,1,r,a),t(e,1,0,r,b)]).
monster(21,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,0,r,e),t(e,0,1,l,c),t(e,1,1,r,b)]).
monster(22,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,0,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,0,l,e),t(e,1,1,r,b)]).
monster(23,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,0,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,1,l,c),t(e,1,1,r,b)]).
monster(24,[t(a,0,1,r,b),t(a,1,1,l,c),t(b,0,0,l,a),t(b,1,0,l,d),t(c,0,1,l,a),t(c,1,1,r,z),t(d,0,1,l,b),t(d,1,1,r,e),t(e,0,0,r,d),t(e,1,0,r,b)]).
monster(25,[t(a,0,1,r,b),t(a,1,1,r,d),t(b,0,1,l,c),t(b,1,0,l,e),t(c,0,0,r,a),t(c,1,0,l,b),t(d,0,1,r,e),t(d,1,1,r,z),t(e,0,1,l,c),t(e,1,1,r,c)]).
monster(26,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,r,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,0,r,b),t(d,0,0,r,e),t(d,1,1,r,z),t(e,0,1,l,c),t(e,1,1,r,a)]).
monster(27,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,b),t(a,3,1,r,a),t(a,4,3,r,a),t(b,0,2,l,b),t(b,1,3,l,a),t(b,2,3,r,a),t(b,3,4,r,b),t(b,4,1,r,z)]). % Lafitte and Papazian #a macro(1) !! but macro(2) is close
monster(28,[t(a,0,1,r,b),t(a,1,2,r,b),t(a,2,3,l,a),t(a,3,2,r,a),t(a,4,3,r,a),t(b,0,2,l,b),t(b,1,2,l,a),t(b,2,1,l,a),t(b,3,4,r,b),t(b,4,1,r,z)]). % Lafitte and Papazian #b macro(2) but macro(1) is close
monster(29,[t(a,0,1,r,b),t(a,1,2,r,b),t(a,2,3,r,b),t(a,3,4,l,a),t(a,4,3,r,a),t(b,0,0,l,a),t(b,1,4,r,b),t(b,2,1,r,z),t(b,3,0,r,b),t(b,4,1,l,b)]). % Lafitte and Papazian #c macro(2)
monster(30,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,3,r,b),t(a,3,1,l,a),t(a,4,3,l,b),t(b,0,2,l,a),t(b,1,3,r,a),t(b,2,4,l,b),t(b,3,2,r,a),t(b,4,1,r,z)]). % Lafitte and Papazian #d macro(2), but it is hard work
monster(31,[t(a,0,1,r,b),t(a,1,2,r,b),t(a,2,3,l,a),t(a,3,2,r,a),t(a,4,3,r,a),t(b,0,2,l,b),t(b,1,2,l,a),t(b,2,3,l,a),t(b,3,4,r,b),t(b,4,1,r,z)]). % Lafitte and Papazian #e macro(1) (!!)
monster(32,[t(a,0,1,r,b),t(a,1,3,l,b),t(a,2,1,r,z),t(a,3,1,l,a),t(a,4,1,l,a),t(b,0,2,l,a),t(b,1,3,r,b),t(b,2,4,l,b),t(b,3,4,l,b),t(b,4,3,r,a)]). % Lafitte and Papazian #f macro(1) with macro(2) close
monster(33,[t(a,0,1,r,b),t(a,1,3,r,a),t(a,2,1,l,a),t(a,3,1,l,b),t(a,4,3,l,b),t(b,0,2,l,a),t(b,1,4,l,b),t(b,2,3,r,a),t(b,3,2,r,b),t(b,4,1,r,z)]). % Lafitte and Papazian #g macro(1) (!!)
monster(34,[t(a,0,1,r,b),t(a,1,3,r,a),t(a,2,4,l,b),t(a,3,2,r,a),t(a,4,3,l,a),t(b,0,2,l,a),t(b,1,2,l,z),t(b,2,4,r,b),t(b,3,4,r,b),t(b,4,2,l,b)]). % Lafitte and Papazian #h macro(1) (!!)
monster(35,[t(a,0,1,r,b),t(a,1,3,l,b),t(a,2,4,l,b),t(a,3,4,l,a),t(a,4,2,r,a),t(b,0,2,l,a),t(b,1,4,l,z),t(b,2,3,r,b),t(b,3,4,r,a),t(b,4,3,r,b)]). % Lafitte and Papazian #i macro(1)(!!) with macro(2) close
monster(36,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,a),t(a,3,4,l,a),t(a,4,1,r,a),t(b,0,2,l,b),t(b,1,2,r,a),t(b,2,1,r,z),t(b,3,0,r,a),t(b,4,0,r,b)]). % Lafitte and Papazian #j weird and has multiple regressors macro(3), macro(6), ...
% monster(362, machine( [t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,a),t(a,3,4,l,a),t(a,4,1,r,a),t(b,0,2,l,b),t(b,1,2,r,a),t(b,2,1,r,z),t(b,3,0,r,a),t(b,4,0,r,b)], [],
% 		      [o(1,oo( config( [ grp([1],Y1), grp([1,0],1) ], a, grp([2],1), r, [ grp([3],1), grp([4],X1), grp([3],1) ] ), diffs([m(1,-1),m(1,0)], m(1,0), [m(1,0),m(1,1),m(1,0)]), 
% 		               config( [ grp([1],2), grp([1,0],Y1//2-1), grp([1],2)], a, grp([2],1), r, [ grp([3],X1+1), grp([4],1) ] ),
% 		       constraints(mins([X1],[0],[Y1],[1]),[mod(Y1,2,0)]), 2*X1 + 3*Y1 + 10, 0, ['X1'=X1,'Y1'=Y1], 0, []) ) ]	 ) ).
    % monster(37,[t(a,0,4,l,b),t(a,1,1,r,z),t(a,2,2,r,a),t(a,3,0,l,b),t(a,4,3,l,b),t(b,0,2,r,a),t(b,1,3,l,b),t(b,2,3,r,b),t(b,3,2,l,b),t(b,4,1,l,b)]). % Ligockis #a rework? macro(2), but 3 and 4 work
% monster(37,[t(a,0,1,r,b),t(a,4,4,r,z),t(a,2,2,l,a),t(a,3,0,r,b),t(a,1,3,r,b),t(b,0,2,l,a),t(b,4,3,r,b),t(b,2,3,l,b),t(b,3,2,r,b),t(b,1,4,r,b)]). % Ligockis #a with 4 and 1 swapped, and made orthodox
monster(37,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,2,l,a),t(a,3,0,r,b),t(a,4,4,l,z),t(b,0,2,l,a),t(b,1,4,r,b),t(b,2,3,l,b),t(b,3,2,r,b),t(b,4,3,r,b)]). % Ligockis #a with 4 and 1 swapped and sorted. 
% monster(38,[t(a,0,4,r,b),t(a,1,2,l,a),t(a,2,4,l,a),t(a,3,4,r,a),t(a,4,3,l,a),t(b,0,1,l,a),t(b,1,4,l,a),t(b,2,4,r,a),t(b,3,3,r,b),t(b,4,3,r,z)]). % Ligockis #b rework? macro(2) but 1,2,3,5,6 work
% monster(38,[t(a,0,1,r,b),t(a,4,2,l,a),t(a,2,1,l,a),t(a,3,1,r,a),t(a,1,3,l,a),t(b,0,4,l,a),t(b,4,1,l,a),t(b,2,1,r,a),t(b,3,3,r,b),t(b,1,3,r,z)]). % Ligockis #b with 4 and 1 swapped
monster(38,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,a),t(a,3,1,r,a),t(a,4,2,l,a),t(b,0,4,l,a),t(b,1,3,r,z),t(b,2,1,r,a),t(b,3,3,r,b),t(b,4,1,l,a)]). % Ligockis #b  with 4 and 1 swapped and sorted
monster(39,[t(a,0,1,r,b),t(a,1,4,l,a),t(a,2,1,l,a),t(a,3,2,l,a),t(a,4,1,r,a),t(b,0,3,l,a),t(b,1,1,r,z),t(b,2,1,r,a),t(b,3,2,r,a),t(b,4,4,r,b)]). % Ligockis #c macro(2), but 1,3,4 work
monster(40,[t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,1,l,a),t(a,3,1,l,b),t(a,4,3,l,b),t(b,0,2,l,a),t(b,1,3,r,b),t(b,2,1,r,z),t(b,3,4,r,a),t(b,4,1,l,a)]). % Ligockis #d macro(2) but others work
monster(41,[t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,1,l,a),t(a,3,3,l,a),t(a,4,2,r,a),t(b,0,2,l,a),t(b,1,3,r,b),t(b,2,4,l,a),t(b,3,1,l,b),t(b,4,1,r,z)]). % Ligockis #e macro(1) but others work
monster(42,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,a),t(a,3,0,l,b),t(a,4,1,r,a),t(b,0,2,l,a),t(b,1,4,l,b),t(b,2,4,l,a),t(b,3,1,r,a),t(b,4,1,r,z)]). % Ligockis #f macro(1) but others work
monster(43,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,4,l,a),t(a,3,4,l,b),t(a,4,2,r,a),t(b,0,2,l,b),t(b,1,2,r,b),t(b,2,3,r,b),t(b,3,2,r,a),t(b,4,0,r,b)]). % Ligockis #g macro(1) but others work
monster(44,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,3,r,a),t(a,3,1,r,z),t(a,4,2,l,b),t(b,0,2,l,a),t(b,1,4,r,a),t(b,2,4,r,b),t(b,3,2,l,b),t(b,4,0,r,a)]). % Ligockis #h macro(1) but others work
monster(45,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,3,l,b),t(a,3,0,l,b),t(a,4,1,r,a),t(b,0,2,l,a),t(b,1,4,l,b),t(b,2,4,l,a),t(b,3,1,r,a),t(b,4,1,r,z)]). % Ligockis #i macro(1) but others work
monster(46,[t(a,0,1,r,b),t(a,1,0,r,b),t(a,2,4,r,a),t(a,3,2,l,b),t(a,4,2,l,a),t(b,0,2,l,a),t(b,1,1,l,b),t(b,2,3,r,b),t(b,3,4,r,a),t(b,4,1,r,z)]). % Ligockis #j macro(1) but others work
monster(47,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,4,r,a),t(a,3,1,l,b),t(a,4,2,l,a),t(b,0,0,l,a),t(b,1,2,r,b),t(b,2,3,r,b),t(b,3,2,r,a),t(b,4,1,r,z)]). % Ligockis #k macro(2) 1,3,4 work
monster(48,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,4,r,a),t(a,3,2,l,b),t(a,4,2,l,a),t(b,0,0,l,a),t(b,1,2,r,b),t(b,2,3,r,b),t(b,3,4,r,a),t(b,4,1,r,z)]). % Ligockis #l macro(2) 1,4 work
monster(49,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,4,r,a),t(a,3,2,l,b),t(a,4,2,l,a),t(b,0,0,l,a),t(b,1,2,r,b),t(b,2,3,r,b),t(b,3,1,r,a),t(b,4,1,r,z)]). % Ligockis #m macro(2) 1,4 work
monster(50,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(a,3,2,l,b),t(a,4,2,l,a),t(b,0,0,l,a),t(b,1,2,r,b),t(b,2,3,r,b),t(b,3,4,r,a),t(b,4,1,r,z)]). % Ligockis #n macro(2) 1 works 
monster(51,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,0,l,f),t(c,1,1,l,d),t(d,0,1,r,a),t(d,1,0,l,e),t(e,0,0,r,a),t(e,1,1,l,c),t(f,0,1,r,e),t(f,1,1,r,z)]). % macro(3)
monster(52,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,0,r,f),t(c,1,1,l,d),t(d,0,1,r,a),t(d,1,0,l,e),t(e,0,1,l,z),t(e,1,1,l,f),t(f,0,0,l,a),t(f,1,0,l,c)]). % macro(4)
monster(53,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,0,r,a),t(c,0,0,l,d),t(c,1,1,r,z),t(d,0,1,r,e),t(d,1,1,l,d),t(e,0,0,l,f),t(e,1,0,l,e),t(f,0,1,r,f),t(f,1,0,l,b)]). % macro(3)
monster(54,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,0,r,e),t(c,0,1,l,d),t(c,1,0,l,f),t(d,0,0,l,b),t(d,1,1,l,c),t(e,0,1,r,b),t(e,1,1,r,a),t(f,0,1,r,b),t(f,1,1,r,z)]).  % macro(4)
monster(55,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,0,r,e),t(c,0,1,l,d),t(c,1,1,l,f),t(d,0,0,l,b),t(d,1,1,l,c),t(e,0,1,r,b),t(e,1,1,r,a),t(f,0,0,l,c),t(f,1,1,r,z)]). % macro(4)
monster(56,[t(a,0,1,r,b),t(a,1,0,l,b),t(b,0,1,l,a),t(b,1,1,l,c),t(c,0,1,l,b),t(c,1,0,r,d),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,1,r,f),t(e,1,0,r,a),t(f,0,0,r,c),t(f,1,1,l,c)]). % ?? Correct when all otters only go to non-zero case ... faster with macro(2) than with macro(4)
monster(57,[t(a,0,1,r,b),t(a,1,1,l,c),t(b,0,0,l,a),t(b,1,0,l,d),t(c,0,1,l,a),t(c,1,1,r,z),t(d,0,1,l,b),t(d,1,1,r,e),t(e,0,0,r,d),t(e,1,0,r,f),t(f,0,0,r,d),t(f,1,0,l,d)]). % macro(4)
monster(58,[t(a,0,1,r,b),t(a,1,1,l,c),t(b,0,0,l,a),t(b,1,0,l,d),t(c,0,1,l,a),t(c,1,1,r,z),t(d,0,1,l,b),t(d,1,1,r,e),t(e,0,0,r,d),t(e,1,0,r,f),t(f,0,0,r,f),t(f,1,0,l,d)]). % macro(4)
monster(59,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,1,r,d),t(c,0,1,r,d),t(c,1,1,l,c),t(d,0,1,r,e),t(d,1,1,l,f),t(e,0,0,r,a),t(e,1,1,r,b),t(f,0,1,r,z),t(f,1,0,l,d)]). % macro(4)
monster(60,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,1,r,d),t(c,0,0,l,b),t(c,1,0,l,e),t(d,0,1,r,a),t(d,1,0,r,b),t(e,0,1,l,f),t(e,1,1,l,c),t(f,0,0,l,a),t(f,1,1,r,z)]). % macro(4)
monster(61,[t(a,0,1,r,b),t(a,1,0,r,c),t(b,0,0,l,a),t(b,1,0,r,d),t(c,0,1,r,d),t(c,1,1,r,z),t(d,0,1,l,e),t(d,1,0,l,d),t(e,0,1,r,f),t(e,1,1,l,b),t(f,0,1,r,a),t(f,1,1,r,e)]). % macro(4)
monster(62,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,1,r,d),t(c,0,0,l,b),t(c,1,0,l,e),t(d,0,1,r,a),t(d,1,0,r,b),t(e,0,1,l,f),t(e,1,1,l,c),t(f,0,1,r,d),t(f,1,1,r,z)]). % macro(4)
monster(63,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,1,r,d),t(c,0,1,r,a),t(c,1,0,l,e),t(d,0,1,r,a),t(d,1,0,r,b),t(e,0,1,l,f),t(e,1,1,l,c),t(f,0,1,r,d),t(f,1,1,r,z)]). % macro(4)
monster(64,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,1,l,d),t(c,0,1,r,d),t(c,1,0,r,c),t(d,0,0,l,b),t(d,1,0,r,e),t(e,0,1,r,c),t(e,1,1,l,f),t(f,0,1,l,e),t(f,1,1,r,z)]). % macro(4)
monster(65,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,a),t(b,1,1,r,c),t(c,0,1,r,a),t(c,1,0,l,d),t(d,0,1,l,e),t(d,1,1,l,c),t(e,0,1,r,f),t(e,1,1,r,z),t(f,0,1,r,a),t(f,1,1,r,e)]). % macro(4)
monster(66,[t(a,0,1,r,b),t(a,1,0,l,b),t(b,0,1,l,c),t(b,1,0,r,e),t(c,0,1,r,e),t(c,1,0,l,d),t(d,0,1,l,a),t(d,1,1,l,a),t(e,0,0,r,a),t(e,1,0,r,f),t(f,0,1,r,e),t(f,1,1,r,z)]). % macro(4) about 24 seconds down to 8 seconds with history at 100
monster(67,[t(a,0,1,r,b),t(a,1,0,l,b),t(b,0,0,r,c),t(b,1,1,l,b),t(c,0,1,r,d),t(c,1,0,l,a),t(d,0,1,l,e),t(d,1,1,l,f),t(e,0,1,l,a),t(e,1,0,l,d),t(f,0,1,r,z),t(f,1,1,l,e)]). % this one is a prick! Terminates with macro(3)!! In about 440 seconds at home Seems much quicker with 3 than 6 finds a lot more otters with history at 1000, but much faster with history at 100. macro(3) history 100 takes about 136 seconds at work improves greatly with history at 300 rather than 120
monster(68,[t(a,0,1,r,b),t(a,1,0,l,f),t(b,0,0,r,c),t(b,1,0,r,d),t(c,0,1,l,d),t(c,1,1,r,e),t(d,0,0,l,e),t(d,1,0,l,d),t(e,0,0,r,a),t(e,1,1,r,c),t(f,0,1,l,a),t(f,1,1,r,z)]). % macro(6) in about 163 seconds at work with non-zero otter macro(2) in about 125 seconds macro(4) in about 170 seconds
% marxens machine #r
monster(69,[t(a,0,1,r,b),t(a,1,0,r,f),t(b,0,0,l,b),t(b,1,1,l,c),t(c,0,1,l,d),t(c,1,0,r,c),t(d,0,1,l,e),t(d,1,1,r,z),t(e,0,1,l,f),t(e,1,0,l,d),t(f,0,1,r,a),t(f,1,0,l,e)]). % Logicki #a  macro(6) in about 87 seconds at work. Values are my answers
monster(70,[t(a,0,1,r,b),t(a,1,0,l,e),t(b,0,1,l,c),t(b,1,0,r,a),t(c,0,1,l,d),t(c,1,0,r,c),t(d,0,1,l,e),t(d,1,0,l,f),t(e,0,1,l,a),t(e,1,1,l,c),t(f,0,1,l,e),t(f,1,1,r,z)]). % Logicki #b macro(4) in about 280 seconds. Values are my answers
monster(71,[t(a,0,1,r,b),t(a,1,0,l,d),t(b,0,1,r,c),t(b,1,0,r,f),t(c,0,1,l,c),t(c,1,1,l,a),t(d,0,0,l,e),t(d,1,1,r,z),t(e,0,1,l,a),t(e,1,0,r,b),t(f,0,0,r,c),t(f,1,0,r,e)]). % Kropitz #a  macro(?) in about 2616 seconds at work
monster(72,[t(a,0,1,r,b),t(a,1,1,l,e),t(b,0,1,r,c),t(b,1,1,r,f),t(c,0,1,l,d),t(c,1,0,r,b),t(d,0,1,r,e),t(d,1,0,l,c),t(e,0,1,l,a),t(e,1,0,r,d),t(f,0,1,r,z),t(f,1,1,r,c)]). % Kropitz macro(6) in about 890 seconds at work 
monster(73,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,0,l,c),t(a,3,0,r,a),t(b,0,3,l,c),t(b,1,2,r,c),t(b,2,1,l,b),t(b,3,0,r,c),t(c,0,1,r,a),t(c,1,0,l,b),t(c,2,1,r,z),t(c,3,0,r,b)]). % Ligockis 3x4 #a may need adaptive compression for this one ... 
monster(74,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,1,l,b),t(a,3,1,r,a),t(b,0,0,l,a),t(b,1,2,r,b),t(b,2,2,l,c),t(b,3,1,r,z),t(c,0,3,r,b),t(c,1,2,l,b),t(c,2,1,r,c),t(c,3,0,r,c)]). % Ligockis 3x4 #b macro(1)
monster(75,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,2,l,c),t(a,3,3,l,a),t(b,0,0,r,c),t(b,1,1,r,z),t(b,2,2,r,c),t(b,3,1,l,b),t(c,0,1,l,b),t(c,1,2,l,a),t(c,2,3,r,c),t(c,3,2,l,c)]). % Ligockis 3x4 #c macro(2) history 150
monster(76,[t(a,0,1,r,b),t(a,1,0,r,b),t(a,2,3,l,c),t(a,3,1,r,c),t(b,0,0,r,c),t(b,1,1,r,z),t(b,2,2,r,c),t(b,3,3,r,c),t(c,0,1,l,b),t(c,1,2,l,a),t(c,2,3,l,a),t(c,3,2,r,b)]). % Ligockis 3x4 #d
monster(77,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,3,r,c),t(a,3,1,r,a),t(b,0,2,r,c),t(b,1,1,l,a),t(b,2,1,r,z),t(b,3,2,r,b),t(c,0,1,l,c),t(c,1,1,r,b),t(c,2,1,l,b),t(c,3,2,r,a)]). % Ligockis 3x4 #e massive
monster(78,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,3,l,a),t(a,3,3,r,c),t(b,0,2,l,c),t(b,1,2,l,b),t(b,2,1,r,b),t(b,3,1,r,a),t(c,0,2,l,a),t(c,1,3,l,c),t(c,2,1,r,z),t(c,3,1,l,b)]). % Ligockis 3x4 #f massive
monster(79,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,2,r,a),t(a,3,1,l,a),t(b,0,2,l,a),t(b,1,1,r,c),t(b,2,0,l,b),t(b,3,2,r,a),t(c,0,1,r,b),t(c,1,3,l,c),t(c,2,1,l,a),t(c,3,1,r,z)]). % Ligockis 3x4 #g massive
monster(80,[t(a,0,1,r,b),t(a,1,1,r,a),t(a,2,1,l,b),t(a,3,1,r,c),t(b,0,2,l,a),t(b,1,0,l,b),t(b,2,3,l,c),t(b,3,1,r,z),t(c,0,1,l,b),t(c,1,0,r,c),t(c,2,2,r,a),t(c,3,2,r,c)]). % Ligockis 3x4 #h massive
monster(81,[t(a,0,1,r,b),t(a,1,1,r,a),t(a,2,2,l,b),t(a,3,3,l,a),t(b,0,2,l,a),t(b,1,0,l,b),t(b,2,1,l,c),t(b,3,1,l,b),t(c,0,3,r,b),t(c,1,3,r,c),t(c,2,1,r,z),t(c,3,1,l,c)]). % Ligockis 3x4 #i massive
% monster(82,[t(a,0,1,l,b),t(a,1,1,r,c),t(a,2,1,r,d),t(b,0,0,r,a),t(b,1,1,l,d),t(b,2,2,r,z),t(c,0,1,r,a),t(c,1,2,l,c),t(c,2,1,r,c),t(d,0,1,l,b),t(d,1,1,l,c),t(d,2,2,r,a)]). % Ligockis 4x3 #a reworked by me. This will have one less transition ...
monster(82,[t(a,0,1,r,b),t(a,1,1,l,c),t(a,2,1,l,d),t(b,0,0,l,a),t(b,1,1,r,d),t(b,2,2,r,z),t(c,0,1,l,a),t(c,1,2,r,c),t(c,2,1,l,c),t(d,0,1,r,b),t(d,1,1,r,c),t(d,2,2,l,a)]). % Ligockis 4x3 #a made orthodox by me. This will still have one less transition ... 
monster(83,[t(a,0,1,r,b),t(a,1,0,l,c),t(a,2,1,r,z),t(b,0,2,l,c),t(b,1,1,r,d),t(b,2,0,l,b),t(c,0,2,l,a),t(c,1,1,l,c),t(c,2,1,l,a),t(d,0,1,r,b),t(d,1,2,l,d),t(d,2,2,r,a)]). % Ligockis 4x3 #b massive
monster(84,[t(a,0,1,r,b),t(a,1,2,r,c),t(a,2,1,r,a),t(b,0,2,l,c),t(b,1,1,l,a),t(b,2,1,l,b),t(c,0,2,l,d),t(c,1,0,l,b),t(c,2,0,r,c),t(d,0,0,r,d),t(d,1,1,r,z),t(d,2,0,r,a)]). % Ligockis 4x3 #c massive
monster(85,[t(a,0,1,r,b),t(a,1,1,r,a),t(a,2,0,l,b),t(b,0,2,l,c),t(b,1,1,l,b),t(b,2,1,r,c),t(c,0,0,r,d),t(c,1,2,l,c),t(c,2,1,r,a),t(d,0,2,r,a),t(d,1,1,r,z),t(d,2,1,r,c)]). % Ligockis 4x3 #d massive
monster(86,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,1,r,d),t(b,0,2,l,c),t(b,1,0,r,a),t(b,2,1,l,b),t(c,0,2,l,a),t(c,1,0,l,b),t(c,2,0,r,d),t(d,0,2,r,c),t(d,1,1,r,z),t(d,2,0,l,c)]). % Ligockis 4x3 #e massive
monster(87,[t(a,0,1,r,b),t(a,1,2,l,d),t(a,2,1,r,z),t(b,0,2,l,c),t(b,1,2,r,c),t(b,2,2,r,b),t(c,0,1,l,d),t(c,1,0,r,c),t(c,2,1,r,c),t(d,0,2,l,a),t(d,1,2,l,d),t(d,2,0,l,b)]). % Ligockis 4x3 #f massive
monster(88,[t(a,0,1,r,b),t(a,1,1,l,d),t(a,2,1,r,z),t(b,0,1,r,c),t(b,1,2,l,b),t(b,2,2,l,d),t(c,0,1,l,c),t(c,1,2,r,a),t(c,2,0,r,d),t(d,0,1,r,c),t(d,1,1,l,a),t(d,2,0,l,a)]). % Ligockis 4x3 #g massive
monster(89,[t(a,0,1,r,b),t(a,1,0,l,b),t(a,2,1,r,d),t(b,0,2,r,c),t(b,1,2,l,a),t(b,2,0,l,a),t(c,0,1,l,b),t(c,1,0,l,a),t(c,2,0,l,a),t(d,0,1,r,a),t(d,1,0,r,a),t(d,2,1,r,z)]). % Ligockis 4x3 #h massive
monster(90,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,2,r,c),t(b,0,2,l,c),t(b,1,2,r,d),t(b,2,0,l,c),t(c,0,1,r,a),t(c,1,2,r,b),t(c,2,0,l,b),t(d,0,1,l,b),t(d,1,0,l,d),t(d,2,2,r,c)]). % Ligockis 4x3 #i massive
monster(91,[t(a,0,1,r,b),t(a,1,0,r,b),t(a,2,1,l,d),t(b,0,2,l,c),t(b,1,0,r,a),t(b,2,1,l,a),t(c,0,2,l,a),t(c,1,1,l,b),t(c,2,1,r,z),t(d,0,2,r,a),t(d,1,1,l,b),t(d,2,0,r,d)]). % Ligockis 4x3 #i reworked by me to avoid getting a blank tape after a few steps. This has 5 fewer steps (!!) then the other one. 
% monster(92,[t(a,0,5,r,b),t(a,1,5,r,a),t(a,2,3,r,z),t(a,3,1,r,b),t(a,4,3,l,a),t(a,5,1,l,a),t(b,0,4,l,b),t(b,1,1,r,b),t(b,2,4,r,z),t(b,3,2,r,a),t(b,4,5,l,b),t(b,5,5,l,a)]). % Ligockis 2x6 #a macro(1)
% monster(92,[t(a,0,1,r,b),t(a,5,1,r,a),t(a,2,3,r,z),t(a,3,5,r,b),t(a,4,3,l,a),t(a,1,5,l,a),t(b,0,4,l,b),t(b,5,5,r,b),t(b,2,4,r,z),t(b,3,2,r,a),t(b,4,1,l,b),t(b,1,1,l,a)]). % Ligockis 2x6 #a macro(1) with symbols 5 and 1 swapped by me. This changes the sorting ...
monster(92,[t(a,0,1,r,b),t(a,1,5,l,a),t(a,2,3,r,z),t(a,3,5,r,b),t(a,4,3,l,a),t(a,5,1,r,a),t(b,0,4,l,b),t(b,1,1,l,a),t(b,2,4,r,z),t(b,3,2,r,a),t(b,4,1,l,b),t(b,5,5,r,b)]). % Ligockis 2x6 #a macro(1) with symbols 5 and 1 swapped by me. This changes the sorting ...     
% monster(93,[t(a,0,4,r,b),t(a,1,4,r,a),t(a,2,4,r,a),t(a,3,1,l,a),t(a,4,1,l,a),t(a,5,1,l,b),t(b,0,4,l,b),t(b,1,2,r,b),t(b,2,5,l,b),t(b,3,3,r,a),t(b,4,3,l,a),t(b,5,1,r,z)]). % Ligockis 2x6 #b macro(1) 2,3,4 work
    % monster(93,[t(a,0,1,r,b),t(a,4,1,r,a),t(a,2,1,r,a),t(a,3,4,l,a),t(a,1,4,l,a),t(a,5,4,l,b),t(b,0,1,l,b),t(b,4,2,r,b),t(b,2,5,l,b),t(b,3,3,r,a),t(b,1,3,l,a),t(b,5,4,r,z)]). % Ligockis 2x6 #b macro(1) 2,3,4 work with symbols 4 and 1 swapped by me
monster(93,[t(a,0,1,r,b),t(a,1,4,l,a),t(a,2,1,r,a),t(a,3,4,l,a),t(a,4,1,r,a),t(a,5,4,l,b),t(b,0,1,l,b),t(b,1,3,l,a),t(b,2,5,l,b),t(b,3,3,r,a),t(b,4,2,r,b),t(b,5,4,r,z)]). % Ligockis 2x6 #b macro(1) 2,3,4 work as above after sorting
monster(94,[t(a,0,1,r,b),t(a,1,4,l,a),t(a,2,1,r,a),t(a,3,5,l,b),t(a,4,1,r,a),t(a,5,3,l,b),t(b,0,1,l,b),t(b,1,1,l,a),t(b,2,5,l,a),t(b,3,2,l,a),t(b,4,2,r,b),t(b,5,1,r,z)]). % Ligockis 2x6 #c macro(2), 1,3,4 work
monster(95,[t(a,0,1,r,b),t(a,1,0,r,b),t(a,2,3,l,a),t(a,3,5,l,a),t(a,4,1,r,z),t(a,5,4,l,b),t(b,0,1,l,a),t(b,1,2,r,b),t(b,2,3,l,a),t(b,3,4,l,b),t(b,4,3,r,b),t(b,5,3,r,a)]). % Ligockis 2x6 #d macro(1) 2,4 work
monster(96,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,4,r,b),t(a,3,1,l,a),t(a,4,1,r,b),t(a,5,1,r,z),t(b,0,1,l,a),t(b,1,3,r,a),t(b,2,5,r,a),t(b,3,4,l,b),t(b,4,0,r,a),t(b,5,4,l,a)]). % Ligockis 2x6 #e massive
monster(97,[t(a,0,1,r,b),t(a,1,1,l,b),t(a,2,3,r,a),t(a,3,4,l,a),t(a,4,2,l,a),t(a,5,4,l,b),t(b,0,2,l,a),t(b,1,2,r,b),t(b,2,3,l,b),t(b,3,1,l,a),t(b,4,5,r,a),t(b,5,1,r,z)]). % Ligockis 2x6 #f massive
monster(98,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,z),t(a,3,5,l,b),t(a,4,5,l,a),t(a,5,4,l,b),t(b,0,1,l,a),t(b,1,4,r,b),t(b,2,3,r,b),t(b,3,5,l,b),t(b,4,1,l,b),t(b,5,4,r,a)]). % Ligockis 2x6 #g massive
% monster(99, [t(a,0,1,l,d),t(a,1,1,l,b),t(b,0,1,l,z),t(b,1,1,l,a),t(c,0,0,l,b),t(c,1,1,l,d),t(d,0,0,l,e),t(d,1,0,l,d),t(e,0,1,l,f),t(e,1,1,r,c),t(f,0,0,l,g),t(f,1,0,l,f),t(g,0,1,r,g),t(g,1,1,r,e)]). % Green 7x2 from 1964 paper
monster(99, [t(a,0,1,r,b),t(a,1,1,r,d),t(b,0,0,r,e),t(b,1,0,r,b),t(c,0,0,r,d),t(c,1,1,r,b),t(d,0,1,r,z),t(d,1,1,r,a),t(e,0,1,r,f),t(e,1,1,l,c),t(f,0,0,r,g),t(f,1,0,r,f),t(g,0,1,l,g),t(g,1,1,l,e)]). % Green 7x2 from 1964 paper reworked by me.
% monster(100, [t(a,0,1,l,b),t(a,1,1,r,z),t(b,0,0,l,c),t(b,1,1,l,c),t(c,0,0,l,d),t(c,1,0,l,c),t(d,0,1,l,e),t(d,1,1,r,a),t(e,0,0,l,f),t(e,1,0,l,e),t(f,0,1,l,g),t(f,1,1,r,d),t(g,0,0,l,h),t(g,1,0,l,g),t(h,0,1,r,h),t(h,1,1,r,f)]). % Green 8x2 from 1964 paper
monster(100, [t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,0,r,c),t(b,1,1,r,c),t(c,0,0,r,d),t(c,1,0,r,c),t(d,0,1,r,e),t(d,1,1,l,a),t(e,0,0,r,f),t(e,1,0,r,e),t(f,0,1,r,g),t(f,1,1,l,d),t(g,0,0,r,h),t(g,1,0,r,g),t(h,0,1,l,h),t(h,1,1,l,f)]). % Green 8x2 from 1964 paper reworked by me
monster(101, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,0,l,d),t(d,0,0,r,b),t(d,1,1,l,e),t(e,0,1,r,z),t(e,1,0,r,b)]). % Michel survey 
monster(102, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,0,l,d),t(d,0,1,r,c),t(d,1,1,l,e),t(e,0,1,r,z),t(e,1,0,r,b)]). % Michel survey 
monster(103, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,0,l,c),t(b,1,0,r,c),t(c,0,1,r,z),t(c,1,1,r,d),t(d,0,1,l,e),t(d,1,0,l,a),t(e,0,1,l,a),t(e,1,1,l,e)]). % Michel survey 
monster(104, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,0,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,1,l,c),t(e,1,0,l,a)]). % Michel survey 
monster(105, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,0,l,d),t(d,0,0,r,b),t(d,1,1,l,e),t(e,0,1,r,z),t(e,1,1,l,c)]). % Michel survey 
monster(106, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,0,r,c),t(c,1,1,l,d),t(d,0,1,r,a),t(d,1,0,l,e),t(e,0,1,r,z),t(e,1,1,l,c)]). % Michel survey 
monster(107, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,0,l,d),t(d,0,1,r,c),t(d,1,1,l,e),t(e,0,1,r,z),t(e,1,1,l,c)]). % Michel survey 
monster(108, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,0,l,c),t(b,1,0,r,c),t(c,0,1,r,z),t(c,1,1,r,d),t(d,0,1,l,e),t(d,1,1,r,b),t(e,0,1,l,a),t(e,1,1,l,e)]). % Michel survey 
monster(109, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,1,l,d),t(d,0,0,r,e),t(d,1,0,l,e),t(e,0,1,r,z),t(e,1,1,l,c)]). % Michel survey 
monster(110, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,1,r,a),t(c,1,1,l,d),t(d,0,1,r,a),t(d,1,0,l,e),t(e,0,1,r,z),t(e,1,1,l,c)]). % Michel survey 
monster(111, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,0,l,e),t(e,1,0,r,b)]). % Michel survey 
monster(112, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,1,l,a),t(e,1,0,r,b)]). % Michel survey 
monster(113, [t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,1,l,c),t(d,0,1,r,z),t(d,1,1,r,e),t(e,0,1,r,a),t(e,1,0,r,b)]). % Michel survey 
monster(114, [t(a,0,1,r,b),t(a,1,1,r,d),t(b,0,1,l,c),t(b,1,0,l,e),t(c,0,0,r,a),t(c,1,0,l,b),t(d,0,1,r,e),t(d,1,1,r,z),t(e,0,1,l,c),t(e,1,1,r,c)]). % Michel survey reworked by me with one less transition.
% monster(114,  [t(a,0,0,r,b),t(a,1,0,l,c),t(b,0,1,r,c),t(b,1,1,r,d),t(c,0,1,l,a),t(c,1,0,l,e),t(d,0,1,r,e),t(d,1,1,r,z),t(e,0,1,l,a),t(e,1,1,r,a)]). % 2,358,065 1471   114
% monster(114a, [t(a,0,1,r,c),t(a,1,1,r,d),t(b,0,0,r,a),t(b,1,0,l,c),t(c,0,1,l,b),t(c,1,0,l,e),t(d,0,1,r,e),t(d,1,1,r,z),t(e,0,1,l,b),t(e,1,1,r,b)]). % 2,358,064 1471   114 with a and b swapped
% monster(114b, [t(a,0,1,r,b),t(a,1,1,r,d),t(b,0,1,l,c),t(b,1,0,l,e),t(c,0,0,r,a),t(c,1,0,l,b),t(d,0,1,r,e),t(d,1,1,r,z),t(e,0,1,l,c),t(e,1,1,r,c)]). % 2,358,064 1471   114a with b and c swapped
monster(115, [t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,1,l,c),t(b,1,1,r,c),t(c,0,0,r,e),t(c,1,0,l,d),t(d,0,1,l,c),t(d,1,0,l,b),t(e,0,1,r,d),t(e,1,1,r,a)]). % Michel survey 

monster(116,[t(a,0,0,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,2,r,b),t(b,2,1,r,c),t(c,0,1,r,z),t(c,1,1,l,b),t(c,2,1,l,c)]).
monster(117,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,1,r,z),t(b,0,0,l,c),t(b,1,2,r,b),t(b,2,1,l,b),t(c,0,1,r,a),t(c,1,1,l,c),t(c,2,2,l,c)]).
monster(118,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,2,l,a),t(b,0,1,l,b),t(b,1,1,r,c),t(b,2,1,r,z),t(c,0,1,l,a),t(c,1,2,r,c),t(c,2,1,l,c)]).
monster(119,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,2,l,a),t(b,0,2,r,c),t(b,1,1,r,c),t(b,2,1,r,z),t(c,0,1,l,a),t(c,1,2,r,c),t(c,2,1,l,c)]).
monster(120,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,2,l,c),t(b,0,2,l,a),t(b,1,2,r,b),t(b,2,1,r,b),t(c,0,1,r,z),t(c,1,0,l,b),t(c,2,0,r,c)]).
monster(121,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,2,l,c),t(b,0,1,l,c),t(b,1,2,r,b),t(b,2,1,l,b),t(c,0,1,l,a),t(c,1,2,r,c),t(c,2,2,l,a)]).
monster(122,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,l,a),t(b,0,2,l,a),t(b,1,1,r,c),t(b,2,2,r,b),t(c,0,1,r,z),t(c,1,0,l,c),t(c,2,0,r,a)]).
monster(123,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,b),t(b,1,1,l,a),t(b,2,2,r,c),t(c,0,1,r,z),t(c,1,1,l,a),t(c,2,2,r,b)]).
monster(124,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,c),t(b,1,1,l,a),t(b,2,2,r,c),t(c,0,1,r,z),t(c,1,1,l,a),t(c,2,2,r,b)]).
monster(125,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,c),t(b,1,2,r,b),t(b,2,1,r,c),t(c,0,1,r,z),t(c,1,1,l,a),t(c,2,1,l,b)]).
monster(126,[t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,1,l,a),t(b,0,2,l,a),t(b,1,2,l,b),t(b,2,2,r,c),t(c,0,1,r,z),t(c,1,2,r,b),t(c,2,1,r,b)]).

monster(127,[t(a,0,1,r,b),t(a,1,0,r,a),t(a,2,3,l,b),t(a,3,1,l,b),t(a,4,1,r,z),t(b,0,2,l,a),t(b,1,3,r,b),t(b,2,4,r,b),t(b,3,3,r,a),t(b,4,0,l,a)]).
monster(128,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,2,r,a),t(a,3,4,l,b),t(a,4,1,r,a),t(b,0,1,l,a),t(b,1,3,r,a),t(b,2,3,l,a),t(b,3,4,l,a),t(b,4,1,r,z)]).
monster(129,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,4,l,b),t(a,3,3,l,a),t(a,4,1,r,z),t(b,0,1,l,a),t(b,1,3,r,a),t(b,2,3,l,b),t(b,3,0,l,b),t(b,4,0,r,a)]).
monster(130,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,4,r,b),t(a,3,2,r,b),t(a,4,1,r,z),t(b,0,1,l,a),t(b,1,3,r,a),t(b,2,4,r,a),t(b,3,3,l,b),t(b,4,1,l,b)]).
monster(131,[t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,3,l,a),t(a,3,4,l,a),t(a,4,2,r,b),t(b,0,2,l,a),t(b,1,1,r,z),t(b,2,1,l,a),t(b,3,1,r,a),t(b,4,3,r,a)]).
monster(132,[t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,3,l,a),t(a,3,4,r,b),t(a,4,1,r,z),t(b,0,2,l,a),t(b,1,3,r,b),t(b,2,3,r,a),t(b,3,1,l,b),t(b,4,3,l,b)]).
monster(133,[t(a,0,1,r,b),t(a,1,2,r,b),t(a,2,4,l,b),t(a,3,2,l,b),t(a,4,1,r,z),t(b,0,2,l,a),t(b,1,0,l,a),t(b,2,3,r,b),t(b,3,0,l,a),t(b,4,2,r,a)]).
monster(134,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,-,-,-),t(a,3,4,r,b),t(a,4,0,l,b),t(b,0,2,l,a),t(b,1,3,l,b),t(b,2,4,l,a),t(b,3,1,r,b),t(b,4,3,r,a)]).
monster(135,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,l,a),t(a,3,2,l,a),t(a,4,1,r,a),t(b,0,2,l,b),t(b,1,3,r,a),t(b,2,2,r,b),t(b,3,4,r,b),t(b,4,1,r,z)]).
monster(136,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,4,l,a),t(a,3,2,r,b),t(a,4,1,l,a),t(b,0,2,l,a),t(b,1,4,r,b),t(b,2,1,r,z),t(b,3,3,r,a),t(b,4,3,l,a)]).
monster(137,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,4,r,b),t(a,3,0,r,b),t(a,4,2,l,a),t(b,0,1,l,b),t(b,1,2,l,a),t(b,2,3,l,a),t(b,3,1,r,a),t(b,4,1,r,z)]).

monster(138,[t(a,0,1,r,b),t(a,1,0,r,a),t(a,2,3,r,b),t(a,3,0,l,b),t(a,4,1,r,a),t(a,5,2,l,a),t(b,0,2,l,a),t(b,1,4,l,b),t(b,2,1,r,a),t(b,3,3,l,b),t(b,4,5,l,b),t(b,5,1,r,z)]).
monster(139,[t(a,0,1,r,b),t(a,1,0,r,a),t(a,2,3,r,b),t(a,3,0,l,b),t(a,4,5,l,a),t(a,5,2,l,a),t(b,0,2,l,a),t(b,1,4,l,b),t(b,2,1,r,a),t(b,3,3,l,b),t(b,4,5,l,b),t(b,5,1,r,z)]).
monster(140,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(a,3,4,l,a),t(a,4,5,r,a),t(a,5,0,l,b),t(b,0,1,l,a),t(b,1,3,r,a),t(b,2,2,r,b),t(b,3,1,r,z),t(b,4,3,r,b),t(b,5,4,l,a)]).
monster(141,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,z),t(a,3,1,r,b),t(a,4,5,r,b),t(a,5,0,r,b),t(b,0,2,l,a),t(b,1,4,r,a),t(b,2,3,l,b),t(b,3,5,l,b),t(b,4,5,r,a),t(b,5,4,l,b)]).
monster(142,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,5,l,b),t(a,3,0,r,a),t(a,4,1,r,a),t(a,5,3,l,b),t(b,0,1,l,a),t(b,1,4,l,a),t(b,2,3,l,b),t(b,3,3,r,b),t(b,4,3,r,b),t(b,5,1,r,z)]).
monster(143,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,0,r,a),t(a,3,2,r,a),t(a,4,5,r,a),t(a,5,1,l,b),t(b,0,2,l,a),t(b,1,4,r,b),t(b,2,3,l,b),t(b,3,2,r,b),t(b,4,0,r,b),t(b,5,1,r,z)]).
monster(144,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,1,r,z),t(a,3,3,l,a),t(a,4,2,l,a),t(a,5,4,r,b),t(b,0,1,l,a),t(b,1,3,r,b),t(b,2,4,r,b),t(b,3,1,l,b),t(b,4,5,l,b),t(b,5,0,r,a)]).
monster(145,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,3,l,a),t(a,3,1,r,a),t(a,4,0,r,a),t(a,5,1,r,z),t(b,0,1,l,a),t(b,1,2,r,b),t(b,2,1,l,b),t(b,3,4,r,b),t(b,4,5,r,a),t(b,5,3,l,a)]).
monster(146,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,3,r,a),t(a,3,4,l,b),t(a,4,2,l,b),t(a,5,0,l,a),t(b,0,2,l,a),t(b,1,5,l,b),t(b,2,2,r,b),t(b,3,0,r,a),t(b,4,0,r,a),t(b,5,1,r,z)]).
monster(147,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,4,l,b),t(a,3,0,r,b),t(a,4,1,r,a),t(a,5,3,l,a),t(b,0,2,l,a),t(b,1,2,r,a),t(b,2,4,l,a),t(b,3,1,r,a),t(b,4,5,r,b),t(b,5,1,r,z)]).
monster(148,[t(a,0,1,r,b),t(a,1,3,l,b),t(a,2,0,r,b),t(a,3,5,r,a),t(a,4,1,l,b),t(a,5,1,r,z),t(b,0,2,l,b),t(b,1,3,l,a),t(b,2,4,r,a),t(b,3,0,r,b),t(b,4,0,r,a),t(b,5,2,l,b)]).
monster(149,[t(a,0,1,r,b),t(a,1,3,l,b),t(a,2,3,r,b),t(a,3,4,l,a),t(a,4,2,l,a),t(a,5,4,l,a),t(b,0,2,l,a),t(b,1,2,r,b),t(b,2,1,l,b),t(b,3,0,r,a),t(b,4,5,r,a),t(b,5,1,r,z)]).
monster(150,[t(a,0,1,r,b),t(a,1,3,r,a),t(a,2,4,l,a),t(a,3,1,l,a),t(a,4,0,l,a),t(a,5,1,r,z),t(b,0,2,l,a),t(b,1,0,l,b),t(b,2,1,r,a),t(b,3,1,l,b),t(b,4,5,l,b),t(b,5,2,r,a)]).
monster(151,[t(a,0,1,r,b),t(a,1,3,r,a),t(a,2,4,l,b),t(a,3,5,r,a),t(a,4,5,l,b),t(a,5,4,r,a),t(b,0,2,l,a),t(b,1,1,r,z),t(b,2,1,r,b),t(b,3,2,l,a),t(b,4,5,l,a),t(b,5,0,l,a)]).
monster(152,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,1,l,b),t(a,3,5,l,a),t(a,4,2,l,b),t(a,5,1,r,z),t(b,0,2,l,a),t(b,1,3,r,a),t(b,2,4,r,b),t(b,3,2,l,b),t(b,4,0,l,a),t(b,5,4,r,b)]).
monster(153,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,5,l,a),t(a,3,1,l,a),t(a,4,2,r,a),t(a,5,3,l,a),t(b,0,2,l,a),t(b,1,3,r,a),t(b,2,2,l,b),t(b,3,4,l,b),t(b,4,1,r,z),t(b,5,0,r,a)]).
monster(154,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,5,l,a),t(a,3,1,l,a),t(a,4,2,r,a),t(a,5,3,l,a),t(b,0,2,l,a),t(b,1,3,r,a),t(b,2,2,l,b),t(b,3,4,l,b),t(b,4,1,r,z),t(b,5,1,l,a)]).
monster(155,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,5,l,a),t(a,3,1,l,a),t(a,4,2,r,a),t(a,5,3,l,a),t(b,0,2,l,a),t(b,1,3,r,a),t(b,2,2,l,b),t(b,3,4,l,b),t(b,4,1,r,z),t(b,5,2,l,a)]).
monster(156,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,5,l,a),t(a,3,1,l,a),t(a,4,2,r,a),t(a,5,3,l,a),t(b,0,2,l,a),t(b,1,3,r,a),t(b,2,2,l,b),t(b,3,4,l,b),t(b,4,1,r,z),t(b,5,3,r,a)]).
monster(157,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,5,r,a),t(a,3,1,l,b),t(a,4,5,l,a),t(a,5,2,l,b),t(b,0,2,l,a),t(b,1,2,r,a),t(b,2,4,r,b),t(b,3,1,r,z),t(b,4,3,l,b),t(b,5,2,l,a)]).

monster(158,[t(a,0,1,r,b),t(a,1,0,l,b),t(a,2,1,r,a),t(a,3,2,l,b),t(b,0,2,r,c),t(b,1,3,l,b),t(b,2,3,r,b),t(b,3,2,l,a),t(c,0,2,l,c),t(c,1,1,r,z),t(c,2,1,l,a),t(c,3,2,r,b)]).
monster(159,[t(a,0,1,r,b),t(a,1,0,l,b),t(a,2,1,r,z),t(a,3,3,l,a),t(b,0,0,l,c),t(b,1,3,r,b),t(b,2,3,r,c),t(b,3,1,l,b),t(c,0,2,r,b),t(c,1,2,l,a),t(c,2,3,r,a),t(c,3,1,l,c)]).
monster(160,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,1,r,z),t(a,3,0,l,b),t(b,0,2,l,c),t(b,1,2,l,b),t(b,2,1,r,c),t(b,3,1,r,b),t(c,0,3,l,a),t(c,1,3,l,c),t(c,2,0,l,c),t(c,3,0,r,a)]).
monster(161,[t(a,0,1,r,b),t(a,1,1,l,b),t(a,2,2,l,a),t(a,3,3,l,c),t(b,0,1,l,a),t(b,1,2,r,b),t(b,2,3,r,a),t(b,3,1,l,b),t(c,0,1,r,z),t(c,1,1,r,b),t(c,2,2,l,b),t(c,3,3,l,b)]).
monster(162,[t(a,0,1,r,b),t(a,1,1,r,a),t(a,2,1,l,b),t(a,3,3,r,a),t(b,0,1,r,c),t(b,1,3,l,b),t(b,2,1,l,c),t(b,3,1,r,c),t(c,0,2,l,a),t(c,1,2,r,a),t(c,2,1,r,z),t(c,3,0,l,a)]).
monster(163,[t(a,0,1,r,b),t(a,1,1,r,a),t(a,2,1,l,b),t(a,3,3,r,a),t(b,0,1,r,c),t(b,1,3,l,b),t(b,2,1,l,c),t(b,3,1,r,c),t(c,0,2,l,a),t(c,1,2,r,a),t(c,2,1,r,z),t(c,3,1,r,b)]).
monster(164,[t(a,0,1,r,b),t(a,1,1,r,a),t(a,2,3,l,a),t(a,3,3,r,b),t(b,0,2,l,c),t(b,1,2,r,c),t(b,2,1,l,b),t(b,3,2,r,a),t(c,0,2,r,a),t(c,1,2,r,b),t(c,2,0,l,b),t(c,3,1,r,z)]).
monster(165,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,1,l,a),t(a,3,2,r,b),t(b,0,1,r,c),t(b,1,3,r,c),t(b,2,1,l,a),t(b,3,2,l,b),t(c,0,2,l,b),t(c,1,2,r,c),t(c,2,1,l,c),t(c,3,3,r,b)]).
monster(166,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,1,l,a),t(a,3,2,r,b),t(b,0,2,r,c),t(b,1,3,r,c),t(b,2,3,l,b),t(b,3,2,r,a),t(c,0,2,l,b),t(c,1,3,r,b),t(c,2,3,l,c),t(c,3,1,l,a)]).
monster(167,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(a,3,1,r,c),t(b,0,1,l,a),t(b,1,3,l,c),t(b,2,3,r,b),t(b,3,1,r,c),t(c,0,3,l,a),t(c,1,1,r,z),t(c,2,3,l,b),t(c,3,2,r,c)]).
monster(168,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,1,r,z),t(a,3,3,l,a),t(b,0,1,l,a),t(b,1,3,r,c),t(b,2,2,l,c),t(b,3,1,l,c),t(c,0,2,l,a),t(c,1,3,r,c),t(c,2,0,r,a),t(c,3,1,l,b)]).
monster(169,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,1,r,z),t(a,3,3,l,a),t(b,0,1,l,a),t(b,1,3,r,c),t(b,2,3,l,b),t(b,3,1,l,c),t(c,0,2,r,a),t(c,1,3,r,c),t(c,2,0,r,a),t(c,3,1,l,b)]).
monster(170,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,c),t(a,3,2,r,a),t(b,0,1,l,a),t(b,1,3,r,a),t(b,2,2,r,b),t(b,3,1,r,z),t(c,0,3,l,b),t(c,1,2,l,c),t(c,2,1,r,a),t(c,3,0,l,b)]).
monster(171,[t(a,0,1,r,b),t(a,1,2,r,a),t(a,2,1,l,a),t(a,3,1,l,b),t(b,0,2,r,c),t(b,1,3,r,b),t(b,2,1,r,z),t(b,3,3,l,c),t(c,0,2,l,a),t(c,1,1,r,c),t(c,2,1,r,b),t(c,3,0,r,a)]).
monster(172,[t(a,0,1,r,b),t(a,1,3,l,a),t(a,2,1,r,a),t(a,3,2,l,b),t(b,0,2,l,c),t(b,1,1,r,a),t(b,2,2,r,c),t(b,3,3,r,b),t(c,0,1,r,z),t(c,1,1,l,a),t(c,2,2,r,a),t(c,3,3,r,a)]).
monster(173,[t(a,0,1,r,b),t(a,1,3,l,b),t(a,2,1,r,z),t(a,3,2,r,a),t(b,0,2,l,c),t(b,1,3,r,b),t(b,2,1,l,c),t(b,3,2,r,a),t(c,0,3,r,b),t(c,1,1,l,b),t(c,2,3,l,c),t(c,3,2,r,c)]).
monster(174,[t(a,0,1,r,b),t(a,1,3,l,c),t(a,2,0,r,a),t(a,3,1,r,c),t(b,0,2,l,a),t(b,1,1,r,z),t(b,2,3,l,a),t(b,3,2,r,b),t(c,0,3,l,a),t(c,1,0,r,a),t(c,2,1,l,a),t(c,3,0,r,a)]).
monster(175,[t(a,0,1,r,b),t(a,1,3,l,c),t(a,2,0,r,a),t(a,3,1,r,c),t(b,0,2,l,a),t(b,1,1,r,z),t(b,2,3,l,a),t(b,3,2,r,b),t(c,0,3,l,a),t(c,1,0,r,a),t(c,2,3,l,b),t(c,3,0,r,a)]).
monster(176,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,1,l,c),t(a,3,2,l,a),t(b,0,2,l,a),t(b,1,2,r,b),t(b,2,1,l,b),t(b,3,3,r,a),t(c,0,1,r,a),t(c,1,1,r,z),t(c,2,1,l,c),t(c,3,2,r,a)]).
monster(177,[t(a,0,1,r,b),t(a,1,3,r,b),t(a,2,1,l,c),t(a,3,2,l,a),t(b,0,2,l,a),t(b,1,2,r,b),t(b,2,1,l,b),t(b,3,3,r,a),t(c,0,3,l,a),t(c,1,1,r,z),t(c,2,1,l,c),t(c,3,2,r,a)]).

monster(178,[t(a,0,0,r,b),t(a,1,1,r,z),t(a,2,0,r,b),t(b,0,1,r,c),t(b,1,1,l,b),t(b,2,2,l,b),t(c,0,1,l,b),t(c,1,2,r,d),t(c,2,1,l,c),t(d,0,1,r,a),t(d,1,2,r,c),t(d,2,0,l,d)]).
monster(179,[t(a,0,1,r,b),t(a,1,0,l,c),t(a,2,1,r,c),t(b,0,1,l,a),t(b,1,2,r,b),t(b,2,1,l,b),t(c,0,1,r,c),t(c,1,2,l,a),t(c,2,0,r,d),t(d,0,2,l,b),t(d,1,1,r,z),t(d,2,2,l,c)]).
monster(180,[t(a,0,1,r,b),t(a,1,0,l,c),t(a,2,1,r,d),t(b,0,1,r,c),t(b,1,1,l,d),t(b,2,0,r,a),t(c,0,2,l,a),t(c,1,0,r,c),t(c,2,1,r,b),t(d,0,0,l,b),t(d,1,2,l,b),t(d,2,1,r,z)]).
monster(181,[t(a,0,1,r,b),t(a,1,0,r,b),t(a,2,1,l,c),t(b,0,2,l,c),t(b,1,0,l,d),t(b,2,1,r,a),t(c,0,2,r,b),t(c,1,2,l,d),t(c,2,1,r,z),t(d,0,2,l,a),t(d,1,2,l,b),t(d,2,0,l,d)]).
monster(182,[t(a,0,1,r,b),t(a,1,0,r,c),t(a,2,1,l,b),t(b,0,2,l,c),t(b,1,2,r,d),t(b,2,1,l,c),t(c,0,1,r,c),t(c,1,0,l,c),t(c,2,1,l,b),t(d,0,1,r,z),t(d,1,1,r,a),t(d,2,-,-,-)]).
monster(183,[t(a,0,1,r,b),t(a,1,0,r,c),t(a,2,2,l,b),t(b,0,2,l,c),t(b,1,2,r,d),t(b,2,1,l,c),t(c,0,1,r,c),t(c,1,0,l,c),t(c,2,1,l,b),t(d,0,1,r,z),t(d,1,1,r,a),t(d,2,1,r,a)]).
monster(184,[t(a,0,1,r,b),t(a,1,0,r,c),t(a,2,2,l,b),t(b,0,2,l,c),t(b,1,2,r,d),t(b,2,1,l,c),t(c,0,1,r,c),t(c,1,0,l,c),t(c,2,1,l,b),t(d,0,1,r,z),t(d,1,2,l,d),t(d,2,1,r,a)]).
monster(185,[t(a,0,1,r,b),t(a,1,1,l,a),t(a,2,1,r,d),t(b,0,2,l,a),t(b,1,0,l,c),t(b,2,2,l,d),t(c,0,1,r,z),t(c,1,2,r,a),t(c,2,2,l,b),t(d,0,0,l,c),t(d,1,2,r,c),t(d,2,1,r,a)]).
monster(186,[t(a,0,1,r,b),t(a,1,1,l,d),t(a,2,0,r,c),t(b,0,2,l,c),t(b,1,0,r,b),t(b,2,1,r,a),t(c,0,1,r,a),t(c,1,0,l,b),t(c,2,1,r,d),t(d,0,0,l,a),t(d,1,2,l,a),t(d,2,1,r,z)]).
monster(187,[t(a,0,1,r,b),t(a,1,1,l,d),t(a,2,2,l,a),t(b,0,0,r,c),t(b,1,1,r,z),t(b,2,0,r,a),t(c,0,1,l,d),t(c,1,2,l,a),t(c,2,0,l,c),t(d,0,2,r,d),t(d,1,2,r,c),t(d,2,0,l,d)]).
monster(188,[t(a,0,1,r,b),t(a,1,1,r,c),t(a,2,1,r,b),t(b,0,1,l,c),t(b,1,0,r,a),t(b,2,2,l,d),t(c,0,2,r,a),t(c,1,0,l,d),t(c,2,1,r,z),t(d,0,0,l,b),t(d,1,2,l,d),t(d,2,1,r,d)]).
monster(189,[t(a,0,1,r,b),t(a,1,1,r,d),t(a,2,1,l,c),t(b,0,2,l,b),t(b,1,1,r,b),t(b,2,1,l,c),t(c,0,1,r,z),t(c,1,1,l,a),t(c,2,1,l,d),t(d,0,0,r,b),t(d,1,2,r,a),t(d,2,2,r,d)]).
monster(190,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,0,r,c),t(b,0,1,r,c),t(b,1,1,r,a),t(b,2,0,l,d),t(c,0,2,r,d),t(c,1,2,r,b),t(c,2,0,r,d),t(d,0,1,l,b),t(d,1,2,l,d),t(d,2,2,r,a)]).
monster(191,[t(a,0,1,r,b),t(a,1,1,r,z),t(a,2,2,r,d),t(b,0,1,l,c),t(b,1,0,r,d),t(b,2,0,r,c),t(c,0,2,l,c),t(c,1,1,l,a),t(c,2,0,r,b),t(d,0,2,r,c),t(d,1,0,r,c),t(d,2,2,r,a)]).
monster(192,[t(a,0,1,r,b),t(a,1,2,l,a),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,0,r,c),t(b,2,1,l,c),t(c,0,1,l,c),t(c,1,2,r,b),t(c,2,0,l,d),t(d,0,2,r,a),t(d,1,1,r,z),t(d,2,2,r,c)]).
monster(193,[t(a,0,1,r,b),t(a,1,2,l,b),t(a,2,0,l,b),t(b,0,2,l,c),t(b,1,2,l,a),t(b,2,0,l,a),t(c,0,2,r,d),t(c,1,1,l,c),t(c,2,1,r,z),t(d,0,1,r,a),t(d,1,2,l,d),t(d,2,1,r,d)]).
monster(194,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,0,r,d),t(b,2,2,r,b),t(c,0,2,l,d),t(c,1,0,r,c),t(c,2,2,l,d),t(d,0,2,l,a),t(d,1,1,r,z),t(d,2,0,r,d)]).
monster(195,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,0,r,d),t(b,2,2,r,b),t(c,0,2,l,d),t(c,1,2,l,a),t(c,2,2,l,d),t(d,0,2,l,a),t(d,1,1,r,z),t(d,2,0,r,d)]).
monster(196,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,2,l,d),t(b,2,2,r,b),t(c,0,2,l,d),t(c,1,0,r,c),t(c,2,2,l,d),t(d,0,2,l,a),t(d,1,1,r,z),t(d,2,0,r,d)]).
monster(197,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,2,l,d),t(b,2,2,r,b),t(c,0,2,l,d),t(c,1,2,l,a),t(c,2,1,l,b),t(d,0,2,l,a),t(d,1,1,r,z),t(d,2,0,r,d)]).
monster(198,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,a),t(b,0,1,l,a),t(b,1,2,l,d),t(b,2,2,r,b),t(c,0,2,l,d),t(c,1,2,l,a),t(c,2,2,l,d),t(d,0,2,l,a),t(d,1,1,r,z),t(d,2,0,r,d)]).
monster(199,[t(a,0,1,r,b),t(a,1,2,l,c),t(a,2,1,r,a),t(b,0,2,r,c),t(b,1,1,l,b),t(b,2,2,r,d),t(c,0,1,l,d),t(c,1,2,l,a),t(c,2,0,l,b),t(d,0,0,l,a),t(d,1,1,r,z),t(d,2,0,l,c)]).

monster(200,[t(a,0,1,r,b),t(a,1,0,l,a),t(b,0,1,l,c),t(b,1,1,l,f),t(c,0,0,l,d),t(c,1,0,l,c),t(d,0,0,l,e),t(d,1,0,l,b),t(e,0,1,r,e),t(e,1,0,r,a),t(f,0,1,r,z),t(f,1,1,l,d)]).
monster(201,[t(a,0,1,r,b),t(a,1,0,l,d),t(b,0,1,r,c),t(b,1,0,r,f),t(c,0,1,l,c),t(c,1,1,l,a),t(d,0,0,l,e),t(d,1,1,r,z),t(e,0,1,l,f),t(e,1,0,r,b),t(f,0,0,r,c),t(f,1,0,r,e)]).
monster(202,[t(a,0,1,r,b),t(a,1,0,l,e),t(b,0,0,r,c),t(b,1,1,r,a),t(c,0,0,l,d),t(c,1,1,r,f),t(d,0,1,r,e),t(d,1,0,r,b),t(e,0,1,l,a),t(e,1,0,l,c),t(f,0,0,r,d),t(f,1,1,r,z)]).
monster(203,[t(a,0,1,r,b),t(a,1,0,l,e),t(b,0,1,l,c),t(b,1,1,r,a),t(c,0,1,r,e),t(c,1,0,l,d),t(d,0,1,l,c),t(d,1,1,l,f),t(e,0,1,l,a),t(e,1,0,r,c),t(f,0,1,r,z),t(f,1,1,l,c)]).
monster(204,[t(a,0,1,r,b),t(a,1,0,l,f),t(b,0,1,l,c),t(b,1,0,r,a),t(c,0,1,r,d),t(c,1,0,l,b),t(d,0,1,l,e),t(d,1,1,r,c),t(e,0,1,r,z),t(e,1,1,l,a),t(f,0,1,l,a),t(f,1,1,l,e)]).
monster(205,[t(a,0,1,r,b),t(a,1,0,l,f),t(b,0,1,r,c),t(b,1,1,r,b),t(c,0,1,l,d),t(c,1,0,r,a),t(d,0,1,l,b),t(d,1,0,l,e),t(e,0,1,r,z),t(e,1,0,l,c),t(f,0,1,l,a),t(f,1,1,l,f)]).
monster(206,[t(a,0,1,r,b),t(a,1,0,l,f),t(b,0,1,r,c),t(b,1,1,r,b),t(c,0,1,l,d),t(c,1,0,r,a),t(d,0,1,l,f),t(d,1,0,l,e),t(e,0,1,r,z),t(e,1,0,l,c),t(f,0,1,l,a),t(f,1,1,l,f)]).
monster(207,[t(a,0,1,r,b),t(a,1,0,l,f),t(b,0,1,r,c),t(b,1,1,r,b),t(c,0,1,l,d),t(c,1,0,r,a),t(d,0,1,r,f),t(d,1,0,l,e),t(e,0,1,r,z),t(e,1,0,l,c),t(f,0,1,l,a),t(f,1,1,l,f)]).
monster(208,[t(a,0,1,r,b),t(a,1,0,r,b),t(b,0,0,r,c),t(b,1,0,l,f),t(c,0,0,r,d),t(c,1,0,r,a),t(d,0,0,l,e),t(d,1,-,-,-),t(e,0,1,l,e),t(e,1,0,l,a),t(f,0,1,l,f),t(f,1,1,r,a)]).
monster(209,[t(a,0,1,r,b),t(a,1,0,r,f),t(b,0,1,l,c),t(b,1,0,r,a),t(c,0,1,r,z),t(c,1,0,l,d),t(d,0,1,l,e),t(d,1,1,l,d),t(e,0,1,r,b),t(e,1,1,r,c),t(f,0,0,l,d),t(f,1,0,r,e)]).
monster(210,[t(a,0,1,r,b),t(a,1,0,r,f),t(b,0,1,l,c),t(b,1,1,l,b),t(c,0,0,r,e),t(c,1,0,l,d),t(d,0,0,l,c),t(d,1,0,l,b),t(e,0,0,r,a),t(e,1,1,r,e),t(f,0,0,r,d),t(f,1,1,r,z)]).
monster(211,[t(a,0,1,r,b),t(a,1,0,r,f),t(b,0,1,l,c),t(b,1,1,r,b),t(c,0,0,r,d),t(c,1,0,l,b),t(d,0,1,r,z),t(d,1,0,l,e),t(e,0,1,r,e),t(e,1,0,r,a),t(f,0,1,r,d),t(f,1,1,r,e)]).
monster(212,[t(a,0,1,r,b),t(a,1,1,l,a),t(b,0,1,l,c),t(b,1,0,r,f),t(c,0,1,l,d),t(c,1,1,l,c),t(d,0,1,l,e),t(d,1,0,r,e),t(e,0,0,r,b),t(e,1,0,l,c),t(f,0,1,r,z),t(f,1,1,r,a)]).
monster(213,[t(a,0,1,r,b),t(a,1,1,l,c),t(b,0,1,l,a),t(b,1,1,r,e),t(c,0,0,r,d),t(c,1,0,l,a),t(d,0,1,r,z),t(d,1,1,l,b),t(e,0,1,l,d),t(e,1,0,r,f),t(f,0,0,r,d),t(f,1,1,r,b)]).
monster(214,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,l,c),t(b,1,1,l,e),t(c,0,1,r,e),t(c,1,0,l,d),t(d,0,1,l,c),t(d,1,0,l,f),t(e,0,1,r,z),t(e,1,0,r,a),t(f,0,0,r,a),t(f,1,0,l,b)]).
monster(215,[t(a,0,1,r,b),t(a,1,1,r,a),t(b,0,1,r,c),t(b,1,1,r,z),t(c,0,1,l,d),t(c,1,0,r,f),t(d,0,1,r,a),t(d,1,0,l,e),t(e,0,0,l,d),t(e,1,1,r,c),t(f,0,1,r,a),t(f,1,0,r,e)]).
monster(216,[t(a,0,1,r,b),t(a,1,1,r,c),t(b,0,1,l,c),t(b,1,1,r,e),t(c,0,1,l,d),t(c,1,0,l,b),t(d,0,1,r,e),t(d,1,1,l,c),t(e,0,1,l,e),t(e,1,0,r,f),t(f,0,1,r,z),t(f,1,1,r,a)]).
monster(217,[t(a,0,1,r,b),t(a,1,1,r,e),t(b,0,1,l,c),t(b,1,1,l,f),t(c,0,1,r,d),t(c,1,0,l,b),t(d,0,1,l,e),t(d,1,0,r,c),t(e,0,1,r,a),t(e,1,0,l,d),t(f,0,1,r,z),t(f,1,1,l,c)]).
monster(218,[t(a,0,1,r,b),t(a,1,1,r,f),t(b,0,1,l,c),t(b,1,1,r,e),t(c,0,0,l,d),t(c,1,1,l,b),t(d,0,1,l,a),t(d,1,0,r,a),t(e,0,0,r,a),t(e,1,0,r,b),t(f,0,1,r,z),t(f,1,0,r,d)]).
monster(219,[t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,0,l,c),t(b,1,0,l,d),t(c,0,1,l,d),t(c,1,1,l,c),t(d,0,1,r,e),t(d,1,1,l,b),t(e,0,1,r,f),t(e,1,1,r,d),t(f,0,0,l,d),t(f,1,0,r,a)]).

monster(220,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,c),t(b,1,0,l,d),t(c,0,1,l,a),t(c,1,1,l,b),t(d,0,0,l,g),t(d,1,1,r,e),t(e,0,1,l,d),t(e,1,0,r,f),t(f,0,0,r,a),t(f,1,1,r,e),t(g,0,1,r,z),t(g,1,1,l,c)]).
monster(221,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,l,c),t(b,1,1,l,d),t(c,0,1,l,a),t(c,1,1,l,b),t(d,0,0,l,g),t(d,1,1,r,e),t(e,0,1,l,d),t(e,1,0,r,f),t(f,0,0,r,a),t(f,1,1,r,e),t(g,0,1,r,z),t(g,1,1,l,a)]).
monster(222,[t(a,0,1,r,b),t(a,1,0,l,c),t(b,0,1,r,c),t(b,1,0,r,g),t(c,0,1,r,d),t(c,1,0,l,f),t(d,0,1,r,e),t(d,1,0,r,f),t(e,0,1,l,a),t(e,1,1,r,g),t(f,0,1,l,e),t(f,1,1,l,f),t(g,0,1,r,z),t(g,1,1,r,d)]).
monster(223,[t(a,0,1,r,b),t(a,1,0,l,d),t(b,0,1,r,c),t(b,1,1,r,a),t(c,0,0,r,d),t(c,1,1,r,g),t(d,0,1,l,e),t(d,1,1,l,f),t(e,0,0,l,f),t(e,1,1,l,e),t(f,0,0,r,a),t(f,1,0,l,d),t(g,0,0,r,a),t(g,1,1,r,z)]).
monster(224,[t(a,0,1,r,b),t(a,1,0,l,e),t(b,0,1,r,c),t(b,1,0,r,a),t(c,0,1,r,d),t(c,1,0,r,c),t(d,0,1,l,e),t(d,1,1,l,d),t(e,0,1,l,a),t(e,1,0,l,f),t(f,0,0,l,a),t(f,1,0,l,g),t(g,0,1,r,z),t(g,1,0,r,d)]).
monster(225,[t(a,0,1,r,b),t(a,1,0,l,g),t(b,0,0,r,c),t(b,1,1,r,z),t(c,0,1,l,d),t(c,1,0,l,a),t(d,0,1,r,e),t(d,1,1,l,e),t(e,0,1,l,c),t(e,1,1,r,f),t(f,0,0,r,e),t(f,1,0,r,a),t(g,0,0,r,f),t(g,1,1,l,g)]).
monster(226,[t(a,0,1,r,b),t(a,1,0,r,a),t(b,0,1,l,c),t(b,1,1,l,f),t(c,0,1,r,d),t(c,1,0,l,b),t(d,0,1,r,a),t(d,1,1,l,e),t(e,0,1,r,z),t(e,1,0,l,c),t(f,0,1,r,g),t(f,1,1,l,d),t(g,0,0,r,g),t(g,1,0,r,f)]).
monster(227,[t(a,0,1,r,b),t(a,1,0,r,b),t(b,0,1,l,c),t(b,1,1,r,g),t(c,0,1,r,d),t(c,1,1,r,c),t(d,0,1,r,e),t(d,1,0,r,a),t(e,0,1,l,f),t(e,1,0,l,b),t(f,0,1,r,f),t(f,1,0,l,e),t(g,0,0,r,d),t(g,1,1,r,z)]).
monster(228,[t(a,0,1,r,b),t(a,1,0,r,d),t(b,0,1,r,c),t(b,1,0,l,a),t(c,0,0,l,a),t(c,1,0,l,e),t(d,0,1,r,e),t(d,1,1,r,z),t(e,0,1,r,f),t(e,1,0,r,a),t(f,0,1,l,g),t(f,1,0,l,e),t(g,0,1,l,c),t(g,1,0,l,g)]).
monster(229,[t(a,0,1,r,b),t(a,1,0,r,d),t(b,0,1,r,c),t(b,1,0,r,a),t(c,0,0,r,d),t(c,1,1,l,d),t(d,0,0,l,e),t(d,1,1,l,f),t(e,0,1,l,a),t(e,1,0,l,g),t(f,0,0,l,c),t(f,1,1,l,b),t(g,0,1,l,c),t(g,1,1,r,z)]).
monster(230,[t(a,0,1,r,b),t(a,1,0,r,f),t(b,0,1,r,c),t(b,1,1,r,z),t(c,0,0,l,d),t(c,1,1,r,f),t(d,0,0,r,a),t(d,1,1,l,e),t(e,0,0,l,c),t(e,1,1,l,f),t(f,0,1,l,e),t(f,1,0,r,g),t(g,0,0,l,e),t(g,1,1,r,a)]).
monster(231,[t(a,0,1,r,b),t(a,1,0,r,g),t(b,0,1,l,c),t(b,1,0,l,e),t(c,0,1,l,d),t(c,1,0,l,b),t(d,0,0,l,e),t(d,1,1,r,e),t(e,0,0,r,a),t(e,1,1,r,f),t(f,0,0,r,d),t(f,1,1,r,c),t(g,0,1,r,d),t(g,1,1,r,z)]).
monster(232,[t(a,0,1,r,b),t(a,1,0,r,g),t(b,0,1,l,c),t(b,1,0,r,e),t(c,0,1,l,f),t(c,1,1,l,d),t(d,0,0,l,e),t(d,1,1,l,c),t(e,0,1,r,a),t(e,1,1,r,b),t(f,0,1,l,d),t(f,1,0,l,f),t(g,0,1,r,z),t(g,1,0,r,f)]).
monster(233,[t(a,0,1,r,b),t(a,1,1,l,b),t(b,0,1,l,c),t(b,1,1,r,f),t(c,0,1,l,a),t(c,1,0,l,d),t(d,0,1,r,e),t(d,1,0,l,g),t(e,0,0,r,c),t(e,1,1,r,z),t(f,0,0,r,b),t(f,1,0,r,d),t(g,0,0,r,f),t(g,1,1,l,g)]).
monster(234,[t(a,0,1,r,b),t(a,1,1,l,f),t(b,0,1,r,c),t(b,1,1,r,a),t(c,0,1,l,d),t(c,1,0,l,d),t(d,0,1,l,a),t(d,1,1,l,e),t(e,0,0,l,a),t(e,1,0,l,d),t(f,0,1,l,g),t(f,1,0,r,f),t(g,0,0,l,e),t(g,1,1,r,z)]).
monster(235,[t(a,0,1,r,b),t(a,1,1,r,f),t(b,0,0,r,c),t(b,1,1,r,g),t(c,0,1,l,d),t(c,1,1,l,e),t(d,0,0,l,e),t(d,1,1,l,d),t(e,0,0,r,f),t(e,1,0,l,c),t(f,0,1,r,a),t(f,1,0,l,c),t(g,0,0,r,f),t(g,1,1,r,z)]).
monster(236,[t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,0,r,c),t(b,1,0,r,e),t(c,0,1,l,d),t(c,1,1,l,a),t(d,0,1,l,c),t(d,1,0,l,g),t(e,0,0,r,f),t(e,1,1,l,f),t(f,0,0,r,d),t(f,1,1,l,f),t(g,0,1,l,b),t(g,1,0,l,e)]).
monster(237,[t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,1,l,c),t(b,1,0,r,e),t(c,0,0,l,d),t(c,1,1,l,b),t(d,0,1,r,e),t(d,1,0,l,a),t(e,0,1,r,f),t(e,1,0,r,g),t(f,0,0,r,a),t(f,1,0,l,g),t(g,0,1,r,b),t(g,1,1,l,g)]).
monster(238,[t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,1,r,c),t(b,1,0,l,e),t(c,0,0,r,d),t(c,1,1,r,b),t(d,0,1,l,e),t(d,1,1,r,a),t(e,0,1,l,f),t(e,1,0,l,g),t(f,0,0,l,g),t(f,1,0,r,g),t(g,0,1,l,b),t(g,1,1,r,g)]).
monster(239,[t(a,0,1,r,b),t(a,1,1,r,z),t(b,0,1,r,c),t(b,1,0,r,f),t(c,0,1,l,d),t(c,1,1,r,b),t(d,0,1,r,g),t(d,1,0,l,e),t(e,0,1,l,d),t(e,1,0,r,a),t(f,0,1,r,e),t(f,1,0,l,d),t(g,0,0,r,c),t(g,1,1,l,f)]).
monster(240,[t(a,0,1,r,b),t(a,1,3,l,b),t(a,2,4,l,c),t(a,3,2,r,a),t(a,4,4,l,b),t(b,0,2,l,c),t(b,1,3,r,b),t(b,2,1,l,c),t(b,3,2,r,a),t(b,4,1,r,z),t(c,0,3,r,b),t(c,1,1,l,b),t(c,2,3,l,c),t(c,3,2,r,c),t(c,4,4,l,c)]).

origin(116,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(117,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(118,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(119,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(120,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(121,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(122,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(123,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(124,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(125,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(126,"https://wiki.bbchallenge.org/wiki/BB(3,3)","Shawn Ligocki").
origin(127,"https://wiki.bbchallenge.org/wiki/BB(2,5)","mxdys").
origin(128,"https://wiki.bbchallenge.org/wiki/BB(2,5)","mxdys").
origin(129,"https://wiki.bbchallenge.org/wiki/BB(2,5)","Pavel Kropitz").
origin(130,"https://wiki.bbchallenge.org/wiki/BB(2,5)","mxdys").
origin(131,"https://wiki.bbchallenge.org/wiki/BB(2,5)","prurq and LegionMammal9781").
origin(132,"https://wiki.bbchallenge.org/wiki/BB(2,5)","Daniel Yuan").
origin(133,"https://wiki.bbchallenge.org/wiki/BB(2,5)","mxdys").
origin(134,"https://wiki.bbchallenge.org/wiki/BB(2,5)","mxdys").
origin(135,"https://wiki.bbchallenge.org/wiki/BB(2,5)","mxdys").
origin(136,"https://wiki.bbchallenge.org/wiki/BB(2,5)","prurq and LegionMammal978").
origin(137,"https://wiki.bbchallenge.org/wiki/BB(2,5)","Daniel Yuan").
origin(138,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Shawn Ligocki").
origin(139,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(140,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Shawn Ligocki").
origin(141,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Peacemaker II").
origin(142,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(143,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(144,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Shawn Ligocki").
origin(145,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Shawn Ligocki").
origin(146,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(147,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Pavel Kropitz").
origin(148,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(149,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Shawn Ligocki").
origin(150,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(151,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(152,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(153,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(154,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(155,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(156,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Andrew Ducharme").
origin(157,"https://wiki.bbchallenge.org/wiki/BB(2,6)","Pavel Kropitz").
origin(158,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(159,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Pavel Kropitz").
origin(160,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(161,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(162,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(163,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(164,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(165,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Pavel Kropitz").
origin(166,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(167,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(168,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(169,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(170,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Lúkos").
origin(171,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Lúkos").
origin(172,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(173,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Pavel Kropitz").
origin(174,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(175,"https://wiki.bbchallenge.org/wiki/BB(3,4)","XnoobSpeakable").
origin(176,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Pavel Kropitz").
origin(177,"https://wiki.bbchallenge.org/wiki/BB(3,4)","Pavel Kropitz").
origin(178,"https://wiki.bbchallenge.org/wiki/BB(4,3)","").
origin(179,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(180,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(181,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(182,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(183,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(184,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(185,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(186,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(187,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(188,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(189,"https://wiki.bbchallenge.org/wiki/BB(4,3)","").
origin(190,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(191,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(192,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(193,"https://wiki.bbchallenge.org/wiki/BB(4,3)","").
origin(194,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(195,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(196,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(197,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(198,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Terry Ligocki").
origin(199,"https://wiki.bbchallenge.org/wiki/BB(4,3)","Andrew Ducharme").
origin(200,"https://wiki.bbchallenge.org/wiki/BB(6)","Shawn Ligocki").
origin(201,"https://wiki.bbchallenge.org/wiki/BB(6)","Pavel Kropitz").
origin(202,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(203,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(204,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(205,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(206,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(207,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(208,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(209,"https://wiki.bbchallenge.org/wiki/BB(6)","poppuncher").
origin(210,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(211,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(212,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(213,"https://wiki.bbchallenge.org/wiki/BB(6)","mxdys").
origin(214,"https://wiki.bbchallenge.org/wiki/BB(6)","poppuncher").
origin(215,"https://wiki.bbchallenge.org/wiki/BB(6)","mxdys").
origin(216,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(217,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(218,"https://wiki.bbchallenge.org/wiki/BB(6)","").
origin(219,"https://wiki.bbchallenge.org/wiki/BB(6)","Rachelin(3)").
origin(220,"https://wiki.bbchallenge.org/wiki/BB(7)","@stokastic").
origin(221,"https://wiki.bbchallenge.org/wiki/BB(7)","Terry Ligocki").
origin(222,"https://wiki.bbchallenge.org/wiki/BB(7)","@stokastic").
origin(223,"https://wiki.bbchallenge.org/wiki/BB(7)","Terry Ligocki").
origin(224,"https://wiki.bbchallenge.org/wiki/BB(7)","@Iijil").
origin(225,"https://wiki.bbchallenge.org/wiki/BB(7)","@poppuncher").
origin(226,"https://wiki.bbchallenge.org/wiki/BB(7)","Pavel Kropitz").
origin(227,"https://wiki.bbchallenge.org/wiki/BB(7)","Terry Ligocki").
origin(228,"https://wiki.bbchallenge.org/wiki/BB(7)","").
origin(229,"https://wiki.bbchallenge.org/wiki/BB(7)","@prurq").
origin(230,"https://wiki.bbchallenge.org/wiki/BB(7)","Katelyn Doucette, Andrew Ducharme").
origin(231,"https://wiki.bbchallenge.org/wiki/BB(7)","Andrew Ducharme ").
origin(232,"https://wiki.bbchallenge.org/wiki/BB(7)","Andrew Ducharme").
origin(233,"https://wiki.bbchallenge.org/wiki/BB(7)","Andrew Ducharme").
origin(234,"https://wiki.bbchallenge.org/wiki/BB(7)","Terry Ligocki").
origin(235,"https://wiki.bbchallenge.org/wiki/BB(7)","Terry Ligocki").
origin(236,"https://wiki.bbchallenge.org/wiki/BB(7)","Andrew Ducharme").
origin(237,"https://wiki.bbchallenge.org/wiki/BB(7)","Terry Ligocki").
origin(238,"https://wiki.bbchallenge.org/wiki/BB(7)","@Iijil, Andrew Ducharme").
origin(239,"https://wiki.bbchallenge.org/wiki/BB(7)","@Iijil").
origin(240,"https://wiki.bbchallenge.org/wiki/BB(3,5)","Racheline").

origin(1, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 2-state 4-symbol #a from P.Michel").
origin(2, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 2-state 4-symbol #b from P.Michel").
origin(3, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 2-state 4-symbol #c from P.Michel").
origin(4, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 2-state 4-symbol #a from Ligocki & Ligocki rewritten into normal form").
origin(5, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Brady #SB").
origin(6, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Brady #b").
origin(7, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Brady #c").
origin(8, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Brady #d").
origin(9, "http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Souris #a").
origin(10,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Souris #b").
origin(11,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte and Papazian #a").
origin(12,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte and Papazian #b").
origin(13,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte and Papazian #c").
origin(14,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte and Papazian #d").
origin(15,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte and Papazian #e").
origin(16,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #a").
origin(17,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #b").
origin(18,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #1").
origin(19,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #2").
origin(20,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #3").
origin(21,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #4").
origin(22,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #5").
origin(23,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #6").
origin(24,"http://www.logique.jussieu.fr/~michel/ha.html#tm52", " Uhing").
origin(25,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " 5-state record list #7").
origin(26,"http://www.logique.jussieu.fr/~michel/ha.html#tm52", " Schult").
origin(27,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #a").
origin(28,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #b").
origin(29,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #c").
origin(30,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #d").
origin(31,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #e").
origin(32,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #f").
origin(33,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #g").
origin(34,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #h").
origin(35,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #i").
origin(36,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Lafitte & Papazian #j").
origin(37,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #a").
origin(38,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #b").
origin(39,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #c").
origin(40,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #d").
origin(41,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #e").
origin(42,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #f").
origin(43,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #g").
origin(44,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #h").
origin(45,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #i").
origin(46,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #j").
origin(47,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #k").
origin(48,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #l").
origin(49,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #m").
origin(50,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #n").
origin(51,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " old 6-state list #1").
origin(52,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " old 6-state list #2").
origin(53,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #a").
origin(54,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #b").
origin(55,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #c").
origin(56,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #d").
origin(57,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #e").
origin(58,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #g").
origin(59,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #i").
origin(60,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #j").
origin(61,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #k").
origin(62,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #l").
origin(63,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #m").
origin(64,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #n").
origin(65,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #o").
origin(66,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #p").
origin(67,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #r").
origin(68,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " new 6-state list #s").
origin(69,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #a").
origin(70,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #b").
origin(71,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Kropitz #a").
origin(72,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Kropitz #b").
origin(73,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #a").
origin(74,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #b").
origin(75,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #c").
origin(76,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #d").
origin(77,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #e").
origin(78,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #f").
origin(79,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #g").
origin(80,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #h").
origin(81,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #i").
origin(82,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #a reworked by me. Mine has one less transition").
origin(83,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #b").
origin(84,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #c").
origin(85,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #d").
origin(86,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #e").
origin(87,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #f").
origin(88,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #g").
origin(89,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #h").
origin(90,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #i").
origin(91,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #i reworked by me to avoid blank tape. Mine has 5 less transitions").
origin(92,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #a").
origin(93,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #b").
origin(94,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #c").
origin(95,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #d").
origin(96,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #e").
origin(97,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #f").
origin(98,"http://www.drb.insel.de/~heiner/BB/bbsimtab.html", " Ligocki & Ligocki #g").
origin(99, "http://dl.acm.org/citation.cfm?id=1449643", " Green, from 1964 paper").
origin(100,"http://dl.acm.org/citation.cfm?id=1449643", " Green, from 1964 paper").
origin(101,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(102,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(103,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(104,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(105,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(106,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(107,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(108,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(109,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(110,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(111,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(112,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(113,"https://arxiv.org/abs/0906.3749", " Michel ").
origin(114,"https://arxiv.org/abs/0906.3749", " Michel reworked by me. Mine has one less transition").
origin(115,"https://arxiv.org/abs/0906.3749", " Michel ").

kellett([t(a,0,1,r,c),t(a,1,1,r,z),t(b,0,0,r,a),t(b,1,1,r,c),t(c,0,1,l,d),t(c,1,1,r,e),t(d,0,1,r,e),t(d,1,1,l,d),t(e,0,1,r,z),t(e,1,1,r,b)]).

% new 6x2 monsters`
new_monster(116, 6, 2, "1rb1ra1rc1rz1ld0rf1ra0le0ld1rc1ra0re").
new_monster(117, 6, 2, "1rb1lc1la1re0rd0la1rz1lb1ld0rf0rd1rb").
new_monster(118, 6, 2, "1rb0ld1rc0rf1lc1la0le1rz1lf0rb0rc0re").
new_monster(119, 6, 2, "1rb0lf1rc1rb1ld0ra1lb0le1rz0lc1la1lf").
new_monster(120, 6, 2, "1rb0lf1rc1rb1ld0ra1rf0le1rz0lc1la1lf").
new_monster(121, 6, 2, "1rb0lf1rc1rb1ld0ra1lf0le1rz0lc1la1lf").
new_monster(122, 6, 2, "1rb1rc1lc1re1ld0lb1re1lc1le0rf1rz1ra").
new_monster(123, 6, 2, "1rb1ra1lc1le1re0ld1lc0lf1rz0ra0ra0lb").
new_monster(124, 6, 2, "1rb0rf1lc0ra1rz0ld1le1ld1rb1rc0ld0re").
new_monster(125, 6, 2, "1rb0la1lc1lf0ld0lc0le0lb1re0ra1rz1ld").
new_monster(126, 6, 2, "1rb1re1lc1lf1rd0lb1le0rc1ra0ld1rz1lc").
new_monster(127, 6, 2, "1rb0le0rc1ra0ld1rf1re0rb1la0lc0rd1rz").
new_monster(128, 6, 2, "1rb0rf1lc1lb0re0ld0lc0lb0ra1re0rd1rz").
new_monster(129, 6, 2, "1rb1la1lc0rf1ld1lc1le0re0rb0lc1rz1ra").
new_monster(130, 6, 2, "1rb0le1lc1ra1re0ld1lc1lf1la0rc1rz1lc").
new_monster(131, 6, 2, "1rb1rf1lc1re0ld1lb1la0ra0ra0rb1rz0rd").
new_monster(132, 6, 2, "1rb0lf1lc0ra1rd0lb1le1rc1rz1la1la1le").
new_monster(133, 6, 2, "1rb0rf1lc1rb0rd0lb1rz0le1re0ra1rd1re").
new_monster(134, 6, 2, "1rb0rb0rc0lf0rd0ra0le---1le0la1lf1ra").
new_monster(135, 6, 2, "1rb1rz0lc0ld1ld1lc1re1lb1rf1rd0ld0ra").

% new 7x2 monster
new_monster(136, 7, 2, "1rb0ra1lc1lf1rd0lb1ra1le1rz0lc1rg1ld0rg0rf").
% new 9x2 monster
new_monster(137, 9, 2, "1rb1ra0lc0lf0rd1lc1ra1rg1rz0ra1lb1lf1lh1re0li1lh1lb0lh").
% new 10x2 monster
new_monster(138, 10, 2, "1rb1ra0lc0lf0rd1lc1ra1rg1rz0ra1lb1lf1lh1re0li1lh0lf0lj1lh0lj").
% new 11x2 monster
new_monster(139, 11, 2, "1lh1la1li1rg0rd1lc0rf1re1lj0rf1rb1rf0lc1lh0lc0la1lk1lj1rz0li0ld1le").
% new 12x2 monster
new_monster(140, 12, 2, "0lj0rf1lh1rc0ld0lg0re1ld1rf1ra1rb1rf1lc1lg1ll1li1lk0lh1rh1lj1rz1la1rf1ll").
% new 13x2 monster
new_monster(141, 13, 2, "1rb1ra1lc1rd1la1lc1lg0re1lc1rb0rl1lg0lm0rh1ri1rh1lk0ri---0lk1lf1lk1lj1rl1rz1rh").
% new 14x2 monster
new_monster(142, 14, 2, "1lh1la1li1rg0rd1lc0rf1re1lj0rf1rb1rf0lc1lh0lc0la1lk1lj1rl0li0ll1le1lm1rz0ln1lf0lj---").
% new 15x2 monster
new_monster(143, 15, 2, "0rh1ld1ri0rc1rb1ld0ld1le1lf1ra1rg0le1rb1rg1rd1ra0ln0rj1rz0lk0lk1ll1rg1lm0ll0ll1lo1ln0lg1ln").
    

