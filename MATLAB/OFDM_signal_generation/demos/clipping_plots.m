clearvars;

% Script to calculate the minimum SNR needed to establish a BER of 1e-3
% for a range of clipping ratios and varying modulation
% orders/formats

% Modulation parameters
MODULATION_FORMAT = 'QAM';

NUM_SUBCARRIERS = 31;

DESIRED_NUM_BITS = 1e6;

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

SNR_values = linspace(5,35, 100);
clipping_ratio_values = 1:1:50;

% Number of unique symbols; powers of 2 starting from 16
MODULATION_ORDERS = 2.^[4];

hold on;
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
    
    minimum_SNR_values = NaN(size(clipping_ratio_values));
    
    noisey_OFDM_signals = zeros(numel(SNR_values), numel(ofdm_signal));
    
    for SNR_index = 1:1:numel(SNR_values)
        noisey_OFDM_signals(SNR_index, :) = awgn(ofdm_signal, SNR_values(SNR_index), 'measured');
    end

    for clip_index = 1:1:numel(clipping_ratio_values)
        disp(strcat("Processing order ", num2str(modulation_order,'%u'), " with ", num2str(clip_index,'%u'), "dB clipping ratio"))

        for SNR_index = 1:1:numel(SNR_values)
            
            % Quantise the signal with the 8 quantisation bits
            [ofdm_signal_clipped, ~, ~, amplitude_limit] = clipSignal(noisey_OFDM_signals(SNR_index, :), clip_index);

            ofdm_signal_quantised = quantiseSignal(ofdm_signal_clipped, 8, amplitude_limit);

            extracted_encoded_signal = convertFromOFDMSignal(ofdm_signal_quantised, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);

            extracted_stream = decodeSignal(extracted_encoded_signal, modulation_order, MODULATION_FORMAT);

            [~, bit_error_rate, ~, ~] = calcErrorRates(extracted_stream, symbol_stream);
            
            % Once we pass the threshold, log this minimum SNR and break
            % from the for loop, moving onto the nex quantisation-bit value
            if bit_error_rate < 1e-3
                minimum_SNR_values(clip_index) = SNR_values(SNR_index);
                break;
            end

        end

    end
    
    % Plot for each modulation order
    plot(clipping_ratio_values, minimum_SNR_values, '^-');
    
end
