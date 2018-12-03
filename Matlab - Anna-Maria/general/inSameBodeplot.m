function [] = inSameBodeplot(sys,wlimits,ylimits,p,col)
% inSameBodeplot(sys,wlimits,ylimits,p)
% plotStepsInTimeFreq(SpecModels.y(1:10),permute(SpecModels.mod(4,3,1:10),[3 2 1]),permute(SpecModels.sim(4,3,1:10),[3,2,1]),0:SpecModels.ts{1}:(length(SpecModels.y{1})*SpecModels.ts{1}-1),{[-5,5];[-19,19]},{0.01,1},[],[],[])
% [] = inSameBodeplot(sys,{0.01,1},{[-5,5];[-19,19]},1)
% ylim = {[-5,5];[-19,19]};
% wlim = {0.01,1};
% figure('WindowStyle','docked')
lenSys  = numel(sys);
if isempty(col)
    col     = copper(lenSys);
end
for i = 1:lenSys    
    % Default the new plot color to red
    
    h = bodeplot(gca,sys{i},wlimits,'r');
    setoptions(h,'Ylim',ylimits)
    grid on    
    % Find handles of all lines in the figure that have the color red
    lineHandle = findobj(gcf,'Type','line','-and','Color','r');

    % Change the color to the one you defined
    set(lineHandle,'Color',col(i,:));
    hold on
        
    if p == true
        pause
    end
end
hold off
end