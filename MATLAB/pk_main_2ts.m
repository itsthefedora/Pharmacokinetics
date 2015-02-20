%=========================================================================%
% Pharmacokinetic Model
% => Main entry point, two-timescale.
% 
% [Authors]
% Spring 2015
%=========================================================================%

function [tResult, yResult, tResultFast, yResultFastvf] = pk_main_2ts( input_args )
%PK_MAIN_2TS Summary of this function goes here

%% Initialization

% Deal with MATLAB's crappy environment handling
clear functions;
addpath( pwd( ) );

% Parameter defaults
doPlots = true;

% Parse input arguments
switch length(varargin)
    
    case 0
        %
    
    case 1
        doPlots = varargin{1};
        
    otherwise
        error('Invalid number of arguments!');
    
end


%% Set-up models

% Generate default models
model = pk_default_model_2ts( );

% Open and run INI file
[ iniFN, iniPath ] = uigetfile( 'pk_ini2ts_*.m' );
iniFullPath = fullfile( iniPath, iniFN );
run( iniFullPath );

% Compute model structures


%% Run model




%% Plot result

if doPlots
    
    pk_plot( tResult, yResult );
    
end


end




























