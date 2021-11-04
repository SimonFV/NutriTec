
% Tipos de dieta
tipoDieta(keto).
tipoDieta(proteica).
tipoDieta(vegetariana).
tipoDieta(alcalina).
tipoDieta(frugivora).

% Padecimientos: [nombre, descripcion]
padecimiento([dislipidemia, "problemas del control del colesterol"]).
padecimiento([diabetes, "problemas de insulina en la sangre"]).
padecimiento([sobrepeso, "peso relativamente excesivo por acumulacion de grasa"]).
padecimiento([anemia, "disminucion de globulos rojos"]).
padecimiento([acidez, "niveles bajos de pH en el cuerpo"]).


% Actividad fisica semanal
nivelesActividad(inicial). % 2 o menos dias
nivelesActividad(intermedio). % 3, 4 dias
nivelesActividad(avanzado). % 5 o mas dias

% Calorias
calorias('1500').
calorias('1800').
calorias('2000').
calorias('2500').
calorias('3000').


% Dietas: [Nombre, tipo, calorias, recomendaciones, detalles].
dieta("Dieta keto (2000 kcal)", tipoDieta(keto), calorias('2000'),
        padecimiento(diabetes), padecimiento(acidez), % Recomendado, No recomendado
        nivelesActividad(intermedio), nivelesActividad(inicial), % Recomendado, No recomendado
        "Desayuno: 4 huevos revueltos con verduras\nRefrigerio: punado de nueces\nAlmuerzo: 1 taza albondigas a la italiana\nMerienda: Yogurt natural con almendras.\nCena: Hamburguesa de atun").

dieta("Dieta vegetariana (1800 kcal)", tipoDieta(vegetariana), calorias('1800'), 
        padecimiento(sobrepeso), padecimiento(anemia), % Recomendado, No recomendado
        nivelesActividad(inicial), nivelesActividad(avanzado), % Recomendado , No recomendado
        "Desayuno: 1 taza de yogurt desnatado con avena\nRefrigerio: 1 kiwi\nAlmuerzo: 1 taza de garbanzos con espinacas\nMerienda: Ensalada de frutas\nCena: 1 taza ensalada con queso y linaza").

dieta("Dieta proteica (3000 kcal)", tipoDieta(proteica), calorias('3000'), 
        padecimiento(anemia), padecimiento(sobrepeso), % Recomendado, No recomendado
        nivelesActividad(avanzado), nivelesActividad(inicial), % Recomendado , No recomendado
        "Desayuno: 2 huevos, 1 taza de avena, cafe con leche\nRefrigerio: sandwich de jamon y verduras\nAlmuerzo: 200g pollo, 250g patatas y 1 aguacate\nMerienda: 1 manzana y sandiwch de queso\nCena: 200 g de salmon, 250g de arroz y verduras al gusto").

dieta("Dieta alcalina (2500 kcal)", tipoDieta(alcalina), calorias('2500'), 
        padecimiento(acidez), padecimiento(dislipidemia), % Recomendado, No recomendado
        nivelesActividad(intermedio), nivelesActividad(inicial), % Recomendado , No recomendado
        "Desayuno: 1 tostada de pan integral con pavo, agua con limon\nRefrigerio: 1 manzana\nAlmuerzo: 1 plato de pasta integral con pescado, sumo de tomate\nMerienda: Batido de leche de almendras con fresas\nCena: Sopa con caldo de pollo, arroz integral y cebolla").

dieta("Dieta frugivora (1500 kcal)", tipoDieta(alcalina), calorias('1500'), 
        padecimiento(dislipidemia), padecimiento(anemia), % Recomendado, No recomendado
        nivelesActividad(inicial), nivelesActividad(avanzado), % Recomendado , No recomendado
        "Desayuno: Leche de coco, 1 platano, 1 taza de fresas\nRefrigerio: 1 manzana\nAlmuerzo: Ensalada de espinacas, pera y nueces, jugo de naranja\nMerienda: Punado de semillas de girasol y calabaza\nCena: Sopa de melon, limon y menta, higos").




% REGLAS PARA SELECCIONAR DIETAS


% Confirma que el tipo de dieta sea el mismo
mismo_tipo(Tipo, Tipo2, RequisitosCumplidos):-
    (Tipo = Tipo2; Tipo = tipoDieta(tipo)),
    RequisitosCumplidos is 1, !;
    RequisitosCumplidos is 0.

% Confirma que las calorias sean las correctas para la dieta
mismas_calorias(Cal1, Cal2, RequisitosCumplidos):-
    (Cal1 = Cal2; Cal1 = calorias(calorias)),
    RequisitosCumplidos is 1, !;
    RequisitosCumplidos is 0.

% Confirma que los padecimientos sean los correctos para la dieta
padecimientos_adecuados(Pad, PadRec2, PadNoRec2, RequisitosCumplidos):-
    (Pad = PadRec2; Pad \= PadNoRec2; Pad = padecimiento(padecimiento)) -> 
    RequisitosCumplidos is 1;
    RequisitosCumplidos is 0.

% Confirma que los niveles de actividad sean los correctos para la dieta
actividad_correcta(ActDeseada, ActivRec2, ActNoRec2, RequisitosCumplidos):-
    (ActDeseada = ActivRec2; ActDeseada \= ActNoRec2; ActDeseada = nivelesActividad(actividad)) -> 
    RequisitosCumplidos is 1;
    RequisitosCumplidos is 0.


% Recomienda una dieta con al menos 3 requisitos cumplidos
recomendar(Nombre, [Tipo, Cal, Pad, ActDeseada], Detalles) :-
    dieta(Nombre, Tipo2, Cal2, PadRec2, PadNoRec2, ActivRec2, ActNoRec2, Detalles),

    mismo_tipo(tipoDieta(Tipo), Tipo2, ReqCumplidos1),
    mismas_calorias(calorias(Cal), Cal2, ReqCumplidos2),
    padecimientos_adecuados(padecimiento(Pad), PadRec2, PadNoRec2, ReqCumplidos3),
    actividad_correcta(nivelesActividad(ActDeseada), ActivRec2, ActNoRec2, ReqCumplidos4),

    RequisitosCumplidos is ReqCumplidos1 + ReqCumplidos2 + ReqCumplidos3 + ReqCumplidos4,
    RequisitosCumplidos = 4,
    format("Dieta encontrada con 4 requisitos cumplidos:\n ~s\n~s \n", [Nombre, Detalles]), !.

recomendar(Nombre, [Tipo, Cal, Pad, ActDeseada], Detalles) :-
    dieta(Nombre, Tipo2, Cal2, PadRec2, PadNoRec2, ActivRec2, ActNoRec2, Detalles),

    mismo_tipo(tipoDieta(Tipo), Tipo2, ReqCumplidos1),
    mismas_calorias(calorias(Cal), Cal2, ReqCumplidos2),
    padecimientos_adecuados(padecimiento(Pad), PadRec2, PadNoRec2, ReqCumplidos3),
    actividad_correcta(nivelesActividad(ActDeseada), ActivRec2, ActNoRec2, ReqCumplidos4),

    RequisitosCumplidos is ReqCumplidos1 + ReqCumplidos2 + ReqCumplidos3 + ReqCumplidos4,
    RequisitosCumplidos = 3,
    format("Dieta encontrada con 3 requisitos cumplidos:\n ~s\n~s \n", [Nombre, Detalles]), !;
    format("\nNo se encontro ninguna dieta que cumpla con al menos 3 de los requisitos solicitados.\n").


