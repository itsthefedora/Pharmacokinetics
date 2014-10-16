%=========================================================================%
% Pharmacokinetic Model
% => One-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Input parameters

bindRateFactor	= 1e4;		% / hr

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

dose 			= 7500;	% mg
doseDuration	= 0.1;		% hr
doseSpacing		= 4;		% hr

bioavailability = 0.90;		% [0 1]
VdPerMass 		= 0.95;		% L / kg

bindingFraction = 0.20;		% [0 1]

kE 				= log(2) / 2.5;	% / hr
kErFraction 	= 0.1;
kA 				= log(2) / 0.35;		% / hr

kENapqi 		= log(2) / 2.0;		% / hr

cGSH 			= 1.02;		% mM;
molarMassGSH 	= 307.32;	% g / mol
VdPerMassGSH 	= 0.19;		% L / kg

productionGSHRaw	= 19.74 * 0.5;	% umol / min

kEGSH 			= log(2) / (2.37 / 60);	% / hr

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L

VdGSH 			= VdPerMassGSH * waterMass;	% L
productionGSH 	= productionGSHRaw * molarMassGSH * 60 * 1e-3; % mg / hr;
equilGSH 		= productionGSH / kEGSH;	% mg

effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

kEr				= kErFraction * kE;

kEr				= kErFraction * kE;

kRelNAPQI		= 0.15;
kRelOther		= 0.85;
kRelSum 		= kRelNAPQI + kRelOther;

kEm 		= (1 - kErFraction) * kE;
kNAPQI 		= (kRelNAPQI / kRelSum) * kEm;
kOther 		= (kRelOther / kRelSum) * kEm;

kIntNG 		= 0.1;


%% Simulation

model.timeSpan = [ 0 24*4 ];


%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = 0;%effectiveDose;
x.displayName = 'GI Tract';
model.compartments.gi = x;

x = pk_default_compartment( );
x.volume = Vd;
x.initialAmount = 0;
x.displayName = 'Body';
model.compartments.body = x;

x = pk_default_compartment( );
x.volume = Vd;
x.initialAmount = 0;
x.displayName = 'Bound';
model.compartments.bound = x;

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = 0;
x.displayName = 'NAPQI';
model.compartments.napqi = x;

x = pk_default_compartment( );
x.volume = VdGSH;
x.initialAmount = equilGSH;
x.displayName = 'Glutathione';
model.compartments.gsh = x;


%% Connections

x = pk_default_connection( );
x.from = 'gi';
x.to = 'body';
x.linker = pk_linear_linker( kA );
model.connections{ end + 1 } = x;

% Renal clearance
x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kEr );
model.connections{ end + 1 } = x;

% Enzyme clearance to non-toxic
x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kOther );
model.connections{ end + 1 } = x;

% Conversion to NAQPI
x = pk_default_connection( );
x.from = 'body';
x.to = 'napqi';
x.linker = pk_linear_linker( kNAPQI );
model.connections{ end + 1 } = x;

% Elimination of GSH
x = pk_default_connection( );
x.from = 'gsh';
x.to = '';
x.linker = pk_linear_linker( kEGSH );
model.connections{ end + 1 } = x;

% Plasma protein binding
x = pk_default_connection( );
x.from = 'body';
x.to = 'bound';
x.linker = pk_linear_linker( kB );
model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'bound';
x.to = 'body';
x.linker = pk_linear_linker( kU );
model.connections{ end + 1 } = x;


%% Interactions

% Elimination of NAPQI via Glutathione
x = pk_default_interaction( );
x.from = {'napqi', 'gsh'};
x.to = {''};
x.linker = pk_product_linker( kIntNG );
model.interactions{ end + 1 } = x;


%% Inputs

% Addition of APAP
x = pk_default_input( );
x.target = 'gi';
x.flow = pk_pulsed_flow( effectiveDose, doseDuration, doseSpacing );
model.inputs{ end + 1 } = x;

% Production of GSH
x = pk_default_input( );
x.target = 'gsh';
x.flow = pk_constant_flow( productionGSH );
model.inputs{ end + 1 } = x;








