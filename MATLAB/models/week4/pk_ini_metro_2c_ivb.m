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

dose 			= 500;		% mg

bioavailability = 1.0;		% [0 1]
VdPerMass 		= 0.81;		% L / kg
kE				= 0.0866;	% / hr
kA				= 5.4;		% / hr

Vc				= 36;	% L
Vp 				= 14;	% L
kCP				= 0.9;	% / hr
kPC 			= 2.1;	% / hr
bindingFraction = 0.20;	% [0 1]

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Generate standard 2C model

run( 'pk_subini_standard_2c_ivb.m' );

