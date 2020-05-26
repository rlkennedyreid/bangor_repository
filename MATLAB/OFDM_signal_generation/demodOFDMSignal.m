function extracted_modulated_signal = demodOFDMSignal(ofdm_signal, NUM_SYMBOLS_PER_CARRIER, NUM_SUBCARRIERS)

    received = fft(reshape(ofdm_signal, [], NUM_SYMBOLS_PER_CARRIER));
    
    extracted_modulated_signal = received((end-NUM_SUBCARRIERS+1):end,:);

end