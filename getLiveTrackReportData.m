function [pupil,glint] = getLiveTrackReportData(params)

% Load a LiveTrack '*report.mat' data file, outputs pupil and glint data
%
%   Usage:
%       [pupil,glint] = getLiveTrackReportData(params)
%
%   Required:
%       params.reportFile   - '/path/to/some/reportFile.mat';
%       params.videoDims    - [xDim yDim]; % used to flip the y dimension
%
%   Output:
%       pupil.x             - vector of pupil center X coordinates (pixels)
%       pupil.y             - vector of pupil center Y coordinates (pixels)
%       pupil.width         - vector of pupil widths (pixels)
%       pupil.height        - vector of pupil heights (pixels)
%       pupil.frameNum      - vector of frame numbers
%       glint.x             - vector of glint center X coordinates (pixels)
%       glint.y             - vector of glint center Y coordinates (pixels)
%       glint.frameNum      - vector of frame numbers
%    
%   Written by Andrew S Bock Oct 2016

%% Load the LiveTrack data file
liveTrackData           = load(params.reportFile);

%% Loop through each frame, pull out the X, Y, and size 
ct                      = 0;
for i = 1:length(liveTrackData.Report)
    % Channel 1
    ct                  = ct + 1;
    pupil.x(ct)         = liveTrackData.Report(i).PupilCameraX_Ch01;
    pupil.y(ct)         = params.videoDims(2) - liveTrackData.Report(i).PupilCameraY_Ch01;
    pupil.width(ct)     = liveTrackData.Report(i).PupilWidth_Ch01;
    pupil.heigth(ct)    = liveTrackData.Report(i).PupilHeight_Ch01;
    pupil.frameNum(ct)  = liveTrackData.Report(i).frameCount;
    glint.x(ct)         = liveTrackData.Report(i).Glint1CameraX_Ch01;
    glint.y(ct)         = params.videoDims(2) - liveTrackData.Report(i).Glint1CameraY_Ch01;
    glint.frameNum(ct)  = liveTrackData.Report(i).frameCount;
    % Channel 2
    ct                  = ct + 1;
    pupil.x(ct)         = liveTrackData.Report(i).PupilCameraX_Ch02;
    pupil.y(ct)         = params.videoDims(2) - liveTrackData.Report(i).PupilCameraY_Ch02;
    pupil.width(ct)     = liveTrackData.Report(i).PupilWidth_Ch02;
    pupil.heigth(ct)    = liveTrackData.Report(i).PupilHeight_Ch02;
    pupil.frameNum(ct)  = liveTrackData.Report(i).frameCount;
    glint.x(ct)         = liveTrackData.Report(i).Glint1CameraX_Ch02;
    glint.y(ct)         = params.videoDims(2) - liveTrackData.Report(i).Glint1CameraY_Ch02;
    glint.frameNum(ct)  = liveTrackData.Report(i).frameCount;
end