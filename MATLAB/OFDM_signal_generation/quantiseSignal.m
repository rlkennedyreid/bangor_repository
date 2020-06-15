function [quantised_signal] = quantiseSignal(SIGNAL, NUM_QUANTISATION_BITS)
%QUANTISESIGNAL Summary of this function goes here
%   Detailed explanation goes here
    num_quant_levels = 2^NUM_QUANTISATION_BITS;

%     SIGNAL = -100 + (100*2)*rand(1e6,1);

    minimum_val = min(SIGNAL);
    maximum_val = max(SIGNAL);

    quant_spacing = abs((maximum_val-minimum_val)/num_quant_levels);

    codebook = minimum_val:quant_spacing:maximum_val;
    partition = codebook(1:(end-1)) + quant_spacing/2;

    [~,quantised_signal] = quantiz(SIGNAL,partition,codebook);
end

