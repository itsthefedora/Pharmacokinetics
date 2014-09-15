%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_input()
%PK_DEFAULT_CONNECTION Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.target = '';
ret.flow = pk_constant_flow( 1.0 );

end