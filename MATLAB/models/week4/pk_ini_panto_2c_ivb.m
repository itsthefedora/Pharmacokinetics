%=========================================================================%
% Pharmacokinetic Model
% => One-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Input parameters

bindRateFactor	= 1e3;

patientMass 	= 70;		% kg
waterFraction	= 0.65;		% [0 1]

dose 			= 40;		% mg

bioavailability = 0.77;		% [0 1]
VdPerMass 		= 0.15;		% L / kg
halfLifeE		= 1.1;		% hr
kA				= 14.15;	% / hr

Vc				= 6.9;	% L
Vp 				= 5.1;	% L
kCP				= 1.12;	% / hr
kPC 			= 0.91;	% / hr
bindingFraction = 0.98;	% [0 1]

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg
kE 				= log(2) / halfLifeE;		% / hr

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Generate standard 2C model

run( 'pk_subini_standard_2c_ivb.m' );


