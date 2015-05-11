%=========================================================================%
% Pharmacokinetic 2TS Model
% => Final model.
% 
% [Authors]
% Spring 2015
%=========================================================================%


%=========================================================================%
%% SETUP

%% -- Quick access

% ... %

%% -- Slow model

% GLUT4
Glut4Volume 		= 1.0;
Glut4Default 		= 1.0;

kEGlut4 			= 1.0;		% TODO
QGlut4Base			= 1.0;		% TODO

QVFGlut4Max 		= 1.0;		% TODO
QVFGlut4Shape 		= 1.0;		% TODO
QVFGlut4Center		= 1.0;		% TODO

% Beta stuff
BetaFakeVolume 		= 1.0;		% TODO?
BetaQmaxDefault 	= 1.0;		% TODO
BetaNDefault 		= 1.0;		% TODO
BetaXDefault 		= 1.0;		% TODO?

kEBetaQmax 			= 1.0;		% TODO
kEBetaN				= 1.0;		% TODO
kEBetaX 			= 1.0;		% TODO
QBetaQmaxBase		= 1.0;		% TODO
QBetaNBase 			= 1.0;		% TODO
QBetaXBase 			= 1.0;		% TODO

%% -- Fast model

% ... %

%=========================================================================%
%% GLOBAL

%% -- Parameters

% ... %

model.slow.timeSpan = [0, 1 * 365];		% d
model.fast.timeSpan = [0, 3 * 24];		% h
model.fastSpacing = 14;					% d

model.updateSlow = @( m, inStruct ) pk_final_updateSlow( m, inStruct );
model.updateFast = @( m, inStruct ) pk_final_updateFast( m, inStruct );

%=========================================================================%
%% SLOW MODEL

%%  -- Compartments

% Storage
x = pk_default_compratment( );
x.volume = VFatVolume;
x.initialAmount = VFatDefault;
x.displayName = 'Storage/V.Fat';
model.slow.compartments.fatV = x;

% ... %

% GLUT4 TFs
x = pk_default_compratment( );
x.volume = Glut4Volume;
x.initialAmount = Glut4Default;
x.displayName = 'GLUT4/Liver';
model.slow.compartments.glut4liver = x;
x = pk_default_compratment( );
x.volume = Glut4Volume;
x.initialAmount = Glut4Default;
x.displayName = 'GLUT4/Muscle';
model.slow.compartments.glut4muscle = x;
x = pk_default_compratment( );
x.volume = Glut4Volume;
x.initialAmount = Glut4Default;
x.displayName = 'GLUT4/VF';
model.slow.compartments.glut4vf = x;

% Beta stuff
x = pk_default_compratment( );
x.volume = BetaFakeVolume;
x.initialAmount = BetaQmaxDefault;
x.displayName = 'Beta/Qmax';
model.slow.compartments.betaQmax = x;

x = pk_default_compratment( );
x.volume = BetaFakeVolume;
x.initialAmount = BetaNDefault;
x.displayName = 'Beta/N';
model.slow.compartments.betaN = x;

x = pk_default_compratment( );
x.volume = BetaFakeVolume;
x.initialAmount = BetaXDefault;
x.displayName = 'Beta/FactorX';
model.slow.compartments.betaX = x;

%% -- Connections

% Degradation
x = pk_default_connection( ); x.from = 'glut4liver'; x.to = '';
x.linker = pk_linear_linker( kEGlut4 );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'glut4muscle'; x.to = '';
x.linker = pk_linear_linker( kEGlut4 );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'glut4vf'; x.to = '';
x.linker = pk_linear_linker( kEGlut4 );
model.slow.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'betaQmax'; x.to = '';
x.linker = pk_linear_linker( kEBetaQmax );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'betaN'; x.to = '';
x.linker = pk_linear_linker( kEBetaN );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'betaX'; x.to = '';
x.linker = pk_linear_linker( kEBetaX );
model.slow.connections{ end + 1 } = x;

%% -- Inputs

% Accumulation
% ... %

% Baseline TF production
x = pk_default_input( ); x.target = 'glut4liver';
x.flow = pk_constant_flow( QGlut4Base );
model.slow.inputs{ end + 1 } = x;
x = pk_default_input( ); x.target = 'glut4muscle';
x.flow = pk_constant_flow( QGlut4Base );
model.slow.inputs{ end + 1 } = x;
x = pk_default_input( ); x.target = 'glut4vf';
x.flow = pk_constant_flow( QGlut4Base );
model.slow.inputs{ end + 1 } = x;

% TF secretion by VF
x = pk_default_sdinput( ); x.input = { 'fatV' }; x.target = 'glut4tf';
x.flow = pk_tanh_sd_flow( QVFGlut4Max, QVFGlut4Shape, QVFGlut4Center );
model.slow.sdinputs{ end + 1 } = x;

% Beta-stuff Production
x = pk_default_input( ); x.target = 'betaQmax';
x.flow = pk_constant_flow( QQmaxBetaBase );
model.slow.inputs{ end + 1 } = x;


%=========================================================================%
%% FAST MODEL

%%  -- Compartments
