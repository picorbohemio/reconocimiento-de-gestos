function dataGesture=dataRead(folderAddress,versionTT,gender,nameUser,nameGesture)

% folderAddress % ubicación de la carpeta(women,men)
% genero % men\women
% versionTT % training\testing

    if isequal(versionTT, 'training')
        userD = 'Train';
    else
        userD = 'Test';
    end

    filepath = [folderAddress '\' gender '\' nameUser '\' versionTT '\userData.mat'];
    userData = load(filepath);

    userData = userData.(['userData' userD]).gestures;
    if isequal(nameGesture,'relax')
        dataGesture.emg = cell(10,1);
        dataGesture.myo = cell(10,1);
        dataGesture.gesture=userData.(nameGesture).gestureName;
        for kRep = 1:10
            dataGesture.emg{kRep} = userData.(nameGesture).data{kRep, 1}.emg;
            dataGesture.myo{kRep} = userData.(nameGesture).data{kRep, 1}.pose_myo;
        end

    else
        dataGesture.emg = cell(25,1);
        dataGesture.myo = cell(25,1);
        dataGesture.gesture=userData.(nameGesture).gestureName;
        for kRep = 1:25
            dataGesture.emg{kRep} = userData.(nameGesture).data{kRep, 1}.emg;
            dataGesture.myo{kRep} = userData.(nameGesture).data{kRep, 1}.pose_myo;
        end
    end

end

