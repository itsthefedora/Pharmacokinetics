%=========================================================================%
% Pharmacokinetic Model
% => Plots.
% 
% [Authors]
% Spring 2015
%=========================================================================%


function [ hFig ] = pk_plot( tResult, yResult, varargin )
%PK_PLOT Summary of this function goes here
%   Detailed explanation goes here

%% Initialization

% Parameter defaults
doLog = true;

% Parse input arguments
switch length(varargin)
    
    case 0
        %
    
    case 1
        doLog = varargin{1};
        
    otherwise
        error('Invalid number of arguments!');
    
end


%% Plot

figure( 'position', [ 10 10 1024 600 ] );
plot( tResult, yResult, 'linewidth', 2 );
legend( model.compartmentDisplayNames, 'fontsize', 24 );
xlabel( 'Time (h)', 'fontsize', 24 );
ylabel( 'Amount of drug (mg)', 'fontsize', 24 );
set( gca, 'fontsize', 24 );
set( gca, 'xlim', model.timeSpan );

figure( 'position', [ 110 10 1024 600 ] );
semilogy( tResult, yResult, 'linewidth', 2 );
legend( model.compartmentDisplayNames, 'fontsize', 24 );
xlabel( 'Time (h)', 'fontsize', 24 );
ylabel( 'Amount of drug (mg)', 'fontsize', 24 );
set( gca, 'fontsize', 24 );
set( gca, 'xlim', model.timeSpan );
set( gca, 'ylim', [ 1e1 1e3 ] );


end

