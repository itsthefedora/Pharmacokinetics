%=========================================================================%
% Pharmacokinetic Model
% => Glucose 
% 
% [Authors]
% Fall 2014
%=========================================================================%


%% Pathology

absorptionFactor    = 2.0;  %0.25;

insResistFactor     = 1.0;  %0.3;   % 0.5
betaDecayFactor     = 1.0;  %1.2;   % 1.8

desequestFactor     = 1.0;


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

doseGlu = 60;			% g
doseFru = 0 / fracFruGlu;			% g
doseDuration = 30 / 60;	% hr
doseSpacing = 8;		% hr

kAGlu = absorptionFactor * 0.205 * 60;		% / hr
kAFru = kAGlu;			% TODO

kEGlu = 0.0141 * 60;	% / hr
kEFru = kEGlu;			% TODO
kEIns = 0.09 * 60;		% / hr
kEGcn = 2.29;			% / hr


% ******************************
% ** TODO: FIND ALL OF THESE. **
deepFactor      = 0.2;       % TODO: Be more nuanced
distFactor      = 3.0;
redistFactor    = 1.0;

kDSGlu = kAGlu;
kRSGlu = kDSGlu * redistFactor;
kDDGlu = kDSGlu * deepFactor;
kRDGlu = kRSGlu * deepFactor;
kDSIns = kEIns * distFactor;
kRSIns = kDSIns * redistFactor;
kDDIns = kDSIns * deepFactor;
kRDIns = kRSIns * deepFactor;
kDSGcn = kEGcn * distFactor;
kRSGcn = kDSGcn * redistFactor;
kDDGcn = kDSGcn * deepFactor;
kRDGcn = kRSGcn * deepFactor;
% ******************************


kErGlu = kEGlu;
kErFru = kEFru * (1 - fracFruGlu);
kErIns = kEIns;
kErGcn = kEGcn;

kFruGlu = kEFru * fracFruGlu;

Vgi     = 1;				% L
VdGlu   = 7.24;
VdFru   = 7.24;
VdIns   = 15.6;
VdGcn   = 0.19 * waterMass;
VtGly   = 1;

eqInsBase   = 50e-12 * molarMassIns * VdIns;
eqGcnBase   = 40e-12 * molarMassGcn * VdGcn;
qInsBase    = eqInsBase * kEIns;
qGcnBase    = eqGcnBase * kEGcn;

eqInsMax    = 800e-12 * molarMassIns * VdIns;
eqGcnMax    = 180e-12 * molarMassGcn * VdGcn;
qInsMax     = betaDecayFactor * eqInsMax * kEIns;
qGcnMax     = eqGcnMax * kEGcn;

xFactor1    = 1 / eqInsBase;
xFactor2    = 1 / eqGcnBase;
kGluGly     = insResistFactor * xFactor1 * (8e-6 * molarMassGlu * waterMass) / (2e-3 * molarMassGlu * VdGlu) * 60;
kGlyGlu     = desequestFactor * xFactor2 * (20e-6 * molarMassGlu * waterMass) / (250e-3 * molarMassGlu * VdGlu) * 60;

% TODO: Find
KmInsGluGly     = 0.5 * 2e-5;
VmaxInsGluGly   = KmInsGluGly * kGluGly;

betaCenter  = 9.5e-3 * molarMassGlu * VdGlu;
alphaCenter = 3.5e-3 * molarMassGlu * VdGlu;
% TODO: Find
betaShape   = 0.45 * betaCenter;
alphaShape  = 0.3 * alphaCenter;


% ******************************
% ** TODO: FIND ALL OF THESE. **
kGluFat = kGluGly;
kFatGlu = kGlyGlu;
% ******************************

%=========================================================================%


%% Set-up simulation

model.timeSpan  = [ 0 3*24 ];
model.maxStep   = doseDuration / 2;


%% Compartments

% GI Tract
x = pk_default_compartment( );
x.volume = Vgi; x.initialAmount = 0; x.displayName = 'GI GLU';
model.compartments.giGlu = x;
x = pk_default_compartment( );
x.volume = Vgi; x.initialAmount = 0; x.displayName = 'GI FRU';
model.compartments.giFru = x;

% Liver metabolites
% TODO: Implement
%x = pk_default_compartment( );
%x.volume = 1; x.initialAmount = 0; x.displayName = 'Liver ATP';
%model.compartments.liverATP = x;
%x = pk_default_compartment( );
%x.volume = 1; x.initialAmount = 0; x.displayName = 'Liver cAMP';
%model.compartments.livercAMP = x;

% Central compartment
x = pk_default_compartment( );
x.volume = VdGlu; x.initialAmount = 0; x.displayName = 'Body GLU';
model.compartments.bodyGlu = x;
x = pk_default_compartment( );
x.volume = VdFru; x.initialAmount = 0; x.displayName = 'Body FRU';
model.compartments.bodyFru = x;
x = pk_default_compartment( );
x.volume = VdIns; x.initialAmount = 0; x.displayName = 'Body INS';
model.compartments.bodyIns = x;
x = pk_default_compartment( );
x.volume = VdGcn; x.initialAmount = 0; x.displayName = 'Body GCN';
model.compartments.bodyGcn = x;

% Shallow compartment
x = pk_default_compartment( );
x.volume = VdGlu; x.initialAmount = 0; x.displayName = 'Close GLU';
model.compartments.closeGlu = x;
x = pk_default_compartment( );
x.volume = VdIns; x.initialAmount = 0; x.displayName = 'Close INS';
model.compartments.closeIns = x;
x = pk_default_compartment( );
x.volume = VdGcn; x.initialAmount = 0; x.displayName = 'Close GCN';
model.compartments.closeGcn = x;

