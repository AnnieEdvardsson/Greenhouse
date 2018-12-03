function [dy_dx]= numDerivative(y,h)
%[d]= numDerivative(y,h)
% y is equally sampled data.
% h is sampling time.
% dy_dx is the derivative approximated by y'(x)= (y(x+h)-y(x-h))/(2*h).
    diff2 = movsum(diff(y),2);
    dy_dx = diff2(2:end)/(2*h);
end