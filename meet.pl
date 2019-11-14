#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

lte(time(_,_,am),time(_,_,pm)).
lte(time(H1,_,NT), time(H2,_,NT)):-H1<H2.
lte(time(H,M1,NT), time(H,M2,NT)):- M1=<M2.

overlap(slot(BeginOut, EndOut),slot(BeginIn,EndIn),slot(BeginIn,EndIn)):-
    lte(BeginOut,BeginIn), lte(BeginIn,EndOut), lte(EndIn, EndOut),BeginIn\==EndIn.

overlap(slot(BeginOut, EndOut), slot(BeginIn, EndIn), slot(BeginIn, EndOut)):-
    lte(BeginOut, BeginIn), lte(BeginIn,EndOut), lte(EndOut, EndIn),BeginIn\==EndOut.

common(Slot1, Slot2, Slot3):-overlap(Slot2,Slot1,Slot3).
common(Slot1, Slot2, Slot3):-overlap(Slot1,Slot2,Slot3).
/*common(Slot1, Slot2, Slot3):-overlap(Slot3,Slot1,Slot2).*/

commonTime([], Slot, Slot).

commonTime([Person|Tail], StartTime, EndTime):-
    free(Person, FreeTime), common(StartTime, FreeTime, DoneTime), commonTime(Tail,DoneTime, EndTime).

meetall([Person|Tail],Slot):- free(Person, TimeFree), commonTime(Tail, TimeFree, Slot).

meet(Slot):-people(People),meetall(People,Slot).

people([ann,bob, carla]).

main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.

/*meet(Person, slot(time(U,V), time(X,Y))) :-
    free(Person, slot(time(A,B), time(D,E))),
    J is V+(U*60), K is Y+(X*60),
    L is B+(A*60), M is E+(D*60),
    L=<J,
    M>=K.*/



/*main :- meet(Person,
        slot(time(8,30), 
        time(8,45))), 
        write(Person),nl,halt.
*/
:- initialization(main).