function [num_symbols_per_carrier, real_num_bits] = calcAdaptiveNumSymbolsPerCarrier(DESIRED_NUM_BITS, MODULATION_ORDERS)
%CALCADAPTIVENUMSYMBOLSPERCARRIER Summary of this function goes here
%   Detailed explanation goes here

    num_subcarriers = numel(MODULATION_ORDERS);
    num_bits_per_symbol = sum(log2(MODULATION_ORDERS));
    
    % fix to a whole number
    num_symbols_per_carrier = fix(DESIRED_NUM_BITS/(num_bits_per_symbol*num_subcarriers));
    
    % the actual number of bits we will produce
    real_num_bits = num_subcarriers*num_symbols_per_carrier*num_bits_per_symbol;
end

