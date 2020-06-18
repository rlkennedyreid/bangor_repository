function [ratio] = peakPower2rms(input_series)

    ratio = max(input_series.^2)/rms(input_series);
    
end