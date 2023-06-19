%% License and Manual
% Authors: Baran Bodur and Serdar Aydın
% A script to evaluate diamond detector measurements obtained with a
% 1 GHz ADC and find out flux even in high pile-up situations

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
low_flux_cal = 0; % Finds area under a single pulse
high_flux_meas = 1;
limit_pulse_with_max_time = 1; % Assumes signals larger than 
                          %max_signal_time as pile-up and rejects them
use_average_maximum = 1; % Use average of several minima instead of one

% Low Flux Calibration Parameters
threshold = 1000; % in ADC codes
max_signal_time = 12; % max signal time

% High Flux Measurement Parameters
number_of_maxima_tocheck = 1;


%% Obtain Data

filename = '';

ADC_data_all = dlmread(filename);
ADC_data = ADC_data(:,1);

% Data Parameters
mean_data = mean(ADC_data)
length_data = length(ADC_data);
% ADC Data in Voltage
%ADC_V_data = 

%% Calibrate with Low Flux
if(low_flux_cal)
    pulse_length = []; %Records length of pulses
    pulse_area = []; % Records area of pulses
    temp_pulse_length = 0;
    temp_pulse_area = 0;
    signal_started = 0; %flag
    for i = 3:1:length_data
        if(ADC_data(i) < (mean_data - threshold))
        	signal_started = 1;
            temp_pulse_length = temp_pulse_length + 1;
            temp_pulse_area = temp_pulse_area + (ADC_data(i) - mean_data);
        elseif(signal_started)
            pulse_length = [pulse_length, temp_pulse_length];
            pulse_area = [pulse_area, temp_pulse_area];
            temp_pulse_length = 0;
            temp_pulse_area = 0;
            signal_started = 0;
        end
    end
    
    if(limit_pulse_with_max_time)
        pulse_length = pulse_length(pulse_length<=max_signal_time);
        pulse_area = pulse_area(pulse_area<=max_signal_time);
    end
    pulse_area = -1 * pulse_area;
    valid_count = length(pulse_length)
    figure(1)
    hist(pulse_area)
    title('Histogram of Pulse Areas (Code * ns)')
    figure(2)
    hist(pulse_length)
    title('Histogram of Pulse Length (ns)')
    

    % Choose the pulse area after performing this analysis, and enter it below
    % or choose it as mean of the measured ones
    % The correctness of this parameter is crucial for the Pile-up measurements
    ave_pulse_area = mean(pulse_area);
end
%% Measure Flux in Situations with Pile-Up
if(high_flux_meas)
    sorted_data = sort(ADC_data);
    maxima_array = sorted_data((end-number_of_maxima_tocheck):end);
    maxima_average = mean(maxima_array); % Average maxima of 
    integral_through_DC_ave = maxima_average*length_data; % ns*Code
    ADC_data_with_DCave = ADC_data - maxima_average; % Data with DC
    integral_through_sum = -1*sum(ADC_data_with_DC_ave); % ns*Code
    count_through_DCave = integral_through_DCave/ave_pulse_area;
    count_through_sum = integral_through_sum/ave_pulse_area;
    flux_through_DCave = count_through_DCave/(area*length_data*10^-9)
    flux_through_sum = count_through_DCave/(area*length_data*10^-9)
    staterror_through_DCave = sqrt(count_through_DCave)/(area*length_data*10^-9)
    staterror_through_sum = sqrt(count_through_sum)/(area*length_data*10^-9)
end
