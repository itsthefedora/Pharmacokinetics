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

% Modifiers

absorptionFactor 	= 5.0;

%% -- Meta

% Physical constants
molarMassGlu 	= 180.16;	% g/mol
molarMassIns 	= 5808;
molarMassGcn 	= 3485;

% Patient data
patientMass 	= 70.0;							% kg
waterFraction	= 0.65;							%[0 1]
waterMass		= waterFraction * patientMass;

fatFraction		= 0.3;
fatMass 		= fatFraction * patientMass * 1000.0;	% g
vfFraction 		= 0.15;
scfFraction 	= 0.3;
vfMass 			= vfFraction * fatMass;
scfMass 		= scfFraction * fatMass;

liverMass 			= 1.5e3;	% g
glycogenPerMass 	= 65e-3;	% g / g
glycogenMass 		= 500;	% TODO	%glycogenPerMass * liverMass * 3;

% Treatment
tripleStart 	= 0;
tripleEnd 		= 0;
deStart 		= 0;
deEnd 			= 0;
ltbStart 		= 30;
ltbEnd 			= 365;

% Diet
fracFruGlu 		= 0.35;		% TODO? % 0.27 - 0.37
dietScale 		= 4.0;

doseGlu 		= dietScale * [35 30 40];				% g
doseFru 		= dietScale * [50 30 40] / fracFruGlu;
doseTg 			= dietScale * [10 16 30];

doseDuration 	= (1/60) * [15 30 45]; 		% hr
doseOffsets 	= [6 12 18];

dosesPerDay		= length( doseOffsets ); 	% #

% ... %

%% -- Slow model

% Storage
VFVolume 			= 1.0;		% OK?	% L
LiverEFVolume 		= 1.0;		% OK?
MuscleEFVolume 		= 1.0;		% OK?

QVFBase 			= 1.0;		% TODO	% g / day
QLiverEFBase 		= 1.0;		% TODO
QMuscleEFBase 		= 1.0;		% TODO

% GLUT4
LTB4Volume 			= 1.0;		% OK?
LTB4Default 		= 1.0;		% OK?

kETreatment 		= 1.0;		% OK?
QTreatment 			= 1.0;		% OK?

kELTB4 				= 1.0;		% OK?	% / day
QLTB4Base			= 1.0;		% OK?	% u / day

QLiverEFLTB4Max 	= 1.0;		% TODO
QLiverEFLTB4Shape 	= 1.0;		% TODO
QLiverEFLTB4Center	= 1.0;		% TODO
QMuscleEFLTB4Max 	= 1.0;		% TODO
QMuscleEFLTB4Shape 	= 1.0;		% TODO
QMuscleEFLTB4Center	= 1.0;		% TODO
QVFLTB4Max 			= 1.0;		% TODO
QVFLTB4Shape 		= 1.0;		% TODO
QVFLTB4Center		= 1.0;		% TODO

% Beta
BetaFakeVolume 		= 1.0;		% OK?
BetaQmaxDefault 	= 1.0;		% TODO
BetaNDefault 		= 1.0;		% TODO
BetaXDefault 		= 1.0;		% OK?

kEBetaQmax 			= 1.0;		% TODO
kEBetaN				= 1.0;		% TODO
kEBetaX 			= 1.0;		% TODO
QBetaQmaxBase		= 1.0;		% TODO
QBetaNBase 			= 1.0;		% TODO
QBetaXBase 			= 1.0;		% TODO

%% -- Fast model

% GI

GIVolume 			= 0.105;		% L

% Absorption
GlukA				= absorptionFactor * 0.205 * 60;	% / h
FrukA 				= GlukA;							% TODO
FATgkA				= GlukA;							% TODO
% Bile action
SITgFAVmax 			= 3 * 1.25 * 60 * GIVolume;	% g / hr
SITgFAKm			= 100 * GIVolume;		% g

% Central

% Volumes
GluVd 				= 7.24;		% L
FruVd				= GluVd;	% TODO
InsVd				= 15.6;
GcnVd				= 0.19 * waterMass;
FAVd				= 1.0;		% TODO
TgVd 				= 1.0;		% TODO
LplVd 				= 1.0;		% TODO

