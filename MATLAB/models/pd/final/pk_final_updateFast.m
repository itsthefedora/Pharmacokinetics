%=========================================================================%
% Pharmacokinetic 2TS Model
% => Final
% 
% [Authors]
% Spring 2015
%=========================================================================%

function [ outModel] = pk_final_updateFast( model, inStruct )
%PK_FAST_UPDATEFAST Summary of this function goes here
%   Detailed explanation goes here

outModel = model;

%% Extract features

t = inStruct.data.t;
y = inStruct.data.y;

isDebug 				= model.globals.isDebug;

idx_ltb4i 				= model.globals.idx_ltb4i;
idx_ltb4liver 			= model.globals.idx_ltb4liver;
idx_ltb4muscle 			= model.globals.idx_ltb4muscle;
idx_ltb4vf 				= model.globals.idx_ltb4vf;

idx_intLiverGluGly		= model.globals.idx_intLiverGluGly;
idx_intDGluBodyMuscle 	= model.globals.idx_intDGluBodyMuscle;

kDGluBodyMuscle 	= model.globals.kDGluBodyMuscle;
kLiverGluGly		= model.globals.kLiverGluGly;
LiverGluGlyCenter 	= model.globals.LiverGluGlyCenter;
LiverGluGlyShape 	= model.globals.LiverGluGlyShape;
irCenter 			= model.globals.irCenter;
irShape 			= model.globals.irShape;
irLow 				= model.globals.irLow;
irLowLTB4i			= model.globals.irLowLTB4i;

ltb4iCur 	= y(end, idx_ltb4i);
irLowTrue 	= ltb4iCur * irLowLTB4i + (1 - ltb4iCur) * irLow;

insRespLiver 	= irLowTrue + (1 - irLowTrue) * (1/2) * ... 
	(1 + tanh( (y(end, idx_ltb4liver) - irCenter) / irShape ));
insRespMuscle 	= irLowTrue + (1 - irLowTrue) * (1/2) * ...
	(1 + tanh( (y(end, idx_ltb4muscle) - irCenter) / irShape ));
insRespVF 		= irLowTrue + (1 - irLowTrue) * (1/2) * ...
	(1 + tanh( (y(end, idx_ltb4vf) - irCenter) / irShape ));


%% Alter model

% ...


% Insulin response
x = pk_default_interaction( );
x.from = { 'liverGly', 'liverGlu', 'bodyIns' }; x.depletes = [false, true, false];
x.to = { 'liverGly' };
x.linker = pk_product_tanh_linker( insRespLiver * kLiverGluGly, LiverGluGlyCenter, LiverGluGlyShape );
model.fast.interactions{ idx_intLiverGluGly } = x;

x = pk_default_interaction( );
x.from = { 'bodyGlu', 'bodyIns' }; x.depletes = [true, false];
x.to = { 'muscleGlu' };
x.linker = pk_product_linker( insRespMuscle * kDGluBodyMuscle );
model.fast.interactions{ idx_intDGluBodyMuscle } = x;


%% Debugging

if isDebug
	disp( ['Ins.Resp. (L, M, VF): ' num2str(insRespLiver) ', ' num2str(insRespMuscle) ...
		', ' num2str(insRespVF) ] );
end


end













