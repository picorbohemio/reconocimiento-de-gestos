clc;
close all;
clear all;
warning off all;

%% TOOLBOXES
%% =======================================================================

addpath(genpath('01.data'));
addpath(genpath('02.preprocessing'));
addpath(genpath('03.featureExtraction'));
addpath(genpath('04.training'));
addpath(genpath('05.clasification'));
addpath(genpath('06.evaluacionRealTime'));

%% SETTINGS
%% =======================================================================
loadOptions;

%Configuraciones de Guardado
description='evaluacionFinal';
formatOut = 'yyyy-mm-dd';
dateNow=datestr(now,formatOut);

%Carpetas de resultados
dirname=['results-' dateNow];
mkdir(['results/' dirname]);
mkdir(['results/' dirname '/plotconfusion']);
mkdir(['results/' dirname '/plotconfusionUsers']);

%Para todos los usuarios
users= getListFiles(options.folderAddressData,options.gender,'*');

%Para un usuario especifico
%users = {'EstefanCevallos', 'AlexToasa'};

lengthUser=length(users);

gestures = {'waveIn',...
            'waveOut',...
            'fist',...
            'fingersSpread',...
            'doubleTap',...
            'relax'};

lengthGestures=length(gestures);
count=1;

%Inicializacion de Tablas de Resultados

varName={   'Iteracion',...
            'NumeroUsuarios',...
            'TamanioVentana',...
            'ClasificacionesPorVentana',...
            'Solapamiento',...
            'KernelSVM',...
            'GradoPolinomial',...
            'RutinaOptimizacion',...
            'motherWavelet',...
            'NivelArbolWavelet',...
            'Rectificado',...
            'Filtrado',...
            'TipoFiltro',...
            'FrecuenciaCorte',...
            'NivelPostprocesamiento',...
            'TiempoEntrenamientoPorUsr',...
            'TiempoClasificacionPorUsr',...
            'ExactitudPromedio'};
        
%myTabla = array2table(arrayRes,'VariableNames',varName);
myTablaTime=array2table(0,'VariableNames',{'Tiempos'});
myTablaAccuracy=array2table({0,0},'VariableNames',{'User' 'Accuracy'});

%Carga de Parametros
numCalibration=options.numCalibration;
%motherWaveletList = {'db25', 'db1'}; %Incluir wavelets a probar
motherWaveletList = {'db25'};

