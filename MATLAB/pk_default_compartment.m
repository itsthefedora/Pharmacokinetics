%=========================================================================%
% Pharmacokinetic Model
% => Default compartment parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_compartment()
%PK_DEFAULT_COMPARTMENT Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.volume = 1;
ret.initialAmount = 0;
ret.displayName = '';

end