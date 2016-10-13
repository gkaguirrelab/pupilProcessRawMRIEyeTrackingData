function [response] = ConvertReportToResponseStruct(metaData, dropboxDir)

% Inputs:
% paths
%     to dropbox project folder
%     to dropbox project subfolder (optional)
%     to output directory
%     to Stimuli directory
%     to Screen specs file
%     to units file
% names
%     subjectName
%     sessionDate
%     runName
%     ScaleCalName
%     GazeCalName

%% SETUP

% define eyetracking data path
if isfield(metaData.dropboxPaths, 'projectSubfolder')
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectFolder, ...
        metaData.dropboxPaths.projectSubfolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,'EyeTracking'));
else
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectFolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,'EyeTracking'));
end


%%  LOAD REPORT
load (fullfile(dataPath,[metaData.names.runName '_report.mat']));
load (fullfile(dataPath,[metaData.names.ScaleCalName '.mat']));
if isfield (metaData.names, 'GazeCalName')
    load (fullfile(dataPath,[metaData.names.GazeCalName '.mat']));
end

%% CALIBRATE LIVE TRACK DATA
if isfield (metaData.names, 'GazeCalName')
    viewDist = metaData.refValues.screenSpecs.SC3TScreenSizeMeasurements.distanceToScreen;
    if strcmp (metaData.refValues.screenSpecs.SC3TScreenSizeMeasurements.distanceToScreen, 'cm')
        viewDist = viewDist * 10;
    end
    [PupilData] = CalibrateLiveTrackData(Report,ScaleCal,CalMat,Rpc,viewDist);
else
    [PupilData] = CalibrateLiveTrackData(Report,ScaleCal);
end

%% MAKE RESPONSE STRUCTURE
[response] = MakePupilResponseStruct(PupilData, metaData);
