function resultados = classVectorEval(rawGesture, vectorRespuestas, trueClass, sysParameters, flags)
% Para un vector con las clases de respuesta correspondiente a un sistema de
% reconocimiento, se retorna cuál es el gesto equivalente de la
% clasificaciOn "classPrediction".  En el caso de que varios gestos hayan sido
% clasificados, se retorna el más común aparte del correcto.
% Se incluye una categoría adicional "NaN" para los casos en
% los que existe discontinuidades pero la clasificación es correcta.

% se reduce el "vectorRespuestas" a una representaciOn por bloques:
% "bloquesRespuestas".
% vectorRespuestas = [6 6 6 6 2 2 2 2 2 6];
% bloquesRespuestas = [4 5 1; 6 2 6]; 4 veces no gesto, 5 veces gesto num 2, 1 vez noGesto.

% "rawGesture" es la matriz nx8 de la señal EMG normalizada sin filtrar

% en las opciones de "flags" se puede dibujar (flags.dibujar = 1;) y mostrar la el
% vectorRespuesta representado en bloques (flags.mostrarBloque = 1;).
% Cuando existe 4 parámetros de entrada .

% sysParameters.tamVentana % ya no es considerada,

%% núm de parámetros de entrada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 4
    flags.dibujar = false;
    flags.mostrarBloque = false;
elseif nargin ~= 5
    disp('Error en los parámetros de entrada de la función classVectorEval')
    return
end


%% Default
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
defaultGesture = sysParameters.defaultGesture; % 6 (noGesto).
saltoVentana = sysParameters.saltoVentana; % numero de puntos del salto de la ventana!
%
% tamVentana = sysParameters.tamVentana; % tamaño de la ventana
tamVentana = saltoVentana; % se modifica
%
idx1raClasificacion = sysParameters.idx1raClasificacion; % la primera clasificaciOn del "vectorRespuestas" a qué punto de la señal EMG corresponde
umbralVentana = sysParameters.umbralVentana; % porcentaje en el que una clasificaciOn debe abarcar al gesto.
umbralRecognition = sysParameters.umbralRecognition; % porcentaje en el que una clasificaciOn debe abarcar al gesto.

%% representaciOn en bloques
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPuntosEMG = size(rawGesture, 1);
numClasificaciones = size(vectorRespuestas, 2);

% Vector con la posiciOn correspondiente para cada respuesta.
vectorRespuestaPosicion = linspace(idx1raClasificacion,...
    idx1raClasificacion + (numClasificaciones - 1) * saltoVentana, numClasificaciones);


% el análisis se basa en diferenciar el vector de respuestas (se obtienen las transiciones)
diffVector = [defaultGesture vectorRespuestas] - [vectorRespuestas defaultGesture];
transiciones = find(diffVector ~= 0);

if isempty(transiciones)
    % todo el vectorRespuestas dio noGesto!
    bloquesRespuestas = [size(vectorRespuestas,2);defaultGesture]; % numRespuestas;clase
    
else
    % alguna respuesta en alguna parte!
    % noGestos del inicio!
    if vectorRespuestas(1) == defaultGesture
        bloquesRespuestas = [transiciones(1) - 1;defaultGesture];
    else
        bloquesRespuestas = [];
    end
    
    % lazo para todas las transiciones
    for kTransiciones = 2:size(transiciones,2)
        repBloque = transiciones(kTransiciones) - transiciones(kTransiciones - 1); % la diferencia en las posiciones de las transiciones me da el número de respuestas en el bloque
        claseBloque = vectorRespuestas(transiciones(kTransiciones - 1)); % la clase correspondiente del bloque es el valor en la posicion transiciones(kTransiciones - 1) del vectorRespuesta
        bloqueResp = [repBloque;claseBloque];
        bloquesRespuestas = [bloquesRespuestas bloqueResp];
    end
    
    % noGestos del final
    if vectorRespuestas(end) == defaultGesture
        repBloque = size(vectorRespuestas,2) - transiciones(end) + 1;
        claseBloque = defaultGesture;
        bloqueResp = [repBloque;claseBloque];
        bloquesRespuestas = [bloquesRespuestas bloqueResp];
    end
    
    
    %%***********%
    % mostrar representaciOn en bloques!
    if flags.mostrarBloque
        disp('fila 1: numRepeticiones en el bloque')
        disp(bloquesRespuestas)
        disp('fila 2: clase correspondiente')
    end
    %%***********%
    
end





