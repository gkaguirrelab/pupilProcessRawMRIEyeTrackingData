function [pupil,glint] = getLiveTrackReportData(reportFile)

% Load a LiveTrack '*report.mat' data file, outputs pupil and glint data
%
%   Usage:
%       [pupil,glint] = getLiveTrackReportData(reportFile)
%
%   Output:
%       pupil.x             - vector of pupil center X coordinates (pixels)
%       pupil.y             - vector of pupil center Y coordinates (pixels)
%       pupil.width         - vector of pupil widths (pixels)
%       pupil.height        - vector of pupil heights (pixels)
%       pupil.frameNum      - vector of frame numbers
%       pupil.TTL           - vector of TTL present (1) or absent (0)
%       pupil.isTracked     - vector of pupil tracked (1) or not (0)
%       glint.x             - vector of glint center X coordinates (pixels)
%       glint.y             - vector of glint center Y coordinates (pixels)
%       glint.frameNum      - vector of frame numbers
%    
%   Written by Andrew S Bock Oct 2016

%% Load the LiveTrack data file
liveTrackData           = load(reportFile);

%% Loop through each frame, pull out the X, Y, and size 
ct                      = 0;
for i = 1:length(liveTrackData.Report)
    % Channel 1
    ct                  = ct + 1;
    pupil.x(ct)         = liveTrackData.Report(i).PupilCameraX_Ch01;
    pupil.y(ct)         = liveTrackData.Report(i).PupilCameraY_Ch01;
    pupil.width(ct)     = liveTrackData.Report(i).PupilWidth_Ch01;
    pupil.height(ct)    = liveTrackData.Report(i).PupilHeight_Ch01;
    pupil.frameNum(ct)  = liveTrackData.Report(i).frameCount;
    pupil.TTL(ct)       = liveTrackData.Report(i).Digital_IO1;
    pupil.isTracked(ct) = liveTrackData.Report(i).PupilTracked_Ch01;
    glint.x(ct)         = liveTrackData.Report(i).Glint1CameraX_Ch01;
    glint.y(ct)         = liveTrackData.Report(i).Glint1CameraY_Ch01;
    glint.frameNum(ct)  = liveTrackData.Report(i).frameCount;
    % Channel 2
    ct                  = ct + 1;
    pupil.x(ct)         = liveTrackData.Report(i).PupilCameraX_Ch02;
    pupil.y(ct)         = liveTrackData.Report(i).PupilCameraY_Ch02;
    pupil.width(ct)     = liveTrackData.Report(i).PupilWidth_Ch02;
    pupil.height(ct)    = liveTrackData.Report(i).PupilHeight_Ch02;
    pupil.frameNum(ct)  = liveTrackData.Report(i).frameCount;
    pupil.TTL(ct)       = liveTrackData.Report(i).Digital_IO2;
    pupil.isTracked(ct) = liveTrackData.Report(i).PupilTracked_Ch02;
    glint.x(ct)         = liveTrackData.Report(i).Glint1CameraX_Ch02;
    glint.y(ct)         = liveTrackData.Report(i).Glint1CameraY_Ch02;
    glint.frameNum(ct)  = liveTrackData.Report(i).frameCount;
end