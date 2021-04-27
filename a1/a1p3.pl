isVarExpr(constE(_)).
isVarExpr(negE(X)) :- isVarExpr(X).
isVarExpr(absE(X)) :- isVarExpr(X).
isVarExpr(plusE(X, Y)) :-
    isVarExpr(X),
    isVarExpr(Y).
isVarExpr(timesE(X, Y)) :-
    isVarExpr(X),
    isVarExpr(Y).
isVarExpr(minusE(X, Y)) :-
    isVarExpr(X),
    isVarExpr(Y).
isVarExpr(expE(X, Y)) :-
    isVarExpr(X),
    isVarExpr(Y).
isVarExpr(var(_)).
isVarExpr(subst(X, Y, Z)) :-
    isVarExpr(X),
    isVarExpr(var(Y)),
    isVarExpr(Z).

interpretVarExpr(constE(X), X).
interpretVarExpr(negE(E), X) :- 
    interpretVarExpr(E, V),
    X is V * -1.
interpretVarExpr(absE(E), X) :-
    interpretVarExpr(E, V),
    X is abs(V).
interpretVarExpr(plusE(E1, E2), X) :-
    interpretVarExpr(E1, V1),
    interpretVarExpr(E2, V2),
    X is V1 + V2.
interpretVarExpr(timesE(E1, E2), X) :-
    interpretVarExpr(E1, V1),
    interpretVarExpr(E2, V2),
    X is V1 * V2.
interpretVarExpr(minusE(E1, E2), X) :-
    interpretVarExpr(E1, V1),
    interpretVarExpr(E2, V2),
    X is V1 - V2.
interpretVarExpr(expE(E1, E2), X) :-
    interpretVarExpr(E1, V1),
    interpretVarExpr(E2, V2),
    X is V1 ** V2.
interpretVarExpr(subst(X1, Y, Z), X2) :-
    substitute(X1, Y, Z, X3),
    interpretVarExpr(X3, X2).

substitute(constE(C), _, _, constE(C)).
substitute(absE(C), V, E, X) :-
    substitute(C, V, E, X1),
    X = absE(X1).
substitute(negE(C), V, E, X) :-
    substitute(C, V, E, X1),
    X = negE(X1).
substitute(var(V), V, E2, E2).
substitute(var(V), _, _, var(V)).
substitute(plusE(C1, C2), V, E2, X) :- 
    substitute(C1, V, E2, X1),
    substitute(C2, V, E2, X2),
    X = plusE(X1, X2).
substitute(timesE(C1, C2), V, E2, X) :- 
    substitute(C1, V, E2, X1),
    substitute(C2, V, E2, X2),
    X = timesE(X1, X2).
substitute(minusE(C1, C2), V, E2, X) :-
    substitute(C1, V, E2, X1),
    substitute(C2, V, E2, X2),
    X = minusE(X1, X2).
substitute(expE(C1, C2), V, E2, X) :-
    substitute(C1, V, E2, X1),
    substitute(C2, V, E2, X2),
    X = expE(X1, X2).
substitute(subst(E1, V1, E2), V2, E3, X) :-
    substitute(E1, V1, E2, X1),
    substitute(X1, V2, E3, X).