% Defaults
BodyGluDefault 		= 0.0;		% TODO
BodyFruDefault		= 0.0;		% TODO
BodyInsDefault		= 0.0;		% TODO
BodyGcnDefault		= 0.0;		% TODO
BodyTgDefault		= 0.0;		% TODO
BodyFADefault		= 0.0;		% TODO
BodyFAbDefault		= 0.0;		% TODO
BodyLplDefault		= 0.0;		% TODO

% Tissue

% Volumes
LiverGluVolume 		= 1.0;		% OK?
LiverFruVolume 		= 1.0;		% OK?
LiverFAVolume 		= 1.0;		% OK?
LiverGlyVolume		= 1.0;		% OK?
LiverEFVolume 		= 1.0;		% OK?
LiverATPVolume 		= 1.0;		% OK?
LiverAMPVolume 		= 1.0;		% OK?
LiverUricVolume 	= 1.0;		% OK?

MuscleGluVolume 	= 1.0;		% OK?
MuscleFAVolume 		= 1.0;		% OK?
MuscleGlyVolume		= 1.0;		% OK?
MuscleEFVolume 		= 1.0;		% OK?

VAdipGluVolume 		= 1.0;		% OK?
VAdipFAVolume 		= 1.0;		% OK?
VAdipStorageVolume 	= 1.0;		% OK?

SCAdipGluVolume 	= 1.0;		% OK?
SCAdipFAVolume 		= 1.0;		% OK?
SCAdipStorageVolume	= 1.0;		% OK?

% Defaults
LiverGluDefault 	= 1.0;		% TODO
LiverFruDefault 	= 1.0;		% TODO
LiverFADefault 		= 1.0;		% TODO
LiverGlyDefault		= glycogenMass;
LiverEFDefault 		= 1.0;		% TODO
LiverATPDefault 	= 1.0;		% TODO
LiverAMPDefault 	= 1.0;		% TODO
LiverUricDefault 	= 1.0;		% TODO

MuscleGluDefault 	= 1.0;		% TODO
MuscleFADefault 	= 1.0;		% TODO
MuscleGlyDefault	= 3 * glycogenMass;		% TODO
MuscleEFDefault 	= 1.0;		% TODO

VAdipGluDefault 	= 1.0;		% TODO
VAdipFADefault 		= 1.0;		% TODO
VAdipStorageDefault = 0.5 * glycogenMass;	% TODO	%vfMass;

SCAdipGluDefault 		= 1.0;		% TODO
SCAdipFADefault 		= 1.0;		% TODO
SCAdipStorageDefault	= 0.75 * glycogenMass;	% TODO	%scfMass;

% Clearance - Renal
kEGlu 		= 0.0141 * 60;	% / h
kEFru 		= kEGlu;		% TODO
kEIns 		= 0.09 * 60;
kEGcn 		= 2.29;
kEFA 		= kEGlu;		% TODO
kELpl 		= kEIns;		% TODO

kErGlu 		= kEGlu;						% TODO	% / h
kErFru 		= kEFru * (1 - fracFruGlu);		% TODO
kErIns 		= kEIns;						% TODO
kErGcn 		= kEGcn;						% TODO

% Clearance - Metabolism
kEmGluLiverBase			= 1.0;	% TODO	% / h
kEmGluLiverActive		= 1.0;	% TODO
kEmGluMuscleBase		= 1.0;	% TODO
kEmGluMuscleActive		= 1.0;	% TODO

kEATP		= 1.0;	% TODO	% / h
kEAMP		= 1.0; 	% TODO
kEUric 		= 1.0;	% TODO

% Fructolysis
kFruGlu 	= kEFru * fracFruGlu;

% Lipid uptake via Lipases
kTgUptakeLiver		= 1.0;	% TODO
kTgUptakeMuscle		= 1.0;	% TODO
kTgUptakeVAdip		= 1.0;	% TODO
kTgUptakeSCAdip		= 1.0;	% TODO

% Lipid packaging
kLiverFATg			= 1.0;	% TODO


