classdef Fluoresensor < handle
	properties %(Access = private)
		RESAMPLE_FACTOR
		MEDIAN_FILTER_LENGTH
		WINDOW_LENGTH
		EXTENSION_LENGTH
		reader
		ip
	end
	methods
		function obj = Fluoresensor()
			obj.reader = [];
			obj.ip = '';
			% Data treatment
			obj.RESAMPLE_FACTOR = 500;
			obj.MEDIAN_FILTER_LENGTH = 3;
			obj.WINDOW_LENGTH = 512;
			obj.EXTENSION_LENGTH = max([obj.MEDIAN_FILTER_LENGTH obj.WINDOW_LENGTH]);

		end
		
		function connect(obj,ip)
			try
				obj.reader = readfluoresensor.FluoresensorReader(ip);
				obj.ip = ip;
			catch
				obj.reader = [];
				throw(MException('FLUORESENSOR:CONNECTION_ERROR', 'Connection timed out.'))
			end
				
        end
        
        function maxreadtime(obj,readtime)
            obj.reader.MAX_READ_TIME = readtime;
        end
		
		function beginRead(obj)
			if obj.reader == []
				throw(MException('FLUORESENSOR:STATE_ERROR', 'Connection must be established before starting read.'))
			end
			
			if all(obj.reader.getState == 'TERMINATED')
				try
					obj.reader = readfluoresensor.FluoresensorReader(obj.ip);
					pause(0.1)
					obj.reader.start();
				catch
					obj.reader = [];
					throw(MException('FLUORESENSOR:CONNECTION_ERROR', 'Connection timed out.'))
				end
			elseif all(obj.reader.getState == 'RUNNABLE')
				throw(MException('FLUORESENSOR:STATE_ERROR','Already reading.'));
			elseif all(obj.reader.getState == 'NEW')
				obj.reader.start();
			else
				throw(MException('FLUORESENSOR:STATE_ERROR',['Thread in bad state: ' obj.reader.getState]));
			end
		end
		
		function stopRead(obj)
			obj.reader.stopNow();
		end
		
		function out = result(obj)
			ts = obj.reader.getTimeStamps();
			data = obj.reader.getValues();
			if isempty(ts) || isempty(data)
				throw(MException('FLUORESENSOR:BUSY', 'Cannot get result before read is complete.'))
			end
			TCP_PACKET_SIZE = obj.reader.TCP_PACKET_SIZE;
			
			x = [((TCP_PACKET_SIZE/2-1):length(ts))', ones(length(ts)-TCP_PACKET_SIZE/2+2, 1)]\ts((TCP_PACKET_SIZE/2-1):end);
			ts(1:TCP_PACKET_SIZE/2-2) = x(2) + x(1)*(1:(TCP_PACKET_SIZE/2-2))';
	
			out.raw_time = ts/1000;
			out.raw_measurement = data;
		
		
			%% Filter and downsample
			w = gausswin(obj.WINDOW_LENGTH, 1.5);
			w = w/sum(w);

			data_v_extended = [flipud(out.raw_measurement(1:obj.EXTENSION_LENGTH/2)); out.raw_measurement; flipud(out.raw_measurement(end-obj.EXTENSION_LENGTH/2+1:end))];
			data_median = medfilt1(data_v_extended, obj.MEDIAN_FILTER_LENGTH);
			data_median = filtfilt(w, 1, data_median);

			data_median(1:obj.WINDOW_LENGTH/2) = [];
			data_median(end-obj.WINDOW_LENGTH/2+1:end) = [];

			out.time = out.raw_time(1:obj.RESAMPLE_FACTOR:end) - out.raw_time(1);
			out.measurement = data_median(1:obj.RESAMPLE_FACTOR:end);
			
		end
	end
end