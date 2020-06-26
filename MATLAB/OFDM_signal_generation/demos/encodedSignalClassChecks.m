clearvars;

% Choose modulation order and format
DESIRED_NUM_BITS = 1e6;

NUM_SUBCARRIERS = 15;

MODULATION_ORDERS = datasample(2.^[3,4,5], NUM_SUBCARRIERS)';

MODULATION_FORMATS = datasample(["QAM"], NUM_SUBCARRIERS);

% To do - adapt for amoofdm
[num_symbols_per_carrier, real_num_bits] = calcAdaptiveNumSymbolsPerCarrier(DESIRED_NUM_BITS, MODULATION_ORDERS);

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

checkOFDMSymbolLength(NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH)

% Create QAM modulated signal, given number of symbols we want to generate
[symbol_stream] = calcAdaptiveRandomSymbolStream(MODULATION_ORDERS, num_symbols_per_carrier);

[modulated_signal] = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, symbol_stream);


for subcarrier_index = 1:1:NUM_SUBCARRIERS
    mod_order = modulated_signal.modulation_orders_(subcarrier_index);
    
    if mod_order == 2^3
        plot(modulated_signal.encoded_stream_(subcarrier_index, :), 'r.');
        hold on;
    end
    
    if mod_order == 2^4
        plot(modulated_signal.encoded_stream_(subcarrier_index, :), 'b.');
        hold on;
    end
    
    if mod_order == 2^5
        plot(modulated_signal.encoded_stream_(subcarrier_index, :), 'g.');
        hold on;
    end
end

% ofdm_signal = convertToOFDMSignal(modulated_signal, CYCLIC_PREFIX_LENGTH);
% ofdm_signal = awgn(ofdm_signal, 10, 'measured');
% 
% extracted_modulated_signal = convertFromOFDMSignal(ofdm_signal, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);
% scatterplot(extracted_modulated_signal(:))
% extracted_stream = decodeSignal(extracted_modulated_signal, MOD_ORDER, MODULATION_FORMAT);
% [~, bit_error_rate, ~, ~] = calcErrorRates(extracted_stream, symbol_stream);
