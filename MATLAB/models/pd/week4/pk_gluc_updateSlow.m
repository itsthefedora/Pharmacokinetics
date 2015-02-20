%=========================================================================%
% Pharmacokinetic 2TS Model
% => Glucose
% 
% [Authors]
% Spring 2015
%=========================================================================%

function [ outModel ] = pk_gluc_updateSlow( model, inStruct )
%PK_GLUC_UPDATESLOW Summary of this function goes here
%   Detailed explanation goes here

outModel = model;

%% Extract features

t = inStruct.data.t;
y = inStruct.data.y;

kFruGlu         = model.globals.kFruGlu;
fruIdx          = model.globals.fruIdx;
qBase           = model.globals.qInFatVBase;
qMax            = model.globals.qInFatVMax;
idx_inputFatV   = model.globals.idx_inputFatV;

frucRate = kFruGlu * y(:, fruIdx);
frucTotal = trapz( t, frucRate );
frucPerDay = 24 * frucTotal / ( t(end) - t(1) );

% TEMP.
qCenter = 120;
qShape = 0.02;
qInFatVNew = qBase + (qMax - qBase) * (1/2) * (1 + tanh( qShape * ( frucPerDay - qCenter ) ) );
disp(['FRU/day: ' num2str(frucPerDay)]);
disp(['Q-fat: ' num2str(qBase) ' + ' num2str(qInFatVNew - qBase)]);


%% Alter model

% FatV Source
x = pk_default_input( );
x.target = 'fatV';
x.flow = pk_constant_flow( qInFatVNew );
outModel.slow.inputs{ idx_inputFatV } = x;


end