%% Resultados de la clasificacion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% en el caso de que la respuesta no presente discontinuidades.
% Caso1 % bloqueRespuesta = [30;2] % 30 veces la clase 2.
% Caso2 % bloqueRespuesta = [15 30 27;6 2 6] % 15 veces noGesto, 30 veces la clase 2, 27 veces noGesto

%-------------------------------
% 1 elemento
if isequal(size(bloquesRespuestas),[2 1])
    
    % Caso 1 (todas las respuestas corresponden a una clase)
    classPrediction = bloquesRespuestas(2);
    
    %-------------------------------
    % 2 elementos
elseif  isequal(size(bloquesRespuestas),[2 2])
    
    % Caso 2. (caso improbable, un gesto reconocido al incio, con noGestos al final)
    if bloquesRespuestas(2,2) == defaultGesture
        classPrediction = bloquesRespuestas(2,1); % el primer valor
        
        % Caso 3. (caso improbable, espejo. un gesto reconocido al final, con noGestos al inicio)
    elseif bloquesRespuestas(2,1) == defaultGesture
        classPrediction = bloquesRespuestas(2,2); % el primer valor
        
        % Caso 4. (caso improbable, dos gestos sin noGesto)
    else
        
        respParasitas = bloquesRespuestas(:,bloquesRespuestas(2,:) ~= trueClass); % remuevo las clasificaciones correctas y los noGestos.
        [~, posclassPrediction] = max(respParasitas(1,:)); % corresponde al que más veces apareciO (excluyendo a la clase correcta!).
        classPrediction = respParasitas(2,posclassPrediction);
    end
    
    %-------------------------------
    % 3 elementos
elseif isequal(size(bloquesRespuestas),[2 3])
    
    % Caso 5. (caso ideal, un gesto reconocido en medio de los noGestos)
    if bloquesRespuestas(2,1) == defaultGesture && bloquesRespuestas(2,3) == defaultGesture
        classPrediction = bloquesRespuestas(2,2); % el valor intermedio!
        
        % caso 6. el resultado no está en la mitad!
    else
        respParasitas = bloquesRespuestas(:,bloquesRespuestas(2,:) ~= defaultGesture & bloquesRespuestas(2,:) ~= trueClass); % remuevo las clasificaciones correctas y los noGestos.
        
        if isempty(respParasitas)
            % gesto correctamente clasificado pero vacíos intermedios!
            classPrediction = nan;
        else
            % gesto parásitos
            [~, posclassPrediction] = max(respParasitas(1,:)); % corresponde al que más veces apareciO (excluyendo a la clase correcta!).
            classPrediction = respParasitas(2,posclassPrediction);
        end
    end
    
    %-------------------------------
    % más elementos!
else
    % demás casos (discontinuidades y gestos parásitos)
    respParasitas = bloquesRespuestas(:,bloquesRespuestas(2,:) ~= defaultGesture & bloquesRespuestas(2,:) ~= trueClass); % remuevo las clasificaciones correctas y los noGestos.
    
    if isempty(respParasitas)
        % gesto correctamente clasificado pero vacíos intermedios!
        classPrediction = nan;
    else
        % gesto parásitos
        [~, posclassPrediction] = max(respParasitas(1,:)); % corresponde al que más veces apareciO (excluyendo a la clase correcta!).
        classPrediction = respParasitas(2,posclassPrediction);
    end
end

% validaciOn de resultados
reconocimientoAnalizar = (classPrediction == trueClass); % flags para realizar el análisis del reconocimiento (solo cuando son correctas todas las clasificaciones)




%% Resultados del reconocimiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, idxEMGStart, idxEMGEnd] = segmentationGesture(rawGesture); % segmentaciOn (basado en detectMuscleActivity)

