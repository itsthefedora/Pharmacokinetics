%=========================================================================%
% Pharmacokinetic Model
% => Test initialization script.
% 
% [Authors]
% Fall 2014
%=========================================================================%

%% Simulation

model.timeSpan = [ 0 20 ];

%% Compartments

x = pk_default_compartment( );
x.volume = 1;
x.initialAmount = 3;
x.displayName = 'GI Tract';
model.compartments.gi = x;

x = pk_default_compartment( );
x.volume = 10;
x.initialAmount = 0;
x.displayName = 'Body';
model.compartments.body = x;

%% Connections

x = pk_default_connection( );
x.from = 'gi';
x.to = 'body';
x.linker = pk_linear_linker( 0.5 );
model.connections{ end + 1 } = x;

x = pk_default_connection( );
x.from = 'body';
x.to = '';
x.linker = pk_linear_linker( 1.0 );
model.connections{ end + 1 } = x;

%% Inputs

x = pk_default_input( );
x.target = 'gi';
x.flow = pk_constant_flow( 0.5, 5, 15 );
model.inputs{ end + 1 } = x;















