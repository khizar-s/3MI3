% Given predicate
hasDivisorLessThanOrEqualTo(_,1) :- !, false.
hasDivisorLessThanOrEqualTo(X,Y) :- 0 is X mod Y, !.
hasDivisorLessThanOrEqualTo(X,Y) :- Z is Y - 1, hasDivisorLessThanOrEqualTo(X,Z).

% Predicate that checks if a number is prime by seeing if it has divisors less than itself
isPrime(2).
isPrime(X) :- 
    integer(X), 
    X > 2, 
    Z is X - 1, 
    not(hasDivisorLessThanOrEqualTo(X,Z)).

% Helper predicate to check if a integer has a corresponding list by using divisions of 10 and comparing to the first element of the list
toList(0, []) :- !.
toList(N, [A|As]) :- 
    A is N mod 10, 
    N1 is floor(N / 10), 
    toList(N1, As).

% Helper predicate to check if a list has a corresponding integer by using multiplications of 10 and the first element of the list to add up to the number
toInt(Num, Num, []).
toInt(N, Num, [H|T]) :- 
    M is N * 10 + H,
    toInt(M, Num, T).

% This predicate was added to help us solve for the "vice versa" portion by checking to see which elements are given and choosing a strategy accordingly
checker(X,[H|T]) :-
    nonvar(X),
    toList(X,L),
    append([H],T,L).
checker(X,[H|T]) :-
    var(X),
    append([H],T,L),
    reverse(L,R),
    toInt(0,X,R).

% Filled in code to call my helper predicate to solve
isDigitList(_,[]) :- false.
isDigitList(X,[X]) :- true.
isDigitList(X,[H|T]) :- checker(X,[H|T]).

% By reversing the list and comparing it to itself we'll know if the list is a palindrome or not
isPalindrome(L) :- reverse(L, L).

% Checks for prime behaviour using a previous predicate and palindrome by converting to a list(helper predicate) and checking for palindrome behaviour
primePalindrome(X) :- 
    isPrime(X),
    toList(X,Z),
    isPalindrome(Z).