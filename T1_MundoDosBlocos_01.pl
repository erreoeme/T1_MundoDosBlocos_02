
%declaracao dos blocos
block(a).
block(b).
block(c).
block(d).

%declaracao dos lugares, funciona como uma matriz[6][6] (0..5)
place(0).
place(1).
place(2).
place(3).
place(4).
place(5).

%declaracao da altura dos blocos
height(a,1).
height(b,1).
height(c,1).
height(d,1).

%declaracao do comprimento dos blocos.
len(a,1).
len(b,1).
len(c,2).
len(d,3).

%declaracoes de estados de teste:
%final -> situação 1 final e state -> situação 1 inicial
%s30 -> situação 3 estado 0, s33 -> situação 3 estado 3, s37 -> situação 3 estado 7.
final([clear(0,0), clear(1,0), clear(2,0), on(d,at(3,0)), clear(3,1), on(a, at(4,1)), on(b, at(5,1)), on(c,at(4,2)), clear(4,3), clear(5,3)]).
state([on(c,at(0,0)), clear(0,1), clear(1,1), clear(2,0), on(a,at(3,0)), on(d, at(3,1)), clear(4,0), on(b,at(5,0)), clear(3,2), clear(4,2), clear(5,2)]).
s30([on(c, at(0,0)), on(d, at(3,1)), on(a,at(3,0)), on(b, at(5,0)), clear(0,1), clear(1,1), clear(2,0), clear(3,2), clear(4,2), clear(5,2), clear(4,0)]).
s37([on(a, at(0,1)), on(b,at(1,1)), on(c,at(0,0)), on(d, at(3,0)), clear(0,2), clear(1,2), clear(2,0), clear(3,1), clear(4,1), clear(5,1)]).
s36([on(a, at(0,1)), on(b,at(1,1)), on(c,at(0,0)), on(d, at(2,0)), clear(0,2), clear(1,2), clear(5,0), clear(3,1), clear(4,1), clear(2,1)]).
s34([on(a, at(0,1)), on(b,at(5,0)), on(c,at(0,0)), on(d, at(2,0)), clear(0,2), clear(1,1), clear(5,1), clear(3,1), clear(4,1), clear(2,1)]).
s33([on(a, at(5,1)), on(b,at(5,0)), on(c,at(0,0)), on(d, at(2,0)), clear(0,1), clear(1,1), clear(5,2), clear(3,1), clear(4,1), clear(2,1)]).



%funcao que me retorna uma lista de clear em um intervalo de x1 até um x2  
clearInterval(X1, X2, _, []) :- X1 > X2, !. % Intervalo vazio

clearInterval(X1, X2, Y, [clear(X1, Y) | L]) :-
    place(X1),
    Xn is X1 + 1,
    clearInterval(Xn, X2, Y, L).


%----------------------------------------------------------
%predicado can -> temos uma lista L que tem as condições necessárias para realizar uma ação move

%definicao para bloco de comprimento 1
can(move(Block,at(Xf, Yf), at(Xt, Yt)),L):-
    block(Block),                                                       % Verificando se é um bloco
    len(Block, 1),                                                      % Verificando se tem comprimento 1
    height(Block, BlockHeight),
    place(Xf),                                                          %verificando os locais
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),                                        %verificando se a cordenada de origem é diferente da de destino
    Y1 is Yf + BlockHeight,                                             %altura em cima do bloco original 
    place(Y1),                                                          
    addnew([on(Block, at(Xf, Yf)),clear(Xt, Yt)], [clear(Xf, Y1)], L).  %adiciona as relacoes necessárias em L

%definicao para bloco de comprimento 2
can(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block, at(Xf, Yf))|L]):-
    block(Block),                                                       
    len(Block, 2),                                                      %verificando se comprimento é 2
    height(Block, BlockHeight),
    place(Xf),                
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    X3 is Xf + 1,
    X4 is Xt + 1,
    place(X3), place(X4),
    H is Yf + BlockHeight,
    place(H),
    clearInterval(Xf, X3, H, L1),                                       %verificando se nao tem nada no em cima bloco a ser movido
    clearInterval(Xt, X4, Yt, L2),                                      %verificando se o lugar onde o bloco irá ocupar está livre
    append(L1, L2, L4),
    XEnd is Xt + 1,
    place(XEnd),
    addnew([clear(Xt, Yt), clear(XEnd, Yt)], L4, L).                    %temos que garantir que o bloco está estável -> 2 blocos sustentando nas pontas

%caso bloco de comprimento nao par
%somente em blocos de comprimento impar podemos ter um bloco sustentando no meio
can(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block, at(Xf, Yf))|L]):-
    block(Block),           % Verificando se � um bloco
    len(Block, BlockLength),
    dif(BlockLength,1),
    dif(BlockLength,2),
    height(Block, BlockHeight),
    place(Xf),                                                          %Verificando os locais
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    X3 is BlockLength + Xf - 1,
    X4 is BlockLength + Xt - 1,
    place(X3), place(X4),
    Par is mod(BlockLength,2),                                          %verificacao se eh impar
    dif(Par,0),
    H is Yf + BlockHeight,
    place(H),
    clearInterval(Xf, X3, Yf, L0),
    clearInterval(Xf, X3, H, L1),                                       %verificando se nao tem nada no em cima bloco a ser movido
    clearInterval(Xt, X4, Yt, L2),                                      %verificando se o lugar onde o bloco irá ocupar está livre
    append(L1,L2,L3),
    Mid is BlockLength // 2,
    XMid is Xt + Mid,
    place(XMid),
    addnew([clear(XMid,Yt)], L3, L4),                                   %adicionando cond de estabilidade -> se temos clear no meio -> bloco embaixo pois so temos clear em cima de um bloco.
    delete_all(L4, L0, L).

