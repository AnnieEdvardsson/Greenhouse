function [SpecBands,varargout] = getSpectrumBands(Spectrometers,varargin)
% The definitions of wavelength bands here is the same as in the JAZ-tool 

int_index(:,:,1)            = [350 850; 400 700; 350 400; 400 500; 500 600; 600 700; 700 800];
colors                      = [1,1,1; 1,1,0.5; 1,0.394,0.97; 0,0,1; 0,0.5,0; 0.8,0,0; 0.5,0,0;];
DATA = amprepareData_All(Spectrometers, 1, int_index);

for i = 1:length(DATA.intIRR(1).spec_uEin_int)
    FULL(1,i)   = DATA.intIRR(1).spec_uEin_int{i};
    PAR(1,i)    = DATA.intIRR(2).spec_uEin_int{i};
    UVA(1,i)    = DATA.intIRR(3).spec_uEin_int{i};
    BLUE(1,i)   = DATA.intIRR(4).spec_uEin_int{i};
    GREEN(1,i)  = DATA.intIRR(5).spec_uEin_int{i};
    RED(1,i)    = DATA.intIRR(6).spec_uEin_int{i};
    FARRED(1,i) = DATA.intIRR(7).spec_uEin_int{i};
    if exist('varargin','var')
        if varargin{end} == 1
          f(i) = figure;
          hold
          for j = 1:size(int_index,1)
              [~,id1] = min(abs(DATA.IRR.WLs-int_index(j,1)));
              [~,id2] = min(abs(DATA.IRR.WLs-int_index(j,2)));
              fig = area(DATA.IRR.WLs(id1:id2),DATA.IRR.spec_uEin_nm{i}(id1:id2));
              fig.FaceColor = colors(j,:);
          end
          ylabel('\mumol photons*m^-^2*s^-^1*nm^-^1')
          xlabel('nm')
          fr = sprintf('Red:FR \t %0.1f:%d',RED(i)/FARRED(i),1);
          br = sprintf('Blue:Red \t %d:%0.1f',1,RED(i)/BLUE(i));
          bg = sprintf('Percentage Green \t %0.1f',GREEN(i)/PAR(i)*100);
%           pos1 = gtext(fr);
%           pos2 = gtext(br);
%           pos3 = gtext(bg);
          pos1 = gtext(fr);
          text(pos1.Position(1),pos1.Position(2)*1.1, 0,br)
          text(pos1.Position(1),pos1.Position(2)*1.17, 0,bg)
          text(pos1.Position(1)*1.4, pos1.Position(2)*1.1, 0, strcat('PAR: ',num2str(PAR(1,i)),'\muE'))
          pause
          if nargout>1
              varargout = {f};
          end
        end
    end
end

SpecBands.Full = FULL;
SpecBands.Par = PAR;
SpecBands.UvA  = UVA;
SpecBands.Blue = BLUE;
SpecBands.Green = GREEN;
SpecBands.Red   = RED;
SpecBands.FarRed = FARRED;
SpecBands.R2B   = RED./BLUE;
SpecBands.R2FR  = RED./FARRED;
end