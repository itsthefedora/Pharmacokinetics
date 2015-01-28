%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_tanh_sd_flow(varargin)
%PK_CONSTANT_FLOW Summary of this function goes here
%   Detailed explanation goes here

% Parse parameters

switch nargin

case 0
	center = 0;
	shapeFactor = 1;
	amplitude = 1;
case 1
	center = 0;
	shapeFactor = 1;
	amplitude = varargin{1};
case 2
	center = 0;
	shapeFactor = varargin{2};
	amplitude = varargin{1};
case 3
	center = varargin{3};
	shapeFactor = varargin{2};
	amplitude = varargin{1};

end

% Compute function

ret = @(t, y) amplitude * (1/2) * ( 1 + tanh( ( y(1) - center ) / shapeFactor ) );

end





