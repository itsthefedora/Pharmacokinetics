%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_sdinput()
%PK_DEFAULT_SDINPUT Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.input = { '' };
ret.target = '';
ret.flow = pk_tanh_sd_flow( );

end