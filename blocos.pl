% Definindo blocos e lugares
block(a).
block(b).
block(c).
block(d).

place(1).
place(2).
place(3).
place(4).
place(5).
place(6).

% Estado inicial:
%             d         
%       c     a   b
%       = = = = = =
% place 1 2 3 4 5 6
initial_state([clear(c), clear(2), clear(3), clear(d), clear(5), 
               on(c,1), on(a,4), on(b,6), on(d,a), on(d,b)]).

% Metas:
%             c   
%             a  b        
%             d    
%       = = = = = =
% place 1 2 3 4 5 6
goals([on(c,a), on(a,d), on(b,d), on(d,4), clear(1), clear(2), clear(3), clear(c)]).

% Definindo um objeto
object(X) :- place(X) ; block(X).

% Regras para verificar se uma ação é possível
can(move(Block, From, To), [clear(Block), clear(To), on(Block, From)]) :-
    block(Block), % Bloco a ser movido
    object(To),   % 'To' é um bloco ou um lugar
    To \== Block, % O bloco não pode ser movido para si mesmo
    object(From), % 'From' é um bloco ou um lugar
    From \== To,  % Move para a nova posição
    Block \== From. % Bloco não movido de si mesmo

% Efeitos de uma ação
adds(move(Block, From, To), [on(Block, To), clear(From)]).
deletes(move(Block, From, To), [on(Block, From), clear(To)]).

% Checa se todos os objetivos foram alcançados
satisfied(State, Goals) :-
    delete_all(Goals, State, []).

% Seleciona um objetivo
select(State, Goals, Goal) :-
    member(Goal, Goals).

% Verifica se uma ação alcança um objetivo
achieves(Action, Goal) :-
    adds(Action, AddList),
    member(Goal, AddList).

% Verifica se uma ação preserva os objetivos
preserves(Action, Goals) :-
    deletes(Action, DelList),
    \+ (member(Goal, DelList), member(Goal, Goals)).

% Regressão dos objetivos através de uma ação
regress(Goals, Action, Condition, RegressedGoals) :-
    adds(Action, NewRelations),
    delete_all(Goals, NewRelations, RestGoals),
    addnew(Condition, RestGoals, RegressedGoals).

% Substitui as variáveis nas condições das ações
substitute_vars([], _, []).
substitute_vars([clear(X) | Rest], State, [clear(X) | SubstitutedRest]) :-
    substitute_vars(Rest, State, SubstitutedRest).
substitute_vars([on(Block, Place) | Rest], State, [on(Block, SubstitutedPlace) | SubstitutedRest]) :-
    member(on(Block, SubstitutedPlace), State),
    substitute_vars(Rest, State, SubstitutedRest).

% Adiciona novos objetivos aos objetivos existentes
addnew([], L, L).
addnew([X | L1], L2, L3) :-
    addnew(L1, L2, L3).

% Diferença de conjuntos
delete_all([], _, []).
delete_all([X | L1], L2, Diff) :-
    member(X, L2), !,
    delete_all(L1, L2, Diff).
delete_all([X | L1], L2, [X | Diff]) :-
    delete_all(L1, L2, Diff).

% Predicado para planejar
plan(State, Goals, []) :-
    satisfied(State, Goals), % Objetivos alcançados no estado atual
    !. % Não há ações a serem executadas para alcançar os objetivos

plan(State, Goals, [Action | PrePlan]) :-
    select(State, Goals, Goal),                     % Seleciona um objetivo
    achieves(Action, Goal),                         % Verifica se uma ação alcança o objetivo
    can(Action, Condition),                         % Garante que a ação não contenha variáveis
    substitute_vars(Condition, State, SubstitutedCondition), % Substitui as variáveis na condição
    preserves(Action, Goals),                       % Protege os objetivos
    regress(Goals, Action, SubstitutedCondition, RegressedGoals), % Regressão dos objetivos
    plan(State, RegressedGoals, PrePlan).           % Recursão para planejar com os novos objetivos

% Execução do planejador
solve(Plan) :-
    initial_state(State),
    goals(Goals),
    plan(State, Goals, Plan).

% Imprime o plano de ação
print_result([]).
print_result([Action | Rest]) :-
    write(Action), nl,
    print_result(Rest).