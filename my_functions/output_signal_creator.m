% Function that creates a signal, from input particle pulses

function output_signal_cell = output_signal_creator(shared_charge_cell, ...
    time, sim_step)
    [pixel_number_x, pixel_number_y] = size(shared_charge_cell);
    output_signal_cell = cell(pixel_number_x,pixel_number_y);
    
    for i = 1:1:pixel_number_x
        for j = 1:1:pixel_number_y
            output_signal_cell{i,j} = zeros(1,length(time));
        end
    end
 
    for i = 1:1:pixel_number_x
        for j = 1:1:pixel_number_y
            for t = 1:1:length(time)
                created_electrons = shared_charge_cell{i,j}(t) ;
                if (created_electrons > 0)
                    temp_signal = zeros(1,length(time));
                    temp_signal(t) = 1;
                    pulse_width =  24*log(created_electrons);
                    selected_pulse = landau_pulse(created_electrons, ...
                       pulse_width , 0, sim_step);
                    output_signal_cell{i,j} = output_signal_cell{i,j}...
                       + conv(temp_signal,selected_pulse,'same');
                end
            end
        end
    end
    
end