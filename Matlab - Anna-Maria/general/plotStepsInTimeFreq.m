%Plot step responses in time- and frequency domain
% plotStepsInTimeFreq(data,sys,sim,t,ylim,wlim,ax,names,colors)
% plotStepsInTimeFreq(SpecModels.y(1:10),permute(SpecModels.mod(4,3,1:10),[3 2 1]),permute(SpecModels.sim(4,3,1:10),[3,2,1]),0:SpecModels.ts{1}:(length(SpecModels.y{1})*SpecModels.ts{1}-1),{[-5,5];[-19,19]},{0.01,1},[],[],[])
function [] = plotStepsInTimeFreq(data,sys,sim,t,ylim,wlim,ax,names,colors,plotALL,doPause)
if isempty(ax)
    ax = [0 330 -1*10^-1 15*10^-1];

end
% ylim = {[-88,-77];[-19,19]};
% wlim = {0.01,1};
lenSys  = numel(sys);
if isempty(colors)
    cmapname = input('Please choose one of these colormaps:''winter'',''hsv'',''summer'',''copper'')');
    if strcmp(cmapname,'winter')
        colors    = winter(lenSys);
    elseif strcmp(cmapname,'summer')
        colors    = summer(lenSys);
    elseif strcmp(cmapname,'hsv')
        colors    = hsv(lenSys);
    elseif strcmp(cmapname,'copper')
        colors = copper(lenSys);
    end
end
figure%('WindowStyle','Docked')
for r = 1:size(sys,1)
    for c = 1:size(sys,2)
        h(1) = subplot(2,3,[1,4]);
        hold on
        h(2) = subplot(2,3,[2,3]); 
        h(3) = subplot(2,3,[5,6]); 
        
        if ~isempty(data)
            line_handle1 = plot(h(1),t,data{r,c},'LineStyle','none','Marker','.','MarkerSize',4);
        end
        if ~isempty(sim)
            line_handle2 = plot(h(1),t,sim{r,c}.OutputData,'LineStyle','-');
        end
        xlabel(h(1),'time (s)')
        ylabel(h(1),'normalized fluorescence')% (nmole/m^2s)')
        

        if ~isempty(ax)
           axis(h(1),ax)
        end
        if exist('line_handle1','var')
            set(line_handle1,'Color',colors(r*c,:))
        end
        if exist('line_handle2','var')
            set(line_handle2,'Color',colors(r*c,:))
        end
        
        if ~isempty(names)
            title(h(1),names{r,c},'Interpreter','none')
        end
        box on

        %mybode(sys,wlim,ylim,fig,col)
        [h1, h2]= mybode(sys{r,c},wlim,ylim,h(2:3),colors(r*c,:));
        set(h1,'LineStyle','-')
        set(h2,'LineStyle','-')
    end
    if plotALL && doPause

        
        pause
    else
        pause
        clf
    end
end
    
    
    
    
    



