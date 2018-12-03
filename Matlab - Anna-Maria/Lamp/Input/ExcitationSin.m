classdef ExcitationSin < handle
    properties 
        lambda
        period_t
        amplitude
        meanvalue
        intIRRmatrix
        lampINTmatrix
    end
    properties(SetAccess = private)
        baseLevel
        maxLevel
        maxAmp
    end
    
    methods 
        function obj = ExcitationSin(lambda,period_t,amplitude,meanvalue,intIRRmatrix,lampINTmatrix) %constructor
            obj.lambda      = lambda;
            obj.period_t    = period_t;
            obj.meanvalue   = meanvalue;
            obj.intIRRmatrix = intIRRmatrix;
            obj.lampINTmatrix =lampINTmatrix;
            obj.defineAppropriateLevels()
            obj.setAmplitude(amplitude)
            
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
            defineAppropriateLevels();
            setAmplitude(obj.amplitude);
        end

%         function setAmplitude(obj,newAmp)
%             if newAmp > obj.maxAmp
%                 obj.amplitude = obj.maxAmp;
%             else
%                 obj.amplitude = newAmp;
%             end
%             setMeanvalue(obj.meanvalue)
%         end
        
%         function setMeanvalue(obj,newMean)
%             meanMax      = obj.maxLevel-obj.amplitude;
%             meanMin      = obj.baseLevel + obj.amplitude;
%             if newMean > meanMax
%                 obj.meanvalue  = meanMax;
%             elseif exc_mean < meanMin
%                 obj.meanvalue  = meanMin;
%             else
%                 obj.meanvalue  = newMean;
%             end
%         end
        function setAmplitude(obj,newAmp)
            if newAmp > obj.maxAmp
                obj.amplitude = obj.maxAmp;
            else
                obj.amplitude = newAmp;
            end
            obj.setMeanvalue(obj.meanvalue)
        end
%         
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
        
        function spectrum = getIntensity(obj,t)
            spectrum = obj.meanvalue+obj.amplitude.* (sin(2*pi*1./obj.period_t.*t));
            spectrum = spectrum.* obj.lambda;
         end
    end
end
