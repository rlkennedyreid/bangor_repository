function [symbol_stream] = calcAdaptiveRandomSymbolStream(MODULATION_ORDERS, NUM_SYMBOLS_PER_CARRIER)
%CALCADAPTIVERANDOMSYMBOLSTREAM Summary of this function goes here
%   Detailed explanation goes here
    
    num_subcarriers = numel(MODULATION_ORDERS);
    
    symbol_stream = zeros(num_subcarriers, NUM_SYMBOLS_PER_CARRIER);
    
    for substream_index = 1:1:num_subcarriers
        symbol_stream(substream_index, :) = randi([0, (MODULATION_ORDERS(substream_index)-1)], [1, NUM_SYMBOLS_PER_CARRIER]);
    end
end

