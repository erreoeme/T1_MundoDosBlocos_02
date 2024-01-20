isEmpty([]).


%impossivel um bloco estar em 2 lugares ao mesmo tempo
impossible(on(Block,at(X1,Y1)),Goals):-
    member(on(Block2,at(X1,Y1)),Goals),
    dif(Block,Block2),
    !.

%impossivel um bloco estar em diferentes cordenadas ao mesmo tempo
impossible(on(Block,at(X1,Y1)),Goals):-
    member(on(Block,at(X2,Y2)),Goals),
    dif(at(X1,Y1),at(X2,Y2)),
    !.

%impossivel ter clear em goals se temos um bloco em goals naquela mesma posicao
impossible(clear(X1,Y1), Goals):-
    member(on(_, at(X1, Y1)), Goals),
    !.

plan(State, Goals, []):-
    satisfied(State, Goals).  % caso base

plan(State, Goals, Plan):-
    append(PrePlan, [Action], Plan), % estrategia me apresentada no livro
    select(State, Goals, Goal), % selecione um goal G não resolvido em Goals
    achieves(Action, Goal), % procurar uma ação A que alcança G
    preserves(Action,Goals),   % garantir que A não quebre os Goals
    regress(Goals, Action, RegressedGoals), % fazer a regressão
    plan(State, RegressedGoals, PrePlan).


% verifica recursivamente tirando o cabeça da lista se todos os Goals
% estão presentes no estado atual 'State'
satisfied(_, []). % caso base (sem goals)

satisfied(State, [Goal|Goals]):-
    member(Goal, State),   % verifica de Goal está presente no estado atual State
    satisfied(State, Goals). %verifica o resto das goals


select(State, Goals, Goal):-    %verifica se Goal pertence a Goals
    delete_all(Goals, State, GoalsNResolvidas), %gera um conjunto com apenas as goals ainda nao resolvidas
    member(Goal, GoalsNResolvidas). %seleciona uma goal desse conjunto

% verifica se uma ação Action adiciona algo a lista Goals, e se Goal pertence a Goals.
% Ou seja, acredito que seja para verificar se ao realizar Action,
% algum efeito na lista Goals acontece.
achieves(Action, Goal):-
    adds(Action, Goals),
    member(Goal, Goals).

%verifica se uma ação não quebra algum Goal em Goals
preserves(Action , Goals):-
    deletes(Action, Relations),
    naoQuebra(Relations, Goals).

%verifica se alguma das goals está sendo quebrada
naoQuebra([H|_], Goals):-
    member(H, Goals),
    !,
    fail.

naoQuebra([_|T], Goals):-
    naoQuebra(T, Goals).

naoQuebra([], _).

regress(Goals, Action, RegressedGoals):-
    adds(Action, NewRelations),
    delete_all(Goals, NewRelations, RestGoals),
    deletes(Action,Condition),
    addnew(Condition, RestGoals, RegressedGoals).


%addnew(L1, L2, L3) -> (L2 - L1) + L2 = L3
addnew([], L, L).
addnew([Goal | _], Goals, _):-
    impossible(Goal, Goals),
    !,
    fail.

addnew([X|L1], L2, L3):-
    member(X,L2),
    !,
    addnew(L1, L2, L3).

addnew([X|L1], L2, [X|L3]):-
    addnew(L1,L2,L3).

%delete_all(L1,L2,Diff): if Diff is set-difference of L1 and L2
delete_all([],_,[]).

delete_all([X|L1], L2, Diff):-
    member(X,L2),
    !,
    delete_all(L1, L2, Diff).

delete_all([X|L1], L2, [X|Diff]):-
    delete_all(L1, L2, Diff).


%funcao para testar a capacidade de gerar um plano L do Inicio até as Goals.
testarPlano(L):-
    s33(Inicio),
    s37(Goals),
    plan(Inicio, Goals, L).




