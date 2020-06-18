

function output = autocorrelation(INPUT_SERIES, MAX_LAG)
    average = mean(INPUT_SERIES);
    
    deviations = (INPUT_SERIES - average);
    
    denominator = sum((deviations.^(2.0)));
    
    output = zeros([1, MAX_LAG]);
    
    for autocorr_index = 0:1:MAX_LAG
        snipped_series = deviations(1:end-autocorr_index);
        offset_series = deviations(autocorr_index+1:end);
        
        output(autocorr_index+1) = sum(snipped_series .* offset_series);
    end
    
    output = output/denominator;
end