function normalised_signal = normalisePower(signal)
%NORMALISEPOWER Simple function to normalise a signal's power to 1

    signal_power = mean(abs(signal(:).^2));
    
    multiplier = (sqrt(1/signal_power));
    
    normalised_signal = multiplier * signal;   
    
end

