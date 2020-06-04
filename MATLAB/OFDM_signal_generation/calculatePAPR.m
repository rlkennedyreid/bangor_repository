function [PAPR_db] = calculatePAPR(input_series)
    PAPR_db = 20*log10(peak2rms(input_series));
end

