function [num_symbols_per_carrier, real_num_bits] = calcNumSymbolsPerCarrier(DESIRED_NUM_BITS, NUM_SUBCARRIERS, MODULATION_ORDER)
%CALCNUMSYMBOLSPERCARRIER Simple function to calculate the number of
%symbols needed per carrier in a modulation scheme, given the total number
%of bits desired, the number of subcarriers and the modulation order of the
%scheme
%   The actual number of bits that will be produced will not be exactly the
%   desired amount, and so is given as a secondary output

    num_bits_per_symbol = log2(MODULATION_ORDER);
    
    num_symbols_per_carrier = fix(DESIRED_NUM_BITS/(num_bits_per_symbol*NUM_SUBCARRIERS));
    
    real_num_bits = NUM_SUBCARRIERS*num_symbols_per_carrier*num_bits_per_symbol;
    
end

