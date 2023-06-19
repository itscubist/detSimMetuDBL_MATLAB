%% License and Manual
% Author: Baran Bodur
% Takes input from Labview user interface and determines positions to move
% respectively for a measurement (for Tpx3 and diamond)

%% Inputs (should be commented when feeded from Labview directly)

% User entered to Labview (in mm) (Detector center)
from_x = -110;
to_x = 80;
from_y = -110;
to_y = 200;
skip1 = 0; % skip measurement at a point if 1, not if 0
ordering = 4; % 1 for top-first, 2 for left-first, 3 for bottom-first,
% 4 for right-first, 5 for center-first (spiral outward)
row_divide = 8; % row_division of tpx3 chip (only for tpx3, 1 for diamond)
column_divide = 8; % column_division of tpx3 chip (only for tpx3, 1 for diamond)
% bin_size = 10 % user entered for diamond (commented for tpx3)
% covering_ratio = bin_size^2/(1.5^2*pi) % calculated for diamond (commented for tpx3)

% Constants from Labview (might be different for different detectors)
max_x = 100; % max possible x
min_x = -100; % min possible x
max_y = 100; % max possible y
min_y = -100; % min possible y
bin_size = 14.1; % Dimension of chip

%% Find positions to stop and stay within limits
% Check whether from_x is within limits and correct
if(from_x > max_x)
    from_x = max_x;
elseif(from_x < min_x)
    from_x = min_x;
end
% Check whether to_x is within limits and correct
if(to_x > max_x)
    to_x = max_x;
elseif(to_x < min_x)
    to_x = min_x;
end
% Create x positions according to bin_size
x_pos = from_x;
cur_x = from_x;
while(x_pos(end) < to_x)
    cur_x = cur_x + bin_size;
    x_pos = [x_pos,cur_x];
end
% Check whether last element of x_pos is within the limits
if(x_pos(end) > max_x)
    x_pos = x_pos(1:(end-1));
end

% Check whether from_y is within limits and correct
if(from_y > max_y)
    from_y = max_y;
elseif(from_y < min_y)
    from_y = min_y;
end
% Check whether to_y is within limits and correct
if(to_y > max_y)
    to_y = max_y;
elseif(to_y < min_y)
    to_y = min_y;
end
% Create x positions according to bin_size
y_pos = from_y;
cur_y = from_y;
while(y_pos(end) < to_y)
    cur_y = cur_y + bin_size;
    y_pos = [y_pos,cur_y];
end
% Check whether last element of x_pos is within the limits
if(y_pos(end) > max_y)
    y_pos = y_pos(1:(end-1));
end
% Give the arranged positions back
from_x_cor = x_pos(1)
to_x_cor = x_pos(end)
from_y_cor = y_pos(1)
to_y_cor = y_pos(end)

x_pos;
y_pos;
nx = length(x_pos);
ny = length(y_pos);
result_matrix = zeros((row_divide*ny),(column_divide*nx));

%%
sub_x_size = bin_size/column_divide;
sub_y_size = bin_size/row_divide;
divided_x_pos = linspace((x_pos(1) - bin_size/2 + sub_x_size/2),...
    (x_pos(end) + bin_size/2 - sub_x_size/2),(column_divide*nx));
divided_y_pos = linspace((y_pos(1) - bin_size/2 + sub_y_size/2),...
    (y_pos(end) + bin_size/2 - sub_y_size/2),(column_divide*ny));

%% Find the path according to given ordering
x_order_pos = []; % Initialize path arrays
y_order_pos = [];
asc_x_pos = sort(x_pos,'ascend'); % Order arrays to use later
des_x_pos = sort(x_pos,'descend');
asc_y_pos = sort(y_pos,'ascend');
des_y_pos = sort(y_pos,'descend');
if(ordering == 1)
    for i = 1:1:ny
        if(mod(i,2))
            x_order_pos = [x_order_pos, des_x_pos];
        else
            x_order_pos = [x_order_pos,asc_x_pos];
        end
        y_order_pos = [y_order_pos, des_y_pos(i)*ones(1,nx)];
    end
elseif(ordering == 2)
    for i = 1:1:nx
        if(mod(i,2))
            y_order_pos = [y_order_pos, des_y_pos];
        else
            y_order_pos = [y_order_pos,asc_y_pos];
        end
        x_order_pos = [x_order_pos, des_x_pos(i)*ones(1,ny)];
    end
elseif(ordering == 3)
    for i = 1:1:ny
        if(mod(i,2))
            x_order_pos = [x_order_pos, asc_x_pos];
        else
            x_order_pos = [x_order_pos,des_x_pos];
        end
        y_order_pos = [y_order_pos, asc_y_pos(i)*ones(1,nx)];
    end
elseif(ordering == 4)
    for i = 1:1:nx
        if(mod(i,2))
            y_order_pos = [y_order_pos, asc_y_pos];
        else
            y_order_pos = [y_order_pos,des_y_pos];
        end
        x_order_pos = [x_order_pos, asc_x_pos(i)*ones(1,ny)];
    end
elseif(ordering == 5)
%     x_center_index = round(nx/2);
%     y_center_index = round(ny/2);
%     for i = 1:1:(nx+ny-1)
%         
%     end
end
if(skip1)
    x_order_pos = x_order_pos(logical(mod(1:1:(nx*ny),2)));
    y_order_pos = y_order_pos(logical(mod(1:1:(nx*ny),2)));
end
l_x_order_pos = length(x_order_pos);
l_y_order_pos = length(y_order_pos);
x_order_pos;
y_order_pos;
plot(-x_order_pos,y_order_pos)