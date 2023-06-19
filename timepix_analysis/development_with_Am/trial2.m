clear all
close all
row_size = 256;
column_size = 256;
filename = 't2';
file_ext = 'pmf';
ToT = dlmread(strcat(filename,'.',file_ext,'_ToT.',file_ext),' ');
ToA = dlmread(strcat(filename,'.',file_ext,'_ToA.',file_ext),' ');
shutter_time = 1; % in seconds

direct_count = sum(sum(ToT>0))

mean_sum = 0;
mean_square_sum = 0;
sum_count = 0;
for r = 1:1:row_size
    for c = 1:1:column_size
        if(ToT(r,c) ~= 0)
            mean_sum = mean_sum + ToT(r,c);
            mean_square_sum = mean_square_sum + ToT(r,c)^2;
            sum_count = sum_count + 1;
        end
    end
end
mean_ToT = mean_sum/sum_count;
std_ToT = sqrt(mean_square_sum/sum_count - mean_ToT^2);

%Find ToT nodiff
ToT_nodiff = zeros(row_size, column_size);
ToA_nodiff = zeros(row_size, column_size);
for r = 3:1:(row_size-2)
    for c = 3:1:(column_size-2)
        if(ToT(r,c))
            ToT_prev = 0;
            for delta_r = -2:1:2
                for delta_c = -2:1:2             
                    if((ToA(r,c)+3)>ToA(r+delta_r,c+delta_c) ...
                                && (ToA(r,c)-3)<ToA(r+delta_r,c+delta_c) && ...
                                ToT(r+delta_r,c+delta_c) > mean_ToT - 0.9*std_ToT)
                        if(ToT(r+delta_r,c+delta_c) > ToT_prev)
                            ToT_prev = ToT(r+delta_r,c+delta_c);
                            r2 = r+delta_r;
                            c2 = c+delta_c;
                        end
                    end
                end
            end
            ToT_nodiff(r2,c2) = ToT_prev;
            ToA_nodiff(r2,c2) = ToA(r2,c2);
        end
    end
end
% Statistics of ToT no diff
mean_sum = 0;
mean_square_sum = 0;
sum_count = 0;
for r = 1:1:row_size
    for c = 1:1:column_size
        if(ToT_nodiff(r,c) ~= 0)
            mean_sum = mean_sum + ToT_nodiff(r,c);
            mean_square_sum = mean_square_sum + ToT_nodiff(r,c)^2;
            sum_count = sum_count + 1;
        end
    end
end
mean_ToT_nodiff = mean_sum/sum_count;
std_ToT_nodiff = sqrt(mean_square_sum/sum_count - mean_ToT_nodiff^2);

reduced_count = sum(sum(ToT_nodiff>0))
error_reduced = sqrt(reduced_count);

%Flux Determination with Pile-up correction
area_in_pixels = (254*4-4)*0.5 + 252*252; % possible contribution from edge
area_in_cm2 = (0.0055*0.0055) * area_in_pixels; % in cm
occupancy_ratio = direct_count/reduced_count;
syms x;
corrected_count = double(vpasolve((reduced_count*occupancy_ratio/...
    (area_in_pixels*shutter_time)) == x*exp(-1*x*shutter_time),x))...
    *shutter_time*area_in_pixels/occupancy_ratio

flux_red = reduced_count/(area_in_cm2*shutter_time) % in p/cm2/s
flux_cor = corrected_count/(area_in_cm2*shutter_time) % in p/cm2/s
flux_red_error = error_reduced/(area_in_cm2*shutter_time)




% 
% mark1 = zeros(row_size, column_size);
% mark2 = zeros(row_size, column_size);
% mark3 = zeros(row_size, column_size);
% for r = 2:1:(row_size-1)
%     for c = 2:1:(column_size-1)
%         if(ToT(r,c) > (mean_ToT-0*std_ToT))
%         mark1(r,c) = 1;
%             for delta_r = -1:1:1
%                 for delta_c = -1:1:1
%                     if (delta_r ~= 0 || delta_c ~= 0)
%                         if((ToA(r,c)+3)>ToA(r+delta_r,c+delta_c) ...
%                                 || (ToA(r,c)-3)<ToA(r+delta_r,c+delta_c))
%                             mark2(r+delta_r,c+delta_c) = 1;
%                         end
%                     end
%                 end
%             end
%             
%         end
%     end
% end
% for r = 2:1:(row_size-1)
%     for c = 2:1:(column_size-1)
%         if (ToT(r,c)>0 && ~mark1(r,c) && ~mark2(r,c))
%              for delta_r = -1:1:1
%                 for delta_c = -1:1:1
%                     if (delta_r ~= 0 || delta_c ~= 0)
%                         if(~((ToA(r,c)+3)>ToA(r+delta_r,c+delta_c) ...
%                                 || (ToA(r,c)-3)<ToA(r+delta_r,c+delta_c)) ...
%                                 || mark1(r+delta_r,c+delta_c) == 0 || ...
%                                 mark2(r+delta_r,c+delta_c) == 0)
%                                 
%                             mark3(r+delta_r,c+delta_c) = 1;
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
