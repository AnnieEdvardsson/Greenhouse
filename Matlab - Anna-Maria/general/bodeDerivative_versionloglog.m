function [magDer, phaseDer, ExtrVal] = bodeDerivative_versionloglog(sys,wlim,nDeriv,fig)
%[magDer, phaseDer, ExtrVal] = bodeDerivative(sys,wlim,n,fig)
% % Numerically calculates the 'nDeriv' first derivatives of the bode magnitude- and phase-curves in the frequency interval given by wlim.
% % Estimates max and min values for magnitude- and phase-curve as well as
% % for the first derivative of these curves.
% 
% %If fig is nonempty derviatives and extremevalues are plotted in the axis
% %given by fig(1) -magnitude, and fig(2)- phase.
% % returnALL == 1 means that multiple min and max values are returned.
% % returnALL == 0 means that only the smallest/largest min/max-value is
% % returned.

% % magDer = {0-derivative,1st derivative, 2nd derivative,...,nth derivative}
% % ExtrVal= struct('phaseMin',[wmin,phaseMin],'phaseMax',[wmax,phaseMax],'phaseMinDer',[wmin,phaseMinDer],'phaseMaxDer',..,'magMin',..etc.);
% % i.e. ExtrVal.(fieldName)(:,1) is w-values and ExtrVal.(fieldName)(:,2) contains min/max-values.
% % if returnALL is true there could be several rows, but if returnALL is
% % false there could be only 0 or 1 row.

    spacing     = 0.001; %i.e. 1000 samples/decade
