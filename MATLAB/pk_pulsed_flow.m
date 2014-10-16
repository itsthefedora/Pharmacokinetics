%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_pulsed_flow(varargin)
%PK_PULSED_FLOW Summary of this function goes here
%   Detailed explanation goes here

switch nargin

case 3
	integral = varargin{1};
	pulseWidth = varargin{2};
	pulseSpacing = varargin{3};

otherwise
	integral = 1;
	pulseWidth = 1 / 60;
	pulseSpacing = 1;

end

pulseFlowRate = integral / pulseWidth;

ret = @(t) (mod(t, pulseSpacing) <= pulseWidth) * pulseFlowRate;

end