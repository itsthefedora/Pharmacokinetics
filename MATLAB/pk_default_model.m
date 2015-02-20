%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_model()
%PK_DEFAULT_MODEL Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.timeSpan = [0 10];
ret.maxStep = 0.1;

% TODO: Necessary?
ret.analyticType = '';
ret.analyticParameters = struct;

ret.constants = struct;

ret.compartments = struct;
ret.connections = { };
ret.inputs = { };
ret.sdinputs = { };
ret.interactions = { };

end