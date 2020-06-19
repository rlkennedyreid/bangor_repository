function [PAPR_db] = calcPAPR(input_series)
%CALCPAPR Simple function to calculate the number of
%symbols needed per carrier in a modulation scheme, given the total number
%of bits desired, the number of subcarriers and the modulation order of the
%scheme
%   The actual number of bits that will be produced will not be exactly the
%   desired amount, and so is given as a secondary output
    PAPR_db = 20*log10(peak2rms(input_series(:)));
end

