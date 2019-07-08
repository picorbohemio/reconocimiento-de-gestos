function databaseOut=createPartWavelets(nameUser,valueWindows,gesture,options,numTraining)

    databaseIn=dataRead(options.folderAddressData,'training',options.gender,nameUser,gesture);

    numInstant=options.numInstant;
    codeMov =gestureToCode(databaseIn.gesture);
    data=[];
    databaseAux =cell(numTraining,1);
    databaseOut=[];

    
    for sample=1:numTraining
        
        dbLength=length(databaseIn.emg{sample,1});
        [a,b]=detectMuscleActivity(databaseIn.emg{sample,1}*128, options);
        
        if(isequal(gesture, 'relax'))
            m=floor(dbLength/2);
        else
            m=floor((a+b)/2);
        end

        for sensor=1:8
            
            if(m+floor(valueWindows/2)>=1000)
                signalIn=databaseIn.emg{sample,1}(dbLength-valueWindows:dbLength,sensor);
            else
                signalIn=databaseIn.emg{sample,1}(m-floor(valueWindows/2):m+floor(valueWindows/2),sensor);
            end
            
            signalIn=preprocessing(signalIn,options);
            wavelets=extractionWavelets(signalIn,options);
            
            wSize=size(wavelets);
            wLength=wSize(1);
            t=wLength*numInstant;

            count=1;
            for i=1:valueWindows
                
                j=i+(numInstant-1);
                if(valueWindows>=j)
                    
                    matrixAux=wavelets(1:wLength,i:j);
                    matrixAux2=matrixAux(:)';
                    data(count,1)=codeMov;                                     %Etiqueta
                    data(count,(t*sensor)-(t-2):(t*sensor)+1)=matrixAux2;      %Características
                    count=count+1;
                    
                end
            end

        end
        
        databaseAux{sample,1}=data;
        databaseOut=[databaseOut;databaseAux{sample,1}];
    
    end

end