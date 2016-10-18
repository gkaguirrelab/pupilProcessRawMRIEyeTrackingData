%% pupilPETD_main.m
%
% DESCRIPTION OF ROUTINE HERE
%
%

%% SETUP

% housekeeping
clearvars; close all; clc;
warning on;

% Get user name and define path to dropbox folder
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
dropboxDir = fullfile('/Users', userName, '/Dropbox-Aguirre-Brainard-Lab');


%% Identify available reports to process on the DropBox directory
% Organize the list of available reports

% TO BE WRITTEN -- the result of this routine will be a metaData cell array
% (with the dimensions session / subject / date / run ) which has the
% information needed for processing for each run.

% NOTE: All paths returned in the metaData should be referenced with
% respect to TOME_data or TOME_analysis. That is, the paths should not
% include the user name or the particular name of the toplevel dropbox
% direcotry

% This needs to be written
%[ metaDataCellArray ] = identifyReportsToProcess(dropboxDir);

% For now, here is some hard-coded production of a metaDataCellArray
projectFolder = 'TOME_data'; 
projectSubfolder = 'session2_spatialStimuli';
eyeTrackingFolder = 'EyeTracking';
outputDir = 0 ;
stimuliDir = 'TOME_materials/StimulusFiles';
screenSpecsFile = '/Users/giulia/Dropbox-Aguirre-Brainard-Lab/TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
unitsFile = 0;
subjectName = 'TOME_3001';
sessionDate = '081916';
runName = 'tfMRI_RETINO_PA_run01';
ScaleCalName = 'TOME_3001_081916ScaleCal';
GazeCalName = 'LTcal_081916_133549';

%% make metadata cell array
[metaDataCellArray{1,1,1,1}] = makeMetaData(outputDir,projectFolder,...
    projectSubfolder,eyeTrackingFolder,stimuliDir,screenSpecsFile,unitsFile,...
    subjectName,sessionDate,runName,ScaleCalName,GazeCalName);

%% Convert the metaDataCellArray into a cell array of response structs

nSessions=size(metaDataCellArray,1);
nSubjects=size(metaDataCellArray,2);
nDates=size(metaDataCellArray,3);
nRuns=size(metaDataCellArray,4);

for ss=1:nSessions
    for bb=1:nSubjects
        for dd=1:nDates
            for rr=1:nRuns
                if ~isempty(metaDataCellArray{ss,bb,dd,rr})
                    responseStructCellArray{ss,bb,dd,rr} = ...
                        convertReportToResponseStruct(metaDataCellArray{ss,bb,dd,rr}, dropboxDir);
                end % check that this instance exists
            end % loop over runs
        end % loop over dates
    end % loop over subjects
end % loop over sessions

