%% Options Loading
%% =======================================================================
%% General Configurations
%% =======================================================================

options.folderAddressData='01.data';
options.gender='all'; %men , women, all

%Configuraciones de almacenamiento de Resultados
options.savexlsx=true;
options.savejpg=true;
options.saveTime=true;
options.saveUserAccuracy=true;

%% Configuraciones para detección de movimiento
%% =======================================================================

options.fs=200;
options.minWindowLengthOfMuscleActivity=50;
options.plotSignals=false;
options.threshForSumAlongFreqInSpec=4000;

%% Configurations of preprocessing
%% =======================================================================

options.rectification=true;         % Opción de rectificación 
options.filtering=true;             % Opción de filtración

%Configuraciones Filtrado:

options.typefilt='low';             % Tipo de filtro ['low' | 'high' | 'bandpass' ]
options.cutfreq=50;                 % Frecuencia de corte para low y high
options.cutfreqband1=20;            % Frecuencias de corte para bandpass
options.cutfreqband2=80;

%% Configurations of feature extraction
%% =======================================================================

options.wname='db25';               % Nombre de la wavelet madre
options.levelTree=4;                % Nivel del árbol wavelet [ floor(log2(100))=6 valor maximo ]
options.fullTree=false;             % Opción de descomposición completa del árbol completa
options.waveletSquared=true;        % Opción de wavelets al cuadrado
options.timeAlign=true;             % Opción de wavelets alineado en el tiempo    

%Opciones para el nombre de la wavelet madre:
%'dbN'      — Daubechies wavelet with N vanishing moments (1-45) only naturls
%'symN'     — Symlets wavelet with N vanishing moments 2-45 only naturals
%'coifN'    — Coiflets wavelet with N vanishing moments 1-5 only naturals
%'fkN'      — Fejer-Korovkin wavelet with N coefficients 4 6 8 14 18 22

%% Configurations of training/clasification
%% =======================================================================

options.numTrainingGesture=10;  %1-25
options.numTrainingRelax=10;    %1-10
options.numCalibration=25;      %1-25

options.numSamples=9;               % CLasificaciones por ventana 
options.numDisplacement=50;         % Desplazamiento de la ventana de clasificación
options.valueWindow=150;            % Tamaño de la ventana de clasificación
options.numInstant=3;               % Instantes seguidos de cada muestra  

%Configuraciones del clasificador SVM

options.standardizeSVM=false;
options.kernelFunctionSVM='gaussian';   % Funcion kernel ['linear' | 'gaussian' | 'polynomial' | 'auto']
options.polynomialOrderSVM='-';         % Orden en caso de kernel polynomial
options.solverSVM='SMO';                % Algoritmo de rutina de optimizacion ['ISDA'| 'L1QP' | 'SMO']
options.distanceSV=0.01;

%% Configurations of post-processing
%% =======================================================================

options.state=1;                    % Opción de cambio de estado pasos: [1 | 2]

%% Configurations of evaluation methodology
%% =======================================================================

sysParameters.defaultGesture = 6; %(noGesto) % cuando se aumenten más gestos, el default sería otro valor
sysParameters.saltoVentana = options.numDisplacement+5; % puntos del salto de la ventana!
% sysParameters.tamVentana = 160; % tamaño de la ventana/ not anymore!
sysParameters.idx1raClasificacion = 85; % la primera clasificación a qué punto de la señal EMG corresponde!
sysParameters.umbralVentana = 0.5;
sysParameters.umbralRecognition = 0.5; % umbral admisible de la intersección entre el gesto segmentado y las respuestas del clasificador!
% opciones de la función.
flags.dibujar = 0;
flags.mostrarBloque = 0; % mostrarBloque imprime en pantalla las respuestas del vectorRespuestas del modo:
