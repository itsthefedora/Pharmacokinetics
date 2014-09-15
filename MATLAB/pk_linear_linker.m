%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_linear_linker(rateConst)
%PK_LINEAR_LINKER Summary of this function goes here
%   Detailed explanation goes here

ret = @(Ain) rateConst * Ain;

end