clc;
clearvars;

% Script to calculate the minimum SNR needed to establish a BER of 1e-3
% for a range of quantisation bit numbers and varying modulation
% orders/formats


% Modulation parameters
MODULATION_FORMAT = 'QAM';

NUM_SUBCARRIERS = 7;

DESIRED_NUM_BITS = 1e6;

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

SNR_values = linspace(5,35, 100);
quantisation_bit_values = 1:1:20;

% Number of unique symbols; powers of 2 starting from 16
MODULATION_ORDERS = 2.^[4,5,6,7,8];

for order_index = 1:1:numel(MODULATION_ORDERS)
    
    % Generate our random symbol stream
    
    modulation_order = MODULATION_ORDERS(order_index);

    [num_symbols_per_carrier, ~] = calcNumSymbolsPerCarrier(DESIRED_NUM_BITS, NUM_SUBCARRIERS, modulation_order);

    symbol_stream = calcRandomSymbolStream(modulation_order,NUM_SUBCARRIERS, num_symbols_per_carrier);
    
    % Encode stream, then convert to OFDM

    [encoded_signal] = encodeSignal(symbol_stream, modulation_order, MODULATION_FORMAT);

    ofdm_signal = convertToOFDMSignal(encoded_signal, CYCLIC_PREFIX_LENGTH);
    
    % Hold our minimum SNR values as they are found. Pre-allocated to NaN
    % because if minimums are not found, these points will not be plotted
    
    minimum_SNR_values = NaN(size(quantisation_bit_values));

    for quant_index = 1:1:numel(quantisation_bit_values)

        for SNR_index = 1:1:numel(SNR_values)
            
            % Add AWGN at the desired SNR. We use the same original OFDM
            % signal at each pass through this loop
            
            noisey_OFDM_signal = awgn(ofdm_signal, SNR_values(SNR_index), 'measured');
            
            % Quantise the signal with the desired number of quantisation
            % bits

            ofdm_signal_quantised = quantiseSignal(noisey_OFDM_signal, quantisation_bit_values(quant_index));

            extracted_encoded_signal = convertFromOFDMSignal(ofdm_signal_quantised, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);

            extracted_stream = decodeSignal(extracted_encoded_signal, modulation_order, MODULATION_FORMAT);

            [~, bit_error_rate, ~, ~] = calcErrorRates(extracted_stream, symbol_stream);
            
            % Once we pass the threshold, log this minimum SNR and break
            % from the for loop, moving onto the nex quantisation-bit value
            if bit_error_rate < 1e-3
                minimum_SNR_values(quant_index) = SNR_values(SNR_index);
                break;
            end

        end

    end
    
    % Plot for each modulation order
    plot(quantisation_bit_values, minimum_SNR_values);
    hold on;
    
end

legend(strcat(num2str(MODULATION_ORDERS(1),'%u'), '-', MODULATION_FORMAT), strcat(num2str(MODULATION_ORDERS(2),'%u'), '-', MODULATION_FORMAT), strcat(num2str(MODULATION_ORDERS(3),'%u'), '-', MODULATION_FORMAT), strcat(num2str(MODULATION_ORDERS(4),'%u'), '-', MODULATION_FORMAT), strcat(num2str(MODULATION_ORDERS(5),'%u'), '-', MODULATION_FORMAT))
ylim([0, SNR_values(end)]);
ylabel('Minimum SNR (dB)');
xlabel('Number of quantisation bits');
hold off;

exportgraphics(gcf, strcat(timestampString(), '.pdf'))