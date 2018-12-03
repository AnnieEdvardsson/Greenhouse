classdef LightRegime
    properties 
        spectra
        durations
    end
    methods 
        function obj = LightRegime(spectra,durations) %constructor
            obj.spectra     = spectra;
            obj.durations   = durations;
            if length(spectra) ~= length(durations)
                error('')
            end 
        end
        function length_of_experiment = getTotDuration(obj)
            length_of_experiment = 0;
            for i = 1:length(obj.durations)
                length_of_experiment = length_of_experiment + obj.durations{i};
            end
        end
        function spectrum = getIntensity(obj,t)
            d = 0;
            for i = 1:length(obj.durations) 
                d = d + obj.durations{i};
                if t < d
                spectrum = obj.spectra{i};
                break
                end
            end
        end
    end
end

            