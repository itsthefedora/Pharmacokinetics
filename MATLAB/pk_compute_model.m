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

%% Construct input cells

for i = 1:length( model.inputs )

	cur = model.inputs{ i };
	targetIndex = find( ismember( model.compartmentNames, cur.target ) );

	if ~isempty( targetIndex )
		model.targetFlows{ targetIndex }{ end + 1 } = cur.flow;
	end

end

end











