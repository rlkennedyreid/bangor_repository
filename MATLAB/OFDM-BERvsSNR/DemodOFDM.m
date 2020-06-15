function [BER,BER_Subcarrier,All_ErrorBit,All_TransBit,Rx_QAM,FFT_QAM] = DemodOFDM(Rx,Tx,IFFT_size,Nsc,...
    CP,Nsymbol,bitloading,TrainSeq,Constellation_FFT,Constellation_SigRecv)
%%%%%%%%%%%%%%%%%%%%%%%%% parameter setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mod_Format_Name_mat = strvcat('None','DBPSK','DQPSK','16QAM','32QAM',...
        '64QAM','128QAM','256QAM');
Mod_Format_bits = [0,1,2,4,5,6,7,8];
%%%%%%%%%%%%%%%%%%%%%%% Delete CP and FFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rx = Rx - mean(Rx);
Rx = Rx(1:(1+CP)*IFFT_size*Nsymbol);
Rx = reshape(Rx,(1+CP)*IFFT_size,[]);
Rx = Rx((CP*IFFT_size+1):end,:); % delete CP
Rx = fft(Rx);
if IFFT_size == 2*Nsc+2
    Rx = Rx(end-Nsc+1:end,:);
end
Rx = Rx(1:Nsc,1:Nsymbol);
Tx = Tx(1:Nsc,1:Nsymbol);
if Constellation_FFT == 1  %%%% draw the constellation
    ss = Rx;
    ss = reshape(ss,1,[]);
    ss = ss/mean(abs(ss).^2);
    figure
    plot(real(ss), imag(ss),'.b');
end
FFT_QAM = Rx;
%%%%%%%%%%%%%%%%%%%%%% Signal recovery and BER %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% channel estimation for each subcarrier and BER calculation
Rx_TrainSeq = Rx(:,1:TrainSeq);
Tx_TrainSeq = Tx(:,1:TrainSeq);
Rx = Rx(:,TrainSeq+1:end); %%%% delete the training sequence
Tx = Tx(:,TrainSeq+1:end);
for p = 1:1:Nsc
    if Mod_Format_bits(bitloading(p)) == 0
        BER_Subcarrier(p) = 0;
        N_ErrorBit(p) = 0;
        N_TransmittedBit(p) =0;
    else
        %%%% channel estimation
        H_Channel = mean(Rx_TrainSeq(p,:)./Tx_TrainSeq(p,:),2);
        Rx(p,:) = Rx(p,:)./repmat(H_Channel,1,size(Rx,2));
        %%% BER calculation
        Bit_QAM = Mod_Format_bits(bitloading(p));
        MapMode = Mod_Format_Name_mat(bitloading(p),:);
        bits_Rx = modulate_def(Rx(p,:),MapMode,-1);
        bits_Tx = modulate_def(Tx(p,:),MapMode,-1);
        N_ErrorBit(p) = sum(sum(abs(bits_Rx-bits_Tx)));
        N_TransmittedBit(p) = Bit_QAM*Nsymbol;
        BER_Subcarrier(p) = N_ErrorBit(p)/(N_TransmittedBit(p));
    end
end
%%%%%% the BER exclude the training sequence and pilot subcarrier
BER = sum(N_ErrorBit)/sum(N_TransmittedBit);
All_ErrorBit = sum(N_ErrorBit);
All_TransBit = sum(N_TransmittedBit);

Rx_QAM = Rx;
if Constellation_SigRecv == 1  %%%% draw the constellation
    ss = Rx;
    ss = reshape(ss,1,[]);
    ss = ss/mean(abs(ss).^2);
    figure
    plot(real(ss), imag(ss),'.b');
end
end