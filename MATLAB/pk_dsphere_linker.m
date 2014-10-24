%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_dsphere_linker(kD, rho, r0, M0)
%PK_DSPHERE_LINKER Summary of this function goes here
%   Detailed explanation goes here

ret = @(Ain) (Ain > 0) * (4/3) * (kD/(rho * r0)) * (M0 * Ain * Ain)^(1/3);

end