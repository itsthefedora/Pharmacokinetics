%=========================================================================%
% Pharmacokinetic Model
% => Main entry point.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Set-up model variables

model = pk_default_model( );

%% Open and run INI file

[ iniFN, iniPath ] = uigetfile( );
iniFullPath = fullfile( iniPath, iniFN );
run( iniFullPath );

%% Compute model variables

[model] = pk_compute_model( model );

%% Run model

f = @(t, y) pk_odefun( t, y, model );
[ tResult, yResult ] = ode45( f, model.timeSpan, model.initialState );

%% Plot result

figure( 'position', [ 10 10 1024 600 ] );
plot( tResult, yResult, 'linewidth', 2 );
legend( model.compartmentNames, 'fontsize', 24 );
set( gca, 'fontsize', 24 );













