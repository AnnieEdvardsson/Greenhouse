function [colorOrder,colorNames] = getColororder(LEDs)
% [colorOrder,colorNames] = getColororder(LEDs)
% [rgb,name] = getColororder(420);
% [rgbs,names]= getColororder([400, 530, 5700]);


UV = [250 100 250]./250;
B400 = [190 100 250]./250;
B420 = [10 0 200]./250;
B450 = [0 100 250]./250;
G530 = [0 200 50]./250;
R620 = [250 0 0]./250;
R660 = [220 10 0]./250;
FR   = [190 0 0]./250;
W    = [250 210 0]./250;

Colors = [UV;B400;B420;B450;G530;R620;R660;FR;W];
LX_LEDs = [380 400 420  450 530 620 660 735 5700];

k = 0;
colorOrder = zeros(length(LEDs),3);
colorNames = cell(size(LEDs)); 
for i = 1:length(LEDs)
    f = 0;
    j = 1;
    while f == 0
        if LEDs(i) == LX_LEDs(j)
            k = k+1;
            f = 1;
            colorOrder(k,:) = Colors(j,:);
            colorNames{k} = num2str(LEDs(i));
        else
            j = j+1;
        end
    end
end
end

