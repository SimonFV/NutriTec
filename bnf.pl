:- consult('database.pl').

leer_txt:-
    open('list.txt',read,In),
    repeat,
    read_line_to_codes(In,X),writef(" "),
    writef(X),nl,
    X=end_of_file,!,
    nl,
    close(In).


escribir_txt(Text):-
    open('list.txt', write, Stream),
    write(Stream, Text), nl,
    close(Stream),
    leer_txt.

determinante([el|S], S).
nombre([hombre|S], S).
nombre([manzana|S], S):-escribir_txt("Manzana").
    

verbo([come|S], S).

sintagma_nominal(S0, S):-
    determinante(S0, S1), nombre(S1, S).

sintagma_verbal(S0, S):-
    verbo(S0, S1), sintagma_nominal(S1, S).


oracion(S0, S):-
    sintagma_nominal(S0, S1), sintagma_verbal(S1, S).
