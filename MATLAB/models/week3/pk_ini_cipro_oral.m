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

dose 			= 1000;		% mg

bioavailability = 0.70;		% a.u.

VdPerMass 		= 3.7;		% L / kg
kE 				= 0.17		% / hr
kA 				= 0.27		% / hr

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;			% L
effectiveDose 	= dose * bioavailability	% mg

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

%% Connections

x = pk_default_connection( );
x.from = 'gi';
x.to = 'body';
x.linker = pk_linear_linker( kA );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kE );
model.connections{ end + 1 } = x;

%% Inputs
% [none]