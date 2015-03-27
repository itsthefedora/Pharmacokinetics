%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_product_mm_linker(k, params)
%PK_PRODUCT_MM_LINKER Summary of this function goes here
%   Detailed explanation goes here

ret = @(Avec, t) k * prod( Avec(~params.isMM) ) * ...
    prod( params.Vmax .* Avec(params.isMM) ./ (params.Km + Avec(params.isMM)) );

end