function [symbol_stream] = calcRandomSymbolStream(MODULATION_ORDER,NUM_SUBCARRIERS, NUM_SYMBOLS_PER_CARRIER)
%CALCRANDOMSYMBOLSTREAM Function to generate a random symbol stream for
%encoding, given the modulation order, the number of subcarriers, and the
%number of symbols to produce per subcarrier
%   Each symbol is a random integer on the interval [0, (MODULATION_ORDER-1)]
%   This is the typical formate for matlab's encoding and decoding formats

    symbol_stream = randi([0, (MODULATION_ORDER-1)], [NUM_SUBCARRIERS, NUM_SYMBOLS_PER_CARRIER]);
end

