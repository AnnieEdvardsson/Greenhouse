function [h_mag, h_phase] = mybode(sys,wlim,ylim,fig,col)
%[h_mag h_phase] = mybode(sys,wlim,ylim,fig,col)
% sys = idpoly-object
% or
% sys = struct('mag','phase','w')
% 

if isempty(col)
    col = [0 0 0];
end

if isa(sys,'idpoly')
    [mag,phase,w] = bode(sys,wlim);
    %[mag,phase,wout,sdmag,sdphase] = bode(sys);
elseif isstruct(sys)
    mag     = sys.mag;
    phase   = sys.phase;
    w       = sys.w;
end

for i = 1:length(w)
    m(i) = 20*log10(mag(1,1,i));
    ph(i) = phase(1,1,i);
end

h_mag= semilogx(fig(1),w,m','Color',col);
if ~isempty(ylim)
    set(fig(1),'Ylim',ylim{1})
end
if ~isempty(wlim)
    set(fig(1),'Xlim',[wlim{1},wlim{2}])
end
ylabel(fig(1),'Magnitude, dB')

if ~ ishold(fig(1))
    hold(fig(1))
end

h_phase =semilogx(fig(2),w,ph','Color',col);
if ~isempty(ylim)
    set(fig(2),'Ylim',ylim{2})
end
if~isempty(wlim)
    set(fig(2),'Xlim',[wlim{1},wlim{2}])
end
ylabel(fig(2),'Phase, degrees')
xlabel(fig(2),'Frequency, rad/s')
if ~ ishold(fig(2))
    hold(fig(2))
end
end    