#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

meet(Person, slot(time(U,V), time(X,Y))) :-
    free(Person, slot(time(A,B), time(D,E))),
    J is V+(U*60), K is Y+(X*60),
    L is B+(A*60), M is E+(D*60),
    L=<J,
    M>=K.
people([ann,bob, carla]).

/*main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.*/
main :- meet(Person,
        slot(time(8,30), 
        time(8,45))), 
        write(Person),nl,halt.

:- initialization(main).