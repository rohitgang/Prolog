#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

% Your code goes here.
lte(time(_,_,am),time(_,_,pm)).
lte(time(H1,_,NT),time(H2,_,NT)):-H1<H2.
lte(time(H,M1,NT),time(H,M2,NT)):-M1=<M2.

isSame(slot(StartHour,StartMin), slot(EndHour,EndMin), slot(EndHour,EndMin)):-
        lte(StartHour,EndHour),lte(EndHour,StartMin),lte(EndMin,StartMin),EndHour\==EndMin.
isSame(slot(StartHour,StartMin),slot(EndHour,EndMin),slot(EndHour,StartMin)):-
        lte(StartHour,EndHour),lte(EndHour,StartMin),lte(StartMin,EndMin),EndHour\==StartMin.

sharedtime(Slot1, Slot2, Slot3):-isSame(Slot1, Slot2, Slot3).
sharedtime(Slot1, Slot2, Slot3):-isSame(Slot2, Slot1, Slot3).

playTime(Slotty,Slotty,[]).
playTime(Slotty,Slotty2,[Firstone|Others]):-
    free(Firstone,Free), sharedtime(Slotty,Free,Returned), playTime(Returned,Slotty2, Others).

meetTime(Slotty2,[Firstone|Others]):-
    free(Firstone,Slotty),playTime(Slotty,Slotty2,Others).

meet(Slot):-people(People),meetTime(Slot,People).

people([bob,ann,dave]).

main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.
:- initialization(main).
