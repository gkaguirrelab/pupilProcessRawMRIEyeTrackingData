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

% Get user name and define path to dropbox folder
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
dropboxDir = fullfile('/Users', userName, '/Dropbox-Aguirre-Brainard-Lab');

% project params
params.outputDir = 'TOME_analysis';
params.projectFolder = 'TOME_data';
params.projectSubfolder = 'session*';
params.subjNaming = 'TOME_3*';
params.eyeTrackingDir = 'EyeTracking';
params.stimuliDir = 'Stimuli';
params.screenSpecsFile = 'TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
params.unitsFile = 'TOME_materials/hardwareSpecifications/unitsFile.mat'; %%% this file does not exist yet



%% Identify available reports to process on the DropBox directory
% Organize the list of available reports, matched with all necessary reportParams
% for analysis.

[reportToProcessCellArray, reportParamsStructArray] = identifyReportsToProcess(dropboxDir,params);
%%%% TO DO: in this function identify gaze calibration files

%% Make metaData cell array
nSessTypes                  = size(reportToProcessCellArray,1);
nSubjects                   = size(reportToProcessCellArray,2);
nSessions                   = size(reportToProcessCellArray,3);
nRuns                       = size(reportToProcessCellArray,4);
metaDataCellArray           = cell(nSessTypes,nSubjects,nSessions,nRuns);
responseStructCellArray     = cell(nSessTypes,nSubjects,nSessions,nRuns);
% Loop through data
for st=1:nSessTypes
    for sj=1:nSubjects
        for ss=1:nSessions
            for rr=1:nRuns
                if ~isempty(reportToProcessCellArray{st,sj,ss,rr})
                    % make a meta data cell array
                    metaDataCellArray{st,sj,ss,rr} = ...
                        makeMetaData(reportParamsStructArray{st,sj,ss,rr});
                    % Make the response structure
                    responseStructCellArray{st,sj,ss,rr} = ...
                        createLiveTrackResponseStruct(metaDataCellArray{st,sj,ss,rr},dropboxDir);
                end 
            end 
        end 
    end 
end 