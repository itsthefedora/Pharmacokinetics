%=========================================================================%
% Pharmacokinetic Model
% => Default compartment parameters.
% 
% [Authors]
% Fall 2014
%=========================================================================%

function [yDot] = pk_odefun(t, y, model)
%PK_ODEFUN Summary of this function goes here
%   Detailed explanation goes here

yDot = zeros( size( y ) );

for i = 1:length( y )

	% Inter-compartment connections

	for j = 1:length( model.fromLinkers{ i } )
		yDot( i ) = yDot( i ) - model.fromLinkers{ i }{ j }( y( i ), t );
	end

	for j = 1:length( model.toLinkers{ i } )
		yDot( i ) = yDot( i ) + model.toLinkers{ i }{ j }( ...
			y( model.toLinkerSources{ i }{ j } ), t );
	end

	% Flow inputs

	for j = 1:length( model.targetFlows{ i } )
		yDot( i ) = yDot( i ) + model.targetFlows{ i }{ j }( t );
	end

end

% TODO: All this is super kludgey

for i = 1:length( model.sdFlows )

	inputIdx = model.sdFlowInputs{ i };
	targetIdx = model.sdFlowTargets{ i };

	inVec = y( inputIdx );
	fVal = model.sdFlows{ i }( t, inVec );

	yDot( targetIdx ) = yDot( targetIdx ) + fVal;

end

for i = 1:length( model.interactLinkers )

	fromIdx = model.interactInputs{ i };
	toIdx = model.interactOutputs{ i };

	inVec = y( fromIdx );
	fVal = model.interactLinkers{ i }( inVec );

	% Subtract from inputs
	if isempty( model.interactDepletes{ i } )
		for fromLoop = fromIdx;
			yDot( fromLoop ) = yDot( fromLoop ) - fVal;
		end
	else
		for j = 1:length(fromIdx);
			if model.interactDepletes{ i }( j )
				fromLoop = fromIdx( j );
				yDot( fromLoop ) = yDot( fromLoop ) - fVal;
			end
		end
	end
	% Add to outputs
	for toLoop = toIdx;
		yDot( toLoop ) = yDot( toLoop ) + fVal;
	end

end

end










