%=========================================================================%
% Pharmacokinetic Model
% => Main entry point, two-timescale.
% 
% [Authors]
% Spring 2015
%=========================================================================%

function [tResult, yResult, yNames, tResultFast, yResultFast, yNamesFast] = pk_main_2ts( varargin )
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
timeChop = fullTime(1):model.fastSpacing:fullTime(2);
nChops = length(timeChop) - 1;

% Set up final result vectors
tResult = [ 0 ];
yResult = [ model.slow.initialState' ];
tResultFast = { };
yResultFast = { };

hFig = figure('position', [100 100 1600 600]);
hLocal = subplot( 1, 2, 1 );
hGlobal = subplot( 1, 2, 2 );

% For each segment ...
for i = 1:nChops
    
    % Debug display.
    disp(['Running cycle ' num2str(i) ' of ' num2str(nChops)]);
    
    % Run fast model.
    fFast = @(t, y) pk_odefun( t, y, model.fast );
    [ tSegFast, ySegFast ] = ode15s( fFast, model.fast.timeSpan, model.fast.initialState, model.fast.odeOpts );
    tResultFast{i} = tSegFast;
    yResultFast{i} = ySegFast;
    
    % Update slow model.
    inStruct = struct;
    
    inStruct.data = struct;
    inStruct.data.t = tSegFast;
    inStruct.data.y = ySegFast;
    
    model = model.updateSlow( model, inStruct );
    [ model.slow ] = pk_compute_model( model.slow );
    
    initialState = yResult(end, :);
    
    % Run slow model.
    fSlow = @(t, y) pk_odefun( t, y, model.slow );
    curTimeSpan = [timeChop(i) timeChop(i+1)];
    [ tSeg, ySeg ] = ode15s( fSlow, curTimeSpan, initialState, model.slow.odeOpts );
    tResult = [tResult( 1:(end-1), : ); tSeg];
    yResult = [yResult( 1:(end-1), : ); ySeg];
    
    % Update fast model.
    inStruct = struct;
    
    inStruct.data = struct;
    inStruct.data.t = tSeg;
    inStruct.data.y = ySeg;
    
    model = model.updateFast( model, inStruct );
    [ model.fast ] = pk_compute_model( model.fast );
    
    % TEMP:
    % Plot.
    cla(hLocal);
    plot(hLocal, tSegFast, 100 * ySegFast(:, 6)/7.24, 'k-', 'linewidth', 2);
    hold(hLocal, 'on'); tFirst = tResultFast{1}; yFirst = yResultFast{1};
    plot(hLocal, tFirst, 100 * yFirst(:, 6)/7.24, 'k--', 'linewidth', 2);
    set(hLocal, 'xlim', [2*24, 3*24]);
    set(hLocal, 'fontsize', 24);
    
    plot(hGlobal, tResult, yResult, 'linewidth', 2);
    set(hGlobal, 'xlim', fullTime);
    set(hGlobal, 'fontsize', 24);
    drawnow;
    
end

yNames      = model.slow.compartmentDisplayNames;
yNamesFast  = model.fast.compartmentDisplayNames;

% Generate ODE function handle.
%f = @(t, y) pk_odefun( t, y, model.slow );

% Simulate!
%[ tResult, yResult ] = ode15s( f, model.slow.timeSpan, model.slow.initialState, model.slow.odeOpts );


%% Plot result

if doPlots
    
    pk_plot( tResultFast{end}, yResultFast{end}, model.fast, false );
    
end


end




