% Deep compartment
x = pk_default_compartment( );
x.volume = VdGlu; x.initialAmount = 0; x.displayName = 'Deep GLU';
model.compartments.deepGlu = x;
x = pk_default_compartment( );
x.volume = VdIns; x.initialAmount = 0; x.displayName = 'Deep INS';
model.compartments.deepIns = x;
x = pk_default_compartment( );
x.volume = VdGcn; x.initialAmount = 0; x.displayName = 'Deep GCN';
model.compartments.deepGcn = x;

% "Sequestered" regions
x = pk_default_compartment( );
x.volume = VtGly;
x.initialAmount = glycogenMass;
x.displayName = 'Tissue GLY';
model.compartments.tissueGly = x;

x = pk_default_compartment( );
x.volume = VtGly;
x.initialAmount = glycogenMass;
x.displayName = 'Visc. Fat';
model.compartments.viscFat = x;

x = pk_default_compartment( );
x.volume = VtGly;
x.initialAmount = glycogenMass;
x.displayName = 'SC Fat';
model.compartments.scFat = x;


%% Connections

% Absorption
x = pk_default_connection( ); x.from = 'giGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kAGlu );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giFru'; x.to = 'bodyFru';
x.linker = pk_linear_linker( kAFru );
model.connections{ end + 1 } = x;

% Renal clearance
x = pk_default_connection( ); x.from = 'bodyGlu'; x.to = '';
x.linker = pk_linear_linker( kErGlu );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyFru'; x.to = '';
x.linker = pk_linear_linker( kErFru );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyIns'; x.to = '';
x.linker = pk_linear_linker( kErIns );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyGcn'; x.to = '';
x.linker = pk_linear_linker( kErGcn );
model.connections{ end + 1 } = x;

% Distribution
% GLU
x = pk_default_connection( ); x.from = 'bodyGlu'; x.to = 'closeGlu';
x.linker = pk_linear_linker( kDSGlu );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'closeGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kRSGlu );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyGlu'; x.to = 'deepGlu';
x.linker = pk_linear_linker( kDDGlu );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'deepGlu'; x.to = 'bodyGlu';
x.linker = pk_linear_linker( kRDGlu );
model.connections{ end + 1 } = x;
% INS
x = pk_default_connection( ); x.from = 'bodyIns'; x.to = 'closeIns';
x.linker = pk_linear_linker( kDSIns );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'closeIns'; x.to = 'bodyIns';
x.linker = pk_linear_linker( kRSIns );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyIns'; x.to = 'deepIns';
x.linker = pk_linear_linker( kDDIns );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'deepIns'; x.to = 'bodyIns';
x.linker = pk_linear_linker( kRDIns );
model.connections{ end + 1 } = x;
% GCN
x = pk_default_connection( ); x.from = 'bodyGcn'; x.to = 'closeGcn';
x.linker = pk_linear_linker( kDSGcn );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'closeGcn'; x.to = 'bodyGcn';
x.linker = pk_linear_linker( kRSGcn );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'bodyGcn'; x.to = 'deepGcn';
x.linker = pk_linear_linker( kDDGcn );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'deepGcn'; x.to = 'bodyGcn';
x.linker = pk_linear_linker( kRDGcn );
model.connections{ end + 1 } = x;

% Conversion of FRU to GLU
x = pk_default_connection( );
x.from = 'bodyFru';
x.to = 'bodyGlu';
x.linker = pk_linear_linker( kFruGlu );
model.connections{ end + 1 } = x;


%% Interactions

% Central

% Body GLU -> Tissue GLY
x = pk_default_interaction( );
x.from = {'bodyGlu', 'bodyIns'};
x.depletes = [true false];
x.to = {'tissueGly'};
% Select liver linker type
if true
    x.linker = pk_product_linker( kGluGly );
else
    params = struct;
    params.isMM = [false true];
    params.Vmax = [VmaxInsGluGly];
    params.Km = [KmInsGluGly];
    x.linker = pk_product_mm_linker( 1, params );
end
model.interactions{ end + 1 } = x;

% Tissue GLY -> Body Glu
x = pk_default_interaction( );
x.from = {'tissueGly', 'bodyGcn'};
x.depletes = [true false];
x.to = {'bodyGlu'};
x.linker = pk_product_linker( kGlyGlu );
model.interactions{ end + 1 } = x;

% Shallow

% Body GLU -> Visc. Fat
x = pk_default_interaction( );
x.from = {'closeGlu', 'closeIns'};
x.depletes = [true false];
x.to = {'viscFat'};
x.linker = pk_product_linker( kGluFat );
model.interactions{ end + 1 } = x;

% Visc. Fat -> Body Glu
x = pk_default_interaction( );
x.from = {'viscFat', 'closeGcn'};
x.depletes = [true false];
x.to = {'closeGlu'};
x.linker = pk_product_linker( kFatGlu );
model.interactions{ end + 1 } = x;

% Deep

% Body GLU -> Visc. Fat
x = pk_default_interaction( );
x.from = {'deepGlu', 'deepIns'};
x.depletes = [true false];
x.to = {'scFat'};
x.linker = pk_product_linker( kGluFat );
model.interactions{ end + 1 } = x;

% Visc. Fat -> Body Glu
x = pk_default_interaction( );
x.from = {'scFat', 'deepGcn'};
x.depletes = [true false];
x.to = {'deepGlu'};
x.linker = pk_product_linker( kFatGlu );
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


















