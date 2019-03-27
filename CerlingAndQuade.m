function output = CerlingAndQuade(z,z_star,D,R0)
% This is the analytical solution of the steady state diffusion reaction 
% equation derived in Cerling and Quade (1993), with the assumption of
% exponential decrease of reaction rate.
% z represents the soil depth(s) outputed from this function (can be both number and vector, cm)
% z_star represents the characteristic production depth of C02 in the soil (cm)
% D represents the diffusivity of CO2 (cm2/s)
% R0 represents the respiration rate at the surface of the soil (ug-C/cm3/s)

% Calculation
porosity = 0.4; % Assume a porosity value
output = R0*z_star^2/(D*porosity)*(1-exp(-z/z_star)); % Output in ug-C/cm3
% Unit conversion from ug-C/cm3 to ppm
output = output/12*24.4*1000 + 400; % ppm in soil pores (BC: 400 ppm at the surface)
end