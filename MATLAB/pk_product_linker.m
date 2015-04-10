%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_product_linker(k, varargin)
%PK_PRODUCT_LINKER Summary of this function goes here
%   Detailed explanation goes here


ret = @(Avec, t) k * prod(Avec);

end