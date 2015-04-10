%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_product_tanh_linker(k, varargin)
%PK_PRODUCT_TANH_LINKER Summary of this function goes here
%   Detailed explanation goes here
% Parse parameters

% TODO: Assuming FIRST argument is "regulator".

switch nargin

case 1
	center = 0;
	shapeFactor = 1;
case 2
	center = 0;
	shapeFactor = varargin{1};
case 3
	center = varargin{2};
	shapeFactor = varargin{1};

end

ret = @(Avec, t) k * ( (1/2) * ( 1 + tanh( ( Avec(1) - center ) / shapeFactor ) ) ) ...
		* prod(Avec(2:end));

end