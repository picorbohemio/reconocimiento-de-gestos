%% Ejemplo de la funci�n que evalua un vector de respuestas de un sistema de reconocimiento en tiempo real

%% par�metros de entrada
% se�al EMG original. (normalizada!)
archivoGesto = load('gestureExample.mat'); % se carga como estructura para trackear rawGesture.
rawGesture = archivoGesto.gestureExample; % rawGesture es una matriz nx8...
trueClass = 4; % c�digo del gesto correcto!

%%
sysParameters.defaultGesture = 6; %(noGesto) % cuando se aumenten m�s gestos, el default ser�a otro valor
sysParameters.saltoVentana = 40; % puntos del salto de la ventana!
% sysParameters.tamVentana = 160; % tama�o de la ventana/ not anymore!
sysParameters.idx1raClasificacion = 80; % la primera clasificaci�n a qu� punto de la se�al EMG corresponde!
sysParameters.umbralVentana = 0.5;
sysParameters.umbralRecognition = 0.5; % umbral admisible de la intersecci�n entre el gesto segmentado y las respuestas del clasificador!

% opciones de la funci�n.
flags.dibujar = 1;
flags.mostrarBloque = 1; % mostrarBloque imprime en pantalla las respuestas del vectorRespuestas del modo:
%[13 6 12
% 6 4 6]. Que significa que 13 veces apareci� la clase 6, 6 veces la 4, y 12 veces la 6.

%% ejemplo para un vectorRespuestas correcto
vectorRespuestas = [6 6 6 6 6 6 6 6 6 6 6 6 6 4 4 4 4 4 6 6 6 6 6 6 6 6]; % respuestas del sistema
resultados = classVectorEval(rawGesture, vectorRespuestas, trueClass, sysParameters, flags)



%% ejemplo para un vectorRespuestas con discontinuidades
vectorRespuestas = [6 6 6 6 6 6 6 6 6 6 4 6 6 4 4 4 4 4 6 6 6 6 6 6 6 6]; % respuestas del sistema
resultados = classVectorEval(rawGesture, vectorRespuestas, trueClass, sysParameters, flags)


%% ejemplo para un vectorRespuestas con gestos par�sitos
vectorRespuestas = [6 3 3 3 6 5 5 6 6 6 6 6 6 4 4 4 4 4 6 6 6 6 6 6 6 6]; % respuestas del sistema
resultados = classVectorEval(rawGesture, vectorRespuestas, trueClass, sysParameters, flags)




