%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_mm_linker(Km, Vmax)
%PK_MM_LINKER Summary of this function goes here
%   Detailed explanation goes here

ret = @(Ain) Vmax .* ( Ain ./ ( Km + Ain ) );

end