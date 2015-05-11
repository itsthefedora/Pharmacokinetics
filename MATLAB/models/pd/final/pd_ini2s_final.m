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

% Absorption
GlukA				= 1.0;		% TODO
FrukA 				= 1.0;		% TODO
% Bile action
SITgFfaKm 			= 1.0;		% TODO
SITgFfaVmax			= 1.0;		% TODO

% Central

% Volumes
GluVd 				= 1.0;		% TODO
FruVd				= 1.0;		% TODO
InsVd				= 1.0;		% TODO
GcnVd				= 1.0;		% TODO
VldlVd 				= 1.0;		% TODO
LplVd 				= 1.0;		% TODO

% Defaults
BodyGluDefault 		= 1.0;		% TODO
BodyFruDefault		= 1.0;		% TODO
BodyInsDefault		= 1.0;		% TODO
BodyGcnDefault		= 1.0;		% TODO

% Tissue

% Volumes
LiverGlyVolume 		= 1.0;		% TODO?
LiverEFatVolume		= 1.0;		% TODO?
MuscleGlyVolume 	= 1.0;		% TODO?
MuscleEFatVolume	= 1.0;		% TODO?

% Defaults
LiverGlyDefault		= 1.0;		% TODO
LiverEFatDefault 	= 1.0;		% TODO
LiverGlyDefault		= 1.0;		% TODO
LiverEFatDefault 	= 1.0;		% TODO

% Beta cell action
QInsBase 			= 1.0;		% TODO
QGluInsMax 			= 1.0;		% TODO
QGluInsShape 		= 1.0;		% TODO
QGluInsCenter		= 1.0;		% TODO

% Alpha cell action
QGcnBase 			= 1.0;		% TODO
QGluGcnMax 			= 1.0;		% TODO
QGluGcnShape 		= 1.0;		% TODO
QGluGcnCenter		= 1.0;		% TODO

%=========================================================================%
%% GLOBAL

%% -- Parameters

% ... %

model.slow.timeSpan 	= [0, 1 * 365];		% d
model.fastSpacing 		= 14;

model.fast.timeSpan 	= [0, 3 * 24];				% h
model.fast.maxStep 		= min( doseDuration ) / 2;

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

% Behavioral
x = pk_default_compartment( ); x.displayName = './Activity';
x.volume = 1; x.initialAmount = 0;
model.fast.compartments.activity = x;

% GI Tract
x = pk_default_compartment( ); x.displayName = 'GI/Glu';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giGlu = x;
x = pk_default_compartment( ); x.displayName = 'GI/Fru';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giFru = x;
x = pk_default_compartment( ); x.displayName = 'GI/Tg';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giTg = x;
x = pk_default_compartment( ); x.displayName = 'GI/FA';
x.volume = GIVolume; x.initialAmount = 0;
model.fast.compartments.giFA = x;

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
model.fast.compartments.bodyGcn = x;
x = pk_default_compartment( ); x.displayName = 'Body/Chylo.';
x.volume = ChyloVd; x.initialAmount = BodyChyloDefault;
model.fast.compartments.bodyChylo = x;
x = pk_default_compartment( ); x.displayName = 'Body/VLDL';
x.volume = VldlVd; x.initialAmount = BodyVldlDefault;
model.fast.compartments.bodyLpl = x;
x = pk_default_compartment( ); x.displayName = 'Body/LPL';
x.volume = LplVd; x.initialAmount = BodyLplDefault;
model.fast.compartments.bodyLpl = x;

% Tissues
% Liver
x = pk_default_compartment( ); x.displayName = 'Liver/Glu';
x.volume = LiverGluVolume; x.initialAmount = LiverGluDefault;
model.fast.compartments.liverGlu = x;
x = pk_default_compartment( ); x.displayName = 'Liver/Fru';
x.volume = LiverFruVolume; x.initialAmount = LiverFruDefault;
model.fast.compartments.liverFru = x;
x = pk_default_compartment( ); x.displayName = 'Liver/FA';
x.volume = LiverFAVolume; x.initialAmount = LiverFADefault;
model.fast.compartments.liverFA = x;
x = pk_default_compartment( ); x.displayName = 'Liver/Gly';
x.volume = LiverGlyVolume; x.initialAmount = LiverGlyDefault;
model.fast.compartments.liverGly = x;
x = pk_default_compartment( ); x.displayName = 'Liver/E.Fat';
x.volume = LiverEFatVolume; x.initialAmount = LiverEFatDefault;
model.fast.compartments.liverEF = x;
x = pk_default_compartment( ); x.displayName = 'Liver/ATP';
x.volume = LiverATPVolume; x.initialAmount = LiverATPDefault;
model.fast.compartments.liverATP = x;
x = pk_default_compartment( ); x.displayName = 'Liver/AMP';
x.volume = LiverAMPVolume; x.initialAmount = LiverAMPDefault;
model.fast.compartments.liverAMP = x;
x = pk_default_compartment( ); x.displayName = 'Liver/Uric';
x.volume = LiverUricVolume; x.initialAmount = LiverUricDefault;
model.fast.compartments.liverUric = x;
% Muscle
x = pk_default_compartment( ); x.displayName = 'Muscle/Glu';
x.volume = MuscleGluVolume; x.initialAmount = MuscleGluDefault;
model.fast.compartments.muscleGlu = x;
x = pk_default_compartment( ); x.displayName = 'Muscle/FA';
x.volume = MuscleFAVolume; x.initialAmount = MuscleFADefault;
model.fast.compartments.muscleFA = x;
x = pk_default_compartment( ); x.displayName = 'Muscle/Gly';
x.volume = MuscleGlyVolume; x.initialAmount = MuscleGlyDefault;
model.fast.compartments.muscleGly = x;
x = pk_default_compartment( ); x.displayName = 'Muscle/E.Fat';
x.volume = MuscleEFatVolume; x.initialAmount = MuscleEFatDefault;
model.fast.compartments.muscleEF = x;
% Visceral fat
x = pk_default_compartment( ); x.displayName = 'VAdip/Glu';
x.volume = VFatVt; x.initialAmount = VFatDefault;
model.fast.compartments.vGlu = x;
x = pk_default_compartment( ); x.displayName = 'VAdip/FA';
x.volume = VFatVt; x.initialAmount = VFatDefault;
model.fast.compartments.vFA = x;
x = pk_default_compartment( ); x.displayName = 'VAdip/Storage';
x.volume = VFatVt; x.initialAmount = VFatDefault;
model.fast.compartments.vStorage = x;
% SC Fat
x = pk_default_compartment( ); x.displayName = 'SCAdip/Glu';
x.volume = VFatVt; x.initialAmount = VFatDefault;
model.fast.compartments.scGlu = x;
x = pk_default_compartment( ); x.displayName = 'SCAdip/FA';
x.volume = VFatVt; x.initialAmount = VFatDefault;
model.fast.compartments.scFA = x;
x = pk_default_compartment( ); x.displayName = 'SCAdip/Storage';
x.volume = SCFatVt; x.initialAmount = SCFatDefault;
model.fast.compartments.scStorage = x;

