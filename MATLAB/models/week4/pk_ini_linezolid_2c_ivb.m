%=========================================================================%
% Pharmacokinetic Model
% => One-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Input parameters

bindRateFactor	= 10;		% / hr

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

dose 			= 600;		% mg

bioavailability = 1.0;		% [0 1]
%VdPerMass 		= 45 / (78.6 * waterFraction); % L / kg
halfLifeE		= 4.9;		% hr
kA 				= 5.73;		% / hr

Vc				= 26.8;		% L
Vp 				= 17.3;		% L
kCP				= 8.04;		% / hr
kPC 			= 7.99;		% / hr
bindingFraction = 0.31;		% [0 1]

% Derived parameters
%waterMass 		= patientMass * waterFraction;
%Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg
kE 				= log(2) / halfLifeE;					% / hr

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = Vc;
x.initialAmount = effectiveDose;
x.displayName = 'Body';
model.compartments.body = x;

x = pk_default_compartment( );
x.volume = Vp;
x.initialAmount = 0;
x.displayName = 'Peripheral';
model.compartments.peripheral = x;

x = pk_default_compartment( );
x.volume = Vc;
x.initialAmount = 0;
x.displayName = 'Bound';
model.compartments.bound = x;

%% Connections

x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kE );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'body';
x.to = 'peripheral';
x.linker = pk_linear_linker( kCP );
model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'peripheral';
x.to = 'body';
x.linker = pk_linear_linker( kPC );
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

%% Inputs
% [none]