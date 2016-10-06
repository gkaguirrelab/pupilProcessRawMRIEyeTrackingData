function [PupilData] = pupilPETD_main(savePath, saveName, Report,ScaleCal,LTdata)

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
% PupilData.Theta - polar angle in rad of the gaze direction with respect to the
% center of the screen.
%
% PupilData.Rho - polar radius in mm of the gaze direction with respect to the
% center of the screen.
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
    PupilData(2 * length([Report.frameCount])).Theta = 0;
    PupilData(2 * length([Report.frameCount])).Rho = 0;
    PupilData(2 * length([Report.frameCount])).Eccentricity = 0;
    
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
    % calibrate data using calibration matrix
    
    % Apply Gaze calibration to get gaze location in mm
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
    data = crsLiveTrackCalibrateRawData(CalMat, Rpc, pupil, glint);
    
    for jj = 1 : 2 * length([Report.frameCount])
        % calculate polar coordinates of the gaze on the screen
        [PupilData(jj).Theta, PupilData(jj).Rho] = cart2pol(data(jj,1),data(jj,2));
        % calculate eccentricity
        viewDist = 1065; % distance from the screen in mm
        PupilData(jj).Eccentricity = rad2deg(calc_visual_angle(PupilData(jj).Rho,viewDist));
        %  convert theta to conventional Polar angle (zero on 12oclock,
        %  clockwise)
        
        
    end
end

%% save out calibrated Pupil Data
save(fullfile(savePath,saveName),'PupilData')
