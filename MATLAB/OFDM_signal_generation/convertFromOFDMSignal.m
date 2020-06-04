function extracted_signal = convertFromOFDMSignal(OFDM_SIGNAL, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH)
% convertFromOFDMSignal convert real OFDM signal back to original complex
% signal through fft
% 
% extracted_signal = convertFromOFDMSignal(OFDM_SIGNAL, NUM_SYMBOLS_PER_CARRIER, NUM_SUBCARRIERS)
% 
%   OFDM_SIGNAL: The real OFDM signal
% 
%   NUM_SYMBOLS_PER_CARRIER: The number of symbols per subcarrier, this is
%   the expected number of columns in the complex signal
% 
%   NUM_SUBCARRIERS: The number of subcarriers, this is the expected number
%   of rows in the complex signal

%   LHS, RHS and the N/2 and 0 frequencies
    number_of_rows = (2 + (2*NUM_SUBCARRIERS))*(1+CYCLIC_PREFIX_LENGTH);
    
    reshaped = reshape(OFDM_SIGNAL, number_of_rows, []);
    
    without_prefix = reshaped(end - (2 + (2*NUM_SUBCARRIERS)) + 1:end,:);

    received = fft(without_prefix);
        
    extracted_signal = received((end-NUM_SUBCARRIERS+1):end,:);

end