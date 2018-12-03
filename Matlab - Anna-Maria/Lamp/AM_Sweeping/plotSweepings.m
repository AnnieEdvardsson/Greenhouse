clear all
close all
clc

intIRRmatrix = load('Sweepings/PARTSweeping_RX2018-11-12-1708','intIRRmatrix');
figure
hold
LEDs = [380 400 420  450 530 620 660 735 5700];
for i = 1:length(LEDs)
    [rgb,name]= getColororder(LEDs(i));
    h = plot(intIRRmatrix.intIRRmatrix(i,:),'DisplayName',name{1});
    h.Color = rgb;
end
legend('show')