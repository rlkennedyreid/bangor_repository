function symbol_stream = demodSignal(modulated_signal, MOD_ORDER, MODULATION_FORMAT)
    
    if strcmp(MODULATION_FORMAT, 'QAM')
        symbol_stream = qamdemod(modulated_signal, MOD_ORDER);
    elseif strcmp(MODULATION_FORMAT, 'PSK')
        symbol_stream = pskdemod(modulated_signal, MOD_ORDER);
    else
        error("Unknown argument for MODULATION_FORMAT");
    end
    
end