eqInsBase 		= 50e-12 * molarMassIns * InsVd;
eqInsMax 		= 800e-12 * molarMassIns * InsVd;
eqGcnBase 		= 40e-12 * molarMassGcn * GcnVd;
eqGcnMax 		= 180e-12 * molarMassGcn * GcnVd;

% Distribution
% Glucose			% TODO ALL
GluRedistFactor 	= 1.0;
GluShallowFactor 	= 0.6;
GluDeepFactor		= 0.2;

kDGluBodyLiver		= GlukA;							% / h
kDGluLiverBody		= kDGluBodyLiver * GluRedistFactor;
kDGluBodyMuscle		= GlukA / eqInsBase;
kDGluMuscleBody		= kDGluBodyMuscle * GluRedistFactor;
kDGluBodyVAdip		= GluShallowFactor * GlukA;
kDGluVAdipBody		= kDGluBodyVAdip * GluRedistFactor;
kDGluBodySCAdip		= GluDeepFactor * GlukA;
kDGluSCAdipBody		= kDGluBodySCAdip * GluRedistFactor;

% FAs			% TODO ALL
FADistFactor 		= 3.0;
FARedistFactor 		= 1.0;
FAShallowFactor 	= 0.6;
FADeepFactor		= 0.2;

kDFABodyLiver		= FADistFactor * kEFA;							% / h
kDFALiverBody		= kDFABodyLiver * FARedistFactor;
kDFABodyMuscle		= FADistFactor * kEFA;
kDFAMuscleBody		= kDFABodyMuscle * FARedistFactor;
kDFABodyVAdip		= FAShallowFactor * FADistFactor * kEFA;
kDFAVAdipBody		= kDFABodyVAdip * FARedistFactor;
kDFABodySCAdip		= FADeepFactor * FADistFactor * kEFA;
kDFASCAdipBody		= kDFABodySCAdip * FARedistFactor;

% Inputs

% Beta cell action
QInsBase 		= eqInsBase * kEIns;
QGluInsMax 		= eqInsMax * kEIns;					% TODO
QGluInsCenter	= 9.5e-3 * molarMassGlu * GluVd;
QGluInsShape 	= 0.45 * QGluInsCenter;

% Alpha cell action
QGcnBase 		= eqGcnBase * kEGcn;
QGluGcnMax 		= eqGcnMax * kEGcn;					% TODO
QGluGcnCenter	= 3.5e-3 * molarMassGlu * GluVd;
QGluGcnShape 	= 0.3 * QGluGcnCenter;

% Lipase production
QLplBase 			= QInsBase * 1e5;	% TODO
QInsLplMax 			= QGluInsMax * 1e5;	% TODO
QInsLplCenter		= 11.5e-5;			% TODO
QInsLplShape 		= 0.45 * QInsLplCenter;

% Uric acid production
QUricBase 			= 1.0;		% TODO
QAMPUricMax 		= 1.0;		% TODO
QAMPUricShape 		= 1.0;		% TODO
QAMPUricCenter		= 1.0;		% TODO

% Sequestration

eqInsBaseInv = 1/eqInsBase;
eqGcnBaseInv = 1/eqGcnBase;

kLiverGluGly		= 60 * eqInsBaseInv * ...							% TODO
	(8e-6 * molarMassGlu * waterMass) /	(2e-3 * molarMassGlu * GluVd);
kLiverGlyGlu		= 60 * eqGcnBaseInv * ...							% TODO
	(20e-6 * molarMassGlu * waterMass) / (250e-3 * molarMassGlu * GluVd);
kLiverFAEF			= 1.0;	% TODO
kLiverEFFA			= 1.0;	% TODO

kMuscleGluGly		= kLiverGluGly;	% TODO
kMuscleGlyGlu		= kLiverGlyGlu * eqGcnBase;	% TODO
kMuscleFAEF			= kLiverFAEF;	% TODO
kMuscleEFFA			= kLiverEFFA;	% TODO

kVFAStore			= 1.0;	% TODO
kVStoreFA			= 1.0;	% TODO

kSCFAStore			= 1.0;	% TODO
kSCStoreFA			= 1.0;	% TODO

