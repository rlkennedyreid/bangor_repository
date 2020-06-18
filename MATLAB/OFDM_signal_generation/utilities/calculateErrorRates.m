function [num_bit_errors, bit_error_rate, num_symbol_errors, symbol_error_rate] = calculateErrorRates(stream_1, stream_2)
    
    assert(isequal(size(stream_1), size(stream_2)))
    
    [num_symbol_errors, symbol_error_rate] = symerr(stream_1, stream_2);
    
    [num_bit_errors, bit_error_rate] = biterr(stream_1, stream_2);    
    
end





