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

doseRate 		= 5e-3 * patientMass * 60;	% mg / hr

bioavailability = 0.90;		% [0 1]
VdPerMass 		= 0.10;		% L / kg

bindingFraction = 0.7;		% [0 1]

kE 				= log(2) / (3 / 60);	% / hr
%kA 				= log(2) / 0.35;		% / hr

kBT 			= 0.373 * 60;
kTB 			= 0.103 * 60;
kBD				= 0.0367 * 60;
kDB 			= 0.0124 * 60;

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
%effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Simulation

model.timeSpan = [ -1 18 ];

%% Compartments

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
% IV Infusion of drug
x = pk_default_input( );
x.target = 'body';
x.flow = pk_constant_flow( doseRate, 0, 8 );
model.inputs{ end + 1 } = x;








