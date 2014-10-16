%=========================================================================%
% Pharmacokinetic Model
% => One-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Input parameters

dose 			= 9.6;		% mg
kA 				= 20.4;		% / hr
bioavailability = 1;		% [0 1]

bindRateFactor	= 1e4;		% / hr

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

VdPerMass 		= 4;		% L / kg

bindingFraction = 0.35;		% [0 1]

kE 				= log(2) / (2.2);	% / hr
kErFraction		= 0.9;

kEM6G 			= log(2) / (3.2);	% / hr

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

kEr				= kErFraction * kE;

kRelM6G		= 0.1;
kRelSum 	= kRelM6G;

kEm 		= (1 - kErFraction) * kE;
kM6G 		= (kRelM6G / kRelSum) * kEm;

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = effectiveDose;
x.displayName = 'Pre-Body';
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
x.displayName = 'M6G';
model.compartments.active = x;

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

% Enzyme metabolism to active
x = pk_default_connection( );
x.from = 'body';
x.to = 'active';
x.linker = pk_linear_linker( kM6G );
%x.linker = pk_mm_linker( AmMor, VmaxMora );
model.connections{ end + 1 } = x;

% Elimination of active
x = pk_default_connection( );
x.from = 'active';
x.to = '';
x.linker = pk_linear_linker( kEM6G );
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








