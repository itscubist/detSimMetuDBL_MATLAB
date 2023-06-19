% A function that selects values from two independent uniform PMFs with
% given values

function [selected_x, selected_y] = uniform_event_generator_2d(x_index, ...
    y_index, number)
    % Creating
    x_pdf = vpa((ones(1,length(x_index))*1/length(x_index)),6);
    y_pdf = vpa((ones(1,length(y_index))* 1/length(y_index)),6);
    selected_x = pdf_event_generator(x_index,x_pdf,number);
    selected_y = pdf_event_generator(y_index,y_pdf,number);
end