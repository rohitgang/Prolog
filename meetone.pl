#!/bin/gprolog --consult-file

:- include('data.pl').

% Your code goes here.
lte(time(_,_,am), time(_,_,pm)).

lte(time(T1H,_,AP), time(T2H,_,AP))
	:-T1H<T2H.

lte(time(TH,T1M,AP), time(TH,T2M,AP))
	:-T1M=<T2M.

sharedTime(slot(InnerBegin,InnerEnd),slot(OuterBegin,OuterEnd))
	:-lte(OuterBegin,InnerBegin),lte(InnerEnd,OuterEnd).

meetone(Person,MeetSlot)
	:-free(Person,FreeSlot),sharedTime(MeetSlot,FreeSlot).

main :- findall(Person,
		meetone(Person,slot(time(8,30,am),time(8,45,am))),
		People),
	write(People), nl, halt.

:- initialization(main).