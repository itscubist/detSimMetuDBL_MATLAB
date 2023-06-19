% Creates the PDF of Landau Distribution (approximately)
% Input a number or array, most probable value of
% the Landau distribution and its FWHM, get probabitity of given value
function landau_pdf = landau_dist(landau_index,MPV,FWHM)
    % FWHM adjusted by rationing
    FWHM_original = 3.65;
    FWHM_ratio = FWHM / FWHM_original;
    % Approximate Landau Dist
    landau_pdf  = 1/sqrt(2*pi)*exp(-0.5*((landau_index-MPV)/FWHM_ratio...
        + exp(-(landau_index-MPV)/FWHM_ratio)));
    landau_pdf = landau_pdf / sum(landau_pdf); % Normalizing
end