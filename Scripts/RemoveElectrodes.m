%% %%%%%%%%%%%%%%%%%%%   Remove Faulty Electrodes    %%%%%%%%%%%%%%%%%%% %%
% Written and maintained by Connor Beck
%                  contact: Connorbeck1997@gmail.com
% Updated June 2023
%%%%%%%%%%%%%%%%%%%%%%%%%      OVERVIEW      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Manually remove faulty electrodes from data.
%   
%   2 Primary reasons for removal:
%
%   (1) No neurons were on the electrode
%           This reason MUST be backed up by Brightfield Imaging, however, if
%           no neurons were on the electrode, it can be removed for analysis.
%
%   (2) Excessive noise or variablility in signal.
%           I caution the removal of signals because they 'look strange'
%           however, this can sometimes be the case. 
%
%   Recommended Call Format:
%   [Parameters,Data]=RemoveElectrodes(Parameters,Data);
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%      INPUTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   REQUIRED INPUT ARGUMENTS
%   Data & Parameters
%   and ElectrodeIDs
%   
%   Data and Parameters must be output from the load_MEA() and
%   filterElectrodes() functions before being used here.
%
%   Similarly, an array must be input of which electrodes to remove. This
%   array can either be a cell array with multichannel ids or a double
%   array with the MATLAB index values contained.
%
%   (1) Multichannel Labels : {'34','55','87'}
%   (2) MATLAB index        : [1,5,8,12]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%      OUTPUTS       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Invoking RemoveElectrodes() returns:
%
%               Name             | Type          | Description 
%   Parameters
%               All Previously Contained Values
%               
%               ElectrodeLabel   | cell array    |  This array is adjusted
%                                                   as removed electrodes 
%                                                   are removed from this
%                                                   list and relocated.
%
%               RemovedElectrodes| cell array    |  The removed electrode
%                                                   labels are stored here.
%
%   Data
%               All Previously Contained Values
%               
%               Electrodes
%                   RawElectrode       | double array  | This object is
%                                                        adjusted to remove
%                                                        signals if the
%                                                        electrode is
%                                                        removed.
%                   filteredElectrode  | double array  | This object is
%                                                        adjusted to remove
%                                                        signals if the
%                                                        electrode is
%                                                        removed.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%      CODE       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Parameters,Data]=RemoveElectrodes(Parameters,Data,electrode_removal)
    if iscell(electrode_removal)
        Parameters.removed_electrodes=electrode_removal;
        for i=1:length(electrode_removal)
            if any(strcmp(Parameters.ElectrodeLabel,Parameters.removed_electrodes{i}))
                ID=find(strcmp(Parameters.ElectrodeLabel,Parameters.removed_electrodes{i}));
                % Remove electrode from Label, 
                Parameters.ElectrodeLabel{ID}=[];
                Data.Electrodes(ID).RawElectrode=[];
                Data.Electrodes(ID).FilteredElectrode=[];
            else
                error(['Incorrect Electrode ID:',Parameters.removed_electrodes{i}])
            end
        end
    else
        error('Unknown Removal Request')

    end

end