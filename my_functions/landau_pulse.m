% Function that generates a Landau pulse with given height, length and
% center
% Height : The maximum amplitude
% Length : Time between signal rises 1 % of maximum and falls 1 %
% of maximum
% Step : Step between data points
function [pulse,index] = landau_pulse(height,length, center, step)
    length_original = 12.9;
    length_ratio = length / length_original;
     index = (-15*length_ratio+center):step:(15*length_ratio+center);
    % Approximate Landau Pulse
    pulse  = 1/sqrt(2*pi)*exp(-0.5*((index-center)/length_ratio...
        + exp(-(index-center)/length_ratio)));
    pulse = pulse*height/max(pulse); % Height Arrangement
end