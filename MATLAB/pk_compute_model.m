%=========================================================================%
% Pharmacokinetic Model
% => Default compartment parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [model] = pk_compute_model(inputModel)
%PK_COMPUTE_MODEL Summary of this function goes here
%   Detailed explanation goes here

model = inputModel;

%model.compartments = orderfields( model.compartments );
model.compartmentNames 			= fieldnames( model.compartments );
model.nCompartments 			= length( model.compartmentNames );

model.fromLinkers 				= cell( model.nCompartments, 1 );
model.toLinkers 				= cell( model.nCompartments, 1 );
model.targetInputs 				= cell( model.nCompartments, 1 );
model.compartmentDisplayNames 	= cell( model.nCompartments, 1 );

% TODO: Kludge
model.interactLinkers 			= { };
model.interactInputs 			= { };
model.interactOutputs 			= { };
model.interactDepletes 			= { };

model.sdFlowInputs 				= { };
model.sdFlowTargets				= { };
model.sdFlows 					= { };

%% Generate ODE solver options

model.odeOpts = odeset( 'MaxStep', model.maxStep, 'Vectorize', false );

%% Compute initial state

model.initialState = zeros( model.nCompartments, 1 );

for i = 1:model.nCompartments

	model.fromLinkers{ i } = { };
	model.toLinkers{ i } = { };
	model.toLinkerSources{ i } = { };
	model.targetFlows{ i } = { };

	model.compartmentDisplayNames{ i } = ...
		model.compartments.(model.compartmentNames{i}).displayName;

	model.initialState( i ) = ...
		model.compartments.(model.compartmentNames{i}).initialAmount;

end

%% Construct linker cells

for i = 1:length( model.connections )

	cur = model.connections{ i };
	fromIndex = find( ismember( model.compartmentNames, cur.from ) );
	toIndex = find( ismember( model.compartmentNames, cur.to ) );
	
	if ~isempty( fromIndex )
		model.fromLinkers{ fromIndex }{ end + 1 } = cur.linker;
	end
	if ~isempty( toIndex )
		model.toLinkers{ toIndex }{ end + 1 } = cur.linker;
		model.toLinkerSources{ toIndex }{ end + 1 } = fromIndex;
	end

end

%% Construct interaction cells
% TODO: Kludge

for i = 1:length( model.interactions )

	cur = model.interactions{ i };

	model.interactLinkers{ i } = cur.linker;

	fromIdx = [];
	toIdx = [];
	for fromLoop = 1:length( cur.from )
		fromLoopName = cur.from{ fromLoop };
		fromIdx = [fromIdx find( ismember( model.compartmentNames, fromLoopName ) )];
	end
	for toLoop = 1:length( cur.to )
		toLoopName = cur.to{ toLoop };
		toIdx = [toIdx find( ismember( model.compartmentNames, toLoopName ) )];
	end

	model.interactInputs{ i } = fromIdx;
	model.interactOutputs{ i } = toIdx;

	model.interactDepletes{ i } = cur.depletes;

end

%% Construct input cells

for i = 1:length( model.inputs )

	cur = model.inputs{ i };
	targetIndex = find( ismember( model.compartmentNames, cur.target ) );

	if ~isempty( targetIndex )
		model.targetFlows{ targetIndex }{ end + 1 } = cur.flow;
	end

end

% TODO: Kludge
for i = 1:length( model.sdinputs )

	cur = model.sdinputs{ i };
	targetIndex = find( ismember( model.compartmentNames, cur.target ) );

	inputIdx = [];
	for inputLoop = 1:length( cur.input )
		inputLoopName = cur.input{ inputLoop };
		inputIdx = [inputIdx find( ismember( model.compartmentNames, inputLoopName ) )];
	end

	model.sdFlowInputs{ i } = inputIdx;
	model.sdFlowTargets{ i } = targetIndex;

	if ~isempty( targetIndex )
		model.sdFlows{ i } = cur.flow;
	end

end	

end











