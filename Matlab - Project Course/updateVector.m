function updated_vector = updateVector(vector, element, max_length)
% Update the array "vector" with the input element. If #elements in array 
% is larger than max_length, remove the first element
%
% Syntax:  updated_vector = updateVector(vector)
%
% Inputs:
%    vector     - A array 
%    element    - Element with will be added to "vector"
%    max_length - The maximum length of the vector/updated_vector
%
% Outputs:
%    updated_vector - The array "vector" updated with the element with a
%                     maximum length of max_length
%
%
% Other m-files required: none
% MAT-files required: none
%
% December 2018; Last revision: 03-December-2018
%------------- BEGIN CODE --------------

%% Add element
updated_vector = [vector, element];

%% Se if #element is larger than max_length, if so remove first element
if length(max_length) > max_length
    
    updated_vector = updated_vector(2:end);
end









end