LiverGlyT 			= 0.025;	% [0 1]
LiverGlyCapacity 	= 1000.0;	% g
LiverGluGlyCenter	= 800.0;
LiverGluGlyShape	= (LiverGlyCapacity - LiverGluGlyCenter) / atanh( 2*LiverGlyT - 1 );

MuscleGlyT 			= 0.025;	% [0 1]
MuscleGlyCapacity 	= 3000.0;	% TODO	% g
MuscleGluGlyCenter	= 2000.0;
MuscleGluGlyShape	= (MuscleGlyCapacity - MuscleGluGlyCenter) / atanh( 2*MuscleGlyT - 1 );

VStoreT 			= 0.025;	% [0 1]
VStoreCapacity 		= 3000.0;	%TODO 	% g
VFAStoreCenter 		= 2000.0;
VFAStoreShape 		= (VStoreCapacity - VFAStoreCenter) / atanh( 2*VStoreT - 1 );

VFAT 				= 0.025;	% [0 1]
VInsSatPoint		= 1.0;		% TODO	% g
VStoreFACenter 		= 0.5;		% TODO
VStoreFAShape 		= (VInsSatPoint - VStoreFACenter) / atanh( 2*VFAT - 1 );

SCFAT 				= 0.025;	% [0 1]
SCInsSatPoint		= 1.0;		% TODO	% g
SCStoreFACenter 	= 0.5;		% TODO
SCStoreFAShape 		= (SCInsSatPoint - SCStoreFACenter) / atanh( 2*SCFAT - 1 );

%=========================================================================%
%% GLOBAL

%% -- Globals

model.globals.kLiverGluGly 			= kLiverGluGly;
model.globals.LiverGluGlyCenter 	= LiverGluGlyCenter;
model.globals.LiverGluGlyShape 		= LiverGluGlyShape;

model.globals.kDGluBodyMuscle 		= kDGluBodyMuscle;

model.globals.isDebug 		= true;

model.globals.irCenter 		= 1.0;	% TODO
model.globals.irShape 		= 1.0;	% TODO
model.globals.irLow 		= 0.4;	% OK?
model.globals.irLowLTB4i	= 0.8;	% OK?

%% -- Simulation

% ... %

model.slow.timeSpan 	= [0, 0.3 * 365];		% d
model.fastSpacing 		= 14;

model.fast.timeSpan 	= [0, 5 * 24];				% h
model.fast.maxStep 		= min( doseDuration ) / 2;

model.updateSlow = @( m, inStruct ) pk_final_updateSlow( m, inStruct );
model.updateFast = @( m, inStruct ) pk_final_updateFast( m, inStruct );

%=========================================================================%
%% SLOW MODEL

%%  -- Compartments

% Treatment
x = pk_default_compartment( ); x.displayName = 'Treatment/Met';
x.volume = 1.0; x.initialAmount = 0.0;
model.slow.compartments.met = x;
model.globals.idx_met = length( model.slow.compartments );
x = pk_default_compartment( ); x.displayName = 'Treatment/Su';
x.volume = 1.0; x.initialAmount = 0.0;
model.slow.compartments.su = x;
model.globals.idx_su = length( model.slow.compartments );
x = pk_default_compartment( ); x.displayName = 'Treatment/Tzd';
x.volume = 1.0; x.initialAmount = 0.0;
model.slow.compartments.tzd = x;
model.globals.idx_tzd = length( model.slow.compartments );

x = pk_default_compartment( ); x.displayName = 'Treatment/Exercise';
x.volume = 1.0; x.initialAmount = 0.0;
model.slow.compartments.exercise = x;
model.globals.idx_exercise = length( model.slow.compartments );

x = pk_default_compartment( ); x.displayName = 'Treatment/LTB4I';
x.volume = 1.0; x.initialAmount = 0.0;
model.slow.compartments.ltb4i = x;
model.globals.idx_ltb4i = length( model.slow.compartments );

