function [reportToProcess, reportParamsStruct] = identifyReportsToProcess(dropboxDir,params)

% INPUTS
%
% dropBoxDir = 'TOME_data';
% params.outputDir = 'TOME_analysis';
% params.eyeTrackingDir = 'EyeTracking';
% params.stimuliDir = 'TOME_materials/StimulusFiles';
% screenSpecsFile = 'TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
% unitsFile = 'TOME_materials/hardwareSpecifications/unitsFile.mat';


% HOW THE CELL ARRAY LOOKS LIKE
% reportsToProcessCellArray{cc} = session
% reportsToProcessCellArray{cc,ss} = subject
% reportsToProcessCellArray{cc,ss,dd} = date
% reportsToProcessCellArray{cc,ss,dd,rr} = run
% % code looks for all these fields


% HOW THE PARAMS ARRAY LOOKS LIKE
% reportParamsStructArray{cc,ss,dd,rr}.outputDir
% reportParamsStructArray{cc,ss,dd,rr}.eyeTrackingDir
% reportParamsStructArray{cc,ss,dd,rr}.stimuliDir
% reportParamsStructArray{cc,ss,dd,rr}.screenSpecsFile
% reportParamsStructArray{cc,ss,dd,rr}.unitsFile
% reportParamsStructArray{cc,ss,dd,rr}.scaleCalName % code looks for it
% reportParamsStructArray{cc,ss,dd,rr}.GazeCalName  % code looks for it





% look for Sessions in dropboxDir

for cc = 1: lenght(sessions)
    % look for Subjects in each session
    for ss = 1: length(subjects)
        % look for dates in each subject
        for dd = 1:length(dates)
            % look for runs in each date
            for rr = 1: lenght(runs)
                % do something
            end
        end
    end
end