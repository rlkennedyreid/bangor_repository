function ofdm_signal = convertToOFDMSignal(INPUT_SIGNAL, CYCLIC_PREFIX_LENGTH)
% convertToOFDMSIGNAL generate a real OFDM signal through ifft of a complex
% input signal
% 
% ofdm_signal = convertToOFDMSIGNAL(INPUT_SIGNAL)
% 
%   INPUT_SIGNAL: The complex input signal, each column is a list of
%   parallel symbols, corresponding to each subcarrier
% 
%   ofdm_signal: The real output OFDM signal

% Produce a symmetric conjugate signal so our ifft produces a real output
% signal
    symmetric_conjugate_signal = calcSymmetricConjugate(INPUT_SIGNAL);

    ifft_signal = ifft(symmetric_conjugate_signal);
    
%     error checking
    assert(isreal(ifft_signal));
    
    if CYCLIC_PREFIX_LENGTH ~= 0
        
    %     Get cyclic prefix offset, check for non integer or negative numbers
        offset = size(ifft_signal, 1)*CYCLIC_PREFIX_LENGTH - 1;

        assert(offset >= 0);
        assert(mod(offset, 1) == 0);

    %     Number of elements in cyclic prefix is offset + 1
        ifft_with_prefix = [ifft_signal(end-offset:end,:);ifft_signal];
    else
        ifft_with_prefix = ifft_signal;
    end
    
%     Parallel to serial conversion    
    ofdm_signal = reshape(ifft_with_prefix,1,[]);

end