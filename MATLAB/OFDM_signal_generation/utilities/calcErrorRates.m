function [num_bit_errors, bit_error_rate, num_symbol_errors, symbol_error_rate] = calcErrorRates(stream_1, stream_2)
%CALCERRORRATES Simple function to calculate error rates between two signal
%streams
%   The streams must have the same dimesion, and are assumed to be
%   comprised of integer symbols, representing bit sequences

    assert(isequal(size(stream_1), size(stream_2)), "Cannot calculate SER and BER of streams of different dimension")
    
    [num_symbol_errors, symbol_error_rate] = symerr(stream_1, stream_2);
    
    [num_bit_errors, bit_error_rate] = biterr(stream_1, stream_2);    
    
end





