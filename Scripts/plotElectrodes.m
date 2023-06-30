%% %%%%%%%%%%%%%%%%%%%%   Plot Electrode Array    %%%%%%%%%%%%%%%%%%%%% %%
% Written and maintained by Connor Beck
%                  contact: Connorbeck1997@gmail.com
% Updated June 2023
%%%%%%%%%%%%%%%%%%%%%%%%%      OVERVIEW      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Plots all channels of the microelectrode array
%
%
%   Recommended Call Format:
%   PlotElectrodes(Parameters,Data);
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%      INPUTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   REQUIRED INPUT ARGUMENTS
%   Data & Parameters
%   
%   Data and Parameters must be output from the load_MEA function before 
%   running through filtering.
%
%   Plotting features not available yet.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%      CODE       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotElectrodes(Parameters,Data)
    count=1;
    for i=1:8
        for j=1:8
            if (i==1 && j==1) || (i==1 && j==8) || (i==8 && j==1) || (i==8 && j==8)
            else
                IDX=find(strcmp(Parameters.ElectrodeLabel,strcat(num2str(j),num2str(i))));
                subplot(8,8,count)
                plot(Data.t,Data.Electrodes(IDX).FilteredElectrode);
                title(Parameters.ElectrodeLabel(IDX))
            end
            count=count+1;
        end
    end
end