%% License and Manual
% Authors: Baran Bodur and Serdar Aydın
% Code that analyses the flux distribution at the target area after
% measurement

%% Inputs from Labview (should be commented when used in Labview)

x_analysis_from = -10;
x_analysis_to = 20;
y_analysis_from = 30;
y_analysis_to = 50;

%divided_x_pos;
%divided_y_pos;
result_matrix = rand(size(result_matrix,1),size(result_matrix,2));


[minval,x_analysis_from_index] = min((divided_x_pos-x_analysis_from).^2);
[minval,x_analysis_to_index] = min((divided_x_pos-x_analysis_to).^2);
if(x_analysis_from_index > x_analysis_to_index)
    x_analysis_to_index = x_analysis_from_index;
end
x_analysis_from_cor = divided_x_pos(x_analysis_from_index)
x_analysis_to_cor = divided_x_pos(x_analysis_to_index)

[minval,y_analysis_from_index] = min((divided_y_pos-y_analysis_from).^2);
[minval,y_analysis_to_index] = min((divided_y_pos-y_analysis_to).^2);
if(y_analysis_from_index > y_analysis_to_index)
    y_analysis_to_index = y_analysis_from_index;
end
y_analysis_from_cor = divided_y_pos(y_analysis_from_index)
y_analysis_to_cor = divided_y_pos(y_analysis_to_index)


divided_x_pos_analysed = divided_x_pos(x_analysis_from_index:...
    x_analysis_to_index)
divided_y_pos_analysed = divided_y_pos(y_analysis_from_index:...
    y_analysis_to_index)

result_matrix_analysed = result_matrix(y_analysis_from_index:...
    y_analysis_to_index,x_analysis_from_index:x_analysis_to_index)

x_profile_analysed = mean(result_matrix_analysed,1)
y_profile_analysed = mean(result_matrix_analysed,2)'

mean_flux = mean(mean(result_matrix_analysed))
max_flux = max(max(result_matrix_analysed))
min_flux = min(min(result_matrix_analysed))

upper_fluctuation = (max_flux - mean_flux)/mean_flux * 100
lower_fluctuation = (mean_flux - min_flux)/mean_flux * 100

%uncertainty_matrix_analysed = uncertainty_matrix(y_analysis_from_index:...
%    y_analysis_to_index,x_analysis_from_index:x_analysis_to_index);

%max_uncertainty_percentage =
%max(max(uncertainty_matrix_analysed))/mean_flux*100;
