%=========================================================================%
% Pharmacokinetic Model
% => Glucose 
% 
% [Authors]
% Fall 2014
%=========================================================================%


%% Pathology

if isfield(passStruct, 'absorptionFactor')
    absorptionFactor    = passStruct.absorptionFactor;
else
    absorptionFactor    = 1; %1;  %0.25;
end

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

if isfield(passStruct, 'doseGlu')
    doseGlu    = passStruct.doseGlu;
else
    doseGlu    = 60; % g
end
doseFru = 0 / fracFruGlu;			% g
doseDuration = 60 / 60;	% hr
doseSpacing = 8;		% hr

kAGlu = absorptionFactor * 0.205 * 60;		% / hr
kAFru = kAGlu;			% TODO

kAGluLower = 0.1 * kAGlu;   % TODO

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

Vgi     = 0.105;				% L
VgiFracUpper = 0.1;
VgiUpper = VgiFracUpper * Vgi;
VgiLower = (1 - VgiFracUpper) * Vgi;

VgiDot = .188 * 1e-3 * 60;    % L / min
kTransUpper = VgiDot / VgiUpper;
kTransLower = VgiDot / VgiLower;

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

model.timeSpan  = [ 0 24 ];
model.maxStep   = doseDuration / 2;


%% Compartments

% Upper SI
x = pk_default_compartment( );
x.volume = VgiUpper; x.initialAmount = 0; x.displayName = 'GI GLU (Upper)';
model.compartments.giGluUpper = x;

% Lower SI
x = pk_default_compartment( );
x.volume = VgiLower; x.initialAmount = 0; x.displayName = 'GI GLU (Lower)';
model.compartments.giGluLower = x;


%% Connections

% Absorption
x = pk_default_connection( ); x.from = 'giGluUpper'; x.to = '';
x.linker = pk_linear_linker( kAGlu );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giGluLower'; x.to = '';
x.linker = pk_linear_linker( kAGluLower );
model.connections{ end + 1 } = x;
% Movement
x = pk_default_connection( ); x.from = 'giGluUpper'; x.to = 'giGluLower';
x.linker = pk_linear_linker( kTransUpper );
model.connections{ end + 1 } = x;
x = pk_default_connection( ); x.from = 'giGluLower'; x.to = '';
x.linker = pk_linear_linker( kTransLower );
model.connections{ end + 1 } = x;


%% Interactions


%% Inputs

% Eating
x = pk_default_input( );
x.target = 'giGluUpper';
x.flow = pk_pulsed_flow( doseGlu, doseDuration, doseSpacing );
model.inputs{ end + 1 } = x;
%x = pk_default_input( );
%x.target = 'giFru';
%x.flow = pk_pulsed_flow( doseFru, doseDuration, doseSpacing );
%model.inputs{ end + 1 } = x;


















