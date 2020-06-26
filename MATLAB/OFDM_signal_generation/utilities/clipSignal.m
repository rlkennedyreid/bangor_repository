function [clipped_signal, num_changes, change_ratio, max_amplitude] = clipSignal(INPUT_SIGNAL, CLIPPING_RATIO_DB)
%CLIPSIGNAL Function to clip a signal, given the signal and the clipping
%ratio in dB
    
    % Convert the clipping ratio from dB value
    clipping_ratio = 10^(CLIPPING_RATIO_DB*0.1);
    
    clipped_signal = INPUT_SIGNAL;
    
    average_signal_power = meansqr(INPUT_SIGNAL);
    
    % The new maximum amplitude
    max_amplitude = realsqrt(clipping_ratio*average_signal_power);
    
    % Use a logical array to store values where the amplitude is above or
    % below our limits
    above_max = clipped_signal > max_amplitude;
    below_min = clipped_signal < -max_amplitude;
    
    % Clip the extreme locations
    clipped_signal(above_max) = max_amplitude;
    clipped_signal(below_min) = -max_amplitude;
    
    % Any non-zero element in these arrays indicates a point we have now
    % clipped
    num_changes = nnz(above_max) + nnz(below_min);
    change_ratio = num_changes/numel(INPUT_SIGNAL);
    
end

