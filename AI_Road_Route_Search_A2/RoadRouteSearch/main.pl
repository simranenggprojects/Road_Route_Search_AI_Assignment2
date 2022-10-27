% to increase stack limit
:- set_prolog_flag(stack_limit, 2_147_483_648).

% to reconsult facts.pl
start:-
    reconsult('facts.pl'),nl,
    reconsult('heuristics.pl'),nl,
    printmsg.

% to print the message
printmsg:-
    write("----------------------------------------------------------------------"),nl,
    write("Welcome to Ricerca - Your Road Route Search Guide"),nl,
    write("----------------------------------------------------------------------"),nl,
    takinginput.

% to take source and destination from user
takinginput:-
    write("Dear User! Please help me to help you by providing your"),nl,
    write("Source: "),
    read(SRC),
    write("Destination: "),
    read(DST),
    write(""),nl,
    write("-------------------------------------------------------------"),nl,
    write("As per Depth First Search "),nl,
    write("-------------------------------------------------------------"),nl,
    write("Your Road Route should be: "),
    dfsroute(SRC,DST,LDFS,DistanceDFS),
    write(LDFS),nl,
    write("The distance for the above path is: "),
    write(DistanceDFS),
    write(""),nl,nl,
    clear,
    createheuristics(DST),
    write("-------------------------------------------------------------"),nl,
    write("As per Best First Search "),nl,
    write("-------------------------------------------------------------"),nl,
    bestfirstsearchroute([[SRC]],DST,LBFS,_),
    write("Your Road Route should be (Reverse Order): "),
    write(LBFS),nl,
    write("The approximate distance for the above path is: "),
    heur(SRC,DST,X),
    write(X).

% to handle bidirectionality of roads
dist(X,Y,D):-
    distance(X,Y,D).
dist(X,Y,D):-
    distance(Y,X,D).

% DFS solution
dfsroute(SRC,DST,[SRC|Further],Distance):-
    connected(SRC,DST,Further,Distance).
% rules for direct path or indirect path
connected(SRC,DST,[DST],Distance):-
    dist(SRC,DST,Distance).
connected(SRC,DST,[Intermediate|L],Distance):-
    dist(SRC,Intermediate,Distance1),
    connected(Intermediate,DST,L,Distance2),
    Distance is Distance1 + Distance2.

% to clear all temporary data from heuristics.pl data file
clear:-
    abolish(heur/3),
    tell('heuristics.pl'),
    told.

% iterate through list
itr([],DST).
itr([H|T],DST) :- process(H,DST), itr(T,DST).

process(H,DST):-
    dfsroute(H,DST,_,TheDist),
    HeurDist is TheDist - 10,
    assert(heur(H,DST,HeurDist)).

% function to create heuristics for Best First Search
createheuristics(DST):-
    ListforHeur = ['Agartala','Agra','Ahmedabad','Allahabad','Amritsar','Asansol',
                  'Bangalore','Bhopal','Baroda','Bhubaneshwar','Bombay','Calcutta',
                  'Calicut','Chandigarh','Cochin','Coimbatore',
                  'Delhi','Gwalior','Hubli','Hyderabad','Imphal','Indore',
                  'Jabalpur','Jaipur','Jamshedpur','Jullundur','Kanpur','Kolhapur',
                  'Lucknow','Ludhiana','Madras','Madurai','Meerut','Nagpur','Nasik',
                  'Panjim','Patna','Pondicherry','Pune','Ranchi','Shillong','Shimla',
                  'Surat','Trivandrum','Varanasi','Vijayawada','Vishakapatnam'],
    itr(ListforHeur,DST),
    assert(heur(DST,DST,0)),
    tell('heuristics.pl'),
    listing(heur),
    told.

% to handle bidirectionality of roads
heurdist(X,Y,D):-
    heur(X,Y,D).
heurdist(X,Y,D):-
    heur(Y,X,D).

% the concepts are taken from Dr. Albert Cruz
% Best First Search solution
bestfirstsearchroute([[DST|Path]|_],DST,[DST|Path],0).
bestfirstsearchroute([Path|Queue],DST,FinalPath,DistanceBFS) :-
    findsuccessortoexpand(Path,AdditionalPath),
    append(Queue,AdditionalPath,Queue1),
    sort_pqueue_one(Queue1,NewQueue),
    bestfirstsearchroute(NewQueue,DST,FinalPath,Dist),
    DistanceBFS is Dist+1.

% to find the successors
% it is indirectly maintaining open and closed list
findsuccessortoexpand([Node|Path],AdditionalPath) :-
    findall([NewNode,Node|Path],
            (dist(Node,NewNode,_),
             \+ member(NewNode,Path)),
            AdditionalPath).

% sorting queue to maintain priority
sort_pqueue_one(L,L2) :-
    swap_one(L,L1), !,
    sort_pqueue_one(L1,L2).
sort_pqueue_one(L,L).

% performing the swap operation so as to maintain queue in order
swap_one([[A1|B1],[A2|B2]|T],[[A2|B2],[A1|B1]|T]) :-
    heurdist(A1,DST,D1),
    heurdist(A2,DST,D2),
    D1>D2.

swap_one([X|T],[X|V]) :- swap_one(T,V).

