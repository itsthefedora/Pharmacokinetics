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

dose 			= 30;		% mg

bioavailability = 0.36;		% [0 1]
VdPerMass 		= 2.1;		% L / kg

bindingFraction = 0.97;		% [0 1]

kE 				= log(2) / 3.2;	% / hr
kA 				= log(2) / 0.25;		% / hr

kBT 			= 0.037 * 60;
kTB 			= 0.014 * 60;
kBD				= 0.011 * 60;
kDB 			= 0.0017 * 60;

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = Vd;
x.initialAmount = effectiveDose;
x.displayName = 'GI';
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
x.volume = Vd;
x.initialAmount = 0;
x.displayName = 'Tissue';
model.compartments.tissue = x;

x = pk_default_compartment( );
x.volume = Vd;
x.initialAmount = 0;
x.displayName = 'Deep';
model.compartments.deep = x;

%% Connections

% Absorption
x = pk_default_connection( );
x.from = 'gi';
x.to = 'body';
x.linker = pk_linear_linker( kA );
model.connections{ end + 1 } = x;

% Renal clearance
x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kE );
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

% Inter-compartment
x = pk_default_connection( );
x.from = 'body';
x.to = 'tissue';
x.linker = pk_linear_linker( kBT );
%model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'tissue';
x.to = 'body';
x.linker = pk_linear_linker( kTB );
%model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'body';
x.to = 'deep';
x.linker = pk_linear_linker( kBD );
%model.connections{ end + 1 } = x;
x = pk_default_connection( );
x.from = 'deep';
x.to = 'body';
x.linker = pk_linear_linker( kDB );
%model.connections{ end + 1 } = x;


%% Inputs








