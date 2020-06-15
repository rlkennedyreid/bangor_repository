function [clipped_signal] = clipSignal(INPUT_SIGNAL, CLIPPING_RATIO)
%CLIPSIGNAL Summary of this function goes here
%   Detailed explanation goes here
    
    clipped_signal = INPUT_SIGNAL;
    average_signal_power = meansqr(INPUT_SIGNAL);
    max_amplitude = sqrt(CLIPPING_RATIO*average_signal_power);
    
    above_max = clipped_signal > max_amplitude;
    below_min = find(clipped_signal < -max_amplitude);
    
    clipped_signal(above_max) = max_amplitude;
    clipped_signal(below_min) = -max_amplitude;
    
    num_changes = nnz(above_max) + nnz(below_min);   
    
end

