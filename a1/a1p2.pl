isExpr(constE(_)).
isExpr(negE(X)) :- isExpr(X).
isExpr(absE(X)) :- isExpr(X).
isExpr(plusE(X, Y)) :-
    isExpr(X),
    isExpr(Y).
isExpr(timesE(X, Y)) :-
    isExpr(X),
    isExpr(Y).
isExpr(minusE(X, Y)) :-
    isExpr(X),
    isExpr(Y).
isExpr(expE(X, Y)) :-
    isExpr(X),
    isExpr(Y).

interpretExpr(constE(X), X).
interpretExpr(negE(E), X) :- 
    interpretExpr(E, V),
    X is V * -1.
interpretExpr(absE(E), X) :-
    interpretExpr(E, V),
    X is abs(V).
interpretExpr(plusE(E1, E2), X) :-
    interpretExpr(E1, V1),
    interpretExpr(E2, V2),
    X is V1 + V2.
interpretExpr(timesE(E1, E2), X) :-
    interpretExpr(E1, V1),
    interpretExpr(E2, V2),
    X is V1 * V2.
interpretExpr(minusE(E1, E2), X) :-
    interpretExpr(E1, V1),
    interpretExpr(E2, V2),
    X is V1 - V2.
interpretExpr(expE(E1, E2), X) :-
    interpretExpr(E1, V1),
    interpretExpr(E2, V2),
    X is V1 ** V2.