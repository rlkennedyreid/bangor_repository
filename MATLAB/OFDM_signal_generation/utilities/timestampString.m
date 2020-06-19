function timestamp_string = timestampString()
%TIMESTAMPSTRING Function to produce a formatted, second-accurate
%timestamp string
%   Used to timestamp saved figures, and make sure I don't accidentally
%   overwrite files

    timestamp_string = datestr(now,'yymmdd_HHMMSS');

end