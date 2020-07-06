clearvars;

% Script to calculate the minimum SNR needed to establish a BER of 1e-3
% for a range of clipping ratios and varying modulation
% orders/formats

% Modulation parameters
MODULATION_FORMAT = "QAM";

NUM_SUBCARRIERS = 31;

DESIRED_NUM_BITS = 1e7;

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

SNR_values = linspace(5,35, 100);
clipping_ratio_values = 1:1:50;

% Number of unique symbols; powers of 2 starting from 16
MODULATION_ORDERS = 2.^[4, 5, 6, 7, 8];

hold on;
for order_index = 1:1:numel(MODULATION_ORDERS)
    
    % Generate our random symbol stream
    
    modulation_order = repmat(MODULATION_ORDERS(order_index), [NUM_SUBCARRIERS, 1]);
    
    modulation_format = repmat(MODULATION_FORMAT, [NUM_SUBCARRIERS, 1]);

    [num_symbols_per_carrier, ~] = calcAdaptiveNumSymbolsPerCarrier(DESIRED_NUM_BITS, modulation_order);
    
    if num_symbols_per_carrier < 100
        num_symbols_per_carrier = 100;
    end

    symbol_stream = calcAdaptiveRandomSymbolStream(modulation_order, num_symbols_per_carrier);
    
    % Encode stream, then convert to OFDM

    encoded_signal = encodedSignal(modulation_format, modulation_order, symbol_stream);

    ofdm_signal = convertToOFDMSignal(encoded_signal.encoded_stream_, CYCLIC_PREFIX_LENGTH);
    
    % Hold our minimum SNR values as they are found. Pre-allocated to NaN
    % because if minimums are not found, these points will not be plotted
    
    minimum_SNR_values = NaN(size(clipping_ratio_values));
    
    noisey_OFDM_signals = zeros(numel(SNR_values), numel(ofdm_signal));
    
    for SNR_index = 1:1:numel(SNR_values)
        noisey_OFDM_signals(SNR_index, :) = awgn(ofdm_signal, SNR_values(SNR_index), 'measured');
    end

    for clip_index = 1:1:numel(clipping_ratio_values)
        clc;
        disp(strcat("Processing order ", num2str(modulation_order(1),'%u'), " with ", num2str(clip_index(1),'%u'), "dB clipping ratio"))

        for SNR_index = 1:1:numel(SNR_values)
            
            % Quantise the signal with the 8 quantisation bits
            [ofdm_signal_clipped, ~, ~, amplitude_limit] = clipSignal(noisey_OFDM_signals(SNR_index, :), clip_index);

            ofdm_signal_quantised = quantiseSignal(ofdm_signal_clipped, 8, amplitude_limit);
            
            converted_signal = convertFromOFDMSignal(ofdm_signal_quantised, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);

            extracted_encoded_signal = encodedSignal(modulation_format, modulation_order, converted_signal, true);

            [~, bit_error_rate, ~, ~] = calcErrorRates(extracted_encoded_signal.decode(), symbol_stream);
            
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


leg_string = @(mod_order) strcat(num2str(mod_order,'%u'), '-', MODULATION_FORMAT);

legend(...
    leg_string(MODULATION_ORDERS(1)),...
    leg_string(MODULATION_ORDERS(2)),...
    leg_string(MODULATION_ORDERS(3)),...
    leg_string(MODULATION_ORDERS(4)),...
    leg_string(MODULATION_ORDERS(5)),...
    'Location', 'southwest');


ylim([0, SNR_values(end)]);
ylabel('Minimum SNR (dB)');
xlabel('Minimum SNR (dB)');

full_plot = gcf;

file_name = strcat(MODULATION_FORMAT, '_clipping_ratio_', num2str(DESIRED_NUM_BITS, 1), '_bits_', timestampString());
exportPlotPDF(full_plot, file_name);
