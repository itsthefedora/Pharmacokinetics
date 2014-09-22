%=========================================================================%
% Pharmacokinetic Model
% => One-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Input parameters

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

dose 			= 200;		% mg

bioavailability = 0.52;		% [0 1]
VdPerMass 		= 261 / (76.5 * waterFraction);	% L / kg
kA 				= 1.67;		% / hr
kE				= 0.166;	% / hr

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

Vt = Vd / 2;
kD = kE * 5;
kR = kD / 4;

kB = 5;
kU = 10;

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
x.volume = 1;
x.initialAmount = 0;
x.displayName = 'Bound';
model.compartments.bound = x;

x = pk_default_compartment( );
x.volume = Vt;
x.initialAmount = 0;
x.displayName = 'Tissue';
model.compartments.tissue = x;

%% Connections

x = pk_default_connection( );
x.from = 'gi';
x.to = 'body';
x.linker = pk_linear_linker( kA );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'body';
x.to = 'tissue';
x.linker = pk_linear_linker( kD );
model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'tissue';
x.to = 'body';
x.linker = pk_linear_linker( kR );
model.connections{ end + 1 } = x;

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

x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kE );
model.connections{ end + 1 } = x;

%% Inputs
% [none]