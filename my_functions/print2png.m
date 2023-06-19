function print2png(h, fname, PaperPositionMode_isAuto)
% PRINT2PNG Prints figure h to PNG file fname.png. Uses default paper
%size if
% PaperPositionMode_isAuto is not defined or set to 0. Uses figure's
%screen
% size if PaperPositionMode_isAuto is defined.
%
% Usage: print2png(h, fname, PaperPositionMode_isAuto)
%

if (nargin>1)
   if findstr(fname, '.png')
      f_str=[fname]; % Pre-pend a default path if desired
   else
      f_str=[fname '.png']; % Pre-pend a default path if desired
   end
else
   f_str=[tmp.png']; % Pre-pend a default path if desired
end

if (nargin>2)&(PaperPositionMode_isAuto~=0)
   tPPM = get(h, 'PaperPositionMode');
   set(h, 'PaperPositionMode', 'auto');
end

print(h, '-dpng', '-r288', '-opengl', f_str);

if (nargin>2)&(PaperPositionMode_isAuto~=0)
   set(h, 'PaperPositionMode', tPPM);
end

return 