if reconocimientoAnalizar % cuando la clasificaciOn fue correcta
    % obtenciOn trueGround
    trueGround = ones(1, numClasificaciones) * defaultGesture;
    
    %%%
    % primera clasificaciOn correcta!
    idxVectRespStart = ceil((idxEMGStart - idx1raClasificacion)/ saltoVentana) + 1; % potencial índice de la primera clasificaciOn correcta en el trueGround
    
    idxEMGVectRespStart = idx1raClasificacion + (idxVectRespStart - 1) * saltoVentana;
    % iteración hasta que cumpla con el umbral establecido!
    while ((idxEMGVectRespStart - idxEMGStart) / tamVentana) <= umbralVentana % discretizaciOn
        idxVectRespStart = idxVectRespStart + 1;
        idxEMGVectRespStart = idxEMGVectRespStart + saltoVentana;
    end
    
    % iteración hasta que sea positivo! (adicional debido a señales que empiezan el gesto antes de la 1era clasificación!)
    while idxVectRespStart < 1
        idxVectRespStart = idxVectRespStart + 1;
        idxEMGVectRespStart = idxEMGVectRespStart + saltoVentana;
    end
    
    %%%
    % última clasificaciOn correcta!
    idxVectRespEnd = ceil((idxEMGEnd - idx1raClasificacion)/ saltoVentana) + 1; % potencial ínidice de la última clasificación correcta
    idxEMGVectRespEnd = idx1raClasificacion + (idxVectRespEnd - 1) * saltoVentana;
    % iteración hasta que cumpla con el umbral establecido!
    while ((idxEMGEnd - (idxEMGVectRespEnd - tamVentana)) / tamVentana) > umbralVentana % discretizaciOn
        idxVectRespEnd = idxVectRespEnd + 1;
        idxEMGVectRespEnd = idxEMGVectRespEnd + saltoVentana;
    end
    idxVectRespEnd = idxVectRespEnd - 1;
    idxEMGVectRespEnd = idxEMGVectRespEnd - saltoVentana;
    
    trueGround(idxVectRespStart:idxVectRespEnd) = classPrediction;
        
    
    % cálculo factorSolapamiento
    % factorSolapamiento = 2 * A interseccion B / (A + B);
    % tamTrueGround <= A
    % tamResp <= B
    % interseccionResp <= A interseccion B
    
    tamTrueGround = sum(trueGround == trueClass);
    tamResp = sum(vectorRespuestas == trueClass);
    interseccionResp = sum(trueGround == trueClass & vectorRespuestas == trueClass);
    
    factorSolapamiento = 2 * interseccionResp / (tamTrueGround + tamResp);
    
    recogResult = factorSolapamiento > umbralRecognition;
else
    % no existe rate del reconocimiento!
    factorSolapamiento = nan;
    recogResult = nan;
end


%% output
resultados.classPrediction = classPrediction;
resultados.classResult = reconocimientoAnalizar;
resultados.factorSolapamiento = factorSolapamiento;
resultados.recogResult = recogResult;



