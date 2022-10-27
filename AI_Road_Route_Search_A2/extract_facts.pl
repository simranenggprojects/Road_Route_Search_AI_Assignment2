:- [library(csv)] .
:- [library(lists)] .

:- dynamic distance/3 .

:- op(1,'xfy','csv_') .

csv(FILE0) :- (start) csv_ (FILE0).

(start) csv_ (FILE0) :-
csv:csv_read_file(FILE0,[HEADER|ROWss]) ,
row__to__list(HEADER,HEADERs) ,
(loop) csv_ (HEADERs,ROWss).

(loop) csv_ (_HEADERs,[]) :-
true.

(loop) csv_ (HEADERs,[ROW|ROWss]) :-
row__to__list(ROW,ROWs) ,
lists:nth1(1,ROWs,CITY_A) ,
QUERY_A=(lists:nth1(NTH,ROWs,DISTANCE)) ,
QUERY_B=(NTH > 1) ,
QUERY_C=(lists:nth1(NTH,HEADERs,CITY_B)) ,
QUERY=(QUERY_A,QUERY_B,QUERY_C) ,
ASSERT=assertz(distance(CITY_A,CITY_B,DISTANCE)) ,
forall(QUERY,ASSERT) ,
(loop) csv_ (HEADERs,ROWss).

row__to__list(ROW,ROWs):-
ROW=..[_|ROWs].

save:-
    tell('C:/Users/Simran/Downloads/Subjects/AI/Assignment/Assignment 2/AI_Road_Route_Search_A2/RoadRouteSearch/facts.pl'),
    listing(distance),
    told.
