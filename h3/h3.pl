isBinTree(empty).
isBinTree(node(L,_,R)) :- isBinTree(L), isBinTree(R).

isLeafTree(leaf(_)).
isLeafTree(branch(L,R)) :- isLeafTree(L), isLeafTree(R).

convertLeaf(leaf(A), [A]).
convertLeaf(branch(Left,Right), L) :-
    convertLeaf(Left, S),
    convertLeaf(Right, D),
    append(S,D,L).

convertBin(empty, []).
convertBin(node(Left,A,Right), L) :-
    convertBin(Left, S),
    convertBin(Right, D),
    append(S, [A], M),
    append(M, D, L).

flatten(empty,[]).
flatten(leaf(A), [A]).
flatten(T,L) :-
    isLeafTree(T),
    convertLeaf(T, L).
flatten(T,L) :-
    isBinTree(T),
    convertBin(T, L).

bubble_sort(L,L).
bubble_sort(L1,L2) :-
    append(X,[A,B|Y],L1), A > B,
    append(X,[B,A|Y],T),
    bubble_sort(T,L2).

elemsOrdered(T,L) :-
    flatten(T,R),
    bubble_sort(R,L).