%     lgSamples   = (log10(wlim(2))-log10(wlim(1)))/spacing;
%     w           = transpose(logspace(log10(wlim(1)),log10(wlim(2)),lgSamples));
    lin_w       = transpose(0.001:spacing:2.101);
    magDer      = cell(nDeriv+1,1);
    phaseDer    = cell(nDeriv+1,1);
    [mag,phase] = bode(sys,lin_w);
    bodeMagLin  = permute(mag,[3 2 1]);
    magDer{1}   = [lin_w,20*log10(bodeMagLin)];
    phaseDer{1} = [lin_w,permute(phase,[3 2 1])];
    
    if~isempty(fig)
        cla(fig(1))
        cla(fig(2))
       semilogx(fig(1),lin_w,magDer{1}(:,2));
       if ~ishold(fig(1))
           hold(fig(1))
       end
       semilogx(fig(2),lin_w,phaseDer{1}(:,2));
        lgd{1} = 'bode diagram';
        if ~ishold(fig(2))
            hold(fig(2))
        end
    end
    
    w_temp = lin_w;
    for derOrder = 1:nDeriv
        if derOrder == 1
            magDer_temp         =  numDerivative(bodeMagLin,spacing);
        else
            magDer_temp         =  numDerivative(magDer{derOrder}(:,2),spacing);
        end
        phaseDer_temp       =  numDerivative(phaseDer{derOrder}(:,2),spacing);
        w_temp              =  w_temp(2:end-1);
        if nDeriv == 1
            magDer{derOrder+1,1}  = [w_temp,20*magDer_temp./magDer{derOrder,1}(2:end-1).*w_temp]; %% d (log(mag(w))/d(log(w)) = d(mag(w))/dw * (x/mag(w))
        else
            magDer{derOrder+1,1}  = [w_temp,magDer_temp.*w_temp];
        end
        phaseDer{derOrder+1,1}= [w_temp,phaseDer_temp.*w_temp];
        if~isempty(fig)
            semilogx(fig(1),w_temp,magDer{derOrder+1,1}(:,2))
            semilogx(fig(2),w_temp,phaseDer{derOrder+1,1}(:,2))
        end
       lgd{derOrder+1} = sprintf('%i st derivative',derOrder);
    end
    if ~isempty(fig)
        legend(lgd);
    end
    if  ~isempty(fig)
        phase_plot = fig(2);
        mag_plot   = fig(1);
    else
        phase_plot = [];
        mag_plot   = [];
    end
    % Maxima and minima of the phase curve.
%     plotMin = true; plotMax = false;
%     [ExtrVal.phaseMin,~]         = findExtremeValues(phaseDer{1}(:,1),phaseDer{1}(:,2),phaseDer{2}(:,1),phaseDer{2}(:,2),phase_plot,0,'plotMIN');

    [ExtrVal.phaseMin,~]         = findExtremeValues(phaseDer{1}(:,1),phaseDer{1}(:,2),phaseDer{2}(:,1),phaseDer{2}(:,2),phase_plot,0,'plotMIN');
% plotMin = false; plotMax = true;
    [~,ExtrVal.phaseMax]         = findExtremeValues(phaseDer{1}(:,1),phaseDer{1}(:,2),phaseDer{2}(:,1),phaseDer{2}(:,2),phase_plot,1,'plotMAX');
% % %    % 1 eller 2 här??????????????? 
    plotMin = true; plotMax = false;
    [ExtrVal.phaseMinDer,~]   = findExtremeValues(phaseDer{2}(:,1),phaseDer{2}(:,2),phaseDer{3}(:,1),phaseDer{3}(:,2),phase_plot,0,'plotMIN'); %0 förut
    plotMin = false; plotMax = true;
    [~,ExtrVal.phaseMaxDer]   = findExtremeValues(phaseDer{2}(:,1),phaseDer{2}(:,2),phaseDer{3}(:,1),phaseDer{3}(:,2),phase_plot,2,'plotMAX');
    
    %Same for magnitude curve
    plotMin = true;plotMax = false;
    [ExtrVal.magMin,~]          = findExtremeValues(magDer{1}(:,1),magDer{1}(:,2),magDer{2}(:,1),magDer{2}(:,2),mag_plot,1,'plotMIN');
    plotMin = false; plotMax = true;
    [~,ExtrVal.magMax]          = findExtremeValues(magDer{1}(:,1),magDer{1}(:,2),magDer{2}(:,1),magDer{2}(:,2),mag_plot,0,'plotMAX');
    plotMin = true; plotMax = false;
    [ExtrVal.magMinDer,~]       = findExtremeValues(magDer{2}(:,1),magDer{2}(:,2),magDer{3}(:,1),magDer{3}(:,2),mag_plot,0,'plotMIN');
    plotMin = false; plotMax = true;
    [~,ExtrVal.magMaxDer]       = findExtremeValues(magDer{2}(:,1),magDer{2}(:,2),magDer{3}(:,1),magDer{3}(:,2),mag_plot,1,'plotMAX');

    
%     % Maxima and minima of the phase curve.
%     [ExtrVal.phaseMin,ExtrVal.phaseMax]         = findExtremeValues(phaseDer{1}(:,1),phaseDer{1}(:,2),phaseDer{2}(:,1),phaseDer{2}(:,2),phase_plot,returnALL);
%     % Max and Min of the first derivative of the phase curve.
%     [ExtrVal.phaseMinDer,ExtrVal.phaseMaxDer]   = findExtremeValues(phaseDer{2}(:,1),phaseDer{2}(:,2),phaseDer{3}(:,1),phaseDer{3}(:,2),phase_plot,returnALL);
%     %Same for magnitude curve
%     [ExtrVal.magMin,ExtrVal.magMax]         = findExtremeValues(magDer{1}(:,1),magDer{1}(:,2),magDer{2}(:,1),magDer{2}(:,2),mag_plot,returnALL);
%     [ExtrVal.magMinDer,ExtrVal.magMaxDer]   = findExtremeValues(magDer{2}(:,1),magDer{2}(:,2),magDer{3}(:,1),magDer{3}(:,2),mag_plot,returnALL);
    if ~isempty(fig)
        axis(mag_plot,[wlim,1.01*min(min(ExtrVal.magMin(:,2)),min(ExtrVal.magMinDer(:,2))),1.01*max(max(ExtrVal.magMax(:,2)),max(ExtrVal.magMaxDer(:,2)))])
        axis(phase_plot,[wlim,1.01*min(min(ExtrVal.phaseMin(:,2)),min(ExtrVal.phaseMinDer(:,2))),1.01*max(max(ExtrVal.phaseMax(:,2)),max(ExtrVal.phaseMaxDer(:,2)))])
    end
end

function [MinY,MaxY] = findExtremeValues(x0,y,x1,dy,plot_h,returnALL,plotOpt)
% function [MinY,MaxY] = findExtremeValues(x0,y,x1,dy,plot_h,returnALL,plotOpt)
% Find dy/dx == 0 and local minima or maxima, (but not saddlepoints).

% % returnALL == 0 means that only the GLOBAL MIN AND MAX ARE RETURNED.
% % returnALL == 1 return min and max occuring at lowest frequency.
% % returnALL == 2 return min and max occuring at the highest frequency.
% % else ...       return all max and min values.

if strcmpi(plotOpt,'plotMIN')
    plotMin = true;
    plotMax = false;
elseif strcmpi(plotOpt,'plotMAX')
    plotMax = true;
    plotMin = false;
else
    plotMax = true;
    plotMin = true;
end

imax = [];
imin = [];
for idx = 2:length(x1)
    if dy(idx-1)>0 && dy(idx)<0
        [~,i_temp]  = min([dy(idx-1),dy(idx)]);
        i_x1        = idx+i_temp-2;
        [~,i_x0]    = min(abs(x0-x1(i_x1)));
        imax        =[imax,i_x0];
    elseif dy(idx-1)<0 && dy(idx)>0
        [~,i_temp] = min([dy(idx-1),dy(idx)]);
        i_x1        = idx+i_temp-2;
        [~,i_x0]    = min(abs(x0-x1(i_x1)));
        imin        = [imin,i_x0];
    end
end
if returnALL == 0 % global minima and maxima
    [ymin,i] = min(y(imin));
    MinY = [x0(imin(i)),ymin];
    [ymax,i] = max(y(imax));
    MaxY = [x0(imax(i)),ymax];
elseif returnALL == 1 %min and max occuring at lowest frequency.
    if ~isempty(imin)
        MinY = [x0(imin(1)),y(imin(1))];
    else 
        MinY = [];
    end
    if ~isempty(imax)
        MaxY = [x0(imax(1)),y(imax(1))];
    else
        MaxY = [];
    end
elseif returnALL == 2 %min and max occuring at the highest.
    if ~isempty(imin)
        MinY = [x0(imin(end)),y(imin(end))];
    else
        MinY = [];
    end
    if ~isempty(imax)
        MaxY = [x0(imax(end)),y(imax(end))];
    else
        MaxY = [];
    end
else % return all max and min values.
    MinY = [x0(imin),y(imin)];
    MaxY = [x0(imax),y(imax)];
end
if isempty(MinY)
    MinY = [nan,nan];
end
if isempty(MaxY)
    MaxY = [nan,nan];
end
if ~isempty(plot_h)
    if ~all(isnan(MinY)) && plotMin
        semilogx(plot_h,MinY(~isnan(MinY(:,1)),1),MinY(~isnan(MinY(:,2)),2),'r*');
    end
    if ~all(isnan(MaxY)) && plotMax
        semilogx(plot_h,MaxY(~isnan(MaxY(:,1)),1),MaxY(~isnan(MaxY(:,2)),2),'b*');
    end
end
end