% Author: Baran Bodur
% Gives measurement time * area that can be accounted for, in s*cm2

function [flux_divider] = time_area_norm(ToT,ToA,shutter_length,row_size,...
    column_size,ToA_format, pixel_area,clock_to_ns,timing_downsample_on,...
    downsampling_ratio)

    flux_divider = 0;
    for r = 1:1:row_size
        for c = 1:1:column_size
            if(ToA(r,c) >= 2 || ToA(r,c) == 0) % Do not include pixels with measurement under 2 ns in the measurement
                if(ToT(r,c))
                    flux_divider = flux_divider + (ToA(r,c) - 2);
                else
                    flux_divider = flux_divider + shutter_length;
                end
            end
        end
    end
    
    % Unit correction operations
    flux_divider = flux_divider * pixel_area; % Change pixel to area
    if(~ToA_format) % Change clock cycle to ns if necessary
        flux_divider = flux_divider * clock_to_ns;
    end
    if(timing_downsample_on)
        flux_divider = flux_divider * downsampling_ratio;
    end
    flux_divider = flux_divider*10^-9; %ns to s
end