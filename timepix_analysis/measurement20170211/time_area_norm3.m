% Author: Baran Bodur and Serhan Yılmaz
% Obtain sub-detector flux divider resolution

function [flux_divider] = time_area_norm2(ToT,ToA,shutter_length,row_size,...
    column_size,ToA_format, pixel_area,clock_to_ns,timing_downsample_on,...
    downsampling_ratio,row_divide, column_divide, intr_row_size, ...
    intr_column_size,early_pixels)



row_frame_no = row_size/intr_row_size; % Find number of frames
column_frame_no = column_size/intr_column_size; % Find number of frames
row_sub_size = intr_row_size/row_divide;
column_sub_size = intr_column_size/column_divide;

flux_divider = zeros(row_divide,column_divide); % Create hit matrix in given size
% sub_mask = zeros(row_divide,column_divide); % Create hit mask
% intr_matrix = ones(row_sub_size,column_sub_size);

row_indices = repmat((((1:row_frame_no) - 1) * intr_row_size)' , 1,row_sub_size) + repmat((1:row_sub_size),row_frame_no,1);
row_indices = reshape(row_indices, [1 size(row_indices,1) * size(row_indices,2)]);
column_indices = repmat((((1:column_frame_no) - 1) * intr_column_size)',1,column_sub_size) + repmat((1:column_sub_size),column_frame_no,1);
column_indices = reshape(column_indices, [1 size(column_indices,1) * size(column_indices,2)]);
% hits = (ToT_center > 0 & (~early_pixels));
meas_time_pixel = ToA;
meas_time_pixel(meas_time_pixel==0) = shutter_length;
meas_time_pixel(early_pixels==1) = 0;

for rd = 1:1:row_divide
    for cd = 1:1:column_divide
        row_indices_updated = row_indices + (rd - 1) * row_sub_size;
        column_indices_updated = column_indices + (cd - 1) * column_sub_size;
        flux_divider(rd,cd) = sum(sum(meas_time_pixel(row_indices_updated,column_indices_updated)));
    end
end

%meas_time_pixel = meas_time_pixel + 25*mean(mean(ToT(ToT>0)));
% for rd = 1:1:row_divide
%     for cd = 1:1:column_divide
%         sub_mask(rd,cd) = 1; % Make considered part one only
%         % Kronecker product for obtaining physical pixels
%         intr_mask = kron(sub_mask,intr_matrix);
%         % Mask for all pixels (physical and virtual)
%         full_mask = repmat(intr_mask,row_frame_no,column_frame_no);
%         % Measurement Time for Pixels with Hit After 2 ns
%         meas_time_part = meas_time_pixel;
%         meas_time_part((early_pixels==1 | full_mask==0 )) = 0;
%         flux_divider(rd,cd) = sum(sum(meas_time_part));
%         
%         % Measurement Time for Non-Hitten Pixels
% %         flux_divider(rd,cd) = flux_divider(rd,cd) + shutter_length ...
% %             * sum(sum((ToA==0 & full_mask==1 & early_pixels==0)));
%         % Subtract unmeasured time
% %         flux_divider(rd,cd) = flux_divider(rd,cd) - ...
% %             row_size*column_size*8;
%             
%         sub_mask(rd,cd) = 0; % Reset mask for next operation
%     end
% end
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