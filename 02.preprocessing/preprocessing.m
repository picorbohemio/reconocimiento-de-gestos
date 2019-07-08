function signalOut=preprocessing(signalIn,options)

    signal=signalIn;
    %Rectification
    if (options.rectification)
        signal=abs(signal);
    end
    %Filtering
    if (options.filtering)
        
        if(strcmp(options.typefilt,'low') || strcmp(options.typefilt,'high'))
            fcut=options.cutfreq/100;
        else
            fcut=[options.cutfreqband1/100, options.cutfreqband2/100];
        end

        [Fb,Fa] = butter(1, fcut, options.typefilt); 
        signal = filtfilt(Fb,Fa,signal);
    
    end

    signalOut=signal;

end