function [response] = convertReportToResponseStruct(metaData, dropboxDir)
% [response] = ConvertReportToResponseStruct(metaData, dropboxDir)

% This function will generate a Response Struct for a single LiveTrack
% dataset (i.e. a single run). 

% Inputs
% metadata - created using the function MakeMetaData
% dropboxDir - path to the dropbox directory on local machine

%% SETUP 
% define eyetracking data path
if isfield(metaData.dropboxPaths, 'projectSubfolder')
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectFolder, ...
        metaData.dropboxPaths.projectSubfolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,metaData.dropboxPaths.eyeTrackingFolder));
else
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectFolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,metaData.dropboxPaths.eyeTrackingFolder));
end
%%  LOAD DATA
% load the Report variable
load (fullfile(dataPath,[metaData.names.runName '_report.mat']));
% load the ScaleCal  variable
load (fullfile(dataPath,[metaData.names.ScaleCalName '.mat']));
% load CalMat, Rpc, viewDist (if a scale calibration exists)
if isfield (metaData.names, 'GazeCalName')
    load (fullfile(dataPath,[metaData.names.GazeCalName '.mat']));
    load (metaData.dropboxPaths.screenSpecsFile);
end
%% CALIBRATE LIVE TRACK DATA
if isfield (metaData.names, 'GazeCalName')
    viewDist = SC3TScreenSizeMeasurements.distanceToScreen;
    if strcmp (SC3TScreenSizeMeasurements.units, 'cm')
        viewDist = viewDist * 10;
    end
    [PupilData] = calibrateLiveTrackData(Report,ScaleCal,CalMat,Rpc,viewDist);
else
    [PupilData] = calibrateLiveTrackData(Report,ScaleCal);
end
%% MAKE RESPONSE STRUCTURE
[response] = makePupilResponseStruct(PupilData, metaData);
