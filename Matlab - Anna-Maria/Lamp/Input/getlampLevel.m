function [lampLevel,intIRR, id] = getlampLevel( intIRRmatrix, lampINTmatrix, wishedintIRR,wl)
% Returns the lamplevel (input to the lamp 0-1000) corresponding to the
% specified integrated output intensity for each wavelength given in uE.
% wl corresponds to the column number of a choosen wavelength in
% the current lamp/in the current intIRRmatrix.
% wl = logical([0 1 0 0 0 0 0 0 0]) and wl = 2, yields the same result. 

if (isrow(wl)&&~iscolumn(wl))||(iscolumn(wl)&&~isrow(wl))
    for i = 1:length(wl)
        if wl(i)
            lambda = i;
        end
    end
else
    lambda = wl;
end

[ri,ci] = size(intIRRmatrix);
[rl,cl] = size(lampINTmatrix);
if ri>ci
    intIRRmatrix = intIRRmatrix';
end
if rl>cl
    lampINTmatrix = lampINTmatrix';
end

if (isrow(wishedintIRR)&&~iscolumn(wishedintIRR))||(~isrow(wishedintIRR)&&~iscolumn(wishedintIRR))  
    [~, id] = min(abs(intIRRmatrix(lambda,:) - wishedintIRR(lambda)));
else
    [~, id] = min(abs(intIRRmatrix(lambda,:) - wishedintIRR));
end

lampLevel  = lampINTmatrix(lambda,id);
intIRR     = intIRRmatrix(lambda,id);
end