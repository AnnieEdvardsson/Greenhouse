function [dataOut] = detrend_and_resampleFluoSteps(data,name,Ts,timeForStep,t_before,t_after,medFiltLen,detrendingMode,normalizationMode,filterOption,filterMode,filterParams,doPlot,varargin)
% Todo: Make option plotting only: Needed input parameters for plot_local: data_temp,name,idx,timeForStep,Ts,doPlot,fig
    
%     function [dataOut] = detrend_and_resampleFluoSteps(data,name,Ts,timeForStep,t_before,t_after,medFiltNr,detrendingMode,normalizationMode,filterMode,filterParams,doPlot,varargin)
% IN:
    % data          = cellstructure with EQUALLY SAMPLED data {dataset1, dataset2,...}
    % Ts            = time between samples in the equally sampled data set.
    % t_before      = t_step -1- time before step used for detrending.
    % t_after       = t_end - time in the end of the step used for detrending.
    % t_step        = time for step change (time for first sample after the step change)
    % medFiltLen    = medianfilter-length.
    % detrending = 'none', 'uniform', 'separate' or 'extrapolate'
    % normalization = normalization mode, 'none', 0 (amplitude = 0), 1 (amplitude = 1) or 2 and above (amplitude = 1 at time = timeForStep+normalization-1) 
% OUT:
    % dataOut       = Struct with fields:
%     dataOut.medfilt.data    = data_medfilt;
%     dataOut.medfilt.order   = medFiltLen;
%     dataOut.detrended.data  = data_detr;
%     dataOut.detrended.mode  = detrendingMode;
%     dataOut.detrended.nDetrSamp = t_after; 
%     dataOut.normalized.data = data_normalized;
%     dataOut.normalized.mode = normalizationMode;
%     dataOut.filtered.data   = data_filtered;
%     dataOut.filtered.filter = filterOption;
%     dataOut.filtered.mode   = filterMode
%     dataOut.filtered.params = filterParams;

% INTERNAL FUNCTIONS:
%     function [data_detrended]     = detrend_local(data,idx.t1,idx.t2,idx.t3,idx.t_end,timeForStep,Ts,mode)
%     function [data_normalized]    = normalize_local(data,idx.t3,idx.t_end,timeForStep,Ts,mode)
%     function [filtered_data]      = filter_local(data,Ts,params,filterOptions)
%     function []                   = plot_local(ALLdata,name,plottingMode,fig)
%------------------------------------------------------------------------------
if strcmp(doPlot,'none')
    fig = []; 
elseif exist('varargin','var')
    fig = varargin{1};
else
    fig = figure('Name','Detr&Res','WindowStyle','Docked');
end

data_medfilt = {};          %medianfiltered
data_detr = {};             %detrended
data_normalized = {};       %normalized
data_filtered = {};        %filtered and resampled

for stepNr = 1:length(data)
    [Nans]                  = isnan(data{stepNr});
    data{stepNr}(Nans)      = 0; %NaNs ersätts med 0-or.
    data_medfilt{stepNr}    = medfilt1(data{stepNr},medFiltLen); %medianvärdesfiltrering, (om medFiltNr>1).
    
    %Calculate indices corresponding to before and after excitation.
    idx.t_end   = length(data{stepNr});
    idx.t1      = ceil((timeForStep-t_before)/Ts); 
    idx.t2      = floor(timeForStep/Ts)-1; %time before step_change;
    idx.t3      = ceil(idx.t_end-(t_after/Ts)); 
    
    data_detr{stepNr}   = detrend_local(data_medfilt{stepNr},idx,timeForStep,Ts,detrendingMode);
    
    %Normalization
    if isnumeric(normalizationMode)
        data_normalized{stepNr}     =   normalize_local(data_detr{stepNr},idx,timeForStep,Ts,normalizationMode); %internal function
    elseif strcmp(normalizationMode,'none')
        data_normalized{stepNr}     = data_detr{stepNr};
    end
    
    %Filtering
    if filterMode == 1
        data_filt_temp                 = filter_local(data_normalized{stepNr},Ts,filterParams,filterOption);
    elseif filterMode == 2
        data_filt_temp_bkg              = filter_local(data_normalized{stepNr}(1:(timeForStep-1)/Ts),Ts,filterParams,filterOption);
        data_filt_temp_exc              = filter_local(data_normalized{stepNr}(timeForStep/Ts:end),Ts,filterParams,filterOption);
        data_filt_temp                  = [data_filt_temp_bkg;data_filt_temp_exc];
    end
    t_cut = ceil((timeForStep-t_before)/(Ts*filterParams.q/filterParams.p));
    data_filtered{stepNr}           = data_filt_temp(t_cut:end-1,1);
    
    data_temp.raw  = data{stepNr};
    data_temp.med  = data_medfilt{stepNr};
    data_temp.detr = data_detr{stepNr};
    data_temp.norm = data_normalized{stepNr};
    data_temp.filt = data_filt_temp(1:end-1,1);
    data_temp.filtParams = filterParams;
    
    if ~isempty(fig)
        plot_local(data_temp,strcat(name,'_StepNr',num2str(stepNr)),idx,timeForStep,Ts,doPlot,fig)
    end