% Storage
x = pk_default_compartment( ); x.displayName = 'Storage/VF';
x.volume = VAdipStorageVolume; x.initialAmount = VAdipStorageDefault;
model.slow.compartments.vf = x;
x = pk_default_compartment( ); x.displayName = 'Storage/LiverEF';
x.volume = LiverEFVolume; x.initialAmount = LiverEFDefault;
model.slow.compartments.liverEF = x;
x = pk_default_compartment( ); x.displayName = 'Storage/MuscleEF';
x.volume = MuscleEFVolume; x.initialAmount = MuscleEFDefault;
model.slow.compartments.muscleEF = x;

% ... %

% GLUT4 TFs
x = pk_default_compartment( ); x.displayName = 'LTB4/Liver';
x.volume = LTB4Volume; x.initialAmount = LTB4Default;
model.slow.compartments.ltb4liver = x;
model.globals.idx_ltb4liver = length( model.slow.compartments );
x = pk_default_compartment( ); x.displayName = 'LTB4/Muscle';
x.volume = LTB4Volume; x.initialAmount = LTB4Default;
model.slow.compartments.ltb4muscle = x;
model.globals.idx_ltb4muscle = length( model.slow.compartments );
x = pk_default_compartment( ); x.displayName = 'LTB4/VF';
x.volume = LTB4Volume; x.initialAmount = LTB4Default;
model.slow.compartments.ltb4vf = x;
model.globals.idx_ltb4vf = length( model.slow.compartments );

% Beta stuff
x = pk_default_compartment( ); x.displayName = 'Beta/Qmax';
x.volume = BetaFakeVolume; x.initialAmount = BetaQmaxDefault;
model.slow.compartments.betaQmax = x;

x = pk_default_compartment( ); x.displayName = 'Beta/N';
x.volume = BetaFakeVolume; x.initialAmount = BetaNDefault;
model.slow.compartments.betaN = x;

x = pk_default_compartment( ); x.displayName = 'Beta/FactorX';
x.volume = BetaFakeVolume; x.initialAmount = BetaXDefault;
model.slow.compartments.betaX = x;

%% -- Connections

% Degradation
x = pk_default_connection( ); x.from = 'met'; x.to = '';
x.linker = pk_linear_linker( kETreatment );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'su'; x.to = '';
x.linker = pk_linear_linker( kETreatment );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'tzd'; x.to = '';
x.linker = pk_linear_linker( kETreatment );
model.slow.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'exercise'; x.to = '';
x.linker = pk_linear_linker( kETreatment );
model.slow.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'ltb4i'; x.to = '';
x.linker = pk_linear_linker( kETreatment );
model.slow.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'ltb4liver'; x.to = '';
x.linker = pk_linear_linker( kELTB4 );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'ltb4muscle'; x.to = '';
x.linker = pk_linear_linker( kELTB4 );
model.slow.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'ltb4vf'; x.to = '';
x.linker = pk_linear_linker( kELTB4 );
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

% Regimen
x = pk_default_input( ); x.target = 'met';
x.flow = pk_constant_flow( QTreatment, tripleStart, tripleEnd );
model.slow.inputs{ end + 1 } = x;
x = pk_default_input( ); x.target = 'su';
x.flow = pk_constant_flow( QTreatment, tripleStart, tripleEnd );
model.slow.inputs{ end + 1 } = x;
x = pk_default_input( ); x.target = 'tzd';
x.flow = pk_constant_flow( QTreatment, tripleStart, tripleEnd );
model.slow.inputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'exercise';
x.flow = pk_constant_flow( QTreatment, deStart, deEnd );
model.slow.inputs{ end + 1 } = x;

x = pk_default_input( ); x.target = 'ltb4i';
x.flow = pk_constant_flow( QTreatment, ltbStart, ltbEnd );
model.slow.inputs{ end + 1 } = x;

% Accumulation
x = pk_default_input( ); x.target = 'vf';
x.flow = pk_constant_flow( QVFBase );
model.slow.inputs{ end + 1 } = x;
model.globals.idx_inputVF = length( model.slow.inputs );
x = pk_default_input( ); x.target = 'muscleEF';
x.flow = pk_constant_flow( QMuscleEFBase );
model.slow.inputs{ end + 1 } = x;
model.globals.idx_inputVF = length( model.slow.inputs );
x = pk_default_input( ); x.target = 'liverEF';
x.flow = pk_constant_flow( QLiverEFBase );
model.slow.inputs{ end + 1 } = x;
model.globals.idx_inputVF = length( model.slow.inputs );

