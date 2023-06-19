% Author: Baran Bodur
% Obtain sub-detector resolution

function [sub_hits,error_sub_hits] = sub_hit(intr_row_size,intr_column_size,...
    row_size,column_size,ToT_center,row_divide,column_divide,early_pixels)

row_frame_no = row_size/intr_row_size; % Find number of frames
column_frame_no = column_size/intr_column_size; % Find number of frames
sub_hits = zeros(row_divide,column_divide); % Create hit matrix in given size
sub_mask = zeros(row_divide,column_divide); % Create hit mask
intr_matrix = ones(intr_row_size/row_divide,intr_column_size/column_divide);
for rd = 1:1:row_divide
    for cd = 1:1:column_divide
        sub_mask(rd,cd) = 1; % Make considered part one only
        % Kronecker product for obtaining physical pixels
        intr_mask = kron(sub_mask,intr_matrix);
        % Mask for all pixels (physical and virtual)
        full_mask = repmat(intr_mask,row_frame_no,column_frame_no);
        % Count the hits in given mask and save to sub_hit matrix
        sub_hits(rd,cd) = sum(sum((((ToT_center>0) & full_mask & (~early_pixels)))));
        sub_mask(rd,cd) = 0; % Reset mask for next operation
    end
end
error_sub_hits = sqrt(sub_hits);
end