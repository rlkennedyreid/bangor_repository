function symbol_stream = decodeSignal(modulated_signal, MOD_ORDER, MODULATION_FORMAT)
    
    if strcmp(MODULATION_FORMAT, 'QAM')
        % Force the average power of signal to be 1
        symbol_stream = qamdemod(normalisePower(modulated_signal), MOD_ORDER, 'UnitAveragePower', true);
        
    elseif strcmp(MODULATION_FORMAT, 'QAM_binary')
        % Force the average power of signal to be 1      
        symbol_stream = qamdemod(normalisePower(modulated_signal), MOD_ORDER, 'bin', 'UnitAveragePower', true);
        
    elseif strcmp(MODULATION_FORMAT, 'PSK')
        symbol_stream = pskdemod(modulated_signal, MOD_ORDER);
        
    else
        error("Unknown argument for MODULATION_FORMAT");
    end
    
end