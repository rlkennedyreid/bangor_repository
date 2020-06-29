clearvars;

% Choose modulation order and format
MOD_ORDER = 16;
% 
MODULATION_FORMAT = "QAM";

CYCLIC_PREFIX_LENGTH = 1/8; % Given as a ratio of symbol length

num_subcarriers_vals = (((1:1:300)/CYCLIC_PREFIX_LENGTH) - 2)/2;

DESIRED_NUM_BITS = 1e8;

PAPR_values = zeros([1, length(num_subcarriers_vals)]);

% Each subcarrier number should have its PAPR calculated 10 times, and
% averaged
num_iterations = 10;

for iter_index = 1:1:num_iterations
    
    for index = 1:1:length(num_subcarriers_vals)

        num_subcarriers = num_subcarriers_vals(index);

        MODULATION_FORMATS = repmat(MODULATION_FORMAT, [num_subcarriers, 1]);

        MODULATION_ORDERS = repmat(MOD_ORDER, [num_subcarriers, 1]);

        % The number of bits produced will not stay constant, but as we are
        % looking for harmonics in a symbol, it is important to inspect the
        % same number of symbols each time
        num_symbols_per_subcarrier = 200;

        checkOFDMSymbolLength(num_subcarriers, CYCLIC_PREFIX_LENGTH)

        symbol_stream = calcAdaptiveRandomSymbolStream(MODULATION_ORDERS, num_symbols_per_subcarrier);

        encoded_signal = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, symbol_stream);

        ofdm_signal = convertToOFDMSignal(encoded_signal.encoded_stream_, CYCLIC_PREFIX_LENGTH);

        PAPR_values(index) = PAPR_values(index) + calcPAPR(ofdm_signal);
    end
    
end

PAPR_values = PAPR_values / num_iterations;

PAPR_plot = semilogx(num_subcarriers_vals, PAPR_values, '-+');

xlim([3, num_subcarriers_vals(end)])
PAPR_plot.MarkerSize = 4;
ylabel('PAPR (dB)');
xlabel('Number of subcarriers')
