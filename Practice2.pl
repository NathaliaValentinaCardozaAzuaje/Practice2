% Family Relations
uncle(hermenegildo, persona2).
uncle(vitorino, persona2).
uncle(casimiro, persona2).
child(danny, persona1).
child(yuniliexys, persona1).
child(danny, persona2).
child(danny, persona3).
cousin(benito, persona1).
cousin(benito, persona3).
cousin(felipa, persona3).
sibling(pancracia, persona1).
sibling(pancracia, persona3).
sibling(rosita, persona3).
grandparent(octavio, persona2).
grandparent(vivian, persona2).

% Definition of relation
father(X,Y) :- child(Y,X).
mother(X,Y) :- child(Y,X).

% Levels of Consanguinity

% Level1
levelConsanguinity(X,Y,1) :- father(X,Y).
levelConsanguinity(X,Y,1) :- mother(X,Y).
levelConsanguinity(X,Y,1) :- child(X,Y).

% Level2
levelConsanguinity(X,Y,2) :- sibling(X,Y).
levelConsanguinity(X,Y,2) :- grandparent(X,Y).

% Level3
levelConsanguinity(X,Y,3) :- uncle(X,Y).
levelConsanguinity(X,Y,3) :- cousin(X,Y).

% Inheritance Distribution
distributeInheritance(InheritanceTotal, Dead) :-

% Distribution based in the consanguinity level
    findall(X, levelConsanguinity(X, Dead, 1), Level1),
    findall(X, levelConsanguinity(X, Dead, 2), Level2),
    findall(X, levelConsanguinity(X, Dead, 3), Level3),

    % the length is counting how many people are in each level
    length(Level1, Counting1),
    length(Level2, Counting2),
    length(Level3, Counting3),

    TotalPercentage is Counting1 * 30 + Counting2 * 20 + Counting3 * 10,

% In case that the total percentage is greater than 100% it will 
% be adjusted depending on the level of consanguinity
    (TotalPercentage > 100 ->
        AdjustTotal is 100 / TotalPercentage,
        Percentage1 is 30 * AdjustTotal,
        Percentage2 is 20 * AdjustTotal,
        Percentage3 is 10 * AdjustTotal;
        
        % Adjust the total percentages if there are remaining 
        % shares based on the level of consanguinity
        Excedent is 100 - TotalPercentage,
        Percentage1 is 30 + (Excedent * 30 / TotalPercentage),
        Percentage2 is 20 + (Excedent * 20 / TotalPercentage),
        Percentage3 is 10 + (Excedent * 10 / TotalPercentage)),

    % Distribute the shares between the people that are 
    % in the same level
    distribute1(Level1, InheritanceTotal, Percentage1),
    distribute2(Level2, InheritanceTotal, Percentage2),
    distribute3(Level3, InheritanceTotal, Percentage3).


% Distribute shares

% Shares level 1
distribute1([], _, _).
distribute1([Head | Tail],InheritanceTotal, Percentage1) :-
    Inheritance is InheritanceTotal * Percentage1 / 100,
    format('Herencia de ~w: ~w~n', [Head, Inheritance]),
    distribute1(Tail, InheritanceTotal, Percentage1).

% Shares level 2
distribute2([], _, _).
distribute2([Head | Tail],InheritanceTotal, Percentage2) :-
    Inheritance is InheritanceTotal * Percentage2 / 100,
    format('Herencia de ~w: ~w~n', [Head, Inheritance]),
    distribute2(Tail, InheritanceTotal, Percentage2).

% Shares level 3
distribute3([], _, _).
distribute3([Head | Tail],InheritanceTotal, Percentage3) :-
    Inheritance is InheritanceTotal * Percentage3 / 100,
    format('Herencia de ~w: ~w~n', [Head, Inheritance]),
    distribute3(Tail, InheritanceTotal, Percentage3).

% Main function, it will show the result of the test cases
% when you consult the practice in the terminal
main :-
    write('Test case #1:'), nl,
    distributeInheritance(100000, persona1),
    write('Test case #2:'), nl,
    distributeInheritance(250000, persona2),
    write('Test case #3:'), nl,
    distributeInheritance(150000, persona3).

:- main.
