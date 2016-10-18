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

%% For now, here is some hard-coded production of a metaDataCellArray
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

[metaDataCellArray{1,1,1,1}] = makeMetaData(outputDir,projectFolder,...
    projectSubfolder,eyeTrackingFolder,stimuliDir,screenSpecsFile,unitsFile,...
    subjectName,sessionDate,runName,ScaleCalName,GazeCalName);








%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEV
%% Identify available reports to process on the DropBox directory
% Organize the list of available reports, matched with all necessary params
% for analysis.

% project params
params.outputDir = 'TOME_analysis';
params.projectFolder = 'TOME_data';
params.eyeTrackingDir = 'EyeTracking';
params.stimuliDir = 'Stimuli';
params.screenSpecsFile = 'TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
params.unitsFile = 'TOME_materials/hardwareSpecifications/unitsFile.mat';

[reportsToProcessCellArray, reportParamsStructArray] = identifyReportsToProcess(dropboxDir,params);

%% Make metaData cell array
nSessions=size(reportsToProcessCellArray,1);
nSubjects=size(reportsToProcessCellArray,2);
nDates=size(reportsToProcessCellArray,3);
nRuns=size(reportsToProcessCellArray,4);

for cc=1:nSessions
    for ss=1:nSubjects
        for dd=1:nDates
            for rr=1:nRuns
                if ~isempty(reportsToProcessCellArray{cc,ss,dd,rr})
                    metaDataCellArray{cc,ss,dd,rr} = makeMetaData(reportsToProcessCellArray{cc,ss,dd,rr}, reportParamsStructArray{cc,ss,dd,rr});
                end 
            end 
        end 
    end 
end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% /DEV
%% Convert the metaDataCellArray into a cell array of response structs

nSessions=size(metaDataCellArray,1);
nSubjects=size(metaDataCellArray,2);
nDates=size(metaDataCellArray,3);
nRuns=size(metaDataCellArray,4);

for cc=1:nSessions
    for ss=1:nSubjects
        for dd=1:nDates
            for rr=1:nRuns
                if ~isempty(metaDataCellArray{cc,ss,dd,rr})
                    responseStructCellArray{cc,ss,dd,rr} = ...
                        convertReportToResponseStruct(metaDataCellArray{cc,ss,dd,rr}, dropboxDir);
                end % check that this instance exists
            end % loop over runs
        end % loop over dates
    end % loop over subjects
end % loop over sessions

