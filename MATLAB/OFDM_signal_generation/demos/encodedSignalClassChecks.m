clearvars;

% Choose modulation order and format
DESIRED_NUM_BITS = 1e6;

NUM_SUBCARRIERS = 63;

MODULATION_ORDERS = datasample(2.^[3,4,5,6], NUM_SUBCARRIERS)';

MODULATION_FORMATS = datasample(["QAM", "QAM_binary", "PSK"], NUM_SUBCARRIERS)';

[num_symbols_per_carrier, ~] = calcAdaptiveNumSymbolsPerCarrier(DESIRED_NUM_BITS, MODULATION_ORDERS);

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

checkOFDMSymbolLength(NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH)

% Create QAM modulated signal, given number of symbols we want to generate
[symbol_stream] = calcAdaptiveRandomSymbolStream(MODULATION_ORDERS, num_symbols_per_carrier);

[modulated_signal] = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, symbol_stream);



do_plot = true;

if(do_plot)
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
end

decoded_stream = modulated_signal.decode();
assert(isequal(symbol_stream, decoded_stream), "The decoded symbol stream is not equal to the original input stream")

copy_constructed = modulated_signal;

construct_from_encoded = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, modulated_signal.encoded_stream_, true);

assert(isequal(modulated_signal, copy_constructed, construct_from_encoded), "One of the class' constructors is incorrect");

disp("Script successful!")
