function [ cell_str ] = mat2wwString( LEDinput, lamp_ip )
%mat2wwString Converts a matrix with LEDchannel input intensities to cell
%containing strings in webwrite format
%LEDinput = matrix [channel intensity 1, channel intensity 2, etc], one row
%for each update.
%Usage: webwrite(cell_str{1,i},'');

[nSteps, nChannels] = size(LEDinput);
cell_str = cell(1,nSteps);
for i = 1:nSteps
    setting = num2str(round(LEDinput(i,1)));
    for j = 2:nChannels
        setting = [setting,':',num2str(round(LEDinput(i,j)))];
    end
    cell_str{1,i} = ['http://' lamp_ip '/intensity.cgi?int=' setting];
end
%webwrite(str,'');

end

