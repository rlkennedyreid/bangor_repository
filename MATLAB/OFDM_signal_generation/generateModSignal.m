% \brief Function to generate a random QAM modulated signal with multiple
% subcarriers, given the number of subcarriers, the number of symbols to
% generate per subcarrier, and the order of the QAM modulation
% 
% \input NUM_SYMBOLS The size of the symbol substream per carrier
% \input ORDER the order of the QAM modulation, ie the number of unique
% symbols than can be generated
% \input NUM_SUBCARRIERS The number of subcarriers
% 
% \output output_signal A complex array. Each row is the symbol stream for
% each subcarrier, so the total number of elements in the array will be
% NUM_SUBCARRIERS*NUM_SYMBOLS, and the number of unique complex numbers
% will be NUM_SYMBOLS
% \output symbol_stream An array of integers on the interval
% [0,NUM_SYMBOLS]; the corresponding symbols to the complex numbers in the
% output signal. This is used to check against a later demodulation, to
% calculate a symbol error count

function [output_signal, symbol_stream] = generateModSignal(NUM_SYMBOLS, ORDER, NUM_SUBCARRIERS, MODULATION_FORMAT)
    
    symbol_stream = randi([0, (ORDER -1)], [NUM_SUBCARRIERS, NUM_SYMBOLS]);
    
    if strcmp(MODULATION_FORMAT, 'QAM')
        output_signal = qammod(symbol_stream, ORDER);
    elseif strcmp(MODULATION_FORMAT, 'PSK')
        output_signal = pskmod(symbol_stream, ORDER);
    else
        error("Unknown argument for MODULATION_FORMAT");
    end
    
end