%% dibujar!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flags.dibujar
    % inicio
    lienzo = figure;
    respuestaAxes = axes('Parent',lienzo);
    hold(respuestaAxes, 'on');
    respuestaAxes.XGrid = 'on';
    respuestaAxes.XTick = vectorRespuestaPosicion;
    respuestaAxes.YTick = [];
    respuestaAxes.XLim = [0 size(rawGesture, 1)];
    respuestaAxes.YLim = [-2 3];
    xlabel(respuestaAxes,'Muestras [cada 1/200 seg]')
    
    %%% EMG
    % rawEMG
    plot(respuestaAxes, sum(abs(rawGesture),2) / max(sum(abs(rawGesture),2)) * 2) % representaciOn en un solo canal del gesto, amplitud de 0 a 2,
    % segmentaciOn!
    text(idxEMGStart, 1.5, [num2str(idxEMGStart) ': inicio'], 'HorizontalAlignment', 'right')
    quiver(idxEMGStart, 0, 0, 1.5,0,'LineWidth', 2, 'marker', 'o',...
        'Color', [0 0.447 0.741])
    
    text(idxEMGEnd, 1.5, [num2str(idxEMGEnd) ': fin'])
    quiver(idxEMGEnd, 0, 0, 1.5,0,'LineWidth', 2, 'marker', 'o', 'Color', [0 0.447 0.741])
    
    %%% respuestas
    % punto de la primera respuesta
    text(idx1raClasificacion, 1, '1er resultado!')
    quiver(idx1raClasificacion, 0, 0, 1,0,'LineWidth', 1, 'marker', 'o')
    
    % respuestas
    plot(respuestaAxes, vectorRespuestaPosicion,...
        vectorRespuestas / max(vectorRespuestas) - 2,'linewidth', 2,...
        'Color', [0.85 0.325 0.098])
    
    % texto respuestas!
    text(0, -1.25, 'vectorRespuestas',  'fontsize', 15, 'fontweight', 'bold',...
        'color',[0.85 0.325 0.098])
    text(vectorRespuestaPosicion,...
        zeros(size(vectorRespuestaPosicion)) - 1,...
        strsplit(num2str(vectorRespuestas),' '),...
        'fontsize', 15, 'fontweight', 'bold', 'HorizontalAlignment', 'right')
    
    % respuesta en bloque
    text(numPuntosEMG,2.5, 'Respuesta en bloque',...
        'fontweight', 'bold', 'HorizontalAlignment', 'right')
    
    for kBloque = 1:size(bloquesRespuestas,2)
        text(numPuntosEMG, 2.5 - kBloque * 0.25,...
            ['clase ' num2str(bloquesRespuestas(2,kBloque))...
            ': ' num2str(bloquesRespuestas(1,kBloque)) ' veces'],...
            'fontweight', 'bold', 'HorizontalAlignment', 'right')
    end
    
    % parámetro umbral!
    text([1 1],[2.5 2.25], {'Umbral solapamiento ventana y gesto!',...
        num2str(umbralVentana)}, 'fontweight', 'bold','fontangle', 'italic')
    
    %% en el caso de una correcta clasificaciOn
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    if reconocimientoAnalizar
        % mensaje de correcta clasificaciOn
        text(numPuntosEMG, -1.25, 'OK!! clasificado!',  'fontsize', 15, 'fontweight', 'bold',...
            'HorizontalAlignment', 'right', 'Color', [051 204 051]/ 255)
        
        % recognition
        if recogResult
            text(numPuntosEMG, -1.75, ['factorSolapamiento: ' num2str(factorSolapamiento), '. OK!'],  'fontsize', 17, 'fontweight', 'bold',...
                'HorizontalAlignment', 'right', 'Color', [051 204 051]/ 255)
        else
            text(numPuntosEMG, -1.75, ['Reconocimiento: ' num2str(factorSolapamiento), '. WRONG!'],  'fontsize', 17, 'fontweight', 'bold',...
                'HorizontalAlignment', 'right', 'Color', [204 051 051]/ 255)
        end
        % trueGround!
        plot(respuestaAxes, vectorRespuestaPosicion,...
            trueGround / max(trueGround) - 1, 'linewidth', 2,...
            'Color', [102 204 255] / 255)
        % mensaje
        text(0, -0.25, 'trueGround',  'fontsize', 15, 'fontweight', 'bold',...
            'Color', [102 204 255] / 255)
        %%%
        % primera clasificaciOn correcta
        x1 = idxEMGVectRespStart - tamVentana;
        x2 = idxEMGVectRespStart;
        y11 = 0;
        y12 = 1.75;
        y21 = 0;
        y22 = 2;
        % ventana de la primera clasificaciOn correcta
        plot([x1, x2, x2, x1, x1], [y11, y21, y22, y12, y11], ':', 'LineWidth', 1.5, ...
            'Color', [102 204 51] / 255);
        % texto de la ventana
        text(x1, 1.5, 'W 1era class correcta', ...
            'color',[102 204 51]/255, 'fontweight','bold','HorizontalAlignment', 'right');
        % porcentaje!
        patch([idxEMGStart, x2, x2, idxEMGStart, idxEMGStart], [0, 0, y22, 1.5, 0],...
            [102 204 51]/ 255, 'facealpha', 0.1,...
            'edgecolor',[102 204 51] / 255);
        text(idxEMGVectRespStart, 1.5, ['ventana>=' num2str(umbralVentana)],...
            'HorizontalAlignment', 'right','color',[102 204 51]/255, 'fontweight','bold')
        % línea proyecciOn
        quiver(idxEMGVectRespStart, -2, 0, 2,0,'LineWidth', 1, 'marker', 'o','color',[102 204 51]/255)
        
        %%%
        % última clasificaciOn correcta
        x1 = idxEMGVectRespEnd  - tamVentana;
        x2 = idxEMGVectRespEnd;
        % ventana!
        plot([x1, x2, x2, x1, x1], [y11, y21, y22, y12, y11], ':', 'LineWidth', 1.5,...
            'Color', [255 204 0] / 255);
        % texto de la venta
        text(x2, 1.5, 'WLast class correcta', ...
            'color',[255 204 0]/255, 'fontweight','bold')
        % porcentaje!
        patch([idxEMGEnd, x1, x1, idxEMGEnd, idxEMGEnd], [0, 0, y22, 1.5, 0],...
            [255 204 0] / 255, 'facealpha', 0.1,...
            'edgecolor',[255 204 0] / 255);
        text(x1, 1.5, ['ventana>=' num2str(umbralVentana)], ...
            'color',[255 204 0]/255, 'fontweight','bold')
        % línea proyecciOn
        quiver(idxEMGVectRespEnd, -2, 0, 2,0,'LineWidth', 1, 'marker', 'o','color',[255 204 0]/255)
        
    else
        % mensaje de incorrecta clasificaciOn
        text(numPuntosEMG, -1.25, 'WRONG!! no clasificado!',  'fontsize', 15, 'fontweight', 'bold',...
            'Color', [204 051 051]/ 255, 'HorizontalAlignment', 'right')
    end
end


end


