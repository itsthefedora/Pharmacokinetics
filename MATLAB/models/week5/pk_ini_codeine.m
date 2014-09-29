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

dose 			= 50e3;		% mg

bioavailability = 0.90;		% [0 1]
VdPerMass 		= 3.5;		% L / kg

bindingFraction = 0.16;		% [0 1]

kE 				= 0.231;	% / hr
kErFraction		= 0.1;
kA 				= 0.231;	% / hr

kEMor 			= log(2) / (2.0);	% / hr

% Enzyme kinetics

KmC6G 	= 1488 * 1e-3;		% mM
KmMor	= 194.7 * 1e-3;		% mM
KmNorC 	= 620 * 1e-3;		% mM

molarMassDrug = 299.364;	% g/mol

VmaxC6G		= 93.6;			% (pmol / min) / (mg enzyme)
VmaxMor		= 0.25 * 1e6;	% (pmol / min) / (mg enzyme)
VmaxNorC 	= 6.8 * 1e3;	% (pmol / min) / (mg enzyme)

massC6G 	= 500;	% mg
massMor		= 500;	% mg
massNorC	= 500;	% mg

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

kEr				= kErFraction * kE;

AmC6G 		= KmC6G * molarMassDrug * Vd;	% mg
AmMor 		= KmMor * molarMassDrug * Vd;	% mg
AmNorC 		= KmNorC * molarMassDrug * Vd;	% mg

VmaxC6Ga 	= VmaxC6G * 1e-9 * 60 * molarMassDrug * massC6G;	% mg / hr
VmaxMora 	= VmaxMor * 1e-9 * 60 * molarMassDrug * massMor;	% mg / hr
VmaxNorCa 	= VmaxNorC * 1e-9 * 60 * molarMassDrug * massNorC;	% mg / hr

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
x.displayName = 'Morphine';
model.compartments.morphine = x;

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

% Enzyme metabolism to inactive
x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_mm_linker( AmC6G, VmaxC6Ga );
model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_mm_linker( AmC6G, VmaxC6Ga );
model.connections{ end + 1 } = x;

% Enzyme metabolism to active
x = pk_default_connection( );
x.from = 'body';
x.to = 'morphine';
x.linker = pk_mm_linker( AmMor, VmaxMora );
model.connections{ end + 1 } = x;


% Elimination of active
x = pk_default_connection( );
x.from = 'morphine';
x.to = '';
x.linker = pk_linear_linker( kEMor );
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








