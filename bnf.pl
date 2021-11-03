:- consult('database.pl').

% Reemplaza un elemento de una lista (Lista, Index, Elemento, NuevaLista).
reemplazar_elemento([_|T], 0, X, [X|T]).
reemplazar_elemento([H|T], I, X, [H|R]):-
        I > -1,
        NI is I-1,
        reemplazar_elemento(T, NI, X, R), !.
reemplazar_elemento(L, _, _, L).

% Modicadores para cada requerimiento
modificar_padecimiento(L, Elemento, NL):- reemplazar_elemento(L, 3, Elemento, NL).

% Lee la informacion almacenada en la consulta para ser procesada y recomendar una dieta.
leer_txt(L):-
    open('list.txt',read,In),
    repeat,
    read_line_to_codes(In,X),!,
    split_string(X, "\s", "\s", L),
    close(In).

% Escribe un string en un archivo de texto.
escribir_txt(Texto):-
    open('list.txt', write, Stream),
    write(Stream, Texto), nl,
    close(Stream).

% Modifica los requisitos para seleccionar una dieta guardados en el archivo de texto
modificar_requisitos(Elemento, Tipo):-
    leer_txt(L),
    (Tipo = padecimiento -> 
        modificar_padecimiento(L, Elemento, NL),
        atomics_to_string(NL, " ", Texto),
        escribir_txt(Texto))
        .

% ----------------------- GRAMATICA -----------------------------------

% DETERMINANTES
determinante(["el"|S], S).
determinante(["la"|S], S).
determinante(["los"|S], S).
determinante(["las"|S], S).

% NOMBRES
nombre(["hombre"|S], S).
nombre(["diabetes"|S], S):-modificar_requisitos("diabetes", padecimiento).
nombre(["dislipidemia"|S], S):-modificar_requisitos("dislipidemia", padecimiento).
nombre(["sobrepeso"|S], S):-modificar_requisitos("sobrepeso", padecimiento).
nombre(["me"|S], S).
nombre(["yo"|S], S).

% VERBOS
verbo(["correr"|S], S).
verbo(["corro"|S], S).
verbo(["caminar"|S], S).
verbo(["camino"|S], S).
verbo(["comer"|S], S).
verbo(["como"|S], S).
verbo(["corro"|S], S).
verbo(["tengo"|S], S).
verbo(["tener"|S], S).

% ADJETIVOS



% SALUDOS
saludo(["hola"|S], S).
saludo(["buenas"|S], S).



sintagma_nominal(S0, S):-
    determinante(S0, S1), nombre(S1, S);
    nombre(S0, S).

sintagma_verbal(S0, S):-
    verbo(S0, S1), sintagma_nominal(S1, S).

oracion(S0, S):-
    sintagma_nominal(S0, S1), sintagma_verbal(S1, S);
    saludo(S0, S1), sintagma_verbal(S1, S).



% Inicia el programa
start :-
    write("Bienvenido a NutriTEC: "),
    read(X),
    split_string(X, "\s", "\s", L),
    oracion(L, []).