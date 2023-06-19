% Author: Baran Bodur
% Function that generates hits according to given flux and creates
% associated clusters according to given clustering statistics
function [ToT,ToA,hit_count,missed_hit] = hitandcluster(hit_ns_pixel,intr_row_size,...
    intr_column_size,row_size,column_size, shutter_length, negative_time, ...
    occupancy_per_degree, degree1ToA_prob, degree2ToA_prob, degree3ToA_prob,...
    sideToT,centerToT,step, neighbouring_degree,max_event)

addpath('/media/cubist/files/all/matlabsaves/my_functions'); % Import
% Find occupancy probabilities
% Deg1
% deg1_occupancy_probs = roots([(8:-1:1),-1*(occupancy_per_degree(1))]);
% for i = 1:1:8
%     if(isreal(deg1_occupancy_probs(i)) && deg1_occupancy_probs(i)>=0)
%         deg1_occupancy_prob = deg1_occupancy_probs(i);
%         break
%     end 
% end
% %Degree2
% deg2_occupancy_probs = roots([(16:-1:1),-1*(occupancy_per_degree(2))]);
% for i = 1:1:16
%     if(isreal(deg2_occupancy_probs(i)) && deg2_occupancy_probs(i)>=0)
%         deg2_occupancy_prob = deg2_occupancy_probs(i);
%         break
%     end 
% end
% %Degree3
% deg3_occupancy_probs = roots([(24:-1:1),-1*(occupancy_per_degree(3))]);
% for i = 1:1:24
%     if(isreal(deg3_occupancy_probs(i)) && deg3_occupancy_probs(i)>=0)
%         deg3_occupancy_prob = deg3_occupancy_probs(i);
%         break
%     end 
% end
% Find occupancy probabilities v2
deg1_occupancy_prob = (occupancy_per_degree(1))/8;
deg2_occupancy_prob = (occupancy_per_degree(2))/16;
deg3_occupancy_prob = (occupancy_per_degree(3))/24;
% Find all index
sideToT_index = 1:1:length(sideToT);
centerToT_index = 1:1:length(centerToT);
degree1ToA_index = 1:1:length(degree1ToA_prob);
degree2ToA_index = 1:1:length(degree2ToA_prob);
degree3ToA_index = 1:1:length(degree3ToA_prob);
% Initialization
ToA = ones(row_size,column_size)*(-1*negative_time-1);
ToT = zeros(row_size,column_size);
candToA = zeros(row_size,column_size);
candToT = zeros(row_size,column_size);
empty_rows = 1:1:row_size;
empty_columns = 1:1:column_size;
row_pdf = (ones(1,length(empty_rows))/row_size);
column_pdf = (ones(1,length(empty_columns))/column_size);

hit_count = 0;
total_count = 0;
old_total_count = 1;
missed_hit = 0;
%whole_r = [];
%whole_c = [];

% Possible hits per chip in a step
hit_ns_chip = row_size*column_size*hit_ns_pixel;
[probabilities, events] = poisson_probabilities...
   (hit_ns_chip, step, max_event); % Choose max event wisely
max_array = max_event*(negative_time + shutter_length)/step;
r_array = pdf_event_generator(empty_rows,row_pdf,max_array);
c_array = pdf_event_generator(empty_columns,column_pdf,max_array);

