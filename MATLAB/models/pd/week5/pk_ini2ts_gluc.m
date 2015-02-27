%=========================================================================%
% Pharmacokinetic 2TS Model
% => Glucose
% 
% [Authors]
% Spring 2015
%=========================================================================%

%% Pathology

absorptionFactor = 1.0;

insResistFactor = 1.0;
betaDecayFactor = 1.0;


%% Physical constants

molarMassGlu = 180.16;	% g / mol
molarMassIns = 5808;
molarMassGcn = 3485;


%% Parameters

% -- Global

% About the patient
patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]
waterMass 		= waterFraction * patientMass;
fatVFraction    = 0.10;     % [0 1]
fatVMass        = fatVFraction * patientMass;

% -- Slow

% Normal levels
normalGlut4TF   = 1.0;  % a.u.

% "Sink" terms
kEGlut4TF       = log(2) / 15;      % / day
kEFatV          = log(2) / 60;

% "Source" terms
qGlut4TFMax     = kEGlut4TF * normalGlut4TF;    % TODO
qGlut4TFBase    = qGlut4TFMax * 0.1;
glut4TFShape    = 3.0;
glut4TFCenter   = fatVMass * 1.5;

qInFatVBase     = kEFatV * fatVMass;            % TODO
qInFatVMax      = qInFatVBase * 2.0;

% Fast

liverMass = 1.5e3;		% g
glycogenPerMass = 65e-3; % g / g
glycogenMass = glycogenPerMass * liverMass * 10; % g

fracFruGlu = 0.35;		% 0.27 - 0.37

doseGlu = 30;			% g
doseFru = 30 / fracFruGlu;			% g
doseDuration = 30 / 60;	% hr
doseSpacing = 8;		% hr

kAGlu = absorptionFactor * 0.205 * 60;		% / hr
kAFru = kAGlu;			% TODO

kEGlu = 0.0141 * 60;	% / hr
kEFru = kEGlu;			% TODO
kEIns = 0.09 * 60;		% / hr
kEGcn = 2.29;			% / hr

kErGlu = kEGlu;
kErFru = kEFru * (1 - fracFruGlu);
kErIns = kEIns;
kErGcn = kEGcn;

kFruGlu = kEFru * fracFruGlu;

Vgi = 1;				% L
VdGlu = 7.24;
VdFru = 7.24;
VdIns = 15.6;
VdGcn = 0.19 * waterMass;
VtGly = 1;

eqInsBase = 50e-12 * molarMassIns * VdIns;
eqGcnBase = 40e-12 * molarMassGcn * VdGcn;
qInsBase = eqInsBase * kEIns;
qGcnBase = eqGcnBase * kEGcn;

eqInsMax = 800e-12 * molarMassIns * VdIns;
eqGcnMax = 180e-12 * molarMassGcn * VdGcn;
qInsMax = betaDecayFactor * eqInsMax * kEIns;
qGcnMax = eqGcnMax * kEGcn;

xFactor1 = 1 / eqInsBase;
xFactor2 = 1 / eqGcnBase;
kGluGly = insResistFactor * xFactor1 * (8e-6 * molarMassGlu * waterMass) / (2e-3 * molarMassGlu * VdGlu) * 60;
kGlyGlu = xFactor2 * (20e-6 * molarMassGlu * waterMass) / (250e-3 * molarMassGlu * VdGlu) * 60;

betaCenter = 8e-3 * molarMassGlu * VdGlu;
alphaCenter = 3.5e-3 * molarMassGlu * VdGlu;
betaShape = betaCenter;
alphaShape = alphaCenter;

%=========================================================================%
%% GLOBAL

% For slow update
model.globals.kFruGlu       = kFruGlu;
model.globals.fruIdx        = 4;
model.globals.qInFatVBase   = qInFatVBase;
model.globals.qInFatVMax    = qInFatVMax;

% For fast update
model.globals.kGluGly       = kGluGly;
model.globals.glut4tfIdx    = 1;

model.slow.timeSpan = [0 365];
model.fast.timeSpan = [0 3*24];

model.fastSpacing = 14;

model.updateSlow = @( m, inStruct ) pk_gluc_updateSlow( m, inStruct );
model.updateFast = @( m, inStruct ) pk_gluc_updateFast( m, inStruct );

%=========================================================================%
%% SLOW MODEL

%% Compartments

% GLUT4 TFs
x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = 1.0;
x.displayName = 'GLUT4 TFs';
model.slow.compartments.glut4tf = x;

% Visceral fat
x = pk_default_compartment( );
x.volume = Vgi;
x.initialAmount = fatVMass;
x.displayName = 'Fat (V)';
model.slow.compartments.fatV = x;


%% Connections

% Degradation
x = pk_default_connection( );
x.from = 'glut4tf';
x.to = '';
x.linker = pk_linear_linker( kEGlut4TF );
model.slow.connections{ end + 1 } = x;

% Exercise
x = pk_default_connection( );
x.from = 'fatV';
x.to = '';
x.linker = pk_linear_linker( kEFatV );
model.slow.connections{ end + 1 } = x;