end
%% ----------Structuring OUTPUT variables.-----------------
if medFiltLen >=3
    dataOut.medfilt.data    = data_medfilt;
    dataOut.medfilt.order  = medFiltLen;
end
if ~strcmp(detrendingMode,'none')
    dataOut.detrended.data  = data_detr;
    dataOut.detrended.mode  = detrendingMode;
    if strcmp(detrendingMode,'separate')
        dataOut.detrended.nDetrSamples = t_after;
    end
end
if isnumeric(normalizationMode)
    dataOut.normalized.data = data_normalized;
    dataOut.normalized.mode = normalizationMode;
end
dataOut.filtered.data   = data_filtered;
dataOut.filtered.filter = filterOption;
dataOut.filtered.mode   = filterMode;
dataOut.filtered.params = filterParams;
end
%% Local functions - Detrending
function [data_detrended] = detrend_local(data,idx,timeForStep,Ts,mode)
    trend_bkg           = fit([idx.t1:idx.t2]',data(idx.t1:idx.t2),'poly1'); %trend at end of background light
    trend_exc           = fit([idx.t3:idx.t_end]',data(idx.t3:idx.t_end),'poly1'); %trend at end of excitation
            
    if strcmp(mode,'none') %No detrending except that the value before the step change is subtracted from data.
        data_detrended   = data-feval(trend_bkg,idx.t2);
    elseif strcmp(mode,'uniform') %detrended based on a linear trend before excitation 
        data_detrended   = data-feval(trend_bkg,1:idx.t_end);
    elseif strcmp(mode,'separate')%background-part detrended based on trend at end of background light, exciation-part detrended based on trend at end of excitation.
        data_detr_bkg       = data(1:idx.t2)-feval(trend_bkg,1:idx.t2);
        data_detr_exc       = data(ceil(timeForStep/Ts):idx.t_end)-feval(trend_exc,ceil(timeForStep/Ts):idx.t_end)+feval(trend_exc,ceil(timeForStep/Ts))-feval(trend_bkg,ceil(timeForStep/Ts));
        data_detrended   = [data_detr_bkg; data_detr_exc];
    elseif strcmp(mode,'extrapolate') 
        data_detrended   = [data'-interp1(idx.t1:idx.t2,data(idx.t1:idx.t2),1:idx.t_end,'pchip')]';
% %         data_detrended   = [data'-interp1(idx.t1:idx.t2,data(idx.t1:idx.t2),1:idx.t_end,'linear','extrap')]';
    end
end
%% Normalization
function [data_normalized]=normalize_local(data,idx,timeForStep,Ts,mode)
    trend_exc     = fit([idx.t3:idx.t_end]',data(idx.t3:idx.t_end),'poly1'); %trend at end of excitation
    if mode == 0 %Förstärkningen = 0.
        normalized_bkg  = data(1:floor(timeForStep/Ts)-1);
        normalized_exc  = data(timeForStep/Ts:end)-feval(trend_exc,ceil(timeForStep/Ts):idx.t_end);
        data_normalized = [normalized_bkg;normalized_exc]; 
    elseif mode == 1 %Förstärkningen = 1
        normalized_bkg  = data(1:floor(timeForStep/Ts)-1);
        normalized_exc  = data(timeForStep/Ts:end);
        data_normalized = [normalized_bkg;normalized_exc]./feval(trend_exc,idx.t_end); 
    elseif mode >1 %Normaliserat baserat på värdet vid tidpunkten [normalize-1] sekunder efter stegets början.
%         try
        data_normalized = data./feval(trend_exc,ceil((timeForStep+mode-1)/Ts));
%         catch
%             warning(strcat('Step nr ',num2str(stepNr),'Was discarded,since it was not complete'))
%             data_normalized      = [];
    end
end
%% Filtering
function [filtered_data] = filter_local(data,Ts,params,filterOption)

if strcmp(filterOption,'resamp')
% %     if ~isfield(params,'method')
% %         params.method = 'pchip';
% %     end
% %     interp_data = interp1(1:length(data),data,1:(Ts*1/params.p):length(data),params.method)';
% %     filtered_data = resample(interp_data,1,params.q,params.n);
    filtered_data = resample(data,params.p,params.q,params.n);
elseif strcmp(filterOption,'smoothing')
    filtered_data = fastsmooth(data,params.width,params.type,params.ends); 
elseif strcmp(filterOption,'extrapolate')
    if ~isfield(params,'method')
        params.method = 'pchip';
    end
    filtered_data = interp1(1:length(data),data,1:(Ts*params.q/params.p):length(data),params.method)';
%     filtered_data = interp1(idx.t1:idx.t2,data(1:idx.t_end),1:idx.t_end,'pchip');
elseif strcmp(filterOption,'none')
    filtered_data = data;
end
end

%% Plotting
function [] = plot_local(ALLdata,name,idx,timeForStep,Ts,plottingMode,fig)
axes(fig);
clf;
name = sprintf('%s',name);
if strcmp(plottingMode,'plotAll')
    All         = true;
    hRaw        = subplot(131); hold;
    hDetr       = subplot(132); hold;
    hFilt       = subplot(133); hold;
    suptitle(name);
elseif strcmp(plottingMode,'plotRaw')
    Raw         = true;
    Detr        = false;
    Filt        = false;
    All         = false;
    hRaw        = gca; hold;
    title(name,'Interpreter','none');
elseif strcmp(plottingMode,'plotDetr')
    Detr        = true;
    Raw         = false;
    Filt        = false;
    All         = false;
    hDetr       = gca; hold;
    title(name,'Interpreter','none');
elseif strcmp(plottingMode,'plotFilt')
    Filt        = true;
    Raw         = false;
    Detr        = false;
    All         = false;
    hFilt       = gca; hold;
    title(name,'Interpreter','none');
end

if All || Raw
    plot(hRaw,1:Ts:(length(ALLdata.raw)-1)*Ts+1,ALLdata.raw')
    plot(hRaw,1:Ts:(length(ALLdata.med)-1)*Ts+1,ALLdata.med')
    legend(hRaw,'raw','medianfiltered','Location','southeast')
    xlabel('time,(s)')
    ylabel('fluorescence, (\mu E')
end
if All || Detr
    no_detr = detrend_local(ALLdata.med,idx,timeForStep,Ts,'none');
    plot(hDetr,1:Ts:(length(ALLdata.med)-1)*Ts+1,no_detr)
    
    uniform_detr = detrend_local(ALLdata.med,idx,timeForStep,Ts,'uniform');
    plot(hDetr,1:Ts:(length(ALLdata.med)-1)*Ts+1,uniform_detr)
    Lims = axis(hDetr);
    axis(hDetr,[idx.t1,Lims(2),0,Lims(4)]);
    hDetr.YLimMode = 'auto';

    separate_detr = detrend_local(ALLdata.med,idx,timeForStep,Ts,'separate');
    plot(hDetr,1:Ts:(length(ALLdata.med)-1)*Ts+1,separate_detr)

    extrap_detr   = detrend_local(ALLdata.med,idx,timeForStep,Ts,'extrapolate');
    plot(hDetr,1:Ts:(length(ALLdata.med)-1)*Ts+1,extrap_detr)
    legend(hDetr,'raw-end_bkg','raw-trend_{bkg}','raw-[trend_{bkg}, trend_{exc}]','raw-extrapolated_{bkg}','Location','southeast')
    xlabel('time,(s)')
    ylabel('fluorescence, (\mu E')
end
if All || Filt
    if isfield(ALLdata.filtParams,'p')
        p = ALLdata.filtParams.p;
        q = ALLdata.filtParams.q; 
    else
        p = 1;
        q = 1;
    end
    plot(hFilt,(1:Ts:(length(ALLdata.norm)-1)*Ts+1),ALLdata.norm)
    plot(hFilt,1:Ts*q/p:(floor(length(ALLdata.norm)*Ts)-ceil(q/p)),ALLdata.filt)
    Lims = axis(hFilt);
    axis(hFilt,[idx.t1,Lims(2), 0,Lims(4)]);
    hFilt.YLimMode = 'auto';
    legend(hFilt,'normalized','filtered','Location','southeast')
    xlabel('time,(s)')
    ylabel('fluorescence, (arbitr)')
end
pause
end