clearvars;

% Script to calculate the minimum SNR needed to establish a BER of 1e-3
% for a range of quantisation bit numbers and varying modulation
% orders/formats

% Modulation parameters
MODULATION_FORMAT = 'QAM';

NUM_SUBCARRIERS = 63;

DESIRED_NUM_BITS = 1e5;

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

SNR_values = linspace(5,35, 100);
quantisation_bit_values = 1:1:15;

% Number of unique symbols; powers of 2 starting from 16
MODULATION_ORDERS = 2.^[4,5,6,7,8];

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
    
    minimum_SNR_values = NaN(size(quantisation_bit_values));
    
    noisey_OFDM_signals = zeros(numel(SNR_values), numel(ofdm_signal));
    
    for SNR_index = 1:1:numel(SNR_values)
        noisey_OFDM_signals(SNR_index, :) = awgn(ofdm_signal, SNR_values(SNR_index), 'measured');
    end

    for quant_index = 1:1:numel(quantisation_bit_values)
        disp(strcat("Processing order ", num2str(modulation_order,'%u'), " with ", num2str(quant_index,'%u'), " quantisation bits"))

        for SNR_index = 1:1:numel(SNR_values)
            
            % Quantise the signal with the desired number of quantisation bits

            ofdm_signal_quantised = quantiseSignal(noisey_OFDM_signals(SNR_index, :), quantisation_bit_values(quant_index));

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
    
end

load(fullfile(fileparts(which("qam_16.mat")), "qam_16.mat"));
load(fullfile(fileparts(which("qam_32.mat")), "qam_32.mat"));
load(fullfile(fileparts(which("qam_64.mat")), "qam_64.mat"));
load(fullfile(fileparts(which("qam_128.mat")), "qam_128.mat"));
load(fullfile(fileparts(which("qam_256.mat")), "qam_256.mat"));

quick_plot = @(data) plot(data(:, 1), data(:, 2), '--');

quick_plot(qam_16);
quick_plot(qam_32);
quick_plot(qam_64);
quick_plot(qam_128);
quick_plot(qam_256);


leg_string = @(mod_order) strcat(num2str(mod_order,'%u'), '-', MODULATION_FORMAT);

legend(...
    leg_string(MODULATION_ORDERS(1)),...
    leg_string(MODULATION_ORDERS(2)),...
    leg_string(MODULATION_ORDERS(3)),...
    leg_string(MODULATION_ORDERS(4)),...
    leg_string(MODULATION_ORDERS(5)),...
    "16-QAM (Paper)",...
    "32-QAM (Paper)",...
    "64-QAM (Paper)",...
    "128-QAM (Paper)",...
    "256-QAM (Paper)",...
    'Location', 'southwest');

ylim([0, SNR_values(end)]);
ylabel('Minimum SNR (dB)');
xlabel('Number of quantisation bits');

full_plot = gcf;

file_name = strcat(MODULATION_FORMAT, '_quant_SNR_plot_', num2str(DESIRED_NUM_BITS, 1), '_bits_', timestampString());
exportPlotPDF(full_plot, file_name);
