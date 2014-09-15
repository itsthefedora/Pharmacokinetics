%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_connection()
%PK_DEFAULT_CONNECTION Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.from = '';
ret.to = '';
ret.linker = pk_linear_linker(1.0);

end