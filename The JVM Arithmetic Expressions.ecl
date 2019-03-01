

iadd([H1,H2], Sum) :-
   Sum is H1 + H2.


isub([H1,H2], Sum) :-
	Sum is H2-H1.


imul([H1,H2], Sum) :-
	Sum is H1*H2.


idiv([H1,H2], Sum) :-
	Sum is H2/H1.

iconst(X):- 
	X>= 0,
	X=<5.

bipush(X):-
	X>5,
	X=<127.

sipush(X):-
	X > 127,
	X=<32767.

makeitnumber(iconst(X),X):-
	iconst(X).

makeitnumber(bipush(X),X):-
	bipush(X).

makeitnumber(sipush(X),X):-
	sipush(X).

insertAtEnd(X,[ ],[X]).
insertAtEnd(X,[H|T],[H|Z]) :- insertAtEnd(X,T,Z).

%%% jvm_expression/2
%%% Add you code here

jvm_expression(X + Y, LIST):-
	jvm_expression(X, L1),
	jvm_expression(Y, L2),
	insertAtEnd(iadd, L2, NL2),
	append(L1,NL2,LIST).

jvm_expression(X - Y, LIST):-
	jvm_expression(X, L1),
	jvm_expression(Y, L2),
	insertAtEnd(isub, L2, NL2),
	append(L1,NL2,LIST).

jvm_expression(X * Y, LIST):-
	jvm_expression(X, L1),
	jvm_expression(Y, L2),
	insertAtEnd(imul, L2, NL2),
	append(L1,NL2,LIST).

jvm_expression(X / Y, LIST):-
	jvm_expression(X, L1),
	jvm_expression(Y, L2),
	insertAtEnd(idiv, L2, NL2),
	append(L1,NL2,LIST).

jvm_expression(C, [iconst(C)]):-
	iconst(C),
	atomic(C).

jvm_expression(C, [bipush(C)]):-
	bipush(C),
	atomic(C).

jvm_expression(C, [sipush(C)]):-
	sipush(C),
	atomic(C).

%%% evaluate/3
%%% Add you code here

evaluate([H|_], [] , H).


evaluate([H1,H2|LT], [H|T] , R):-
	member(H,[iadd,isub,imul,idiv]),
	Predicate=..[H, [H1,H2],Res],
	call(Predicate),
	evaluate([Res|LT], T , R).

evaluate(LIST1, [H|T] , R):-
	makeitnumber(H,X),
	evaluate( [X|LIST1] , T , R).
