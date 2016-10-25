function [response] = createLiveTrackResponseStruct(metaData,dropboxDir)

% This function will generate a Response Struct for a single LiveTrack
%   dataset (i.e. a single run).
%
%   Usage:
%       [response] = createLiveTrackResponseStruct(metaData,dropboxDir)
%
%   Written by Andrew S Bock and Giulia Frazzetta Oct 2016

%% set defaults
if ~isfield(metaData,'acqRate')
    metaData.acqRate        = 1/60;
    disp(['setting metaData.acqRate = ' num2str(metaData.acqRate)]);
end
if ~isfield(metaData,'viewDist')
    metaData.viewDist       = 1065;
    disp(['setting metaData.viewDist = ' num2str(metaData.viewDist)]);
end
%% Get the eye tracking files
eyeDir                      = fullfile(dropboxDir,metaData.projectFolder,...
    metaData.projectSubfolder,metaData.subjectName,metaData.sessionDate,metaData.eyeTrackingDir);
eyeFile                     = metaData.runName;
reportFile                  = fullfile(eyeDir,eyeFile);

%% Get the pupil raw data
[pupil,glint]               = getLiveTrackReportData(reportFile);

%% Load calibration values
scaleCal                = load(fullfile(eyeDir,metaData.scaleCalName));
if isfield (metaData, 'gazeCalName')
    calMat                  = load(fullfile(eyeDir,metaData.gazeCalName));
end
%% Pull out the response data
% make a temporary vector for timebase
response.timeBase           = 1:length(pupil.x);
% get the first TR
allTs                       = find(pupil.TTL == 1);
% if present, set the first TR to time zero
if ~isempty(allTs)
    firstT                  = allTs(1);
    response.timeBase       = (response.timeBase - firstT) * metaData.acqRate;
else
    response.timeBase       = (response.timeBase - 1) * metaData.acqRate;
end
% set the other values
response.TTL                = pupil.TTL;
response.isTracked          = pupil.isTracked;

%% Calibrate pupil size
% use the maximum diameter calibration dot
[~,maxDot]                  = max(scaleCal.ScaleCal.pupilDiameterMmGroundTruth);
response.pupilWidth         = pupil.width ./ scaleCal.ScaleCal.cameraUnitsToMmWidth(maxDot);
response.pupilHeight        = pupil.height./ scaleCal.ScaleCal.cameraUnitsToMmHeight(maxDot);
% Deprecated, this uses the mean
% response.pupilWidth     = pupil.width ./ scaleCal.ScaleCal.cameraUnitsToMmWidthMean;
% response.pupilHeight    = pupil.height./ scaleCal.ScaleCal.cameraUnitsToMmHeightMean;
%% Calculate the gaze
if isfield (metaData, 'gazeCalName')
    outData                 = crsLiveTrackCalibrateRawData(calMat.CalMat, calMat.Rpc, [pupil.x;pupil.y]', [glint.x;glint.y]');
    gaze.x                  = outData(:,1);
    gaze.y                  = outData(:,2);
    [gaze.pol,gaze.ecc]     = cart2pol(gaze.x,gaze.y);
    response.gazeEcc        = rad2deg(calc_visual_angle(gaze.ecc,metaData.viewDist))';
    response.gazePolar      = mod(rad2deg( ((2*pi) - gaze.pol) + pi),360)';
end
%% Append metaData
response.metaData = metaData;