function code = gestureToCode(gesture)
% GESTURESTOCODE
%   CODES:
%       WAVE_IN        = 1
%       WAVE_OUT       = 2
%       FIST           = 3
%       FINGERS_SPREAD = 4
%       DOUBLE_TAP     = 5
%       RELAX          = 6

    switch gesture
        case 'waveIn'
            code = 1;
        case 'waveOut'
            code = 2;
        case 'fist'
            code = 3;
        case 'fingersSpread'
            code = 4;
        case 'doubleTap'
            code = 5;
        case 'relax'
            code = 6;
    end
end