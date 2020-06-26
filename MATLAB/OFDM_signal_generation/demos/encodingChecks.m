clearvars;

% Choose modulation order and format
MOD_ORDER = 16;

MODULATION_FORMAT = 'QAM';

DESIRED_NUM_BITS = 1e6;

NUM_SUBCARRIERS = 31;

[num_symbols_per_carrier, ~] = calcNumSymbolsPerCarrier(DESIRED_NUM_BITS, NUM_SUBCARRIERS, MOD_ORDER);

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

checkOFDMSymbolLength(NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH)

% Create QAM modulated signal, given number of symbols we want to generate
[symbol_stream] = calcRandomSymbolStream(MOD_ORDER, NUM_SUBCARRIERS, num_symbols_per_carrier);

[modulated_signal] = encodeSignal(symbol_stream, MOD_ORDER, MODULATION_FORMAT);

scatterplot(modulated_signal(:))

ofdm_signal = convertToOFDMSignal(modulated_signal, CYCLIC_PREFIX_LENGTH);
ofdm_signal = awgn(ofdm_signal, 10, 'measured');

extracted_modulated_signal = convertFromOFDMSignal(ofdm_signal, NUM_SUBCARRIERS, CYCLIC_PREFIX_LENGTH);
scatterplot(extracted_modulated_signal(:))
extracted_stream = decodeSignal(extracted_modulated_signal, MOD_ORDER, MODULATION_FORMAT);
[~, bit_error_rate, ~, ~] = calcErrorRates(extracted_stream, symbol_stream);
