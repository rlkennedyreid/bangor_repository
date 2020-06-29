classdef encodedSignal
    %ENCODEDSIGNAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        encoded_stream_
        modulation_formats_
        modulation_orders_
    end
    
    methods (Access = public)
        
        % CONSTRUCTOR
        function obj = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, SYMBOL_STREAM, IS_ENCODED)
            %ENCODEDSIGNAL Construct instance given the modulation
            %information for each subcarrier and the symbol stream
            %   The class handles the encoding on construction if a raw
            %   signal is given, but can also be given already encoded
            %   streams, in which case use optional boolean argument to
            %   indicate
            
            % Make sure to use string arrays (i.e. "" rather than '')
            % otherwise dimensions are incorrect
            assert( (isequal(size(MODULATION_FORMATS), size(MODULATION_ORDERS))), ...
                "The formats and orders should be column vectors of equal size, given modulation information for each subcarrier");
            
            obj.modulation_formats_ = MODULATION_FORMATS;
            obj.modulation_orders_ = MODULATION_ORDERS;
            
            % If our stream is already encoded, 4th argument should be
            % true. Else, default to encoding ourselves
            switch nargin
                case 4
                    if IS_ENCODED ==  true
                        obj.encoded_stream_ = SYMBOL_STREAM;
                    end
                otherwise
                    obj = obj.encodeStream(SYMBOL_STREAM);
            end
        end
        
        % DECODER
        function decoded_stream = decode(obj)
            %DECODE Decode a signal back to raw constellation of bits
            %   This method assumes the class has already been
            %   instantiated. This is a public function as it is our way to
            %   output the symbol stream to the user after any processing
            
            decoded_stream = complex( zeros(size(obj.encoded_stream_)) );
            
            for sub_index = 1:1:size(obj.modulation_formats_, 1)
                decoded_stream(sub_index, :) = obj.decodeSubstream(obj.encoded_stream_(sub_index, :), obj.modulation_formats_(sub_index, :), obj.modulation_orders_(sub_index));
            end

        end

    end
    
    methods (Access = protected)
        
        function obj_out = encodeStream(obj, SYMBOL_STREAM)
            obj.encoded_stream_ = complex( zeros(size(SYMBOL_STREAM)) );
            
            for sub_index = 1:1:size(obj.modulation_formats_, 1)
                obj.encoded_stream_(sub_index, :) = obj.encodeSubstream(SYMBOL_STREAM(sub_index, :), obj.modulation_formats_(sub_index, :), obj.modulation_orders_(sub_index));
            end
            
            obj_out = obj;
        end
        
        function encoded_substream = encodeSubstream(~, SYMBOL_STREAM, MODULATION_FORMAT, ORDER)
            %ENCODESUBSTREAM Encode a substream to the corresponding format
            %and order we have stored for this substream
            %   This method normalises all constellations so the peak power
            %   is 1, so no constellation is arbitrarily larger than
            %   another
            
            if strcmp(MODULATION_FORMAT, "QAM")
                encoded_substream = qammod(SYMBOL_STREAM, ORDER); %, 'UnitAveragePower', true
                
                norm_factor = modnorm(qammod(0:(ORDER-1), ORDER), 'peakpow', 1.0);
                encoded_substream = norm_factor*encoded_substream;
                
            elseif strcmp(MODULATION_FORMAT, "QAM_binary")
                
                encoded_substream = qammod(SYMBOL_STREAM, ORDER, 'bin');
                
                norm_factor = modnorm(qammod(0:(ORDER-1), ORDER), 'peakpow', 1.0);
                encoded_substream = norm_factor*encoded_substream;
                
            elseif strcmp(MODULATION_FORMAT, "PSK")
                encoded_substream = pskmod(SYMBOL_STREAM, ORDER);
                
                norm_factor = modnorm(pskmod(0:(ORDER-1), ORDER), 'peakpow', 1.0);
                encoded_substream = norm_factor*encoded_substream;

            else
                error("Unknown argument for MODULATION_FORMAT");

            end

        end
        
        function decoded_substream = decodeSubstream(~, ENCODED_SUBSTREAM, MODULATION_FORMAT, MOD_ORDER)
            %DECODESUBSTREAM Decode a substream according to the format and
            %order we have stored for that substream
            %   Amplitude-based encodings are normalised by average power
            %   to account for any power change to the signal. I believe
            %   normalising by peak power would be incorrect, as an awgn
            %   channel would effectively shrink our constellations

            if strcmp(MODULATION_FORMAT, 'QAM')
                
                decoded_substream = qamdemod(normalisePower(ENCODED_SUBSTREAM), MOD_ORDER, 'UnitAveragePower', true);
                
            elseif strcmp(MODULATION_FORMAT, 'QAM_binary')
                
                decoded_substream = qamdemod(normalisePower(ENCODED_SUBSTREAM), MOD_ORDER, 'bin', 'UnitAveragePower', true);

            elseif strcmp(MODULATION_FORMAT, 'PSK')
                
                decoded_substream = pskdemod(ENCODED_SUBSTREAM, MOD_ORDER);

            else
                error("Unknown argument for MODULATION_FORMAT");
            end

        end
        
    end
end

