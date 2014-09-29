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

dose 			= 2500;		% mg

bioavailability = 0.90;		% [0 1]
VdPerMass 		= 0.95;		% L / kg

bindingFraction = 0.20;		% [0 1]

kE 				= log(2) / 2.5;	% / hr
kA 				= log(2) / 0.35;		% / hr

kENapqi 		= log(2) / 2.0;		% / hr

% Enzyme kinetics

%KmHLM 	= 12;	% mM
Km1A1	= 5.5;	% mM
Km1A6	= 4;	% mM
Km1A9	= 9.2;	% mM

%Km3A4	= 0.28;	% mM

Km3A4 = 12;
KmHLM = 0.28;

molarMassAcet = 151.169;	% g/mol
molarMassNapqi = 149.147;	% g/mol

VmaxHLM = 16800;
Vmax1A1	= 2620;	% (pmol / min) / (mg enzyme)
Vmax1A6 = 204;
Vmax1A9 = 2070;

Vmax3A4 = 0.035 * 1e3;	% (pmol / min) / (mg enzyme)

massHLM = 0.25 * 1.8 * 1e3;	% mg
mass1A1 = 1500;	% mg
mass1A6 = 1500;	% mg
mass1A9 = 1500;	% mg

mass3A4 = 1000;	% mg

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

kEr				= 0.1 * kE;

AmHLM 	= KmHLM * molarMassAcet * Vd;	% mg
Am1A1	= Km1A1 * molarMassAcet * Vd;	% mg
Am1A6	= Km1A6 * molarMassAcet * Vd;	% mg
Am1A9	= Km1A9 * molarMassAcet * Vd;	% mg

Am3A4	= Km3A4 * molarMassNapqi * Vd;	% mg

VmaxHLMa 	= VmaxHLM * 1e-9 * 60 * molarMassAcet * massHLM;	% mg / hr
Vmax1A1a	= Vmax1A1 * 1e-9 * 60 * molarMassAcet * mass1A1;	% mg / hr
Vmax1A6a	= Vmax1A6 * 1e-9 * 60 * molarMassAcet * mass1A6;	% mg / hr
Vmax1A9a	= Vmax1A9 * 1e-9 * 60 * molarMassAcet * mass1A9;	% mg / hr

Vmax3A4a	= Vmax3A4 * 1e-9 * 60 * molarMassNapqi * mass3A4;	% mg / hr

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = effectiveDose;
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
x.linker = pk_mm_linker( AmHLM, VmaxHLMa );
model.connections{ end + 1 } = x;

% Conversion to NAQPI
x = pk_default_connection( );
x.from = 'body';
x.to = 'napqi';
x.linker = pk_mm_linker( Am3A4, Vmax3A4a );
model.connections{ end + 1 } = x;

% Elimination of NAPQI
x = pk_default_connection( );
x.from = 'napqi';
x.to = '';
x.linker = pk_linear_linker( kENapqi );
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



%% Inputs
% [none]








