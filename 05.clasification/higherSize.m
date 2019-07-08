function resultado=higherSize(folderAddress,nameUser,gender,options)

    waveIn=dataRead(folderAddress,'training',gender,nameUser,'waveIn');
    waveOut=dataRead(folderAddress,'training',gender,nameUser,'waveOut');
    fist=dataRead(folderAddress,'training',gender,nameUser,'fist');
    fingersSpread=dataRead(folderAddress,'training',gender,nameUser,'fingersSpread');
    doubleTap=dataRead(folderAddress,'training',gender,nameUser,'doubleTap');
    %relax=load([nombreBase '_relax']);

    numTraining=options.numTrainingGesture;
    arr=zeros(1,numTraining*5);
    count=1;


    for sample=1:numTraining
        [s,e]=detectMuscleActivity(waveIn.emg{sample,1}*128, options);
        tam=floor((e-s));
        arr(count)=tam;
        count=count+1;

        [s,e]=detectMuscleActivity(waveOut.emg{sample,1}*128, options);
        tam=floor((e-s));
        arr(count)=tam;
        count=count+1;

        [s,e]=detectMuscleActivity(fist.emg{sample,1}*128, options);
        tam=floor((e-s));
        arr(count)=tam;
        count=count+1;

        [s,e]=detectMuscleActivity(fingersSpread.emg{sample,1}*128, options);
        tam=floor((e-s));
        arr(count)=tam;
        count=count+1;

        [s,e]=detectMuscleActivity(doubleTap.emg{sample,1}*128, options);

        tam=floor((e-s));
        arr(count)=tam;
        count=count+1;

    end

    resultado=floor(min(arr));

end