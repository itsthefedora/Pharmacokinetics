%=========================================================================%
% Pharmacokinetic Model
% => Default connection parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [ret] = pk_default_model_2ts()
%PK_DEFAULT_MODEL_2TS Summary of this function goes here
%   Detailed explanation goes here

ret = struct;

ret.slow = pk_default_model();
ret.fast = pk_default_model();

ret.slow.timeSpan = [0 365];    % Days
ret.fast.timeSpan = [0 7];      % Hours

ret.fastSpacing = 14;           % Hours


end