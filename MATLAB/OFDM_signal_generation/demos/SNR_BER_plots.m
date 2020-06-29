clearvars;

MODULATION_FORMAT = "QAM";

DESIRED_NUM_BITS = 1e6;

NUM_SUBCARRIERS = 31;

MODULATION_FORMATS = repmat(MODULATION_FORMAT, [NUM_SUBCARRIERS, 1]);

CYCLIC_PREFIX_LENGTH = 1/4; % Given as a ratio of symbol length

checkOFDMSymbolLength(NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH)

MOD_ORDER_VALS = [4; 16; 64]; % powers of 2 from 4 to 512

% preallocation
snr_ratios = linspace(1,25,50);
ber_vals = NaN(length(snr_ratios), length(MOD_ORDER_VALS));
normalised_snr_vals = zeros(length(snr_ratios), length(MOD_ORDER_VALS));

for mod_order_index = 1:1:length(MOD_ORDER_VALS)
    
    MODULATION_ORDERS = repmat(MOD_ORDER_VALS(mod_order_index), [NUM_SUBCARRIERS, 1]);
    
    [num_symbols_per_carrier, ~] = calcAdaptiveNumSymbolsPerCarrier(DESIRED_NUM_BITS, MODULATION_ORDERS);
    
    [symbol_stream] = calcAdaptiveRandomSymbolStream(MODULATION_ORDERS, num_symbols_per_carrier);
    
    [modulated_signal] = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, symbol_stream);
    
    ofdm_signal = convertToOFDMSignal(modulated_signal.encoded_stream_, CYCLIC_PREFIX_LENGTH);
    
    for snr_index = 1:1:length(snr_ratios)
        ofdm_signal_with_noise = awgn(ofdm_signal, snr_ratios(snr_index), 'measured');
        
        converted_signal = convertFromOFDMSignal(ofdm_signal_with_noise, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);
        extracted_encoded_signal = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, converted_signal, true);
        
        extracted_stream = extracted_encoded_signal.decode();
        [~, bit_error_rate, num_sym_errors, ~] = calcErrorRates(extracted_stream, symbol_stream);
        
        if bit_error_rate ~= 0
            ber_vals(snr_index, mod_order_index) = bit_error_rate;
        end
    end
end

semilogy(snr_ratios, ber_vals, '^');
