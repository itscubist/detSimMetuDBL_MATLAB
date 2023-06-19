%% License and Manual
% Authors: Baran Bodur and Serdar Aydin
% A script to evaluate diamond detector measurements obtained with a
% 1 GHz ADC and find out flux even in high pile-up situations

addpath('C:\Users\ODTU SDH Kontrol\Desktop\diamond_readout\elmas_kod_veri')
%% Parameters
% ADC Parameters
ADC_sample_step = 1; % ns
ADC_bits = 16;
ADC_max_code = 2^15 - 1;
ADC_min_code = -2^15 - 1;
ADC_max_V = 0.95;
ADC_min_V = -0.95;

% Detector Parameters
area = 0.15 * 0.15 * pi; % in cm2,  Circular with 0.15 cm radius

% Options
measurement_method = 0; % 0: automatic, 1: count pulses, 2: integral/pulse area

% High Flux Measurement Parameters
threshold = 1000; % in ADC codes
max_min_dif_threshold = 1.5; % difference between max and min
measurement_method = 2; % 0: automatic, 1: count pulses, 2: integral/pulse area
threshold = 1000; % in ADC codes
number_of_maxima_tocheck = 1;
ave_pulse_height = 2000;
ave_pulse_length = 11; % in ns
ave_pulse_area = 11*2000; % (Code * ns)



%% Obtain Data

filename = 'SpeedTest2.csv';

ADC_data_all = dlmread(filename);
ADC_data = ADC_data_all(:,1);

% Data Parameters
mean_data = mean(ADC_data)
length_data = length(ADC_data)
max_data = max(ADC_data)
min_data = min(ADC_data)
max_min_difference = abs(max_data-min_data)/ave_pulse_height
if(measurement_method== 0)
    if(max_min_difference < max_min_dif_threshold)
        measurement_method = 1;
    else
        measurement_method = 2;
    end
    
end

% ADC Data in Voltage
%ADC_V_data = 


%% Measure Flux in Situations with Pile-Up
  
        sorted_data = sort(ADC_data);
        maxima_array = sorted_data((end-number_of_maxima_tocheck):end);
        maxima_average = mean(maxima_array); % Average maxima of 
        integral_through_DC_ave = maxima_average*length_data; % ns*Code
        ADC_data_with_DC_ave = ADC_data - maxima_average; % Data with DC
        integral_through_sum = -1*sum(ADC_data_with_DC_ave); % ns*Code
        count_through_DC_ave = integral_through_DC_ave/ave_pulse_area;
        count_through_sum = integral_through_sum/ave_pulse_area;
        flux_through_DC_ave = count_through_DC_ave/(area*length_data*10^-9)
        flux_through_sum = count_through_DC_ave/(area*length_data*10^-9);
        staterror_through_DC_ave = sqrt(count_through_DC_ave)/(area*length_data*10^-9)
        staterror_through_sum = sqrt(count_through_sum)/(area*length_data*10^-9);
%% Measure Flux in situations without too much pile-up 
        % Initializations
        pulse_length = []; %Records length of pulses
        pulse_area = []; % Records area of pulses
        pulse_height = []; % Records
        temp_pulse_length = 0;
        temp_pulse_area = 0;
        signal_started = 0; %flag
        % Pulse counter and pulse property recorder
        for i = 3:1:length_data
            if(ADC_data(i) < (mean_data - threshold))
                signal_started = 1;
                temp_pulse_length = temp_pulse_length + 1;
                temp_pulse_area = temp_pulse_area + (ADC_data(i) - mean_data);
                pulse_height = [pulse_height, (max_data - ADC_data(i))];
            elseif(signal_started)
                pulse_length = [pulse_length, temp_pulse_length];
                pulse_area = [pulse_area, temp_pulse_area];
                temp_pulse_length = 0;
                temp_pulse_area = 0;
                signal_started = 0;
            end
        end
        pulse_count = length(pulse_length)
        if(pulse_count == 0)
            pulse_area_occurances = 0;
            pulse_area_index = 0;
            mean_pulse_area = 0;
            pulse_length_occurances = 0;
            pulse_length_index = 0;
            mean_pulse_length = 0;
            pulse_height_occurances = 0;
            pulse_height_index = 0;
            mean_pulse_height = 0;
            flux_through_count = 0
            staterror_through_count = 0
            
        else
            %Pulse area
            pulse_area = -1 * pulse_area;
            pulse_area_index = 0:100:100000;
            pulse_arae_occurances = hist(pulse_area,pulse_area_index);
            mean_pulse_area = mean(pulse_area)
            % Pulse length
            pulse_length_index = 0:1:100;
            mean_pulse_length = mean(pulse_length)
            pulse_length_occurances = hist(pulse_length,pulse_length_index);
            % Pulse height
            pulse_height_index = 0:100:30000;
            mean_pulse_height = mean(pulse_height)
            pulse_height_occurances = hist(pulse_height,pulse_height_index);
            % A simple correction valid for low pile-up
            syms x;
            rate_corrected = double(vpasolve((pulse_count/length_data) == ...
                x*exp(-1*x*mean_pulse_length),x));
        
            flux_through_count = rate*10^9/area
            staterror_through_count = sqrt(rate*length_data)*10^9/(length_data*area)
        end
        if(measurement_method == 2)
            flux = flux_through_DC_ave
            error = staterror_through_DC_ave
        elseif(measurement_method == 1)
            flux = flux_through_count
            error = staterror_through_count
        end


