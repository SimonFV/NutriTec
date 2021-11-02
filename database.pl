miembro(Value, [Value|_]).
miembro(Value, [_|Tail]) :- miembro(Value, Tail).


% Tipos de dieta
tipoDieta(keto).
tipoDieta(proteica).
tipoDieta(vegana).
tipoDieta(alcalina).
tipoDieta(frugivora).
tipoDieta(blanca).
tipoDieta(sinazucar).
tipoDieta(bajaengrasa).

% Padecimientos: [nombre, descripcion]
padecimiento([dislipidemia, "problemas del control del colesterol"]).
padecimiento([diabetes, "problemas de insulina en la sangre"]).
padecimiento([sobrepeso, "peso relativamente excesivo por acumulacion de grasa"]).
padecimiento([blanqueamiento, "blanqueamiento dental reciente"]).

% Actividad fisica semanal: [nivel, dias minimos, dias maximos]
nivelesActividad([inicial, 0, 2]).
nivelesActividad([intermedio, 3, 4]).
nivelesActividad([avanzado, 5, 7]).

% Calorias
calorias(1500).
calorias(2000).
calorias(2500).
calorias(3000).


% Dietas: [Nombre, tipo, calorias, recomendaciones, detalles].
dieta("Baja en grasa 1", tipoDieta(bajaengrasa), calorias(1500),
                            padecimiento(sobrepeso), padecimiento(blanqueamiento), % Recomendado, No recomendado
                            nivelesActividad(inicial), nivelesActividad(avanzado), % Recomendado, No recomendado
                        "Desayuno1, Almuerzo1, Cena1").

dieta("Baja en grasa 2", tipoDieta(bajaengrasa), calorias(2000), 
                            padecimiento(sobrepeso), padecimiento(blanqueamiento), % Recomendado, No recomendado
                            nivelesActividad(inicial), nivelesActividad(avanzado), % Recomendado , No recomendado
                    "Desayuno2, Almuerzo2, Cena2").


% Confirma que el tipo de dieta sea el mismo
mismo_tipo(Tipo, Tipo2, RequisitosCumplidos):-
    Tipo = Tipo2,
    RequisitosCumplidos is 1, !;
    RequisitosCumplidos is 0.

% Confirma que las calorias sean las correctas para la dieta
mismas_calorias(Cal1, Cal2, RequisitosCumplidos):-
    Cal1 = Cal2,
    RequisitosCumplidos is 1, !;
    RequisitosCumplidos is 0.

% Confirma que los padecimientos sean los correctos para la dieta
padecimientos_adecuados(Pad, PadRec2, PadNoRec2, RequisitosCumplidos):-
    (Pad = PadRec2; Pad \= PadNoRec2) -> 
    RequisitosCumplidos is 1;
    RequisitosCumplidos is 0.

% Confirma que los niveles de actividad sean los correctos para la dieta
actividad_correcta(ActDeseada, ActNoDeseada, ActivRec2, ActNoRec2, RequisitosCumplidos):-
    (ActDeseada = ActivRec2, ActNoDeseada \= ActivRec2) -> 
    RequisitosCumplidos is 1;
    (ActDeseada \= ActNoRec2, ActDeseada = ActivRec2) ->
    RequisitosCumplidos is 1;
    RequisitosCumplidos is 0.

% Recomienda una dieta con al menos 3 requisitos cumplidos
recomendar([Nombre, Tipo, Cal, Pad, ActDeseada, ActNoDeseada, Detalles]) :-
    dieta(Nombre, Tipo2, Cal2, PadRec2, PadNoRec2, ActivRec2, ActNoRec2, Detalles),

    mismo_tipo(Tipo, Tipo2, ReqCumplidos1),
    mismas_calorias(Cal, Cal2, ReqCumplidos2),
    padecimientos_adecuados(Pad, PadRec2, PadNoRec2, ReqCumplidos3),
    actividad_correcta(ActDeseada, ActNoDeseada, ActivRec2, ActNoRec2, ReqCumplidos4),

    RequisitosCumplidos is ReqCumplidos1 + ReqCumplidos2 + ReqCumplidos3 + ReqCumplidos4,

    ((RequisitosCumplidos = 4) ->
    format("Dieta recomendada: ~s: ~s \nRequisitos cumplidos: ~w", [Nombre, Detalles, RequisitosCumplidos]), !;
    (RequisitosCumplidos = 3) ->
    format("Dieta recomendada: ~s: ~s \nRequisitos cumplidos: ~w", [Nombre, Detalles, RequisitosCumplidos])).


