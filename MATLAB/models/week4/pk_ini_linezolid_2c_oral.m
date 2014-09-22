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

%% Generate standard 2C model

run( 'pk_subini_standard_2c_oral.m' );


