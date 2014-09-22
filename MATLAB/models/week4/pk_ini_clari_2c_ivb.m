%=========================================================================%
% Pharmacokinetic Model
% => One-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Input parameters

bindRateFactor	= 1e4;

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

dose 			= 200;		% mg

bioavailability = 0.52;		% [0 1]
VdPerMass 		= 261 / (76.5 * waterFraction);	% L / kg
kA 				= 1.67;		% / hr
kE				= 0.166;	% / hr

Vc				= 204.7;	% L
Vp 				= 168.9;	% L
kCP				= 0.0193;	% / hr
kPC 			= 0.434;	% / hr
bindingFraction = 0.713;	% [0 1]

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Generate standard 2C model

run( 'pk_subini_standard_2c_ivb.m' );


