isMixedExpr(constE(_)).
isMixedExpr(negE(X)) :- isMixedExpr(X).
isMixedExpr(absE(X)) :- isMixedExpr(X).
isMixedExpr(plusE(X, Y)) :-
    isMixedExpr(X),
    isMixedExpr(Y).
isMixedExpr(timesE(X, Y)) :-
    isMixedExpr(X),
    isMixedExpr(Y).
isMixedExpr(minusE(X, Y)) :-
    isMixedExpr(X),
    isMixedExpr(Y).
isMixedExpr(expE(X, Y)) :-
    isMixedExpr(X),
    isMixedExpr(Y).
isMixedExpr(tt).
isMixedExpr(ff).
isMixedExpr(bnot(X)) :- isMixedExpr(X).
isMixedExpr(band(X, Y)) :-
    isMixedExpr(X),
    isMixedExpr(Y).
isMixedExpr(bor(X, Y)) :-
    isMixedExpr(X),
    isMixedExpr(Y).

interpretMixedExpr(constE(X), X).
interpretMixedExpr(negE(E), X) :- 
    interpretMixedExpr(E, V),
    X is V * -1.
interpretMixedExpr(absE(E), X) :-
    interpretMixedExpr(E, V),
    X is abs(V).
interpretMixedExpr(plusE(E1, E2), X) :-
    interpretMixedExpr(E1, V1),
    interpretMixedExpr(E2, V2),
    X is V1 + V2.
interpretMixedExpr(timesE(E1, E2), X) :-
    interpretMixedExpr(E1, V1),
    interpretMixedExpr(E2, V2),
    X is V1 * V2.
interpretMixedExpr(minusE(E1, E2), X) :-
    interpretMixedExpr(E1, V1),
    interpretMixedExpr(E2, V2),
    X is V1 - V2.
interpretMixedExpr(expE(E1, E2), X) :-
    interpretMixedExpr(E1, V1),
    interpretMixedExpr(E2, V2),
    X is V1 ** V2.
interpretMixedExpr(tt, true).
interpretMixedExpr(ff, false).
interpretMixedExpr(bnot(B), X1) :- 
    interpretMixedExpr(B, X2),
    negate(X2, X1).
interpretMixedExpr(band(B1, B2), X1) :- 
    interpretMixedExpr(B1, X2),
    interpretMixedExpr(B2, X3),
    and(X2, X3, X1).
interpretMixedExpr(bor(B1, B2), X1) :- 
    interpretMixedExpr(B1, X2),
    interpretMixedExpr(B2, X3),
    or(X2, X3, X1).

negate(true, false).
negate(false, true). 

and(true, true, true).
and(_, _, false).

or(false, false, false).
or(_, _, true).