can(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block, at(Xf, Yf))|L]):-
    block(Block),           % Verificando se � um bloco
    len(Block, BlockLength),
    dif(BlockLength,1),
    dif(BlockLength,2),
    height(Block, BlockHeight),
    place(Xf),                 %  Verificando os locais
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    X3 is BlockLength + Xf - 1,
    X4 is BlockLength + Xt - 1,
    place(X3), place(X4),
    H is Yf + BlockHeight,
    place(H),
    clearInterval(Xf, X3, Yf, L0),
    clearInterval(Xf, X3, H, L1),                                       %verificando se nao tem nada no em cima bloco a ser movido
    clearInterval(Xt, X4, Yt, L2),                                      %verificando se o lugar onde o bloco irá ocupar está livre
    append(L1,L2,L3),
    XEnd is Xt + BlockLength - 1,
    place(XEnd),
    addnew([clear(Xt, Yt) ,clear(XEnd, Yt)], L3, L4),                   %cond de estabilidade -> temos blocos sustentando nas pontas
    delete_all(L4, L0, L).
    


%----------------------------------------------------------
% adds(Action, Relationships): Action establishes new Relationships
%caso de blocos de tamanho 1
adds(move(Block,at(Xf, Yf), at(Xt, Yt)),L):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    len(Block, 1),
    height(Block, BlockHeight),
    Y1 is Yt + BlockHeight,
    addnew([on(Block, at(Xt, Yt)), clear(Xt, Y1)], [clear(Xf, Yf)], L).

%caso de blocos de tamanho 2
adds(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xt, Yt))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    len(Block, 2),
    height(Block, BlockHeight),
    X1 is Xt + 1,
    Y1 is Yt + BlockHeight,
    place(X1),
    place(Y1),
    clearInterval(Xt, X1, Y1, L1),                                    %clear em cima do bloco no lugar novo
    XMid is Xf + 1,
    place(XMid),
    addnew([clear(XMid,Yf), clear(Xf, Yf)], L1, L).

%caso geral
adds(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xt, Yt))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    len(Block, BlockLength),
    height(Block, BlockHeight),
    X1 is Xt + BlockLength - 1,
    X2 is Xf + BlockLength - 1,
    Y1 is Yt + BlockHeight,
    Y2 is Yf + BlockHeight,
    place(X1), place(X2),
    place(Y1), place(Y2),
    clearInterval(Xf, X2, Y2, L5),
    clearInterval(Xt, X1, Y1, L1),                                      %clear em cima do bloco no lugar novo
    XEnd is Xf + BlockLength - 1,
    place(XEnd),
    clearInterval(Xf, XEnd, Yf, L2),
    clearInterval(Xt, X1, Yt, L3),
    append(L1, L2, L4),
    delete_all(L4, L3, L6),
    delete_all(L6, L5, L).


%----------------------------------------------------------
% deletes(Action, Relationships): Action destroy Relationships
% caso bloco de tamanho 1
deletes(move(Block,at(Xf, Yf), at(Xt, Yt)),L):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    len(Block, 1),
    height(Block, BlockHeight),
    Y1 is Yf + BlockHeight,
    addnew([on(Block, at(Xf, Yf)), clear(Xf, Y1)], [clear(Xt, Yt)], L).

% caso bloco de tamanho 2
deletes(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xf, Yf))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    len(Block, 2),
    height(Block, BlockHeight),
    X1 is Xf + 1,
    Y1 is Yf + BlockHeight,
    place(X1),
    place(Y1),
    clearInterval(Xf, X1, Y1, L1),                                      %clear em cima do bloco no lugar antigo
    XMid is Xt + 1,
    place(XMid),
    addnew([clear(XMid,Yt), clear(Xt, Yt)], L1, L).

%caso geral
deletes(move(Block,at(Xf, Yf), at(Xt, Yt)),[on(Block,at(Xf, Yf))|L]):-
    block(Block),
    place(Xf),
    place(Yf),
    place(Xt),
    place(Yt),
    dif(at(Xf, Yf), at(Xt, Yt)),
    len(Block, BlockLength),
    height(Block, BlockHeight),
    X1 is BlockLength + Xf - 1,
    Y1 is Yf + BlockHeight,
    place(X1),
    place(Y1),
    X2 is BlockLength + Xt - 1,
    Y2 is BlockHeight + Yt,
    place(X2),
    place(Y2),
    clearInterval(Xt, X2, Y2, L5),
    clearInterval(Xf, X1, Y1, L1),                                      %clear em cima do bloco no lugar antigo
    XEnd is Xt + BlockLength - 1,
    Y3 is Yt,
    place(XEnd),
    place(Y3),
    clearInterval(Xt, XEnd, Y3, L2),                                    %clears dos blocos abaixo do bloco atual
    clearInterval(Xf, X1, Yf, L3),
    append(L1,L2,L4),
    delete_all(L4, L3, L6),
    delete_all(L6, L5, L).

%----------------------------------------------------------































