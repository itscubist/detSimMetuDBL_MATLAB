% Author: Baran Bodur and Serhan Yılmaz
% Declusters the given pixel matrix according to given parameters:
% neighbouring_degree: 1,2,3
% degree[1,2,3]ToAdiff: How much later than the first hit will be
% accepted for respective neighbouring pixels
function [total_hit, ToT_center, degree1_ToAdist, degree2_ToAdist,...
    degree3_ToAdist,early_pixels] = decluster5(ToT,ToA,neighbouring_degree,...
    degree1_ToAdiff,degree2_ToAdiff,degree3_ToAdiff,shutter_time,...
    row_size, column_size,intr_column_size,intr_row_size, ...
    obtain_clustering_statistics)


% Initializations
ToT_center = zeros(row_size,column_size);
complete_mark = zeros(row_size,column_size);
early_count = 0;
early_pixels = zeros(row_size,column_size);
total_hit = 0;
% For obtaining clustering statistics
degree1_ToAdist = [];
degree2_ToAdist = [];
degree3_ToAdist = [];

% Get all ToA's in 1D array

% ToA_1D = TwotoOneD(ToA);
% ToA_1D = [sort(ToA_1D(ToA_1D>0))]; % 1D ToA array with single 0
% ToA_1D = unique(ToA_1D,'first');

ToA_1D = reshape(ToA, [1, size(ToA,1) * size(ToA,2)]);
ToA_1D_I = 1:length(ToA_1D);
ind = ToA_1D > 0;
ToA_1D = ToA_1D(ind);
ToA_1D_I = ToA_1D_I(ind);
[ToA_1D_U, ~, ToA_1D_V] = unique(ToA_1D);
[ToA_1D_S,ia] = sort(ToA_1D_V,'ascend');
[counts] = hist(ToA_1D_V, (1:length(ToA_1D_U)));
cum = cumsum(counts);
left = zeros(size(ToA_1D_U));
left(1) = 1;
left(2:end) = cum(1:(end - 1)) + 1;
right = cum;


for time = 1:1:length(ToA_1D_U)
    %pixels_that_time = find((ToA == ToA_1D(time)));% & (complete_mark == 0)));
    pixels_that_time = ToA_1D_I(ia(left(time):right(time)));

    
    for i = 1:1:length(pixels_that_time)
        c = ceil(pixels_that_time(i)/row_size);
        r = mod(pixels_that_time(i)-1,row_size) + 1;
        %if (r == 0)
        %    r = row_size;
        %end
        if(~complete_mark(r,c))
            if((ToA(r,c) < 2) && (ToA(r,c) > 0))
                early_count = early_count + 1;
                early_mark = 1;
                early_pixels(r,c) = 1;
            else
                early_mark = 0;
            end
            total_hit = total_hit + 1;
            rToT = r;
            cToT = c;
            ToT_prev = ToT(r,c);
            ToT_sum = ToT_prev;
            complete_mark(r,c) = 1; % Mark not to return to this pixel
            % Decluster Neighbouring Pixels
            frame_no_r = floor((r-1)/intr_row_size);
            frame_no_c = floor((c-1)/intr_column_size);
            for dr = -neighbouring_degree:1:neighbouring_degree
                for dc = -neighbouring_degree:1:neighbouring_degree

                    % Make sure not to pass chip's borders
                    if( ((r+dr)>(intr_row_size*frame_no_r)) && ...
                            ((r+dr-1)<(intr_row_size*(frame_no_r+1)))...
                            && ((c+dc)>(intr_column_size*frame_no_c))...
                            && ((c+dc-1)<(intr_column_size*(frame_no_c+1))))
                        if(abs(dr)<=1 && abs(dc)<=1 && (dc||dr)) % 1st degree
                            if(((ToA(r,c)+degree1_ToAdiff) >= ...
                                    ToA(r+dr,c+dc)) && (ToA(r,c) ...
                                    <= ToA(r+dr,c+dc))) %Check ToA
                                complete_mark(r+dr,c+dc) = 1;
                                ToT_sum = ToT_sum + ToT(r+dr,c+dc);
                                if(ToT(r+dr,c+dc) > ToT_prev)
                                    ToT_prev = ToT(r+dr,c+dc);
                                    rToT = r+dr;
                                    cToT = c+dc;
                                end
%                                 if(obtain_clustering_statistics)
%                                     disp('1')
%                                     degree1_ToAdist = [degree1_ToAdist,...
%                                         (ToA(r+dr,c+dc) - ToA(r,c))];
%                                 end
                                if(early_mark)
                                    early_pixels(r+dr,c+dc) = 1;
                                end
                            end
                        elseif(abs(dr)<=2 && abs(dc)<=2 && (dc||dr)) % 2nd degree
                            if((ToA(r,c)+degree2_ToAdiff) >= ...
                                    ToA(r+dr,c+dc) && (ToA(r,c) ...
                                    <= ToA(r+dr,c+dc))) %Check ToA
                                complete_mark(r+dr,c+dc) = 1;
                                ToT_sum = ToT_sum + ToT(r+dr,c+dc);  
                                
%                                 if(obtain_clustering_statistics)
%                                     disp('2')
%                                     degree2_ToAdist = [degree2_ToAdist,...
%                                         (ToA(r+dr,c+dc) - ToA(r,c))];
%                                 end

                                if(ToT(r+dr,c+dc) > ToT_prev)
                                    ToT_prev = ToT(r+dr,c+dc);
                                    rToT = r+dr;
                                    cToT = c+dc;
                                end
                       
                                if(early_mark)
                                    early_pixels(r+dr,c+dc) = 1;
                                end
                            end
                        elseif(abs(dr)<=3 && abs(dc)<=3 && (dc||dr)) % 3rd degree
                            if((ToA(r,c)+degree3_ToAdiff) >= ...
                                    ToA(r+dr,c+dc) && (ToA(r,c) ...
                                    <= ToA(r+dr,c+dc))) %Check ToA
                                complete_mark(r+dr,c+dc) = 1;
                                ToT_sum = ToT_sum + ToT(r+dr,c+dc);
                                if(ToT(r+dr,c+dc) > ToT_prev)
                                    ToT_prev = ToT(r+dr,c+dc);
                                    rToT = r+dr;
                                    cToT = c+dc;
                                end
%                                 if(obtain_clustering_statistics)
%                                     disp('3')
%                                     degree3_ToAdist = [degree3_ToAdist,...
%                                         (ToA(r+dr,c+dc) - ToA(r,c))];
%                                 end
                                if(early_mark)
                                    early_pixels(r+dr,c+dc) = 1;
                                end
                            end
                        end
                    end

                end
            end


            ToT_center(rToT,cToT) = ToT_sum; % No diffusion ToT
            %ToT_center(r,c) = 1;
        end
    end

    end
%end
    early_count
    %total_hit = sum(sum(ToT_center>0)) - early_count; % Real Hit Count
    total_hit = total_hit - early_count;
    %occupancy = sum(sum(ToT>0))/total_hit; % CountedHits/RealHits
end   
