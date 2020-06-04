function [output_signal, symbol_stream] = generateRandModSignal(NUM_SYMBOLS, ORDER, NUM_SUBCARRIERS, MODULATION_FORMAT)
% generateRandModSignal Function to generate a random encoded signal
% with multiple subcarriers given the number of subcarriers, the number of
% symbols to generate per subcarrier, and the order of the modulation
% format
% 
% [output_signal, symbol_stream] = generateRandModSignal(NUM_SYMBOLS, ORDER, NUM_SUBCARRIERS, MODULATION_FORMAT)
% 
%   NUM_SYMBOLS: The size of the symbol substream per carrier
% 
%   ORDER: the order of the QAM modulation, ie the number of unique
%   symbols than can be generated
% 
%   NUM_SUBCARRIERS: The number of subcarriers
% 
%   MODULATION_FORMAT: The format of modulation, given as a string
% 
%   output_signal: A complex array. Each row is the symbol stream for
%   each subcarrier, so the total number of elements in the array will be
%   NUM_SUBCARRIERS*NUM_SYMBOLS, and the number of unique complex numbers
%   will be NUM_SYMBOLS
% 
%   symbol_stream: An array of integers on the interval [0,NUM_SYMBOLS]; the
%   corresponding symbols to the complex numbers in the output signal. This
%   is used to check against a later demodulation, to calculate a symbol
%   error count. Number of bits per symbol depends on ORDER

    
%     Produce random integer (symbol) streams for all subcarriers at once
    symbol_stream = randi([0, (ORDER -1)], [NUM_SUBCARRIERS, NUM_SYMBOLS]);
    
%     Encode to desired format
    if strcmp(MODULATION_FORMAT, 'QAM')
%     Need to normalise amplitude-based modulation
        output_signal = qammod(symbol_stream, ORDER, 'UnitAveragePower', true);
    elseif strcmp(MODULATION_FORMAT, 'PSK')
        output_signal = pskmod(symbol_stream, ORDER);
    else
        error("Unknown argument for MODULATION_FORMAT");
    end
    
end