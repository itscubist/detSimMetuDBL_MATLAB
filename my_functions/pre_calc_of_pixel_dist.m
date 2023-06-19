% A function that finds all possible electron distributions with given
% diffusion sigma and discritization of pixels.
% For length(x_index)*length(y_index) different positions, normalized
% electron distribution over 9 pixels are calculated

% Notes : 
%   1) A 2D rotationally symmetric gaussian is multiplication of two
% gaussians in 1D 
%   2) For Gaussian integration embedded erf and erfc functions, in
%   addition to symmetries of the gaussian was used
%   3) Pixel Numbers are given in the following form:
%       1   2   3
%       4   5   6
%       7   8   9
%   4) The origin of the coordinate system is at left-down corner of the
%   center pixel

function dist_in_cell = pre_calc_of_pixel_dist(x_index,y_index,diff_sigma)
    length_x = length(x_index);
    length_y = length(y_index);
    pixel_dist = zeros(1,9);
    dist_in_cell = cell(length_y,length_x);
    
    for i = 1:1:length_x
        for j = 1:1:length_y
            % Calculation of relative and rel. complementary sigmas
            rel_sigma_x = x_index(i)/diff_sigma;
            rel_sigma_y = y_index(j)/diff_sigma;
            comp_sigma_x = (length_x-x_index(i))/diff_sigma;
            comp_sigma_y = (length_y-y_index(j))/diff_sigma;
            
            pixel_dist(1) = erfc(rel_sigma_x)*erfc(comp_sigma_y)/4;
            
            pixel_dist(2) = (erf(rel_sigma_x)+erf(comp_sigma_x))*...
                erfc(comp_sigma_y)/4;
            
            pixel_dist(3) = erfc(comp_sigma_x)*erfc(comp_sigma_y)/4;
            
            pixel_dist(4) = erfc(rel_sigma_x)*(erf(rel_sigma_y) + ...
                erf(comp_sigma_y))/4;
            
            pixel_dist(5) =  (erf(rel_sigma_x)+erf(comp_sigma_x))*...
                (erf(rel_sigma_y) + erf(comp_sigma_y))/4;
            
            pixel_dist(6) = erfc(comp_sigma_x) * (erf(rel_sigma_y) ...
                + erf(comp_sigma_y))/4;
            
            pixel_dist(7) = erfc(rel_sigma_x)*erfc(rel_sigma_y)/4;
            
            pixel_dist(8) = (erf(rel_sigma_x)+erf(comp_sigma_x))*...
                erfc(rel_sigma_y)/4;
            
            pixel_dist(9) = erfc(comp_sigma_x) * erfc(rel_sigma_y)/4;
            
            dist_in_cell{i,j} = pixel_dist;
        end
    end
end