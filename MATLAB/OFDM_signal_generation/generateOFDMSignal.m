function ofdm_signal = generateOFDMSignal(MODULATED_SIGNAL)

    symmetric_conjugate_signal = generateSymmetricConjugate(MODULATED_SIGNAL);

    ifft_signal = ifft(symmetric_conjugate_signal);
    ofdm_signal = reshape(ifft_signal,1,[]);

end