function [data_in_years] = days2years(data_in_days, day)
% Initializations
k = 1;
count_in_year = 0;
data_in_years = [];

for i = 1:1:length(data_in_days)
    if(data_in_days(i) == 1)
        count_in_year = count_in_year + 1;
    end
    if(mod(i,day) == 0 )%|| i == length(data_in_days))
        data_in_years(k) = count_in_year;
        k = k + 1;
        count_in_year = 0;
    end    
end

end