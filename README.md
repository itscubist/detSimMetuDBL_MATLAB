# detSimMetuDBL_MATLAB
Detector simulation (Timepix, Diamond Detector...) and analysis code for proton beam uniformity in METU-DBL Radiation Test Facility

This is series of MATLAB codes that simulates response of two detectors to very high proton
fluxes. Then it analyzes the responses and figure out whether detectors can measure the
incoming flux (protons/cm2/s). The goal is to determine the value of flux and its uniformity.
The flux is modified by a specifically designed beamline (METU-DBL), with the goal of
generating a uniform and controllable flux in an area of an A4 paper. This are is used to test
electronics that will go to space for to make sure they can withstand space radiation
conditions.

First detector is a pixaleted silicon detector (very much like a camera) called Timepix.
Second detector is a single pixel detector with very fast time response that is made of
diamond, which we will simply call the diamond detector (But it does not find diamonds...)

Simulations include effects like:
Randomness of energy deposition with Landau and arrival times with Poisson distributions
Estimation of ionized electrons
Their travel time and spread over time due to diffusion: Which results in charge in 1 pixel to
spread to others.
RC time constant to simulate electronic signal shape
Pile-up effects due to a few signals coming on top of each other
Data from alpha particles to check and calibrate above simulations
Digitization and related limitations of the readout of both detectors (ADC or discriminator)


Analysis for flux measurement can be quite complicated and includes:
Statistical corrections for clustering and pile-up
Calibration by alpha sources for obtaining an approximate single particle response
Estimation of the flux and its error at a position
Scanning a large area by moving the detector and patching the measurements together


Directories: 
my_functions: General functions for calculating energy loss of particles in material, creating
electrical signals, poisson and gaussian random variables in time and other utilities...

diamond/diamond_ADC: Code for simulating response of the diamond detector, and analysis code
for extracting flux measurement. The purpose of the simulation is to create the expected signal
beforehand, and make sure analysis can measure the flux correctly. 

timepix_analysis: Code for simulating response of the Timepix detector, and analysis code for
the flux measurement. The purpose of the simulation is to create the expected signal beforehand, and make sure analysis can measure the flux correctly.

For more details on physics, purpose, algorithms and implementation read (in order):
timepix_forfinal.pdf
BaranBodur_METU-DBL_detectors_informal_manual.pdf
