clc
clear all
Nsc = 15; % the number of subcarriers for each OFDM sub-band
IFFT_size = 32; % IFFT_size={2*Nsc+2,Nsc} the first to generate the real OFDM signal, the second used for complex signal generation
CP = 1/8; % CP length
Nsymbol = 1e4;
% Mod_Format_Name_mat = strvcat('None','DBPSK','DQPSK','16QAM','32QAM',...
%         '64QAM','128QAM','256QAM');
% Mod_Format_bits = [0,1,2,4,5,6,7,8];
bitloading = [4 4 4 4 4  4 4 4 4 4  4 4 4 4 4];
powerloading = ones(1,15)';
%%%%%%%%%%%
[OFDM_Sig,Tx,TotalBits] = ModOFDM(Nsc,IFFT_size,Nsymbol,CP,bitloading,powerloading);
SNR_array = 1:20;
for kk = 1:length(SNR_array)
    snr = SNR_array(kk);
    P_sig = mean(abs(OFDM_Sig).^2);
    P_noise = P_sig/10^(snr/10);
    randn('state',2)
    noise = sqrt(P_noise)*randn(1,length(OFDM_Sig));
    Rx = OFDM_Sig + noise;
    [BER(kk),BER_Subcarrier,All_ErrorBit,All_TransBit,Rx_QAM,FFT_QAM] = DemodOFDM(Rx,Tx,IFFT_size,Nsc,...
        CP,Nsymbol,bitloading,300,0,0);
end
semilogy(SNR_array,BER,'b-^',SNR_array,1e-3*ones(1,length(SNR_array)),'r-')
xlabel('SNR (dB)')
ylabel('BER')
        
