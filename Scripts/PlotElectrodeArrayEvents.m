%% %%%%%%%%%%%%%%%%%%%%   Plot Electrode Array Events   %%%%%%%%%%%%%%%%%%%%% %%
% Written and maintained by Connor Beck
%                  contact: Connorbeck1997@gmail.com
% Updated July 2023
%%%%%%%%%%%%%%%%%%%%%%%%%      OVERVIEW      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Plots events of individual channels for the microelectrode array
%
%
%   Recommended Call Format:
%   PlotElectrodeArrayEvents(Parameters,Data);
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%      INPUTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   REQUIRED INPUT ARGUMENTS
%   Data & Parameters
%   
%   Data and Parameters must be output from the load_MEA function before 
%   running through filtering.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%      CODE       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotElectrodeArrayEvents(Parameters,Data)
    count=1;
    for i=1:8
        for j=1:8
            if (i==1 && j==1) || (i==1 && j==8) || (i==8 && j==1) || (i==8 && j==8) || (i==5 && j==1)
            else
                IDX=find(strcmp(Parameters.ElectrodeLabel,strcat(num2str(j),num2str(i))));
                subplot(8,8,count);
                events=Data.Electrodes(IDX).Spikes;
                if ~isempty(events)
                    scatter(events,ones(length(events),1));
                    xlim([0,Parameters.t_max])
                end
                title(Parameters.ElectrodeLabel(IDX))
            end
            count=count+1;
        end
    end
end