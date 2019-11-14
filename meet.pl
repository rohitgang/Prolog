#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

lte(time(_,_,am), time(_,_,pm)).
lte(time(T1H,_,AP), time(T2H,_,AP)):-T1H<T2H.
lte(time(TH,T1M,AP), time(TH,T2M,AP)):-T1M=<T2M.

overlab(slot(OuterBeg,OuterEnd), slot(InnerBeg,InnerEnd), slot(InnerBeg,InnerEnd)):-
    lte(OuterBeg,InnerBeg), lte(InnerBeg,OuterEnd), lte(InnerEnd,OuterEnd),InnerBeg\==InnerEnd.

overlab(slot(OuterBeg,OuterEnd), slot(InnerBeg,InnerEnd), slot(InnerBeg,OuterEnd)):-
    lte(OuterBeg,InnerBeg), lte(InnerBeg,OuterEnd), lte(OuterEnd,InnerEnd),InnerBeg\==OuterEnd.

common(S1,S2,S3):-overlab(S2,S1,S3).
common(S1,S2,S3):-overlab(S1,S2,S3).

commonTime([],Slot,Slot).

commonTime([Person|Tail],FirstSlot, SecondSlot):-
    free(Person,FreeSlot),common(FirstSlot,FreeSlot,ReturnSlot),commonTime(Tail,ReturnSlot,SecondSlot).

meetall([Person|Tail],Slot):- free(Person,FSlot),commonTime(Tail,FSlot,Slot).

meet(Slot):-people(People),meetall(People,Slot).

people([ann,bob,carla]).

main :-findall(Slot,meet(Slot),Slots),
       uniq(Slots,Uniq),
       write(Uniq),nl,halt.

:- initialization(main).