function timestamp_string = timestampString()
%TIMESTAMP_STRING Function to produce a formatted, second-accurate
%timestamp string
%   Used to timestamp saved figures, and make sure we don't accidentally
%   overwrite

    timestamp_string = datestr(now,'yymmdd_HHMMSS');

end