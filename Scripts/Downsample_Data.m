%% %%%%%%%%%%%%%%%%%%%%   Filter Electrode Data    %%%%%%%%%%%%%%%%%%%%% %%
% Written and maintained by Connor Beck
%                  contact: Connorbeck1997@gmail.com
% Updated June 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERT TIME STEP FOR BINNING/DOWNSAMPLING HERE

t=200; %timestep to downsample to (in ms)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% DO NOT ADJUST CODE WITHIN BLOCK %%%%%%%%%%%%%%%%%%%%%
DS=(t/1E3)*Parameters.samplingFrequency; %convert binning time into # of samples

Downsampled_Spikes=zeros(ceil(Parameters.t_max/DS),Parameters.n_electrodes); %Create a map to put the spikes into

for i=1:Parameters.n_electrodes % loop through each electrode
    if ~isempty(Data.Electrodes(i).Spikes) %Check is spikes were detected on the electrode
        for j=1:DS:Parameters.t_max %Loops through to the end where each increment is DS
            timewindow=j:j+DS; %Timewindow for binning
            if any(ismember(timewindow,Data.Electrodes(i).Spikes)) %Check if any of the electrode spikes are in the time window
                Downsampled_Spikes((j-1)/DS+1,i)=1; %If spikes are in the time window, change the 0 to a 1 to indicate spike.
            end
        end
    end
end

%%%%%%%%%%%%%% CODE ABOVE HERE SHOULD REMAIN CONSTANT %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The structure of downsampled spikes is 
% each column is an electrode, and each
% row is a timestep (denoted by the t you
% use in the beginning. 
% 
% To measure the
% population events, if you sum 
% horizontally it would give you the total
% number of events at any given timepoint.
PopulationEvents=sum(Downsampled_Spikes,2);

% If you now want to find the timings of
% the spikes over a given percentage, you 
% can use find to do so.
PopulationEventTiming_samples=find(PopulationEvents>0.5*Parameters.n_electrodes); 
%note, the timing is currently in the binned windows. to convert back,
%multiply value by t
PopulationEventTiming_seconds=PopulationEventTiming*t/1E3;

% To measure event rate, you can sum 
% vertically, giving you the total 
% number of events over the time period. 
% This could be converted to time
EventRate=sum(Downsampled_Spikes,1);

% This can similarly be measured with
% The population event as:
EventRate_Population=sum(PopulationEvents,1);