for time = (-1*negative_time):step:shutter_length
    events_at_time  = pdf_event_generator(events, probabilities, 1);
    total_count = total_count + events_at_time;
    if(events_at_time)      
        if(time > 0 && time < shutter_length)
            hit_count = hit_count + events_at_time;
        end
        for i = old_total_count:1:total_count
            r = r_array(i);
            c = c_array(i);
            missed_flag = 1*(time>0);
            candToA(r,c) = time;
            % Small assumption: ToT_center always on the min_ToA
            % not used in flux measurement anyway
            candToT(r,c) = pdf_event_generator(centerToT_index,...
                centerToT,1);
            % Stop recording particles in a pixel only if a hit recorded
            if ((candToA(r,c) + 25*candToT(r,c)) > 0 && ToA(r,c) == ...
                    (-1*negative_time-1))
                ToA(r,c) = candToA(r,c);
                ToT(r,c) = candToT(r,c);
                missed_flag = 0;
            end
            % To know chip boundaries
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
                            if( rand(1) < deg1_occupancy_prob)
                                
                                % Select the neighbour ToA
                                candToA(r+dr,c+dc) = candToA(r,c) + (-1 +...
                                    pdf_event_generator(...
                                    degree1ToA_index,degree1ToA_prob,1));
                                % Select a side ToT
                                candToT(r+dr,c+dc) = pdf_event_generator...
                                    (sideToT_index,sideToT,1);
                                if ((candToA(r+dr,c+dc) + 25*candToT(r+dr,...
                                        c+dc))>0 && ToA(r+dr,c+dc) == ...
                                        (-1*negative_time-1))
                                    ToA(r+dr,c+dc) = candToA(r+dr,c+dc);
                                    ToT(r+dr,c+dc) = candToT(r+dr,c+dc);
                                    missed_flag = 0 + 1*(candToA(r+dr,...
                                        c+dc) > shutter_length);
                                end
                            end
                        elseif(abs(dr)<=2 && abs(dc)<=2 && (dc||dr)) % 2nd degree
                            if( rand(1) < deg2_occupancy_prob)
                                % Select the neighbour ToA
                                candToA(r+dr,c+dc) = candToA(r,c) + (-1 +...
                                    pdf_event_generator(...
                                    degree2ToA_index,degree2ToA_prob,1));
                                % Select a side ToT
                                candToT(r+dr,c+dc) = pdf_event_generator...
                                    (sideToT_index,sideToT,1);
                                if ((candToA(r+dr,c+dc) + 25*candToT(r+dr,...
                                        c+dc))>0 && ToA(r+dr,c+dc) == ...
                                        (-1*negative_time-1))
                                    ToA(r+dr,c+dc) = candToA(r+dr,c+dc);
                                    ToT(r+dr,c+dc) = candToT(r+dr,c+dc);
                                    missed_flag = 0 + 1*(candToA(r+dr,...
                                        c+dc) > shutter_length);
                                end
                                
                            end
                        elseif(abs(dr)<=3 && abs(dc)<=3 && (dc||dr)) % 3rd degree
                            if( rand(1) < deg3_occupancy_prob)
                                % Select the neighbour ToA
                                candToA(r+dr,c+dc) = candToA(r,c) + (-1 +...
                                    pdf_event_generator(...
                                    degree3ToA_index,degree3ToA_prob,1));
                                % Select a side ToT
                                candToT(r+dr,c+dc) = pdf_event_generator...
                                    (sideToT_index,sideToT,1);
                                if ((candToA(r+dr,c+dc) + 25*candToT(r+dr,...
                                        c+dc))>0 && ToA(r+dr,c+dc) == ...
                                        (-1*negative_time-1))
                                    ToA(r+dr,c+dc) = candToA(r+dr,c+dc);
                                    ToT(r+dr,c+dc) = candToT(r+dr,c+dc);
                                    missed_flag = 0 + 1*(candToA(r+dr,...
                                        c+dc) > shutter_length);
                                end                              
                            end
                        end
                    end
                end
            end
            if(missed_flag)
                missed_hit = missed_hit + 1;
            end
                
        end
    end
    old_total_count = old_total_count + events_at_time;
end

for r = 1:1:row_size
    for c = 1:1:column_size
        if(ToA(r,c) <= 0)
            if((ToA(r,c) + 25*ToT(r,c)) <= 0)
                ToA(r,c) = 0;
                ToT(r,c) = 0;
            else
                ToT(r,c) = ceil((25*ToT(r,c) + ToA(r,c))/25);
                ToA(r,c) = 1;
            end
        elseif(ToA(r,c) > shutter_length)
            ToA(r,c) = 0;
        end
    end
end

end