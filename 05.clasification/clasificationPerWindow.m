function y=clasificationPerWindow(base,model,muestra,startIndex,valueWindow,options)

    numSamples=options.numSamples;
    numInstant=options.numInstant;
    b=base.emg{muestra,1};
    
    featurePreClassification=[];
    %% Feature Extraction
    for sensor=1:8

            signalIn=b(startIndex:startIndex+valueWindow-1,sensor);
            signalIn=preprocessing(signalIn,options);
            
            wl= extractionWavelets(signalIn,options);
            sizeBWL=size(wl);
            sizeWL=sizeBWL(1);
            t=sizeWL*numInstant;
            count=1;

            for i=1:valueWindow %%%%%%%%%%%%%%%%%%%%
                j=i+numInstant-1;
                if(valueWindow>=j)
                    partwl=wl(1:sizeWL,i:j);
                    tpartwl=partwl(:)';

                    featurePreClassification(count,(t*sensor)-(t-1):(t*sensor))=tpartwl;
                    count=count+1;
                end
            end

    end

    %% single-label selection
    sAux=size(featurePreClassification);
    s=sAux(1);
    div=floor(s/numSamples); 
    
    featureAux=[];
    countTwo=1;
    sFor=1:div:s;
    b=length(sFor);
    labels=zeros(1,b);

     for j=sFor
        featureAux(countTwo,:)=featurePreClassification(j,:);
        countTwo=countTwo+1;
     end

     for j=1:b
        feature=featureAux(j,:);
        label=classifierSVM(feature,model,options); %Clasification
        labels(j)=label;
     end

    %array
    labels(labels==6)=[];
    if isempty(labels)
        y=6;
    else
        y=mode(labels);  
    end
    
end
