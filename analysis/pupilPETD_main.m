%% pupilPETD_main.m
%
% DESCRIPTION OF ROUTINE HERE

%   Outputs:
%       response.timebase
%       response.pupilWidth
%       response.pupilHeight
%       response.gazeEcc
%       response.gazePolar
%       response.TTL
%       response.isTracked
%       response.metaData
%
%
%% set defaults

% housekeeping
clearvars; close all; clc;
warning on;

% Get user name and define path to dropbox folder
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
dropboxDir = fullfile('/Users', userName, '/Dropbox-Aguirre-Brainard-Lab');

% project params
params.outputDir = 'TOME_analysis';
params.projectFolder = 'TOME_data';
params.eyeTrackingDir = 'EyeTracking';
params.stimuliDir = 'Stimuli';
params.screenSpecsFile = 'TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
params.unitsFile = 'TOME_materials/hardwareSpecifications/unitsFile.mat';

%% Identify available reports to process on the DropBox directory
% Organize the list of available reports, matched with all necessary params
% for analysis.

[reportsToProcessCellArray, reportParamsStructArray] = identifyReportsToProcess(dropboxDir,params);

%% Make metaData cell array
nSessTypes                  = size(reportsToProcessCellArray,1);
nSubjects                   = size(reportsToProcessCellArray,2);
nSessions                   = size(reportsToProcessCellArray,3);
nRuns                       = size(reportsToProcessCellArray,4);
metaDataCellArray           = cell(nSessTypes,nSubjects,nSessions,nRuns);
responseStructCellArray     = cell(nSessTypes,nSubjects,nSessions,nRuns);
% Loop through data
for st=1:nSessTypes
    for sj=1:nSubjects
        for ss=1:nSessions
            for rr=1:nRuns
                if ~isempty(reportsToProcessCellArray{st,sj,ss,rr})
                    % make a meta data cell array
                    metaDataCellArray{st,sj,ss,rr} = ...
                        makeMetaData(reportsToProcessCellArray{st,sj,ss,rr}, ...
                        reportParamsStructArray{st,sj,ss,rr});
                    % Make the response structure
                    responseStructCellArray{st,sj,ss,rr} = ...
                        createLiveTrackResponseStruct(metaDataCellArray{st,sj,ss,rr},dropboxDir);
                end 
            end 
        end 
    end 
end 

%% Deprecated below
return 











%% For now, here is some hard-coded production of a metaDataCellArray
projectFolder = 'TOME_data'; 
projectSubfolder = 'session2_spatialStimuli';
eyeTrackingFolder = 'EyeTracking';
outputDir = 0 ;
stimuliDir = 'TOME_materials/StimulusFiles';
screenSpecsFile = '/Users/giulia/Dropbox-Aguirre-Brainard-Lab/TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
unitsFile = 0;
subjectName = 'TOME_3003';
sessionDate = '091616';
runName = 'tfMRI_MOVIE_PA_run03';
ScaleCalName = 'TOME_3003_091616ScaleCal';
GazeCalName = 'LTcal_091616_102149';

[metaDataCellArray{1,1,1,1}] = makeMetaData(outputDir,projectFolder,...
    projectSubfolder,eyeTrackingFolder,stimuliDir,screenSpecsFile,unitsFile,...
    subjectName,sessionDate,runName,ScaleCalName,GazeCalName);


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

