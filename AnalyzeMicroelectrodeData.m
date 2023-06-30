%% Analyze Microelectrode signals from Multichannel Systems
% Written and maintained by Connor Beck
% Updated June 2023

% Use this software to extract microelectrode array (MEA) signals from
% multichannel systems datasets (Stored as '.h5' aka '.hdf5' file types).
% 

clear
clc
addpath('Scripts\');

%% User inputs
% None of these inputs are required, but can be used to tune the analysis.
% Not all possible parameters are included here, inputs can be found in the
% documentation of each function or in the full documentation

%Key parameters

Parameters.Filename=[]; 
%^Leave blank if you want to select a file with UI, 
% otherwise include full path and file here


Parameters.filter_frequencies=[300,4000]; 
%^Used Leave blank if you want standard frequencies (300-4000 Hz), 
% otherwise include array for High pass and Low pass
% e.g. [400,5000] for bandpass;
%      [,5000] for low pass only;
%      [,] for no filter;

Parameters.standard_deviation=5;
%^Used to detect action potentials (falling edge).
% Leave blank if you want classic standard deviation (7 std), 
% otherwise set value;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in data
[Parameters,Data] = load_MEA(Parameters);

% Filter Data
[Parameters,Data] = filterElectrodes(Parameters,Data);

plotElectrodes(Parameters,Data);

%% After inspecting electrodes use this part of the code

electrode_removal={'73','85'};
%^Select Electrodes to Remove,
% Leave blank if you dont want to remove any. e.g. {}
[Parameters,Data]=RemoveElectrodes(Parameters,Data,electrode_removal);

% Detect spikes
[Parameters,Data]=SpikeDetection(Parameters,Data);

%Plot Spikes
scatter(Data.SpikeOutput(:,1),Data.SpikeOutput(:,2));