%% %%%%%%%%%%%%%%%%%%   Electrode Spike Detection    %%%%%%%%%%%%%%%%%%% %%
% Written and maintained by Connor Beck
%                  contact: Connorbeck1997@gmail.com
% Updated June 2023
%%%%%%%%%%%%%%%%%%%%%%%%%      OVERVIEW      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Takes filtered Electrode Data and detects events based on falling edge
%   and the refractory period: 
%   base - 7 standard deviations & 3 ms refractory period
%   
%
%   Recommended Call Format:
%   [Parameters,Data]=SpikeDetection(Parameters,Data);
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%      INPUTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   REQUIRED INPUT ARGUMENTS
%   Data & Parameters
%   
%   Data and Parameters must be output from the load_MEA() and
%   filterElectrodes() functions before being used here.
%
%   Parameters (can) include attributes:
%
%   Parameters.standard_deviation=standard deviations; 
%       where standard deviations can be a value of how many standard
%       deviations the voltage must be away from 0 for it to be considered
%       a spike. Base is 7.
%   Parameters.refractory period =  refractory period;
%       where refractory period is a time in ms restricting how long a signal
%       must go after an event before the next event can be detected.
%       Biological limits of neurons often require 3 ms delay.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%      OUTPUTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Invoking SpikeDetection() returns:
%
%               Name             | Type          | Description 
%   Parameters
%               All Previously Contained Values
%               
%               if standard_deviation not contained in parameters on input
%               standard_deviation  | double     | standard deviations the 
%                                                  voltage must be away 
%                                                  from 0 for it to be 
%                                                  considered a spike.
%
%               if refractory_period not contained in parameters on input
%               refractory_period   | double     | time in ms restricting 
%                                                  the time in-between spikes
%
%   Data
%               All Previously Contained Values
%               
%               Electrodes
%                   Spikes  | cell array    | time locations of all detected
%                                             events sorted into a cell for 
%                                             each electrode.
%
%               SpikeOutput | double array  | a Nx2 array where column 1
%                                             represents the times
%                                             associated with an event and
%                                             column 2 represents the
%                                             electrode number associated
%                                             with the spike.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%      CODE       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Parameters,Data] = SpikeDetection(Parameters,Data)
    if ~isfield(Parameters,'standard_deviation') || isempty(Parameters.standard_deviation)
        Parameters.standard_deviation=7;
    end
    if ~isfield(Parameters,'refractory_period') || isempty(Parameters.refractory_period)
        Parameters.refractory_period=3;
    end

    Data.SpikeOutput=[];
    H = waitbar(0,'Detecting Electrode Spikes...'); 
    for i=1:Parameters.n_electrodes
        if ~strcmp(Parameters.ElectrodeLabel{i},'ref')
            waitbar(i/Parameters.n_electrodes)
            %Select an individual electrode for analysis
            Electrode = Data.Electrodes(i).FilteredElectrode;
    
            % Calculate standard deviation of electrode
            electrodeDeviation = std(Electrode);
            Parameters.threshold(i) = (-1) * Parameters.standard_deviation * electrodeDeviation; %Calculate threshold voltage
            
            %find times where the electrode went below the threshold
            SpikeTimes=find(Electrode <=Parameters.threshold(i));
    
            % Comb through spike times, remove events that occured within
            % refractory period
            for j = 2:length(SpikeTimes)
                if (SpikeTimes(j)-SpikeTimes(j-1))<Parameters.refractory_period*1E3/Parameters.samplingFrequency
                    SpikeTimes(j)=[];
                end
            end
            
            Data.Electrodes(i).Spikes=SpikeTimes;
            Spikes=cat(2,SpikeTimes,i*ones(length(SpikeTimes),1));
            if ~isempty(Spikes)
                Data.SpikeOutput=cat(1,Data.SpikeOutput,Spikes);
            end
        else
            Data.Electrodes(i).Spikes=[];
        end
    delete(H)
end