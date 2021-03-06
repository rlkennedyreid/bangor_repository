function [normalised_snr] = normaliseSNR(NUM_BITS_PER_SYMBOL,SYMBOL_PERIOD_OVER_SAMPLE_PERIOD, SNR)
%NORMALISESNR Convert SNR in db to normalised SNR-per-bit (Eb/No)
%   Currently incorrect - will update once I have worked this equation out!

    normalised_snr = 10.0*(log10(SYMBOL_PERIOD_OVER_SAMPLE_PERIOD/NUM_BITS_PER_SYMBOL))+SNR;
end

