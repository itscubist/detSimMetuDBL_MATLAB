% Author: Baran Bodur
% Downsamples time for longer measurements that are though to be lower flux
function [ToA,shutter_length] = downsample(ToA,shutter_length,...
    downsample_ratio)

temp_ToA = round(ToA/downsample_ratio);
ToA = temp_ToA;
shutter_length = shutter_length/downsample_ratio;

end