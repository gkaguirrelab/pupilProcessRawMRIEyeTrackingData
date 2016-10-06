function [PupilData] = LiveTrack_CalibrateReport(savePath, saveName, Report,ScaleCal,LTdata)

% calibrate report
%
% PupilData.relativeTime - t=0 the time when the first T is received. Every
% other row of the report has a relative time stamp (rows contain data
% acquired at 60Hz). If no TTL is received, t = 0 is the first acquired
% frame.
%
% PupilData.TTL - is 1 if a TTL was received in that frame.
%
% PupilData.Width - pupil width in mm , is 0 if blink occurrs or pupil is
% otherwise not tracked.
%
% PupilData.Height - pupil height in mm,  is 0 if blink occurrs or pupil
% is otherwise not tracked.
%
% PupilData.AbsoluteAngle - the absolute displacement of the gaze (in
% degrees of visual angle) between a given sample and a conventional
% "Origin point" on the screen (center of the screen)
%
% PupilData.RelativeAngle - the relative displacement of the gaze (in
% degrees of visual angle) between a given sample and the previous one
%
%% load report and calibration data
load (Report)
load (ScaleCal)
if exist ('LTdata', 'var')
   load (LTdata)
   GazeCal = true;
else
    GazeCal = false;
end

%% intialize PupilData fields
% Double report field so that every raw is 1 sample (rows acquired at 60Hz)
PupilData(2 * length([Report.frameCount])).RelativeTime = 0;
PupilData(2 * length([Report.frameCount])).TTL = 0;
PupilData(2 * length([Report.frameCount])).Width = 0;
PupilData(2 * length([Report.frameCount])).Height = 0;
if GazeCal
    PupilData(2 * length([Report.frameCount])).AbsoluteAngle = 0;
    PupilData(2 * length([Report.frameCount])).RelativeAngle = 0;
end
%% set relative time
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
    %% copy over TTL info
    % note that every TTL signal will always appear in 2 consecutive rows
    for ii = 1: 2 * length([Report.frameCount])
        PupilData(ii).TTL = 0;
    end
    for ii = 1:length(TTLs)
        PupilData(TTLs(ii)*2).TTL = 1;
        %     PupilData(TTLs(ii)*2 +1).TTL = 1;
    end
end
%% Apply scale calibration to pupil Height and Width and populate PupilData
for ii = 1:length([Report.frameCount]);
    jj = ii*2;
    PupilData(jj).Width = Report(ii).PupilWidth_Ch01 ./ ScaleCal.cameraUnitsToMmWidthMean;
    PupilData(jj).Height = Report(ii).PupilHeight_Ch01 ./ ScaleCal.cameraUnitsToMmHeightMean;
    PupilData(jj+1).Width = Report(ii).PupilWidth_Ch02 ./ ScaleCal.cameraUnitsToMmWidthMean;
    PupilData(jj+1).Height = Report(ii).PupilHeight_Ch02 ./ ScaleCal.cameraUnitsToMmHeightMean;
end

%%
if GazeCal
    % calculate calibration matrix using the non approximate formula for the
    % degrees of visual angle. (maybe)
    
    
    % Apply Gaze calibration and populate Absolute Visual angle
    for ii = 1:length([Report.frameCount]);
    viewDist = 1065; % in mm
    jj = ii*2;
    % first field
    pupil(jj) = [Report(ii).PupilCameraX_Ch01 Report(ii).PupilCameraY_Ch01];
    glint(jj) = [Report(ii).Glint1CameraX_Ch01 Report(ii).Glint1CameraY_Ch01];
    data(jj) = crsLiveTrackCalibrateRawData(CalMat, Rpc, pupil(jj), glint(jj));
    PupilData(jj).AbsoluteAngle = rad2deg(calc_visual_angle(sqrt((data(jj,1)).^2 + (data(jj,2).^2)),viewDist));
    % second field
    pupil(jj+1) = [Report(ii).PupilCameraX_Ch02 Report(ii).PupilCameraY_Ch02];
    glint(jj+1) = [Report(ii).Glint1CameraX_Ch02 Report(ii).Glint1CameraY_Ch02];
    data(jj+1) = crsLiveTrackCalibrateRawData(CalMat, Rpc, pupil(jj+1), glint(jj+1));
    PupilData(jj+1).AbsoluteAngle = rad2deg(calc_visual_angle(sqrt((data(jj+1,1)).^2 + (data(jj+1,2).^2)),viewDist));

end
    
    % populate relative Visual angle
    
    
end

%% save out calibrated Pupil Data
save(fullfile(savePath,saveName),'PupilData')
