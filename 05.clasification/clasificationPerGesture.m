function [arrayOut,arrayTime]=clasificationPerGesture(base,model,sample,options)

    numDisplacement=options.numDisplacement;
    valueWindow=options.valueWindow;
    baseLength=length(base.emg{sample,1});
    count=1;

    valueFor=1:numDisplacement:baseLength-valueWindow;
    lengthFor=length(valueFor);
    arrayIn=zeros(1,lengthFor);
    arrayOut=zeros(1,lengthFor);
    arrayTime=zeros(lengthFor,1);

    for i=valueFor
        
        tic
        arrayIn(count)=clasificationPerWindow(base,model,sample,i,valueWindow,options);
        time=toc;

        if(options.saveTime==true)
            arrayTime(count)=time;
        end
        
%% Post-processing
        arrayOut(count)=postprocessing(count,arrayIn,options);
        count=count+1;         
    end
    
     %arrayOut

end