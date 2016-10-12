function [response] = pupilPETD_main(metaData)

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

%% load in all data
% Get user name and define path to dropbox folder
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
dropboxDir = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab/'];
% define eyetracking data path
if isfield(metaData.dropboxPaths, 'projectSubfolder')
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectSubfolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,'Eyetracking'));
else
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectFolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,'Eyetracking'));
end
% load
load (fullfile(dataPath,[metaData.names.runName '_report.mat']));
load (fullfile(dataPath,[metaData.names.ScaleCalName '.mat']));
if isfield (metaData.names, 'GazeCalName')
    load (fullfile(dataPath,[metaData.names.GazeCalName '.mat']));
end

%% Calibrate LiveTrack data
if isfield (metaData.names, 'GazeCalName')
    viewDist = metaData.refValues.screenSpecs.viewDist;
    [PupilData] = CalibrateLivetrackData(Report,ScaleCal,CalMat,Rpc,viewDist);
else
    [PupilData] = CalibrateLivetrackData(Report,ScaleCal);
end
%% Make response structure

[response] = MakePupilResponseStruct(PupilData, metaData);
