function MakePupilResponseStruct(PupilData)

% pupil packet structure for each run:
% pupil.Response.timebase (array)
% pupil.Response.value (array)
% pupil.Response.metadata (struct)

% with "Response" being 
% % TTL
% % width
% % height
% % isTracked (is it a valid sample)
% % gazeX
% % gazeY
% % ecc
% % pol

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