% A function to calculate energy loss PDF of particles passing through
% matter (Its mean should give Bethe-Bloch equation approximately)
%%%%%%% INPUTS %%%%%%
% p_charge : particle charge in terms of magnitude of electron charge
% p_mass : particle mass in MeV/c^2
% p_beta : particle velocity/speed of light
% m_Z : material atomic number
% m_A : material nucleon number
% m_density : material density in g/cm^3
% m_meanIE : material mean ionization energy (That is usually hard to find
    % check pdg database) in eV
% m_thick : thickness of material in terms of micrometers

function [energy_loss_pdf, index] = energy_loss_dist(p_charge, p_mass, p_beta, ...
    m_Z, m_A, m_density, m_meanIE, m_thick)

% Definition of constants
K = 0.307075; % Constant with units MeV*cm^2/g (e_mass*classical_e_rad*4pi
    % *avogadros_constant/(1g/mol (unit A))
c = 299792458; % speed of light in m/s
e_mass = 0.511; % mass of electron in terms of MeV/c^2

% Useful values
p_gamma = 1/sqrt(1-p_beta^2); % gamma of particle
ksi = 0.5 * K * m_density * p_charge^2 * m_Z / m_A...
    * (m_thick*10^-4)/p_beta^2; % Units of MeV
delta_p = ksi * ( log(2*e_mass*10^6*p_beta^2*p_gamma^2/m_meanIE)...
    +log(ksi*10^6/m_meanIE) - p_beta^2 + 0.2); % Most probable energy loss
    % for the given material and thickness
width = 4 * ksi; % The FWHM of the distribution

% Create a meaningful index
index = -1.5*width+delta_p:delta_p/100:6*width+delta_p;
energy_loss_pdf = landau_dist(index,delta_p,width);

end