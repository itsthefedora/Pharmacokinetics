%=========================================================================%
% Pharmacokinetic Model
% => Main entry point, two-timescale.
% 
% [Authors]
% Spring 2015
%=========================================================================%

function [tResult, yResult, tResultFast, yResultFast] = pk_main_2ts( varargin )
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
% TODO: Kludgey fix for this
addpath( iniPath );
iniFullPath = fullfile( iniPath, iniFN );
run( iniFullPath );

% Compute model structures
[ model.slow ] = pk_compute_model( model.slow );
[ model.fast ] = pk_compute_model( model.fast );


%% Run models -- TESTING

% Chop up time into segments
fullTime = model.slow.timeSpan;
timeChop = fulltime(1):model.fastSpacing:fullTime(2);

% Set up final result vectors
tResult = [ ];
yResult = [ ];
tResultFast = { };
yResultFast = { };

% For each segment ...
for i = 1:( length(timeChop) - 1 )
    
    % Run fast model.
    fFast = @(t, y) pk_odefun( t, y, model.fast );
    [ tSegFast, ySegFast ] = ode15s( fFast, model.fast.timeSpan, model.fast.initialState, model.fast.odeOpts );
    tResultFast{i} = tSegFast;
    yResultFast{i} = ySegFast;
    
    % Update slow model.
    % ...
    
    % Run slow model.
    fSlow = @(t, y) pk_odefun( t, y, model.slow );
    curTimeSpan = [timeChop(i) timeChop(i+1)];
    [ tSeg, ySeg ] = ode15s( fSlow, curTimeSpan, model.slow.initialState, model.slow.odeOpts );
    tResult = [tResult( 1:(end-1), : ); tSeg];
    yResult = [yResult( 1:(end-1), : ); ySeg];
    
    % Update fast model.
    % ...
    
end


% Generate ODE function handle.
f = @(t, y) pk_odefun( t, y, model.slow );



% Simulate!
[ tResult, yResult ] = ode15s( f, model.slow.timeSpan, model.slow.initialState, model.slow.odeOpts );


%% Plot result

if doPlots
    
    pk_plot( tResult, yResult, model.slow );
    
end


end




























