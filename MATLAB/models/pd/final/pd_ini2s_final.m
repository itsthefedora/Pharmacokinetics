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

%% -- Meta

% Physical constants
molarMassGlu 	= 180.16;	% g/mol
molarMassIns 	= 5808;
molarMassGcn 	= 3485;

% Diet
fracFruGlu 		= 0.35;		% TODO? % 0.27 - 0.37
dietScale 		= 2.0;

doseGlu 		= dietScale * [35 30 40];				% g
doseFru 		= dietScale * [50 30 40] / fracFruGlu;
doseTg 			= dietScale * [10 16 30];

doseDuration 	= (1/60) * [15 30 45]; % hr
doseOffsets 	= [6 12 18];
dosesPerDay		= length( doseOffsets ); % #

% ... %

%% -- Slow model

% Storage
QFatVBase 			= 1.0;		% TODO

% GLUT4
Glut4Volume 		= 1.0;
Glut4Default 		= 1.0;

kEGlut4 			= 1.0;		% TODO
QGlut4Base			= 1.0;		% TODO

QVFGlut4Max 		= 1.0;		% TODO
QVFGlut4Shape 		= 1.0;		% TODO
QVFGlut4Center		= 1.0;		% TODO

% Beta
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

% GI
GIVolume 			= 1.0;		% TODO

kAGlu				= 1.0;		% TODO
kAFru 				= 1.0;		% TODO

% Central
GluVd 				= 1.0;		% TODO
FruVd				= 1.0;		% TODO
InsVd				= 1.0;		% TODO
GcnVd				= 1.0;		% TODO

BodyGluDefault 		= 1.0;		% TODO
BodyFruDefault		= 1.0;		% TODO
BodyInsDefault		= 1.0;		% TODO
BodyGcnDefault		= 1.0;		% TODO

LiverGlyDefault		= 1.0;		% TODO
LiverEFDefault 		= 1.0;		% TODO

QInsBase 			= 1.0;		% TODO
QGluInsMax 			= 1.0;		% TODO
QGluInsShape 		= 1.0;		% TODO
QGluInsCenter		= 1.0;		% TODO

QGcnBase 			= 1.0;		% TODO
QGluGcnMax 			= 1.0;		% TODO
QGluGcnShape 		= 1.0;		% TODO
QGluGcnCenter		= 1.0;		% TODO

%=========================================================================%
%% GLOBAL

%% -- Parameters

% ... %

model.slow.timeSpan = [0, 1 * 365];		% d
model.fast.timeSpan = [0, 3 * 24];		% h
model.fastSpacing = 14;					% d

% TODO
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
x = pk_default_compratment( ); x.displayName = 'GLUT4/Liver';
x.volume = Glut4Volume; x.initialAmount = Glut4Default;
model.slow.compartments.glut4liver = x;
x = pk_default_compratment( ); x.displayName = 'GLUT4/Muscle';
x.volume = Glut4Volume; x.initialAmount = Glut4Default;
model.slow.compartments.glut4muscle = x;
x = pk_default_compratment( ); x.displayName = 'GLUT4/VF';
x.volume = Glut4Volume; x.initialAmount = Glut4Default;
model.slow.compartments.glut4vf = x;

% Beta stuff
x = pk_default_compratment( ); x.displayName = 'Beta/Qmax';
x.volume = BetaFakeVolume; x.initialAmount = BetaQmaxDefault;
model.slow.compartments.betaQmax = x;

x = pk_default_compratment( ); x.displayName = 'Beta/N';
x.volume = BetaFakeVolume; x.initialAmount = BetaNDefault;
model.slow.compartments.betaN = x;

x = pk_default_compratment( ); x.displayName = 'Beta/FactorX';
x.volume = BetaFakeVolume; x.initialAmount = BetaXDefault;
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
x = pk_default_input( ); x.target = 'fatV';
x.flow = pk_constant_flow( QFatVBase );
model.slow.inputs{ end + 1 } = x;
model.globals.idx_inputFatV = length( model.slow.inputs );	% TODO

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
x.flow = pk_constant_flow( QBetaQmaxBase );
model.slow.inputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'betaN';
x.flow = pk_constant_flow( QBetaNBase );
model.slow.inputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'betaX';
x.flow = pk_constant_flow( QBetaXBase );
model.slow.inputs{ end + 1 } = x;


%=========================================================================%
%% FAST MODEL

%% -- Compartments

% GI Tract
x = pk_default_compartment( ); x.displayName = 'GI/Glu';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giGlu = x;
x = pk_default_compartment( ); x.displayName = 'GI/Fru';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giFru = x;
x = pk_default_compartment( ); x.displayName = 'GI/TG';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giTg = x;
x = pk_default_compartment( ); x.displayName = 'GI/FFA';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giFfa = x;

% Central
x = pk_default_compartment( ); x.displayName = 'Body/Glu';
x.volume = GluVd; x.initialAmount = BodyGluDefault;
model.fast.compartments.bodyGlu = x;
x = pk_default_compartment( ); x.displayName = 'Body/Fru';
x.volume = FruVd; x.initialAmount = BodyFruDefault;
model.fast.compartments.bodyFru = x;
x = pk_default_compartment( ); x.displayName = 'Body/Ins';
x.volume = InsVd; x.initialAmount = BodyInsDefault;
model.fast.compartments.bodyIns = x;
x = pk_default_compartment( ); x.displayName = 'Body/Gcn';
x.volume = GcnVd; x.initialAmount = BodyGcnDefault;
model.fast.compartments.bodyIns = x;

% Tissues
x = pk_default_compartment( ); x.displayName = 'Liver/Gly';
x.volume = InsVd; x.initialAmount = LiverGlyDefault;
model.fast.compartments.liverGly = x;
x = pk_default_compartment( ); x.displayName = 'Liver/EF';
x.volume = InsVd; x.initialAmount = LiverEFDefault;
model.fast.compartments.liverEF = x;

%% -- Connections

% Absorption
x = pk_default_connection( ); x.from = 'giGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kAGlu );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giFru'; x.to = 'bodyFru';
x.linker = pk_linear_linker( kAFru );
model.fast.connections{ end + 1 } = x;

% Clearance - Renal
x = pk_default_connection( ); x.from = 'bodyGlu'; x.to = '';
x.linker = pk_linear_linker( kErGlu );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyFru'; x.to = '';
x.linker = pk_linear_linker( kErFru );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyIns'; x.to = '';
x.linker = pk_linear_linker( kErIns );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyGcn'; x.to = '';
x.linker = pk_linear_linker( kErGcn );
model.fast.connections{ end + 1 } = x;

% Fructolysis
% ... %

%% -- Interactions

% ... %

%% -- Inputs

% Eating
% ... %

% Hormone production
x = pk_default_input( ); x.target = 'bodyIns';
x.flow = pk_constant_flow( QInsBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'bodyGlu' }; x.target = 'bodyIns';
x.flow = pk_tanh_sd_flow( QGluInsMax, QGluInsShape, QGluInsCenter );
model.slow.sdinputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'bodyGcn';
x.flow = pk_constant_flow( QInsBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'bodyGlu' }; x.target = 'bodyGcn';
x.flow = pk_tanh_sd_flow( QGluGcnMax, QGluGcnShape, QGluGcnCenter );
model.slow.sdinputs{ end + 1 } = x;