%=========================================================================%
% Pharmacokinetic Model
% => One-compartment demo drug model.
% 
% [Authors]
% Spring 2014
%=========================================================================%

%% Input parameters

dose 			= 700;      % mg
tStart          = 0;        % hr
tEnd            = 7*24;     % hr
doseRate        = dose / ( tEnd - tStart );    % mg / hr

kA 				= 0.35;		% / hr
bioavailability = 1;        % [0 1]

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

VdPerMass 		= 4;		% L / kg

kE 				= log(2) / (48);	% / hr
kErFraction		= 1;

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kEr				= kErFraction * kE;

%% Simulation

nDays = 14;
model.timeSpan = [ 0, 24 * nDays ];
%model.maxStep = doseDuration / 2;

%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = 0;
x.displayName = 'GI';
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

% Renal clearance
x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( kEr );
model.connections{ end + 1 } = x;


%% Inputs

x = pk_default_input( );
x.target = 'body';
x.flow = pk_constant_flow( doseRate, tStart, tEnd );
model.inputs{ end + 1 } = x;








