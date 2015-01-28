%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_interaction()
%PK_DEFAULT_INTERACTION Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.from = {};
ret.depletes = [];
ret.to = {};
ret.linker = pk_product_linker(1.0);

end