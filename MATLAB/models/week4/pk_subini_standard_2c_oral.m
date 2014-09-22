%=========================================================================%
% Pharmacokinetic Model
% => Two-compartment IV initialization.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Simulation

model.timeSpan = [ 0 24 ];

%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = effectiveDose;
x.displayName = 'GI Tract';
model.compartments.gi = x;

x = pk_default_compartment( );
x.volume = Vc;
x.initialAmount = 0;
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
x.from = 'gi';
x.to = 'body';
x.linker = pk_linear_linker( kA );
model.connections{ end + 1 } = x;

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