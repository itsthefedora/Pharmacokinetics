%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_constant_flow(varargin)
%PK_CONSTANT_FLOW Summary of this function goes here
%   Detailed explanation goes here

switch nargin

case 0
	rateConst = 1;
	tStart = 0;
	tEnd = [];

case 1
	rateConst = varargin{1};
	tStart = 0;
	tEnd = [];

case 2
	rateConst = varargin{1};
	tStart = 0;
	tEnd = varargin{2};

case 3
	rateConst = varargin{1};
	tStart = varargin{2};
	tEnd = varargin{3};

end

if isempty( tEnd )
	ret = @(t) (t >= tStart) * rateConst;
else
	ret = @(t) (t >= tStart) * (t <= tEnd ) * rateConst;
end

end