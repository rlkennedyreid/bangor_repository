clc;
clear all;

% Choose modulation order and format

MODULATION_ORDERS = 2.^[4,5,6,7,8];

MODULATION_FORMAT = 'QAM';

NUM_SUBCARRIERS = 7;

DESIRED_NUM_BITS = 1e5;

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

SNR_values = linspace(5,35, 50);
quantisation_bit_values = 1:1:16;

for order_index = 1:1:numel(MODULATION_ORDERS)
    
    MODULATION_ORDER = MODULATION_ORDERS(order_index);

    [num_symbols_per_carrier, total_num_bits] = calcNumSymbolsPerCarrier(DESIRED_NUM_BITS, NUM_SUBCARRIERS, MODULATION_ORDER);



    minimum_SNR_values = NaN(size(quantisation_bit_values));

    [modulated_signal, symbol_stream] = generateRandModSignal(num_symbols_per_carrier, MODULATION_ORDER, NUM_SUBCARRIERS, MODULATION_FORMAT);

    ofdm_signal = convertToOFDMSignal(modulated_signal, CYCLIC_PREFIX_LENGTH);

    noisey_OFDM_signals = zeros(numel(SNR_values), numel(ofdm_signal));

    for SNR_index = 1:1:numel(SNR_values)

        noisey_OFDM_signals(SNR_index, :) = awgn(ofdm_signal, SNR_values(SNR_index), 'measured');

    end

    for quant_index = 1:1:numel(quantisation_bit_values)

        for SNR_index = 1:1:numel(SNR_values)

            ofdm_signal_quantised = quantiseSignal(noisey_OFDM_signals(SNR_index, :), quantisation_bit_values(quant_index));

            extracted_modulated_signal = convertFromOFDMSignal(ofdm_signal_quantised, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);

            extracted_stream = demodSignal(extracted_modulated_signal, MODULATION_ORDER, MODULATION_FORMAT);

            [~, bit_error_rate, ~, ~] = calculateErrorRates(extracted_stream, symbol_stream);

            if bit_error_rate < 1e-3
                minimum_SNR_values(quant_index) = SNR_values(SNR_index);
                break;
            end

        end

    end
    
    plot(quantisation_bit_values, minimum_SNR_values);
    hold on;
    
end

legend(strcat(num2str(MODULATION_ORDERS(1),'%u'), '_QAM'), strcat(num2str(MODULATION_ORDERS(2),'%u'), '_QAM'), strcat(num2str(MODULATION_ORDERS(3),'%u'), '_QAM'), strcat(num2str(MODULATION_ORDERS(4),'%u'), '_QAM'), strcat(num2str(MODULATION_ORDERS(5),'%u'), '_QAM'))

hold off;