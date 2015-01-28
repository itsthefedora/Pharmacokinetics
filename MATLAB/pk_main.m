%=========================================================================%
% Pharmacokinetic Model
% => Main entry point.
% 
% [Authors]
% Fall 2014
%=========================================================================%

clear functions;
addpath( pwd( ) );

%% Set-up model variables

model = pk_default_model( );

%% Open and run INI file

[ iniFN, iniPath ] = uigetfile( );
iniFullPath = fullfile( iniPath, iniFN );
run( iniFullPath );

%% Compute model variables

[model] = pk_compute_model( model );

%% Run model using ODE45

f = @(t, y) pk_odefun( t, y, model );
% TODO: Make this part of model.
odeOpts = odeset( 'MaxStep', 0.1 );
[ tResult, yResult ] = ode15s( f, model.timeSpan, model.initialState, odeOpts );

% If we gave it analytic solution, do some comparisons

switch model.analyticType

% IV bolus injection
case 'ivb'
	tAnalytic = tResult;
	yAnalytic = model.analyticParameters.A0 * ...
		exp( -model.analyticParameters.kE * tAnalytic );

end

if ~isempty( model.analyticType )

	tEuler = linspace( tAnalytic( 1 ), tAnalytic( end ), 1e3 );
	dt = tEuler( 2 ) - tEuler ( 1 );
	yEuler( 1, : ) = model.initialState';

	for i = 2:length( tEuler )
		yEuler( i, : ) = yEuler( i - 1, : ) + ...
			dt * f( tEuler( i - 1 ), yEuler( i - 1, : )' )';
	end

	tEulerDisp = tResult;
	yEulerDisp = linterp( tEuler, yEuler, tEulerDisp )';

end

%% Plot result

figure( 'position', [ 10 10 1024 600 ] );
plot( tResult, yResult, 'linewidth', 2 );
legend( model.compartmentDisplayNames, 'fontsize', 24 );
xlabel( 'Time (h)', 'fontsize', 24 );
ylabel( 'Amount of drug (mg)', 'fontsize', 24 );
set( gca, 'fontsize', 24 );
set( gca, 'xlim', model.timeSpan );

figure( 'position', [ 110 10 1024 600 ] );
semilogy( tResult, yResult, 'linewidth', 2 );
legend( model.compartmentDisplayNames, 'fontsize', 24 );
xlabel( 'Time (h)', 'fontsize', 24 );
ylabel( 'Amount of drug (mg)', 'fontsize', 24 );
set( gca, 'fontsize', 24 );
set( gca, 'xlim', model.timeSpan );
set( gca, 'ylim', [ 1e1 1e3 ] );

if ~isempty( model.analyticType )

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











