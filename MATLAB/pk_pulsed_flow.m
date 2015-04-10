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
	nPulses = -1;
    tOffset = 0;

case 4
	integral = varargin{1};
	pulseWidth = varargin{2};
	pulseSpacing = varargin{3};
	nPulses = varargin{4};
    tOffset = 0;

case 5
	integral = varargin{1};
	pulseWidth = varargin{2};
	pulseSpacing = varargin{3};
	nPulses = varargin{4};
    tOffset = varargin{5};

otherwise
	integral = 1;
	pulseWidth = 1 / 60;
	pulseSpacing = 1;
	nPulses = -1;
    tOffset = 0;

end

pulseFlowRate = integral / pulseWidth;

ret = @(t) ( ( nPulses == -1 ) || ( floor(t / pulseSpacing) < nPulses ) ) * ...
	(mod((t-tOffset), pulseSpacing) <= pulseWidth) * pulseFlowRate;

end