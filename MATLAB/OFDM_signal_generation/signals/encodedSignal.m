classdef encodedSignal
    %ENCODEDSIGNAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        modulation_formats_
        modulation_orders_
        encoded_stream_
    end
    
    methods (Access = public)
        function obj = encodedSignal(MODULATION_FORMATS, MODULATION_ORDERS, SYMBOL_STREAM)
            %ENCODEDSIGNAL Construct instance given the modulation
            %information for each subcarrier and the symbol stream to
            %encode
            %   The class handles the encoding on construction
            assert( (isequal(size(MODULATION_FORMATS, 1), size(MODULATION_ORDERS, 1))), ...
                "The formats and orders should be column vectors of equal size, given modulation information for each subcarrier");
            
            obj.modulation_formats_ = MODULATION_FORMATS;
            obj.modulation_orders_ = MODULATION_ORDERS;
            obj = obj.encodeStream(SYMBOL_STREAM);
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

            % Encode to desired format
            if strcmp(MODULATION_FORMAT, "QAM")
                % Need to normalise amplitude-based modulation
                encoded_substream = qammod(SYMBOL_STREAM, ORDER, 'UnitAveragePower', true);

            elseif strcmp(MODULATION_FORMAT, "QAM_binary")
                encoded_substream = qammod(SYMBOL_STREAM, ORDER, 'bin', 'UnitAveragePower', true);

            elseif strcmp(MODULATION_FORMAT, "PSK")
                encoded_substream = pskmod(SYMBOL_STREAM, ORDER);

            else
                error("Unknown argument for MODULATION_FORMAT");

            end

        end
        
    end
end

