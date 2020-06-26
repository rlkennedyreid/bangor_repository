function checkOFDMSymbolLength(NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH)
%CHECKOFDMSYMBOLLENGTH quick function to check that an OFDM symbol length
%will be correct, given the number of subcarriers and the cyclic prefix
%length as a fraction of original symbol

    OFDM_SYMBOL_LENGTH = ((2+2*NUM_SUBCARRIERS))*(1+CYCLIC_PREFIX_LENGTH);

    assert(mod(OFDM_SYMBOL_LENGTH, 1) == 0, "OFDM symbol length would not be an integer number of samples with the given settings.");
end

