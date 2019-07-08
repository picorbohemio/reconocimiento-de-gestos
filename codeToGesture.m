function gesture = codeToGesture(code)
% GESTURESTOCODE
%   CODES:
%       WAVE_IN        = 1
%       WAVE_OUT       = 2
%       FIST           = 3
%       FINGERS_SPREAD = 4
%       DOUBLE_TAP     = 5
%       RELAX          = 6

    gesture = 'relax';
    switch code
        case 1
            gesture = 'waveIn';
        case 2
            gesture = 'waveOut';
        case 3
            gesture = 'fist';
        case 4
            gesture = 'fingersSpread';
        case 5
            gesture = 'doubleTap';
        case 6
            gesture = 'relax';
    end
end