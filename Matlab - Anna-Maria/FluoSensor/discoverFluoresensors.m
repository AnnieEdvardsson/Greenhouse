function sensors = discoverFluoresensors()
	d = readfluoresensor.Discovery();	% Initialize object
	d.discover();						% Send out discovery request on all interfaces and wait for replies
	names = d.getNames();
	ips = d.getAddresses();
	
	sensors = struct();
	k = 1;
	for i = 1:length(ips)
		equal = false;
		for j = 1:length(sensors)
			try
				equal = all(sensors(j).IP == char(ips(i)));
			catch
				% They differ in length; not equal
			end
		end
		if ~equal
			sensors(k).NAME = char(names(i));
			sensors(k).IP = char(ips(i));
			sensors(k).SENSOR = Fluoresensor();
			sensors(k).SENSOR.connect(sensors(i).IP);
			k = k + 1;
		end
	end
end
