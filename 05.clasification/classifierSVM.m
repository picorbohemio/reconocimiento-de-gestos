function label=classifierSVM(testSet,svmModel,options)

    distanceSV=options.distanceSV;

    [label,score]=predict(svmModel,testSet);
    
    score=abs(score);
    scoreMin=min(score);

    if(scoreMin>distanceSV)
        label=6;
    end

end