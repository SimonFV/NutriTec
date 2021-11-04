:- consult('database.pl').

% REGLAS AUXILIARES

% Se cumple si el elemento es miembro de la lista dada.
miembro(Value, [Value|_]).
miembro(Value, [_|Tail]) :- miembro(Value, Tail).

% Reemplaza un elemento de una lista (Lista, Index, Elemento, NuevaLista).
reemplazar_elemento([_|T], 0, X, [X|T]).
reemplazar_elemento([H|T], I, X, [H|R]):-
        I > -1,
        NI is I-1,
        reemplazar_elemento(T, NI, X, R), !.
reemplazar_elemento(L, _, _, L).

% Modicadores para cada requerimiento
modificar_tipo(L, Elemento, NL):- reemplazar_elemento(L, 0, Elemento, NL).
modificar_calorias(L, Elemento, NL):- reemplazar_elemento(L, 1, Elemento, NL).
modificar_padecimiento(L, Elemento, NL):- reemplazar_elemento(L, 2, Elemento, NL).
modificar_actividad(L, Elemento, NL):- reemplazar_elemento(L, 3, Elemento, NL).

% Lee la informacion almacenada en la consulta para ser procesada y recomendar una dieta.
leer_txt(L):-
    open('requisitos.txt',read,In),
    repeat,
    read_line_to_codes(In,X),!,
    split_string(X, "\s", "\s", L),
    close(In).

% Escribe un string en un archivo de texto.
escribir_txt(Texto):-
    open('requisitos.txt', write, Stream),
    write(Stream, Texto), nl,
    close(Stream).

% Modifica los requisitos para seleccionar una dieta guardados en el archivo de texto
modificar_requisitos(Elemento, Tipo):-
    leer_txt(L),
    ((Tipo = padecimiento -> 
        modificar_padecimiento(L, Elemento, NL),
        atomics_to_string(NL, " ", Texto),
        escribir_txt(Texto));
    (Tipo = calorias -> 
        modificar_calorias(L, Elemento, NL),
        atomics_to_string(NL, " ", Texto),
        escribir_txt(Texto));
    (Tipo = tipo -> 
        modificar_tipo(L, Elemento, NL),
        atomics_to_string(NL, " ", Texto),
        escribir_txt(Texto));
    (Tipo = actividad -> 
        modificar_actividad(L, Elemento, NL),
        atomics_to_string(NL, " ", Texto),
        escribir_txt(Texto))
    ).





% ----------------------- GRAMATICA -----------------------------------

% DETERMINANTES
determinante(["el"|S], S).
determinante(["la"|S], S).
determinante(["los"|S], S).
determinante(["las"|S], S).
determinante(["una"|S], S).
determinante(["un"|S], S).
determinante(["mi"|S], S).
determinante(["de"|S], S).


% NOMBRES

nombre(["diabetes"|S], S):-modificar_requisitos("diabetes", padecimiento).
nombre(["dislipidemia"|S], S):-modificar_requisitos("dislipidemia", padecimiento).
nombre(["sobrepeso"|S], S):-modificar_requisitos("sobrepeso", padecimiento).
nombre(["anemia"|S], S):-modificar_requisitos("anemia", padecimiento).
nombre(["acidez"|S], S):-modificar_requisitos("acidez", padecimiento).

nombre(["nivel"|S], S).
nombre(["inicial"|S], S):-modificar_requisitos("inicial", actividad).
nombre(["intermedio"|S], S):-modificar_requisitos("intermedio", actividad).
nombre(["avanzado"|S], S):-modificar_requisitos("avanzado", actividad).

nombre(["tipo"|S], S).
nombre(["keto"|S], S):-modificar_requisitos("keto", tipo).
nombre(["proteica"|S], S):-modificar_requisitos("proteica", tipo).
nombre(["vegetariana"|S], S):-modificar_requisitos("vegetariana", tipo).
nombre(["alcalina"|S], S):-modificar_requisitos("alcalina", tipo).
nombre(["frugivora"|S], S):-modificar_requisitos("frugivora", tipo).

nombre(["1500"|S], S):-modificar_requisitos("1500", calorias).
nombre(["1800"|S], S):-modificar_requisitos("1800", calorias).
nombre(["2000"|S], S):-modificar_requisitos("2000", calorias).
nombre(["2500"|S], S):-modificar_requisitos("2500", calorias).
nombre(["3000"|S], S):-modificar_requisitos("3000", calorias).

nombre(["me"|S], S).
nombre(["yo"|S], S).
nombre(["nutritec"|S], S).
nombre(["dieta"|S], S).
nombre(["preferencia"|S], S).

% VERBOS
verbo(["tengo"|S], S).
verbo(["quiero"|S], S).
verbo(["deseo"|S], S).
verbo(["necesito"|S], S).
verbo(["padezco"|S], S).
verbo(["es"|S], S).


