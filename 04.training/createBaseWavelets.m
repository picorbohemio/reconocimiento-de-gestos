function databaseOut=createBaseWavelets(nameUser,options)
    
    numTrainingGesture=options.numTrainingGesture;
    numTrainingRelax=options.numTrainingRelax;
    valueWindow=options.valueWindow;
    

    databaseOut=[   createPartWavelets(nameUser,valueWindow,'waveIn',options,numTrainingGesture);
                    createPartWavelets(nameUser,valueWindow,'waveOut',options,numTrainingGesture);
                    createPartWavelets(nameUser,valueWindow,'fist',options,numTrainingGesture);
                    createPartWavelets(nameUser,valueWindow,'fingersSpread',options,numTrainingGesture);
                    createPartWavelets(nameUser,valueWindow,'doubleTap',options,numTrainingGesture);
                    createPartWavelets(nameUser,valueWindow,'relax',options,numTrainingRelax)];

end