% Baseline hormone production
x = pk_default_input( ); x.target = 'ltb4liver';
x.flow = pk_constant_flow( QLTB4Base );
model.slow.inputs{ end + 1 } = x;
x = pk_default_input( ); x.target = 'ltb4muscle';
x.flow = pk_constant_flow( QLTB4Base );
model.slow.inputs{ end + 1 } = x;
x = pk_default_input( ); x.target = 'ltb4vf';
x.flow = pk_constant_flow( QLTB4Base );
model.slow.inputs{ end + 1 } = x;

% Hormone secretion
x = pk_default_sdinput( ); x.input = { 'liverEF' }; x.target = 'ltb4liver';
x.flow = pk_tanh_sd_flow( QLiverEFLTB4Max, QLiverEFLTB4Shape, QLiverEFLTB4Center );
model.slow.sdinputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'muscleEF' }; x.target = 'ltb4muscle';
x.flow = pk_tanh_sd_flow( QMuscleEFLTB4Max, QMuscleEFLTB4Shape, QMuscleEFLTB4Center );
model.slow.sdinputs{ end + 1 } = x;
x = pk_default_sdinput( ); x.input = { 'vf' }; x.target = 'ltb4vf';
x.flow = pk_tanh_sd_flow( QVFLTB4Max, QVFLTB4Shape, QVFLTB4Center );
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
x = pk_default_compartment( ); x.displayName = 'Behavior/Activity';
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
x = pk_default_compartment( ); x.displayName = 'Body/Tg';
x.volume = TgVd; x.initialAmount = BodyTgDefault;
model.fast.compartments.bodyTg = x;
x = pk_default_compartment( ); x.displayName = 'Body/FA';
x.volume = FAVd; x.initialAmount = BodyFADefault;
model.fast.compartments.bodyFA = x;
x = pk_default_compartment( ); x.displayName = 'Body/FAb';
x.volume = FAVd; x.initialAmount = BodyFAbDefault;
model.fast.compartments.bodyFAb = x;
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
x.volume = LiverEFVolume; x.initialAmount = LiverEFDefault;
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
x.volume = MuscleEFVolume; x.initialAmount = MuscleEFDefault;
model.fast.compartments.muscleEF = x;
% Visceral fat
x = pk_default_compartment( ); x.displayName = 'VAdip/Glu';
x.volume = VAdipGluVolume; x.initialAmount = VAdipGluDefault;
model.fast.compartments.vGlu = x;
x = pk_default_compartment( ); x.displayName = 'VAdip/FA';
x.volume = VAdipFAVolume; x.initialAmount = VAdipFADefault;
model.fast.compartments.vFA = x;
x = pk_default_compartment( ); x.displayName = 'VAdip/Storage';
x.volume = VAdipStorageVolume; x.initialAmount = VAdipStorageDefault;
model.fast.compartments.vStorage = x;
% SC Fat
x = pk_default_compartment( ); x.displayName = 'SCAdip/Glu';
x.volume = SCAdipGluVolume; x.initialAmount = SCAdipGluDefault;
model.fast.compartments.scGlu = x;
x = pk_default_compartment( ); x.displayName = 'SCAdip/FA';
x.volume = SCAdipFAVolume; x.initialAmount = SCAdipFADefault;
model.fast.compartments.scFA = x;
x = pk_default_compartment( ); x.displayName = 'SCAdip/Storage';
x.volume = SCAdipStorageVolume; x.initialAmount = SCAdipStorageDefault;
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
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giFA'; x.to = 'bodyTg';
x.linker = pk_linear_linker( FATgkA );
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
x = pk_default_connection( ); x.from = 'bodyFA'; x.to = '';
x.linker = pk_linear_linker( kEFA );	% TODO
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyLpl'; x.to = '';
x.linker = pk_linear_linker( kELpl );	% TODO
model.fast.connections{ end + 1 } = x;

