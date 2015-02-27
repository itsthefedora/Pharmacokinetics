%=========================================================================%
% Pharmacokinetic 2TS Model
% => Glucose
% 
% [Authors]
% Spring 2015
%=========================================================================%

function [ outModel ] = pk_gluc_updateFast( model, inStruct )
%PK_GLUC_UPDATEFAST Summary of this function goes here
%   Detailed explanation goes here

outModel = model;

%% Extract features

t = inStruct.data.t;
y = inStruct.data.y;

kGluGly         = model.globals.kGluGly;
glut4tfIdx      = model.globals.glut4tfIdx;
idx_intGluGly   = model.globals.idx_intGluGly;

curTFLevel = y(end, glut4tfIdx);
uptakeFactor = 1 + (curTFLevel - 1) * 1.0;

kGluGlyNew = uptakeFactor * kGluGly;
disp(['Uptake factor: ' num2str(uptakeFactor)]);


%% Alter model

% Body GLU -> Tissue GLY
x = pk_default_interaction( );
x.from = {'bodyGlu', 'bodyIns'};
x.depletes = [true false];
x.to = {'tissueGly'};
x.linker = pk_product_linker( kGluGlyNew );
outModel.fast.interactions{ idx_intGluGly } = x;


end

