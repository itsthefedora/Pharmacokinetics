%=========================================================================%
% Pharmacokinetic Model
% => Glucose 
% 
% [Authors]
% Fall 2014
%=========================================================================%


%% Pathology

absorptionFactor = 0.25;

insResistFactor = 0.3;
betaDecayFactor = 1.2;


%% Physical constants

molarMassGlu = 180.16;	% g / mol
molarMassIns = 5808;
molarMassGcn = 3485;


%% Parameters

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]
waterMass 		= waterFraction * patientMass;

liverMass = 1.5e3;		% g
glycogenPerMass = 65e-3; % g / g
glycogenMass = glycogenPerMass * liverMass * 10; % g

fracFruGlu = 0.35;		% 0.27 - 0.37

doseGlu = 30;			% g
doseFru = 0 / fracFruGlu;			% g
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


%% Set-up simulation

model.timeSpan = [ 0 24 ];


%% Compartments

% GI Tract
x = pk_default_compartment( );
x.volume = Vgi;
x.initialAmount = 0;
x.displayName = 'GI GLU';
model.compartments.giGlu = x;

x = pk_default_compartment( );
x.volume = Vgi;
x.initialAmount = 0;
x.displayName = 'GI FRU';
model.compartments.giFru = x;

% Central compartment
x = pk_default_compartment( );
x.volume = VdGlu;
x.initialAmount = 0;
x.displayName = 'Body GLU';
model.compartments.bodyGlu = x;

x = pk_default_compartment( );
x.volume = VdFru;
x.initialAmount = 0;
x.displayName = 'Body FRU';
model.compartments.bodyFru = x;

x = pk_default_compartment( );
x.volume = VdIns;
x.initialAmount = 0;
x.displayName = 'Body INS';
model.compartments.bodyIns = x;

x = pk_default_compartment( );
x.volume = VdGcn;
x.initialAmount = 0;
x.displayName = 'Body GCN';
model.compartments.bodyGcn = x;

% Tissues
x = pk_default_compartment( );
x.volume = VtGly;
x.initialAmount = glycogenMass;
x.displayName = 'Tissue GLY';
model.compartments.tissueGly = x;


%% Connections

% Absorption
x = pk_default_connection( );
x.from = 'giGlu';
x.to = 'bodyGlu';
x.linker = pk_linear_linker( kAGlu );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'giFru';
x.to = 'bodyFru';
x.linker = pk_linear_linker( kAFru );
model.connections{ end + 1 } = x;

% Renal clearance
x = pk_default_connection( );
x.from = 'bodyGlu';
x.to = '';
x.linker = pk_linear_linker( kErGlu );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'bodyFru';
x.to = '';
x.linker = pk_linear_linker( kErFru );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'bodyIns';
x.to = '';
x.linker = pk_linear_linker( kErIns );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'bodyGcn';
x.to = '';
x.linker = pk_linear_linker( kErGcn );
model.connections{ end + 1 } = x;

% Conversion of FRU to GLU
x = pk_default_connection( );
x.from = 'bodyFru';
x.to = 'bodyGlu';
x.linker = pk_linear_linker( kFruGlu );
model.connections{ end + 1 } = x;


%% Interactions

% Body GLU -> Tissue GLY
x = pk_default_interaction( );
x.from = {'bodyGlu', 'bodyIns'};
x.depletes = [true false];
x.to = {'tissueGly'};
x.linker = pk_product_linker( kGluGly );
model.interactions{ end + 1 } = x;

% Tissue GLY -> Body Glu
x = pk_default_interaction( );
x.from = {'tissueGly', 'bodyGcn'};
x.depletes = [true false];
x.to = {'bodyGlu'};
x.linker = pk_product_linker( kGlyGlu );
model.interactions{ end + 1 } = x;


%% Inputs

% Eating
x = pk_default_input( );
x.target = 'giGlu';
x.flow = pk_pulsed_flow( doseGlu, doseDuration, doseSpacing );
model.inputs{ end + 1 } = x;
x = pk_default_input( );
x.target = 'giFru';
x.flow = pk_pulsed_flow( doseFru, doseDuration, doseSpacing );
model.inputs{ end + 1 } = x;


% Hormone production
x = pk_default_input( );
x.target = 'bodyIns';
x.flow = pk_constant_flow( qInsBase );
model.inputs{ end + 1 } = x;

x = pk_default_sdinput( );
x.input = { 'bodyGlu' };
x.target = 'bodyIns';
x.flow = pk_tanh_sd_flow( (qInsMax - qInsBase), betaShape, betaCenter );
model.sdinputs{ end + 1 } = x;

x = pk_default_input( );
x.target = 'bodyGcn';
x.flow = pk_constant_flow( qGcnBase );
model.inputs{ end + 1 } = x;

x = pk_default_sdinput( );
x.input = { 'bodyGlu' };
x.target = 'bodyGcn';
x.flow = pk_tanh_sd_flow( (qGcnMax - qGcnBase), -alphaShape, alphaCenter );
model.sdinputs{ end + 1 } = x;


















