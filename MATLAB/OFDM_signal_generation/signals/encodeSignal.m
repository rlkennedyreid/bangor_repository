function [output_signal] = encodeSignal(SYMBOL_STREAM, ORDER, MODULATION_FORMAT)
% encodeSignal Function to generate a random encoded signal
% with multiple subcarriers given the number of subcarriers, the number of
% symbols to generate per subcarrier, and the order of the modulation
% format
%
% [output_signal] = encodeSignal(NUM_SYMBOLS, ORDER, MODULATION_FORMAT)
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

    % Encode to desired format
    if strcmp(MODULATION_FORMAT, 'QAM')
        % Need to normalise amplitude-based modulation
        output_signal = qammod(SYMBOL_STREAM, ORDER, 'UnitAveragePower', true);
        
    elseif strcmp(MODULATION_FORMAT, 'QAM_binary')
        output_signal = qammod(SYMBOL_STREAM, ORDER, 'bin', 'UnitAveragePower', true);
        
    elseif strcmp(MODULATION_FORMAT, 'PSK')
        output_signal = pskmod(SYMBOL_STREAM, ORDER);
        
    else
        error("Unknown argument for MODULATION_FORMAT");
        
    end

end