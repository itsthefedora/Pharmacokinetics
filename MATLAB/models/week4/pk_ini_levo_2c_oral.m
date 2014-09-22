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

bioavailability = 1.0;		% [0 1]
VdPerMass 		= 1.23;		% L / kg
halfLifeE		= 9.81;		% hr
halfLifeA 		= 0.29;		% hr

Vc				= 66.88;	% L
Vp 				= 50.34;	% L
kCP				= 0.487;	% / hr
kPC 			= 0.647;	% / hr
bindingFraction = 0.31;		% [0 1]

% Derived parameters
waterMass 		= patientMass * waterFraction;
Vd 				= VdPerMass * waterMass;	% L
effectiveDose 	= dose * bioavailability;	% mg
kE = log(2) / halfLifeE;					% / hr
kA = log(2) / halfLifeA;					% / hr

kB 				= kE * bindRateFactor * bindingFraction;
kU 				= kE * bindRateFactor * ( 1 - bindingFraction );

%% Generate standard 2C model

run( 'pk_subini_standard_2c_oral.m' );



