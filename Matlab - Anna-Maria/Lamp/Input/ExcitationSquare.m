% Toggle between intensity of 0 and amplitude, every 'period_t' time units.
classdef ExcitationSquare < handle
    properties 
        lambda
        period_t
        amplitude
        meanvalue
        intIRRmatrix
        lampINTmatrix
        nextPeriodNr
    end
    
    properties(SetAccess = private)
        state
    end
    
    properties(SetAccess = private)
        baseLevel
        maxLevel
        maxAmp
    end
    
    methods 
        function obj = ExcitationSquare(lambda,period_t,amplitude,meanvalue,intIRRmatrix,lampINTmatrix) %constructor
            obj.lambda          = lambda;
            obj.period_t        = period_t;          
            obj.intIRRmatrix    = intIRRmatrix;
            obj.lampINTmatrix   = lampINTmatrix;
            obj.nextPeriodNr    = 1;
            obj.meanvalue       = meanvalue;
            obj.defineAppropriateLevels()
            obj.setAmplitude(amplitude)  
            obj.state           = false;
            
            for i = 1:length(period_t)
                if period_t(i) <= 0
                    error('period time must be a positive, non zero value')
                end
            end
        end
        
        function defineAppropriateLevels(obj)
            obj.baseLevel    = obj.intIRRmatrix(obj.lambda',obj.lampINTmatrix(obj.lambda',:)==100); %100 is chosen because below 100 lamp is in PWM-mode
            obj.maxLevel     = obj.intIRRmatrix(obj.lambda',obj.lampINTmatrix(obj.lambda',:)==1000);
            obj.maxAmp       = (obj.maxLevel-obj.baseLevel)/2;
        end     
        
        function setWavelength(obj,newLambda)
            obj.lambda = newLambda;
            obj.defineAppropriateLevels();
            obj.setAmplitude(obj.amplitude);
        end

        function setAmplitude(obj,newAmp)
            if newAmp > obj.maxAmp
                obj.amplitude = obj.maxAmp;
            else
                obj.amplitude = newAmp;
            end
            obj.setMeanvalue(obj.meanvalue)
        end
        
        function setMeanvalue(obj,newMean)
            meanMax      = obj.maxLevel-obj.amplitude;
            meanMin      = obj.baseLevel + obj.amplitude;
            if newMean > meanMax
                obj.meanvalue  = meanMax;
            elseif newMean < meanMin
                obj.meanvalue  = meanMin;
            else
                obj.meanvalue  = newMean;
            end
        end
        
        function setPeriodTime(obj,newPeriodT)
            obj.period_t=newPeriodT;
        end
        
        function determineState(obj,t)
            on = mod(floor(t ./ (obj.period_t/2)), 2);
            if on ~= obj.state
                obj.state = on;
                if ~on
                    obj.nextPeriodNr = obj.nextPeriodNr+1;
                end
            end
        end
        function spectrum = getIntensity(obj,t)
            obj.determineState(t);
%           intensity = on .* obj.amplitude;
            intensity = obj.state.* obj.amplitude*2-obj.amplitude+obj.meanvalue;
            spectrum = intensity.* obj.lambda;
        end
    end
end