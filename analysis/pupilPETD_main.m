function [response] = pupilPETD_main(someInput)

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


%% make metaData

[metaData] = makeMetaData(someInput);
%% Calibrate LiveTrack data

[PupilData] = CalibrateLivetrackData(Report,ScaleCal,CalMat,Rpc,viewDist);
%% Make response structure

[response] = MakePupilResponseStruct(PupilData, metaData);
