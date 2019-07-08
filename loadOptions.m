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

%% Configuraciones para detecci�n de movimiento
%% =======================================================================

options.fs=200;
options.minWindowLengthOfMuscleActivity=50;
options.plotSignals=false;
options.threshForSumAlongFreqInSpec=4000;

%% Configurations of preprocessing
%% =======================================================================

options.rectification=true;         % Opci�n de rectificaci�n 
options.filtering=true;             % Opci�n de filtraci�n

%Configuraciones Filtrado:

options.typefilt='low';             % Tipo de filtro ['low' | 'high' | 'bandpass' ]
options.cutfreq=50;                 % Frecuencia de corte para low y high
options.cutfreqband1=20;            % Frecuencias de corte para bandpass
options.cutfreqband2=80;

%% Configurations of feature extraction
%% =======================================================================

options.wname='db25';               % Nombre de la wavelet madre
options.levelTree=4;                % Nivel del �rbol wavelet [ floor(log2(100))=6 valor maximo ]
options.fullTree=false;             % Opci�n de descomposici�n completa del �rbol completa
options.waveletSquared=true;        % Opci�n de wavelets al cuadrado
options.timeAlign=true;             % Opci�n de wavelets alineado en el tiempo    

%Opciones para el nombre de la wavelet madre:
%'dbN'      � Daubechies wavelet with N vanishing moments (1-45) only naturls
%'symN'     � Symlets wavelet with N vanishing moments 2-45 only naturals
%'coifN'    � Coiflets wavelet with N vanishing moments 1-5 only naturals
%'fkN'      � Fejer-Korovkin wavelet with N coefficients 4 6 8 14 18 22

%% Configurations of training/clasification
%% =======================================================================

options.numTrainingGesture=10;  %1-25
options.numTrainingRelax=10;    %1-10
options.numCalibration=25;      %1-25

options.numSamples=9;               % CLasificaciones por ventana 
options.numDisplacement=50;         % Desplazamiento de la ventana de clasificaci�n
options.valueWindow=150;            % Tama�o de la ventana de clasificaci�n
options.numInstant=3;               % Instantes seguidos de cada muestra  

%Configuraciones del clasificador SVM

options.standardizeSVM=false;
options.kernelFunctionSVM='gaussian';   % Funcion kernel ['linear' | 'gaussian' | 'polynomial' | 'auto']
options.polynomialOrderSVM='-';         % Orden en caso de kernel polynomial
options.solverSVM='SMO';                % Algoritmo de rutina de optimizacion ['ISDA'| 'L1QP' | 'SMO']
options.distanceSV=0.01;

%% Configurations of post-processing
%% =======================================================================

options.state=1;                    % Opci�n de cambio de estado pasos: [1 | 2]

%% Configurations of evaluation methodology
%% =======================================================================

sysParameters.defaultGesture = 6; %(noGesto) % cuando se aumenten m�s gestos, el default ser�a otro valor
sysParameters.saltoVentana = options.numDisplacement+5; % puntos del salto de la ventana!
% sysParameters.tamVentana = 160; % tama�o de la ventana/ not anymore!
sysParameters.idx1raClasificacion = 85; % la primera clasificaci�n a qu� punto de la se�al EMG corresponde!
sysParameters.umbralVentana = 0.5;
sysParameters.umbralRecognition = 0.5; % umbral admisible de la intersecci�n entre el gesto segmentado y las respuestas del clasificador!
% opciones de la funci�n.
flags.dibujar = 0;
flags.mostrarBloque = 0; % mostrarBloque imprime en pantalla las respuestas del vectorRespuestas del modo:
