function [pureGesture, idxStart, idxEnd] = segmentationGesture(rawGesture)

% par�metros de la segmentaci�n (detectMuscleActivity)
options.fs = 200; % Sampling frequency of the emg
options.minWindowLengthOfMuscleActivity = 80;
options.threshForSumAlongFreqInSpec = 10; % Threshold for detecting the muscle activity
options.plotSignals = false;

%% preprocesamiento
freqFiltro = 0.05;
[Fb, Fa] = butter(4, freqFiltro, 'low'); % creando filtro
rawGesture = filtfilt(Fb, Fa, abs(rawGesture));

%% segmentaci�n
[idxStart, idxEnd] = detectMuscleActivity(rawGesture, options);

% recorte se�al
pureGesture = rawGesture(idxStart:idxEnd, :);
end
