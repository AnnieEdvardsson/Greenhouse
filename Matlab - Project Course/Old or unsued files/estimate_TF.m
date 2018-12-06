function TF = estimate_TF(x, y)
% This function estaimtes the transfer function between the (input) applied 
% lamp intensity and the (output) filtered measured fluorescent signal
%
% Syntax:  TF = estimate_TF(x, y)
%
% Inputs:
%    x - input signal; applied lamp intensity, [1,n]
%    y - output signal; filtered measured fluorescent signal, [1,n]
%
% Outputs:
%    TF - The transfer function
%
%
% Other m-files required: none
% MAT-files required: none
%
% November 2019; Last revision: 30-November-2019
%------------- BEGIN CODE --------------
%% Call build in MATLAB function

TF = tfestimate(x,y);

end