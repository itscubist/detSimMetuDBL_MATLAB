% Author: Baran Bodur and Serhan Yılmaz
% Obtain sub-detector resolution

function [sub_hits,error_sub_hits] = sub_hit(intr_row_size,intr_column_size,...
    row_size,column_size,ToT_center,row_divide,column_divide,early_pixels)


row_frame_no = row_size/intr_row_size; % Find number of frames
column_frame_no = column_size/intr_column_size; % Find number of frames
row_sub_size = intr_row_size/row_divide;
column_sub_size = intr_column_size/column_divide;

sub_hits = zeros(row_divide,column_divide); % Create hit matrix in given size
% sub_hits2 = zeros(row_divide,column_divide); % Create hit matrix in given size
% sub_mask = zeros(row_divide,column_divide); % Create hit mask
% intr_matrix = ones(row_sub_size,column_sub_size);

row_indices = repmat((((1:row_frame_no) - 1) * intr_row_size)' , 1,row_sub_size) + repmat((1:row_sub_size),row_frame_no,1);
row_indices = reshape(row_indices, [1 size(row_indices,1) * size(row_indices,2)]);
column_indices = repmat((((1:column_frame_no) - 1) * intr_column_size)',1,column_sub_size) + repmat((1:column_sub_size),column_frame_no,1);
column_indices = reshape(column_indices, [1 size(column_indices,1) * size(column_indices,2)]);
hits = (ToT_center > 0 & (~early_pixels));

for rd = 1:1:row_divide
    for cd = 1:1:column_divide
        row_indices_updated = row_indices + (rd - 1) * row_sub_size;
        column_indices_updated = column_indices + (cd - 1) * column_sub_size;
        sub_hits(rd,cd) = sum(sum(hits(row_indices_updated,column_indices_updated)));
    end
end

% for rd = 1:1:row_divide
%     for cd = 1:1:column_divide
%         sub_mask(rd,cd) = 1; % Make considered part one only
%         % Kronecker product for obtaining physical pixels
%         intr_mask = kron(sub_mask,intr_matrix);
%         % Mask for all pixels (physical and virtual)
%         full_mask = repmat(intr_mask,row_frame_no,column_frame_no);
%         % Count the hits in given mask and save to sub_hit matrix
%         sub_hits(rd,cd) = sum(sum((((ToT_center>0) & full_mask & (~early_pixels)))));
%         sub_mask(rd,cd) = 0; % Reset mask for next operation
%     end
% end
error_sub_hits = sqrt(sub_hits);
% if(sum(sum(sub_hits2 ~= sub_hits)) > 0)
%    error('WOOOOW'); 
% end
end