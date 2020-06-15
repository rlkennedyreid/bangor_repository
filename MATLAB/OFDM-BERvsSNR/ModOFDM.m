function [SigOutput,Tx,TotalBit] = ModOFDM(Nsc,IFFT_size,...
    Nsymbol,CP,bitloading,powerloading)
%%%%%%%%%%%% parameter setup %%%%%%%%%%%
Mod_Format_Name_mat = strvcat('None','DBPSK','DQPSK','16QAM','32QAM',...
        '64QAM','128QAM','256QAM');
Mod_Format_bits = [0,1,2,4,5,6,7,8];
QAMSig = zeros(Nsc, Nsymbol); % each column is an OFDM symbol
TotalBit = 0;
%%%%%%%%%%% generate QAM signals %%%%%%%%
for p = 1:Nsc   % bitloading
    if Mod_Format_bits(bitloading(p))==0
        continue;
    else
        Bit_QAM = Mod_Format_bits(bitloading(p));
        Bits = randn(1,Bit_QAM*Nsymbol)>0;
        MapMode = Mod_Format_Name_mat(bitloading(p),:);
        QAMSig(p,:) = modulate_def(Bits,MapMode,1);
        TotalBit = TotalBit + Bit_QAM*Nsymbol;
    end
end
 Tx = QAMSig;
 QAMSig =  QAMSig.*repmat(powerloading,1,Nsymbol);% powerloading
%%%%%%%%%%% generate OFDM signals %%%%%%%%
if IFFT_size ==2*Nsc+2 % to generate the real OFDM signal + its Hilbert transform in imag part
    QAMSig = [zeros(1,size(QAMSig,2));conj(QAMSig(end:-1:1,:));zeros(1,size(QAMSig,2));QAMSig];
end
OFDMSig = ifft(QAMSig); % ifft for each column to generate an OFDM symbol
OFDMSig = [OFDMSig((1-CP)*IFFT_size+1:end,:);OFDMSig]; % add CP
SigOutput = reshape(OFDMSig,1,[]);
end