%% Inputs

% Eating
x = pk_default_input( );
x.target = 'fatV';
x.flow = pk_constant_flow( qInFatVBase );
model.slow.inputs{ end + 1 } = x;
model.globals.idx_inputFatV = length(model.slow.inputs);

% TF Production
x = pk_default_input( );
x.target = 'glut4tf';
x.flow = pk_constant_flow( qGlut4TFBase );
model.slow.inputs{ end + 1 } = x;
x = pk_default_sdinput( );
x.input = { 'fatV' };
x.target = 'glut4tf';
x.flow = pk_tanh_sd_flow( (qGlut4TFMax - qGlut4TFBase), -glut4TFShape, glut4TFCenter );
model.slow.sdinputs{ end + 1 } = x;


%=========================================================================%
%% FAST MODEL

%% Compartments

% GI Tract
x = pk_default_compartment( );
x.volume = Vgi;
x.initialAmount = 0;
x.displayName = 'GI GLU';
model.fast.compartments.giGlu = x;

x = pk_default_compartment( );
x.volume = Vgi;
x.initialAmount = 0;
x.displayName = 'GI FRU';
model.fast.compartments.giFru = x;

% Central compartment
x = pk_default_compartment( );
x.volume = VdGlu;
x.initialAmount = 0;
x.displayName = 'Body GLU';
model.fast.compartments.bodyGlu = x;

x = pk_default_compartment( );
x.volume = VdFru;
x.initialAmount = 0;
x.displayName = 'Body FRU';
model.fast.compartments.bodyFru = x;

x = pk_default_compartment( );
x.volume = VdIns;
x.initialAmount = 0;
x.displayName = 'Body INS';
model.fast.compartments.bodyIns = x;

x = pk_default_compartment( );
x.volume = VdGcn;
x.initialAmount = 0;
x.displayName = 'Body GCN';
model.fast.compartments.bodyGcn = x;

% Tissues
x = pk_default_compartment( );
x.volume = VtGly;
x.initialAmount = glycogenMass;
x.displayName = 'Tissue GLY';
model.fast.compartments.tissueGly = x;


%% Connections

% Absorption
x = pk_default_connection( );
x.from = 'giGlu';
x.to = 'bodyGlu';
x.linker = pk_linear_linker( kAGlu );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'giFru';
x.to = 'bodyFru';
x.linker = pk_linear_linker( kAFru );
model.fast.connections{ end + 1 } = x;

% Renal clearance
x = pk_default_connection( );
x.from = 'bodyGlu';
x.to = '';
x.linker = pk_linear_linker( kErGlu );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'bodyFru';
x.to = '';
x.linker = pk_linear_linker( kErFru );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'bodyIns';
x.to = '';
x.linker = pk_linear_linker( kErIns );
model.fast.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'bodyGcn';
x.to = '';
x.linker = pk_linear_linker( kErGcn );
model.fast.connections{ end + 1 } = x;

% Conversion of FRU to GLU
x = pk_default_connection( );
x.from = 'bodyFru';
x.to = 'bodyGlu';
x.linker = pk_linear_linker( kFruGlu );
model.fast.connections{ end + 1 } = x;


%% Interactions

% Body GLU -> Tissue GLY
x = pk_default_interaction( );
x.from = {'bodyGlu', 'bodyIns'};
x.depletes = [true false];
x.to = {'tissueGly'};
x.linker = pk_product_linker( kGluGly );
model.fast.interactions{ end + 1 } = x;
model.globals.idx_intGluGly = length(model.fast.interactions);

% Tissue GLY -> Body Glu
x = pk_default_interaction( );
x.from = {'tissueGly', 'bodyGcn'};
x.depletes = [true false];
x.to = {'bodyGlu'};
x.linker = pk_product_linker( kGlyGlu );
model.fast.interactions{ end + 1 } = x;


%% Inputs

% Eating
x = pk_default_input( );
x.target = 'giGlu';
x.flow = pk_pulsed_flow( doseGlu, doseDuration, doseSpacing );
model.fast.inputs{ end + 1 } = x;
x = pk_default_input( );
x.target = 'giFru';
x.flow = pk_pulsed_flow( doseFru, doseDuration, doseSpacing );
model.fast.inputs{ end + 1 } = x;


% Hormone production
x = pk_default_input( );
x.target = 'bodyIns';
x.flow = pk_constant_flow( qInsBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( );
x.input = { 'bodyGlu' };
x.target = 'bodyIns';
x.flow = pk_tanh_sd_flow( (qInsMax - qInsBase), betaShape, betaCenter );
model.fast.sdinputs{ end + 1 } = x;

x = pk_default_input( );
x.target = 'bodyGcn';
x.flow = pk_constant_flow( qGcnBase );
model.fast.inputs{ end + 1 } = x;
x = pk_default_sdinput( );
x.input = { 'bodyGlu' };
x.target = 'bodyGcn';
x.flow = pk_tanh_sd_flow( (qGcnMax - qGcnBase), -alphaShape, alphaCenter );
model.fast.sdinputs{ end + 1 } = x;


