% Clearance - Metabolism
x = pk_default_connection( ); x.from = 'liverGlu'; x.to = '';
x.linker = pk_linear_linker( kEmGluLiverBase );
model.fast.connections{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'liverGlu', 'activity' }; x.depletes = [true, false];
x.to = { '' }; % TODO
x.linker = pk_product_linker( kEmGluLiverActive );
model.fast.interactions{ end + 1 } = x;
% ... FA? ... %

x = pk_default_connection( ); x.from = 'muscleGlu'; x.to = '';
x.linker = pk_linear_linker( kEmGluMuscleBase );
model.fast.connections{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'muscleGlu', 'activity' }; x.depletes = [true, false];
x.to = { '' }; % TODO
x.linker = pk_product_linker( kEmGluMuscleActive );
model.fast.interactions{ end + 1 } = x;
% ... FA? ... %

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
model.fast.interactions{ end + 1 } = x;

% Lipid uptake via Lipases
x = pk_default_interaction( );
x.from = { 'bodyTg', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'liverFA' };
x.linker = pk_product_linker( kTgUptakeLiver );
model.fast.interactions{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyTg', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'muscleFA' };
x.linker = pk_product_linker( kTgUptakeMuscle );
model.fast.interactions{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyTg', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'vFA' };
x.linker = pk_product_linker( kTgUptakeVAdip );
model.fast.interactions{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyTg', 'bodyLpl' }; x.depletes = [true, false]; 
x.to = { 'scFA' };
x.linker = pk_product_linker( kTgUptakeSCAdip );
model.fast.interactions{ end + 1 } = x;

% Lipid release
x = pk_default_connection( ); x.from = 'liverFA'; x.to = 'bodyTg';
x.linker = pk_linear_linker( kLiverFATg );
model.fast.connections{ end + 1 } = x;

%% -- Sequestration

% Liver
x = pk_default_interaction( );
x.from = { 'liverGly', 'liverGlu', 'bodyIns' }; x.depletes = [false, true, false];
x.to = { 'liverGly' };
x.linker = pk_product_tanh_linker( kLiverGluGly, LiverGluGlyCenter, LiverGluGlyShape );
model.fast.interactions{ end + 1 } = x;
model.globals.idx_intLiverGluGly = length( model.fast.interactions );
x = pk_default_interaction( );
x.from = { 'liverGly', 'bodyGcn' }; x.depletes = [true, false];
x.to = { 'liverGlu' };
x.linker = pk_product_linker( kLiverGlyGlu );
model.fast.interactions{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'liverFA'; x.to = 'liverEF';
x.linker = pk_linear_linker( kLiverFAEF );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'liverEF'; x.to = 'liverFA';
x.linker = pk_linear_linker( kLiverEFFA );
model.fast.connections{ end + 1 } = x;

% Muscle
x = pk_default_interaction( );
x.from = { 'muscleGly', 'muscleGlu' }; x.depletes = [false, true];
x.to = { 'muscleGly' };
x.linker = pk_product_tanh_linker( kMuscleGluGly, MuscleGluGlyCenter, MuscleGluGlyShape );
model.fast.interactions{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'muscleGly'; x.to = 'muscleGlu';
x.linker = pk_linear_linker( kMuscleGlyGlu );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'muscleFA'; x.to = 'muscleEF';
x.linker = pk_linear_linker( kMuscleFAEF );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'muscleEF'; x.to = 'muscleFA';
x.linker = pk_linear_linker( kMuscleEFFA );
model.fast.connections{ end + 1 } = x;

% VF
x = pk_default_interaction( );
x.from = { 'vStorage', 'vFA' }; x.depletes = [false, true];
x.to = { 'vStorage' };
x.linker = pk_product_tanh_linker( kVFAStore, VFAStoreCenter, VFAStoreShape );
model.fast.interactions{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyIns', 'vStorage' }; x.depletes = [false, true];
x.to = { 'vFA' };
x.linker = pk_product_tanh_linker( kVStoreFA, VStoreFACenter, VStoreFAShape );
model.fast.interactions{ end + 1 } = x;

% SCF
x = pk_default_connection( ); x.from = 'scFA'; x.to = 'scStorage';
x.linker = pk_linear_linker( kSCFAStore );
model.fast.connections{ end + 1 } = x;
x = pk_default_interaction( );
x.from = { 'bodyIns', 'scStorage' }; x.depletes = [false, true];
x.to = { 'scFA' };
x.linker = pk_product_tanh_linker( kSCStoreFA, SCStoreFACenter, SCStoreFAShape );
model.fast.interactions{ end + 1 } = x;

%% -- Distribution

% Glucose
x = pk_default_connection( ); x.from = 'bodyGlu'; x.to = 'liverGlu';
x.linker = pk_linear_linker( kDGluBodyLiver );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'liverGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kDGluLiverBody );
model.fast.connections{ end + 1 } = x;

x = pk_default_interaction( );
x.from = { 'bodyGlu', 'bodyIns' }; x.depletes = [true, false];
x.to = { 'muscleGlu' };
x.linker = pk_product_linker( kDGluBodyMuscle );
model.fast.interactions{ end + 1 } = x;
model.globals.idx_intDGluBodyMuscle = length( model.fast.interactions );
x = pk_default_connection( ); x.from = 'muscleGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kDGluMuscleBody );
model.fast.connections{ end + 1 } = x;

x = pk_default_interaction( );
x.from = { 'bodyGlu', 'bodyIns' }; x.depletes = [true, false];
x.to = { 'vGlu' };
x.linker = pk_product_linker( kDGluBodyVAdip );
model.fast.interactions{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'vGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kDGluVAdipBody );
model.fast.connections{ end + 1 } = x;

x = pk_default_interaction( );
x.from = { 'bodyGlu', 'bodyIns' }; x.depletes = [true, false];
x.to = { 'scGlu' };
x.linker = pk_product_linker( kDGluBodySCAdip );
model.fast.interactions{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'scGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kDGluSCAdipBody );
model.fast.connections{ end + 1 } = x;

% FAs
x = pk_default_connection( ); x.from = 'bodyFA'; x.to = 'liverFA';
x.linker = pk_linear_linker( kDFABodyLiver );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'liverFA'; x.to = 'bodyFA';
x.linker = pk_linear_linker( kDFALiverBody );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'bodyFA'; x.to = 'muscleFA';
x.linker = pk_linear_linker( kDFABodyMuscle );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'muscleFA'; x.to = 'bodyFA';
x.linker = pk_linear_linker( kDFAMuscleBody );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'bodyFA'; x.to = 'vFA';
x.linker = pk_linear_linker( kDFABodyVAdip );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'vFA'; x.to = 'bodyFA';
x.linker = pk_linear_linker( kDFAVAdipBody );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( ); x.from = 'bodyFA'; x.to = 'scFA';
x.linker = pk_linear_linker( kDFABodySCAdip );
model.fast.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'scFA'; x.to = 'bodyFA';
x.linker = pk_linear_linker( kDFASCAdipBody );
model.fast.connections{ end + 1 } = x;

%% -- Inputs

% Eating
for i = 1:dosesPerDay

	x = pk_default_input( ); x.target = 'giGlu';
	x.flow = pk_pulsed_flow( doseGlu(i), doseDuration(i), 24, -1, doseOffsets(i) );
	model.fast.inputs{ end + 1 } = x;
	x = pk_default_input( ); x.target = 'giFru';
	x.flow = pk_pulsed_flow( doseFru(i), doseDuration(i), 24, -1, doseOffsets(i) );
	model.fast.inputs{ end + 1 } = x;
	x = pk_default_input( ); x.target = 'giTg';
	x.flow = pk_pulsed_flow( doseTg(i), doseDuration(i), 24, -1, doseOffsets(i) );
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
x = pk_default_sdinput( ); x.input = { 'liverAMP' }; x.target = 'liverUric';
x.flow = pk_tanh_sd_flow( QAMPUricMax, QAMPUricShape, QAMPUricCenter );
model.fast.sdinputs{ end + 1 } = x;























