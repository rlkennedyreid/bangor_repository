function [clipped_signal, num_changes, change_ratio] = clipSignal(INPUT_SIGNAL, CLIPPING_RATIO_DB)
%CLIPSIGNAL Summary of this function goes here
%   Detailed explanation goes here
    
    clipping_ratio = 10^(CLIPPING_RATIO_DB*0.1);
    
    clipped_signal = INPUT_SIGNAL;
    
    average_signal_power = meansqr(INPUT_SIGNAL);
    
    max_amplitude = realsqrt(clipping_ratio*average_signal_power);
    
    above_max = clipped_signal > max_amplitude;
    below_min = clipped_signal < -max_amplitude;
    
    clipped_signal(above_max) = max_amplitude;
    clipped_signal(below_min) = -max_amplitude;
    
    num_changes = nnz(above_max) + nnz(below_min);
    change_ratio = num_changes/numel(INPUT_SIGNAL);
    
end

