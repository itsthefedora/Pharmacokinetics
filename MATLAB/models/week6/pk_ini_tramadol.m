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

dose 			= 50;	% mg

bioavailability = 0.72;		% [0 1]
VdPerMass 		= 2.7;		% L / kg

bindingFraction = 0.20;		% [0 1]

kE 				= log(2) / 5.2;	% / hr
kErFraction		= 0.282;
kA 				= log(2) / 4.9;	% / hr

kEODMT 			= log(2) / (9.0);	% / hr

% Enzyme kinetics

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

kEr				= kErFraction * kE;

kRelODMT 	= 0.1;
kRelOther 	= 0.9;
kRelSum 	= kRelODMT + kRelOther;

kEm 		= (1 - kErFraction) * kE;
kMetODMT 	= (kRelODMT / kRelSum) * kEm;
kEOther 	= (kRelOther / kRelSum) * kEm;

%% Simulation

model.timeSpan = [ 0 24 * 3 ];

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
x.displayName = 'ODMT';
model.compartments.odmt = x;

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
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kEOther );
model.connections{ end + 1 } = x;

% Enzyme metabolism to active
x = pk_default_connection( );
x.from = 'body';
x.to = 'odmt';
x.linker = pk_linear_linker( kMetODMT );
model.connections{ end + 1 } = x;


% Elimination of active
x = pk_default_connection( );
x.from = 'odmt';
x.to = '';
x.linker = pk_linear_linker( kEODMT );
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








