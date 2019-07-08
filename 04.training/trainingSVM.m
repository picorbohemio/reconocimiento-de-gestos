function svmModel=trainingSVM(dataSet,options)

    TrainingSet = dataSet(:,2:end);
    GroupTrain = dataSet(:,1);

    standardizeSVM=options.standardizeSVM;          
    kernelFunctionSVM=options.kernelFunctionSVM;    
    polynomialOrderSVM=options.polynomialOrderSVM;  
    solverSVM=options.solverSVM;                   

    if (strcmp(kernelFunctionSVM,'polynomial'))
        template = templateSVM('Standardize',standardizeSVM,'KernelFunction','polynomial','PolynomialOrder',polynomialOrderSVM,'KernelScale','auto','Solver',solverSVM);
    
    elseif (strcmp(kernelFunctionSVM,'auto'))
        template = templateSVM('Standardize',standardizeSVM,'KernelScale','auto','Solver',solverSVM);
    
    else
        template = templateSVM('Standardize',standardizeSVM,'KernelFunction',kernelFunctionSVM,'Solver',solverSVM);
    
    end

    %Construcción del modelo multiclase
    svmModel = fitcecoc(TrainingSet,GroupTrain,'Learners',template);

end