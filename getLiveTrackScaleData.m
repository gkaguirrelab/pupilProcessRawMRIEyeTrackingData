function [calData] = getLiveTrackScaleData(params)

% Load a LiveTrack '*ScaleCal.mat.mat' data file, outputs scale data
%
%   Usage:
%       [calData] = getLiveTrackScaleData(dataFile)
%
%   Required:
%       params.calFile  - '/path/to/some/calFile.mat';
%
%   Output:
%       calData.mm      - vector of calibration dot sizes (mm)
%       calData.width   - vector of calibration dot widths (pixels)
%       calData.height  - vector of calibration dot heights (pixels)
%       calData.height4 - height of 4mm dot (pixels)
%       calData.width3  - width of 3mm dot (pixels)
%       calData.height3 - height of 3mm dot (pixels)
%
%   Written by Andrew S Bock Oct 2016

%% Load the LiveTrack data file
liveTrackData           = load(params.calFile);

%% Loop through all the dot sizes
for i = 1:length(liveTrackData.ScaleCal.pupilDiameterMmGroundTruth)
    ct = 0;
    tmpWidth                = 0;
    tmpHeight               = 0;
    for j = 1:length(liveTrackData.ScaleCal.ReportRaw{i})
        % Channel 1
        ct                  = ct + 1;
        tmpWidth(ct)        = liveTrackData.ScaleCal.ReportRaw{i}(j).PupilWidth_Ch01;
        tmpHeight(ct)       = liveTrackData.ScaleCal.ReportRaw{i}(j).PupilHeight_Ch01;
        % Channel 2
        ct                  = ct + 1;
        tmpWidth(ct)        = liveTrackData.ScaleCal.ReportRaw{i}(j).PupilWidth_Ch02;
        tmpHeight(ct)       = liveTrackData.ScaleCal.ReportRaw{i}(j).PupilHeight_Ch02;
    end
    % Output data
    calData.mm(i)           = liveTrackData.ScaleCal.pupilDiameterMmGroundTruth(i);
    calData.width(i)        = mean(tmpWidth);
    calData.height(i)       = mean(tmpHeight);
end