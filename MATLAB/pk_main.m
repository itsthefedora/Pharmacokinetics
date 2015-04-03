%=========================================================================%
% Pharmacokinetic Model
% => Main entry point.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [tResult, yResult, yNames] = pk_main(varargin)
%PK_MAIN Summary of this function goes here
%   Detailed explanation goes here

%% Initialization

% Deal with MATLAB's crappy environment handling
clear functions;
addpath( pwd( ) );

% Parameter defaults
doPlots = true;
passStruct = {};
iniFullPath = '';

% Parse input arguments
switch length(varargin)
    
    case 0
        %
    
    case 1
        doPlots = varargin{1};
    
    case 2
        doPlots = varargin{1};
        iniFullPath = varargin{2};
       
    case 3
        doPlots = varargin{1};
        iniFullPath = varargin{2};
        passStruct = varargin{3};
        
    otherwise
        error('Invalid number of arguments!');
    
end


%% Set-up model

% Generate default model
model = pk_default_model( );

if isempty(iniFullPath)
    % Open and run INI file
    [ iniFN, iniPath ] = uigetfile( 'pk_ini_*.m' );
    iniFullPath = fullfile( iniPath, iniFN );
end
run( iniFullPath );

% Compute model structure
[ model ] = pk_compute_model( model );


%% Run model

% Generate ODE function handle.
f = @(t, y) pk_odefun( t, y, model );

% Simulate!
[ tResult, yResult ] = ode15s( f, model.timeSpan, model.initialState, model.odeOpts );
yNames = model.compartmentDisplayNames;

%% Plot result

if doPlots

    pk_plot( tResult, yResult, model, false );

end


%% If we gave it an analytic solution, do some comparisons

if ~isempty( model.analyticType )

    switch model.analyticType

    % IV bolus injection
    case 'ivb'
        tAnalytic = tResult;
        yAnalytic = model.analyticParameters.A0 * ...
            exp( -model.analyticParameters.kE * tAnalytic );

    end
    
	tEuler = linspace( tAnalytic( 1 ), tAnalytic( end ), 1e3 );
	dt = tEuler( 2 ) - tEuler ( 1 );
	yEuler( 1, : ) = model.initialState';

	for i = 2:length( tEuler )
		yEuler( i, : ) = yEuler( i - 1, : ) + ...
			dt * f( tEuler( i - 1 ), yEuler( i - 1, : )' )';
	end

	tEulerDisp = tResult;
	yEulerDisp = linterp( tEuler, yEuler, tEulerDisp )';

	figure( 'position', [ 110 110 1024 600 ] );
	plot( tAnalytic, yAnalytic( :, end ), tEulerDisp, yEulerDisp( :, end ), ...
		tResult, yResult(:, end), 'linewidth', 2 );
	legend( 'Analytic', 'Euler', 'RK 4/5' );
	xlabel( 'Time (h)', 'fontsize', 24 );
	ylabel( 'Amount of drug (mg)', 'fontsize', 24 );
	set( gca, 'fontsize', 24 );
	set( gca, 'xlim', model.timeSpan );

	figure( 'position', [ 110 110 1024 600 ] );
	plot( tAnalytic, yEulerDisp(:, end) - yAnalytic( :, end ), ...
		tAnalytic, yResult( :, end ) - yAnalytic( :, end ),'linewidth', 2 );
	legend( 'Euler', 'RK 4/5' );
	xlabel( 'Time (h)', 'fontsize', 24 );
	ylabel( 'Divergence from analytic solution', 'fontsize', 24 );
	set( gca, 'fontsize', 24 );
	set( gca, 'xlim', model.timeSpan );

end











