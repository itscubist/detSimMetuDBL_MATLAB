% Function that calculates drift time of electrons under some voltage, with
% given length that voltage is applied and length that electrons are
% supposed to drift
% Voltage: in V
% Electron mobility: in um^2/(ns*V)
% Voltage & Drift Length = in um

function drift_time = electron_drift_time(electron_mobility, voltage,voltage_length, ...
    drift_length)
    electric_field = voltage/voltage_length;
    electron_speed = electron_mobility* electric_field;
    drift_time = drift_length/electron_speed;
end