%% EXECUTION OF MODEL 
%% =======================================================================
for mw=1:length(motherWaveletList)
    options.wname=motherWaveletList{mw};
    
    %Inicializacion de datos para la matriz de confusion
    targetsTotal=[];
    predictionsTotal=[];
    tarT=[];
    outT=[];
    
    tiemposTotales=[];
    exactitudTotales=[];
    
    trainingAverageTimes=[];
    ClasificationAverageTimes=[];
    
    for user_i = 1:length(users)
        
        target=zeros(5,numCalibration);
        outputs=zeros(5,numCalibration);
        
        for i=1:numCalibration
            target(1,i)=1;
            target(2,i)=2;
            target(3,i)=3;
            target(4,i)=4;
            target(5,i)=5;
        end
        
        %% Training
        
        disp(['Training... User ' int2str(user_i) '/' int2str(length(users))]);
        
        startTraining=tic;
        baseModel=createBaseWavelets(users{user_i}, options);
        model=trainingSVM(baseModel,options);
        endTraining=toc(startTraining);
        
        trainingAverageTimes=[trainingAverageTimes,endTraining];
        
        disp(['Training Time: ' num2str(endTraining)]);
        
        %% Classification
        
        disp(['Classifier... User ' int2str(user_i) '/' int2str(length(users))]);
        
        %Calculo de exactitud por usuario
        acerts=numCalibration*(length(gestures)-1);
        
        inicioCla=tic;
        for gesture=1:length(gestures)-1
            for muestra=1:numCalibration
                
                base=dataRead(options.folderAddressData,'testing',options.gender,users{user_i},gestures{gesture});
                [responseVector,arrayTime]=clasificationPerGesture(base,model,muestra,options);
                
                gest=gestureToCode(gestures{gesture});
                rawGesture=base.emg{muestra,1};
                sysParameters.idx1raClasificacion = options.valueWindow;
                resultado = classVectorEval(rawGesture,responseVector,gest,sysParameters, flags);
                %r=CaseTest(ar,g);
                %r
                %resultado.classPrediction
                
                %if(options.saveTime==true)
                %tiemposTotales=[tiemposTotales;arrayTime];
                %exatitudTotales=[exactitudTotales;arrayTime];
                %end
                
                if(isnan(resultado.classPrediction))
                    resultado.classPrediction=7;
                end
                
                if(resultado.classPrediction~=gest)
                    acerts=acerts-1;
                end
                
                outputs(gesture,muestra)=resultado.classPrediction;
                
            end
        end
        aa=arrayTime;
        accuracyUser= acerts/(numCalibration*length(gestures)-1);
        %disp(['Accuracy: ' num2str(accuracyUser)]);
        if(options.saveTime==true)
            tiemposTotales=[tiemposTotales;aa];
        end
        
        if(options.saveUserAccuracy==true)
            info={users(1,user_i), accuracyUser};
            myTablaAccuracy=[myTablaAccuracy;info];
        end
        
        finClasification=toc(inicioCla);
        
        ClasificationAverageTimes=[ ClasificationAverageTimes,finClasification];
        
        disp(['Classification Time: ' num2str(finClasification)]);
        
        targetPart = full(sparse(target',1:numCalibration*5,1,7,numCalibration*5));
        predictionsPart = full(sparse(outputs',1:numCalibration*5,1,7,numCalibration*5));
        
        plotconf=plotconfusion(targetPart,predictionsPart);
        savefig(plotconf,['results/' dirname '/plotconfusionUsers/' users{user_i} '.fig'])
        
        close(plotconf)
        
        tarT=[tarT,target];
        outT=[outT,outputs];
        
        targetsTotal=[targetsTotal,targetPart];
        predictionsTotal=[predictionsTotal,predictionsPart];
        
    end
    
    accuracy=100*mean(tarT(:)==outT(:));
    
    % %% plot confusion for gesture recognition
    
    plotconf=plotconfusion(targetsTotal,predictionsTotal);
    savefig(plotconf,['results/' dirname '/plotconfusion/plotconf' int2str(count) '.fig'])
    
    if(options.savejpg==true)
        saveas(gcf,['results/' dirname '/plotconfusion/plotconf' int2str(count) '.jpg'])
    end
    
    close(plotconf)
    
    if(options.filtering==false)
        options.typefilt='-';
        frec='-';
    
    elseif(strcmp(options.typefilt,'bandpass'))
        frec=[options.cutfreqband1,options.cutfreqband2];
        
    elseif(strcmp(options.typefilt,'low') || strcmp(options.typefilt,'high'))
        frec=options.cutfreq;
    
    end
    
    %% Saved results
    arrayRes={  count,...
        lengthUser,...
        options.valueWindow,...
        options.numSamples,...
        options.numDisplacement,...
        options.kernelFunctionSVM,...
        options.polynomialOrderSVM,...
        options.solverSVM,...
        options.wname,...
        options.levelTree,...
        options.rectification,...;
        options.filtering,...
        options.typefilt,...
        frec,...
        options.state,...
        mean(trainingAverageTimes),...
        mean(ClasificationAverageTimes),...
        accuracy};
    
    if(count==1)
        myTabla = array2table(arrayRes,'VariableNames',varName);
    else
        myTabla = [myTabla ; arrayRes];
    end
    
    if(options.saveTime==true)
        tt=num2cell(tiemposTotales);
        myTablaTime = [myTablaTime;tt];
        
    end
    
    
    display(myTabla)
    results.date=datestr(now);
    results.tab=myTabla;
    
    filename=['results-' dateNow '-' description];
    save(['results/' dirname '/' filename] ,'results');
    
    %filenameTime=['resultsTime-' dateNow];
    
    if(options.savexlsx==true)
        xlsxName=['results/' dirname '/' filename '.xlsx'];
        writetable(myTabla,xlsxName,'Sheet', 1);
        
        if(options.saveTime==true)
            writetable(myTablaTime,xlsxName,'Sheet', 2);
        end
        
        if(options.saveUserAccuracy==true)
            writetable(myTablaAccuracy,xlsxName,'Sheet', 3);
        end
    end
    
    count=count+1;
end

        