%% -- Connections and Interactions

% Absorption
x = pk_default_connection( ); x.from = 'giGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( GlukA );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giFru'; x.to = 'bodyFru';
x.linker = pk_linear_linker( FrukA );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'giTg'; x.to = 'giFA';
x.linker = pk_mm_linker( SITgFAKm, SITgFAVmax );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giFA'; x.to = 'bodyChylo';
x.linker = pk_linear_linker( FAChylokA );

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

% Clearance - Metabolism
x = pk_default_connection( ); x.from = 'liverGlu'; x.to = '';
x.linker = pk_linear_linker( kEmGluLiverBase );
model.fast.connections{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'liverGlu', 'activity' }; x.depletes = [true, false];
x.to = { '' }; % TODO
x.linker = pk_product_linker( kEmGluLiverActive );
model.interactions{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'muscleGlu'; x.to = '';
x.linker = pk_linear_linker( kEmGluMuscleBase );
model.fast.connections{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'muscleGlu', 'activity' }; x.depletes = [true, false];
x.to = { '' }; % TODO
x.linker = pk_product_linker( kEmGluMuscleActive );
model.interactions{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'liverATP'; x.to = '';
x.linker = pk_linear_linker( kEATP );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'liverAMP'; x.to = '';
x.linker = pk_linear_linker( kEAMP );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'liverUric'; x.to = '';
x.linker = pk_linear_linker( kEUric );
model.fast.connections{ end + 1 } = x;

% Fructolysis
x = pk_default_interaction( );
x.from = { 'liverFru', 'liverATP' }; x.depletes = [true, true];
x.to = { 'liverGlu', 'liverAMP' };
x.linker = pk_product_linker( kFruGlu );
model.interactions{ end + 1 } = x;

% Chylo. uptake
x = pk_default_interaction( );
x.from = { 'bodyChylo', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'liverFA' };
x.linker = pk_product_linker( kChyloUptake );
model.interactions{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyChylo', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'muscleFA' };
x.linker = pk_product_linker( kChyloUptake );
model.interactions{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyChylo', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'liverFA' };
x.linker = pk_product_linker( kChyloUptake );
model.interactions{ end + 1 } = x;
x.from = { 'bodyChylo', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'vFA' };
x.linker = pk_product_linker( kChyloUptake );
model.interactions{ end + 1 } = x;
x.from = { 'bodyChylo', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'scFA' };
x.linker = pk_product_linker( kChyloUptake );
model.interactions{ end + 1 } = x;

% ... %

%% -- Inputs

% Eating
for i = 1:dosesPerDay

	x = pk_default_input( ); x.target = 'giGlu';
	x.flow = pk_pulsed_flow( doseGlu(i), doseDuration(i), 24, -1, doseOffset(i) );
	model.fast.inputs{ end + 1 } = x;
	x = pk_default_input( ); x.target = 'giFru';
	x.flow = pk_pulsed_flow( doseFru(i), doseDuration(i), 24, -1, doseOffset(i) );
	model.fast.inputs{ end + 1 } = x;
	x = pk_default_input( ); x.target = 'giTg';
	x.flow = pk_pulsed_flow( doseTg(i), doseDuration(i), 24, -1, doseOffset(i) );
	model.fast.inputs{ end + 1 } = x;

end

% Hormone production
x = pk_default_input( ); x.target = 'bodyIns';
x.flow = pk_constant_flow( QInsBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'bodyGlu' }; x.target = 'bodyIns';
x.flow = pk_tanh_sd_flow( QGluInsMax, QGluInsShape, QGluInsCenter );
model.fast.sdinputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'bodyGcn';
x.flow = pk_constant_flow( QInsBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'bodyGlu' }; x.target = 'bodyGcn';
x.flow = pk_tanh_sd_flow( QGluGcnMax, QGluGcnShape, QGluGcnCenter );
model.fast.sdinputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'bodyLpl';
x.flow = pk_constant_flow( QLplBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'bodyIns' }; x.target = 'bodyLpl';
x.flow = pk_tanh_sd_flow( QInsLplMax, QInsLplShape, QInsLplCenter );
model.fast.sdinputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'liverUric';
x.flow = pk_constant_flow( QUricBase );
model.fast.inputs{ end + 1 } = x;























