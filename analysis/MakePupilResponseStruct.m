function [response] = MakePupilResponseStruct(PupilData, metaData)

% Response struct:
% response.timebase
% response.pupilWidth
% response.pupilHeight
% response.gazeEcc
% response.gazePolar
% response.TTL
% response.isTracked
% response.metaData

% In metadata: ( these are either structs or values or paths?)
% % subject name
% % session date
% % run name/number
% % units
% % gaze calibration data
% % gaze calibration matrix
% % scale calibration
% % Raw report
% % Screen specs
% % Stimuli specs


%% copy over metaData
response.metaData = metaData;
%% copy other array elements

response.pupilWidth = [PupilData.Width];
response.pupilHeight = [PupilData.Height];
response.gazeEcc = [PupilData.Ecc];
response.gazePolar = [PupilData.Pol];
response.TTL = [PupilData.TTL];
response.isTracked = [PupilData.isTracked];
sec2msec = 1000;
for ii = 1:length([PupilData.RelativeTime])
   response.timebase(ii) = PupilData(ii).RelativeTime * sec2msec;
end


%% OLD
% %% initialize array elements
% response(length([PupilData.RelativeTime])).timebase = NaN;
% response(length([PupilData.RelativeTime])).pupilWidth = NaN;
% response(length([PupilData.RelativeTime])).pupilHeight = NaN;
% response(length([PupilData.RelativeTime])).gazeEcc = NaN;
% response(length([PupilData.RelativeTime])).gazePolar = NaN;
% response(length([PupilData.RelativeTime])).TTL = NaN;
% response(length([PupilData.RelativeTime])).isTracked = NaN;
%
% %% Populate response fields
% sec2msec = 1000;
% for ii = 1:length([PupilData.RelativeTime])
%     response(ii).timebase = PupilData(ii).RelativeTime * sec2msec;
%     response(ii).pupilWidth = PupilData(ii).Width;
%     response(ii).pupilHeight = PupilData(ii).Height;
%     response(ii).gazeEcc = PupilData(ii).Ecc;
%     response(ii).gazePolar = PupilData(ii).Pol;
%     response(ii).TTL = PupilData(ii).TTL;
%     response(ii).isTracked = PupilData(ii).isTracked;
% end


