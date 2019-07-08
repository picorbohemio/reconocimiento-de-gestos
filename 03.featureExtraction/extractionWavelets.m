function waveletSet=extractionWavelets(emgSignal,options)
    
    %options
    wname=options.wname;
    level=options.levelTree;
    fulltree=options.fullTree;
    wsquared=options.waveletSquared;
    timealign=options.timeAlign;


    [waveletSet,~,~]= modwpt(emgSignal,wname,level,'TimeAlign',timealign,'Fulltree',fulltree);

    if(wsquared)
        waveletSet= waveletSet.^2;
    end

end