% SALUDOS
saludar(["hola"|S], S).
saludar(["buenas"|S], S).
saludo(S0, S):-
    saludar(S0, S1), sintagma_nominal(S1, S);
    saludar(S0, S).

% NEGACION
negar(["no"|S], S).
negacion(S0, S):-
    negar(S0, S1), oracion(S1, S);
    negar(S0, S).


sintagma_nominal(S0, S):-
    determinante(S0, S1), nombre(S1, S);
    nombre(S0, S).

sintagma_verbal(S0, S):-
    verbo(S0, S1), sintagma_nominal(S1, S).

oracion(S0, S):-
    sintagma_nominal(S0, S1), sintagma_verbal(S1, S);
    saludo(S0, S1), sintagma_verbal(S1, S);
    sintagma_verbal(S0, S);
    sintagma_nominal(S0, S);
    negacion(S0, S).



% --------------------- CONTROL DE FLUJO -------------------------


% Solicita a la base de datos una dieta que cumpla con los requisitos del usuario
extraer_lista_requisitos(R):-leer_txt(R).
consultar_dieta:-
        extraer_lista_requisitos([TipoString, CaloriasString, PadecimientoString, ActividadString]),

        (TipoString = "tipo" -> Tipo = tipo; atom_string(Tipo, TipoString)),
        (CaloriasString = "calorias" -> Calorias = calorias; atom_string(Calorias, CaloriasString)),
        (PadecimientoString = "padecimiento" -> Padecimiento = padecimiento; atom_string(Padecimiento, PadecimientoString)),
        (ActividadString = "actividad" -> Actividad = actividad; atom_string(Actividad, ActividadString)),
        recomendar(_, [Tipo, Calorias, Padecimiento, Actividad], _).


solicitar_actividad:-
    write("\nDesea considerar su nivel de actividad fisica semanal?\n"),
    write("[ inicial: 2 o menos dias, intermedio: 3 o 4 dias, avanzado: 5 o mas dias ]\n"),
    read(X),
    split_string(X, "\s", "\s", L),
    (miembro("inicial", L); miembro("intermedio", L); miembro("avanzado", L); miembro("no", L)),
    oracion(L, []);
    write("No se pudo encontrar sentido a la respuesta. Replanteando...\n\n"),
    solicitar_actividad.

solicitar_padecimiento:-
    write("\nTiene algun padecimiento que se deba considerar?\n"),
    write("(Puedo recomendar una dieta para: diabetes, dislipidemia, sobrepeso, anemia o acidez)\n"),
    read(X),
    split_string(X, "\s", "\s", L),
    (miembro("diabetes", L); miembro("dislipidemia", L); miembro("sobrepeso", L); miembro("no", L);
    miembro("anemia", L); miembro("acidez", L)),
    oracion(L, []);
    write("No se pudo encontrar sentido a la respuesta. Replanteando...\n\n"),
    solicitar_padecimiento.

solicitar_calorias:-
    write("\nDesea que contenga una cantidad especifica de kilocalorias?\n"),
    write("(Se admiten los siguientes valores: 1500, 1800, 2000, 2500, 3000)\n"),
    read(X),
    split_string(X, "\s", "\s", L),
    (miembro("1500", L); miembro("1800", L); miembro("2000", L); miembro("no", L);
    miembro("2500", L); miembro("3000", L)),
    oracion(L, []);
    write("No se pudo encontrar sentido a la respuesta. Replanteando...\n\n"),
    solicitar_calorias.

solicitar_tipo:-
    write("\nExiste un tipo de dieta que sea de su preferencia?\n"),
    write("(Puedo ofrecerle los siguientes tipos: keto, proteica, vegetariana, alcalina y frugivora.\n"),
    read(X),
    split_string(X, "\s", "\s", L),
    (miembro("keto", L); miembro("proteica", L); miembro("vegetariana", L);
    miembro("no", L); miembro("alcalina", L); miembro("frugivora", L)),
    oracion(L, []);
    write("No se pudo encontrar sentido a la respuesta. Replanteando...\n\n"),
    solicitar_tipo.

% Inicia el programa
iniciar:-
    escribir_txt("tipo calorias padecimiento actividad"), % Limpia la lista de requisitos
    write("\nBienvenido a NutriTEC, en que le puedo ayudar?\n"),
    read(X),
    split_string(X, "\s", "\s", L),
    miembro("dieta", L),
    oracion(L, []),
    write("Excelente, te hare unas preguntas para encontrar una dieta adecuada...\n\n"),
    solicitar_tipo,
    solicitar_calorias,
    solicitar_padecimiento,
    solicitar_actividad,
    consultar_dieta;
    write("No se pudo encontrar sentido a la oracion, o no se relaciona con dietas.\n").