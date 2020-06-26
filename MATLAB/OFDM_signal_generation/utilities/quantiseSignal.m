function [quantised_signal] = quantiseSignal(SIGNAL, NUM_QUANTISATION_BITS, amplitude_limit)
%QUANTISESIGNAL Function to quantise a given signal into discrete levels
%   The number of levels is 2^NUM_QUANTISATION_BITS. The min and max level
%   is always the min and max of the original signal. Levels are evenly
%   spaced.

    assert(NUM_QUANTISATION_BITS > 0, 'Number of quantisation bits must be a positive integer');
    num_quant_levels = 2^NUM_QUANTISATION_BITS;
    
    switch nargin
        case 2
            minimum_val = min(SIGNAL);
            maximum_val = max(SIGNAL);
        case 3
            abs_limit = abs(amplitude_limit);
            minimum_val = -abs_limit;
            maximum_val = abs_limit;
    end
    
    % For N levels, there are N-1 spaces
    quant_spacing = abs((maximum_val-minimum_val)/(num_quant_levels-1));
    
    % partitions give the crossover value between mapping to corresponding
    % elements in codebook
    codebook = minimum_val:quant_spacing:maximum_val;
    partitions = codebook(1:(end-1)) + quant_spacing/2;
    
    [~,quantised_signal] = quantiz(SIGNAL,partitions,codebook);
end

