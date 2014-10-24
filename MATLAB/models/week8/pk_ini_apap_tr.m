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

dose 			= 500;		% mg

bioavailability = 0.90;		% [0 1]
VdPerMass 		= 0.95;		% L / kg

bindingFraction = 0.20;		% [0 1]

kE 				= log(2) / 2.5;		% / hr
kA 				= log(2) / 0.35;	% / hr

doseDuration	= 3;		% hr
doseSpacing		= 6;		% hr

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

% Dissolution parameters
kDis 			= 100;				% mg / (mm^2 hr)
rho 			= dose / 0.288;		% mg / mm^3
r0 				= 0.5;				% mm
M0				= effectiveDose;	% mg

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = 0;
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



%% Inputs

% Addition of APAP
x = pk_default_input( );
x.target = 'gi';
x.flow = pk_pulsed_flow( effectiveDose, doseDuration, doseSpacing, 1 );
model.inputs{ end + 1 } = x;








