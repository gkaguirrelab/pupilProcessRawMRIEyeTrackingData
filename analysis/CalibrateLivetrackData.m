function [PupilData] = calibrateLiveTrackData(Report,ScaleCal,CalMat,Rpc,viewDist)
% function [PupilData] = CalibrateLiveTrackData(Report,ScaleCal,CalMat,Rpc,viewDist)
%
%
% calibrate LiveTrack Data (collected in the Report) using the Scale and
% gaze calibration values.
%
% PupilData.relativeTime - t=0 the time when the first T is received. Every
% other row of the report has a relative time stamp (rows contain data
% acquired at 60Hz). If no TTL is received, t = 0 is the first acquired
% frame.
%
% PupilData.TTL - is 1 if a TTL was received in that frame.
%
% PupilData.isTracked - is 1 if both glint and pupil are correctly tracked
% (according to the Livetrack, this means that both the pupil and the glint
% were tracked).
%
% PupilData.Width - pupil width in mm , is 0 if blink occurrs or pupil is
% otherwise not tracked.
%
% PupilData.Height - pupil height in mm,  is 0 if blink occurrs or pupil
% is otherwise not tracked.
%
% PupilData.GazeX - X coordinate of the Gaze direction in the calibrated
% screen reference system (positive X pointing right, positive Y pointing
% downs, units in mm).
%
% PupilData.GazeY - Y coordinate of the Gaze direction in the calibrated
% screen reference system (positive X pointing right, positive Y pointing
% downs, units in mm).
%
% PupilData.Ecc - Polar radius in degrees of visual angle of the  gaze
% direction from the center of the screen.
%
% PupilData.Pol - polar position of the gaze, given as clockwise from 0
% degrees (with the upper vertical meridian being the 0 degree position,
% and the right, horizontal meridian being 90 degrees).
%
%
% NOTE: this function does not filter the data, just converts it.
%% load report and calibration data
if exist ('CalMat', 'var') && exist ('Rpc', 'var') && exist ('viewDist', 'var')
    GazeCal = true;
else
    GazeCal = false;
end

%% intialize PupilData fields
% Double report field so that every raw is 1 sample (rows acquired at 60Hz)
PupilData(2 * length([Report.frameCount])).RelativeTime = NaN;
PupilData(2 * length([Report.frameCount])).TTL = NaN;
PupilData(2 * length([Report.frameCount])).isTracked = NaN;
PupilData(2 * length([Report.frameCount])).Width = NaN;
PupilData(2 * length([Report.frameCount])).Height = NaN;
if GazeCal
    PupilData(2 * length([Report.frameCount])).GazeX = NaN;
    PupilData(2 * length([Report.frameCount])).GazeY = NaN;
    PupilData(2 * length([Report.frameCount])).Ecc = NaN;
    PupilData(2 * length([Report.frameCount])).Pol = NaN;
    
end
%% set relative time based on TTL info
hz2sec = 1/60;
TTLs = find ([Report.Digital_IO1]);
if isempty (TTLs)
    PupilData(1).RelativeTime = 0;
    for ii = 2: 2 * length([Report.frameCount])
        PupilData(ii).RelativeTime = hz2sec*ii;
    end
else
    firstTTL = TTLs(1)*2;
    PupilData(firstTTL).RelativeTime = 0;
    for ii = (firstTTL +1 ) : 2 * length([Report.frameCount])
        PupilData(ii).RelativeTime = PupilData(ii-1).RelativeTime + hz2sec;
    end
    for jj = 1: firstTTL-1
        PupilData(jj).RelativeTime = 0 - hz2sec* (firstTTL - jj);
    end
    % copy over TTL info
    % note that every TTL signal will only appear in the first frame that
    % received it.
    for ii = 1: 2 * length([Report.frameCount])
        PupilData(ii).TTL = 0;
    end
    for ii = 1:length(TTLs)
        PupilData(TTLs(ii)*2).TTL = 1;
        %     PupilData(TTLs(ii)*2 +1).TTL = 1;
    end
end
%% Populate isTracked field
for ii = 1:length([Report.frameCount]);
    jj = ii*2;
    PupilData(jj).isTracked = Report(ii).PupilTracked_Ch01;
    PupilData(jj+1).isTracked = Report(ii).PupilTracked_Ch02;  
end
%% Apply scale calibration to pupil Height and Width and populate PupilData
for ii = 1:length([Report.frameCount]);
    jj = ii*2;
    PupilData(jj).Width = Report(ii).PupilWidth_Ch01 ./ ScaleCal.cameraUnitsToMmWidthMean;
    PupilData(jj).Height = Report(ii).PupilHeight_Ch01 ./ ScaleCal.cameraUnitsToMmHeightMean;
    PupilData(jj+1).Width = Report(ii).PupilWidth_Ch02 ./ ScaleCal.cameraUnitsToMmWidthMean;
    PupilData(jj+1).Height = Report(ii).PupilHeight_Ch02 ./ ScaleCal.cameraUnitsToMmHeightMean;
end

%% Calibrate Gaze (if Gaze Calibration matrix available)
if GazeCal
    for ii = 1:length([Report.frameCount]);
        jj = ii*2;
        % first field
        pupil(jj, 1) = Report(ii).PupilCameraX_Ch01;
        pupil(jj, 2) = Report(ii).PupilCameraY_Ch01;
        glint(jj, 1) = Report(ii).Glint1CameraX_Ch01;
        glint(jj, 2) = Report(ii).Glint1CameraY_Ch01;
        
        % second field
        pupil(jj+1, 1) = Report(ii).PupilCameraX_Ch02;
        pupil(jj+1, 2) = Report(ii).PupilCameraY_Ch02;
        glint(jj+1, 1) = Report(ii).Glint1CameraX_Ch02;
        glint(jj+1, 2) = Report(ii).Glint1CameraY_Ch02;
    end
    % calibrate and get: GazeX, GazeY, ecc, pol.
    data = crsLiveTrackCalibrateRawData(CalMat, Rpc, pupil, glint);
    
    for jj = 1 : 2 * length([Report.frameCount])
        PupilData(jj).GazeX = data(jj,1);
        PupilData(jj).GazeY = data(jj,2);
        [PupilData(jj).Ecc, PupilData(jj).Pol] = ConvertLiveTrackCartToPolar(PupilData(jj).GazeX,PupilData(jj).GazeY,viewDist);
    end
end

