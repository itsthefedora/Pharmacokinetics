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

dose 			= 40;		% mg

bioavailability = 0.77;		% [0 1]
VdPerMass 		= 0.15;		% L / kg
halfLifeE		= 1.1;		% hr
kA				= 14.15		% / hr

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg
kE 				= log(2) / halfLifeE;		% / hr

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = Vd;
x.initialAmount = effectiveDose;
x.displayName = 'Body';
model.compartments.body = x;

%% Connections

x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kE );
model.connections{ end + 1 } = x;

%% Inputs
% [none]