:-['friends.ecl']. 

%%% Social Network Exercise goes here.

%α

is_a_friend(X, Y):-
	friend(X,Y).

%β

all_people(List):-
	findall(X,friend(X, Y),L1),
	findall(Y,friend(X, Y),L2),
	append(L2,L1,L3),
	setof( X, member( X, L3), List).

%γ

my_friends(X, Friends, Number):-
	setof(Y,X^friend(X, Y),Friends),
	length(Friends,Number).

%δ

covered_from(Group, P, [P|C]):-
	member(P,Group),
	findall( X, (friend(P,X),member( X, Group)), C).

%ε

covers_most(Group, H, [H|List]):-
	covers_most_HELP(Group,Group, [] ,[H|C2]),
	setof( X, member( X, C2), List).


covers_most(Group, H, [H]):-
	covers_most_HELP(Group,Group, [] ,[H]).


covers_most_HELP([],_, C , C).


covers_most_HELP([H|T],Group, C, C2):-
	findall(X, (friend(H,X),member(X, Group)), C1),
	length([H|C1],Size1),
	length(C,Size),
	Size1>Size,
	covers_most_HELP(T,Group, [H|C1], C2).


covers_most_HELP([H|T],Group, C, C2):-
	findall( X, (friend(H,X),member( X, Group)), C1),
	length([H|C1],Size1),
	length(C,Size),
	Size1=<Size,
	covers_most_HELP(T,Group, C, C2).

%ζ

set_diff([],_,[]).

set_diff([H|T],List,[H|Anc]):-
	not(member(H,List)),!,
	set_diff(T,List,Anc).


set_diff([_|T],List,Anc):-
	set_diff(T,List,Anc).



cover(Group,L):-
	covers_most(Group, H, [H|C2]),
	set_diff(Group,C2,L).


%η
%η ερώτηση θα είναι:
%all_people(People),cover(People,Z),length(Z,K).


