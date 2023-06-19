% A function that gives information about how many times a signal
% passed a threshold and how long

% Enter threshold value, input signal and simulation step so the output
% could be in terms of real time
function [tot,binary_data] = time_over_threshold(threshold, input, step)
    
    binary_data = zeros(1, length(input));
    j = 1;
    tot = [0];
    for i = 1:1:length(input)
       if( input(i) >= threshold)
           binary_data(i) = 1;
           tot(j) = tot(j)+1;
       elseif ( (i>1) && (binary_data(i-1) == 1) )
           j = j + 1;
           tot(j) = 0;
       end       
    end
    if(tot(j) == 0)
        tot = tot(1:(end-1));
    end
    tot = tot*step;
end