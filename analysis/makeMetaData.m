function [metaData] = makeMetaData(reportParams)
%  [metaData] = makeMetaData(reportParams)
% 
%  This functon will create the metadata fields for stimulus Response
%  Structs
% 
% 
% INPUT
% reportParams.outputDir
% reportParams.projectFolder
% reportParams.projectSubfolder
% reportParams.eyeTrackingDir
% reportParams.stimuliDir
% reportParams.screenSpecsFile
% reportParams.unitsFile
% reportParams.subjectName
% reportParams.sessionDate
% reportParams.runName
% reportParams.scaleCalName
% reportParams.gazeCalName
%
%  OUTPUT
% metaData.outputDir
% metaData.projectFolder
% metaData.projectSubfolder
% metaData.eyeTrackingDir
% metaData.stimuliDir
% metaData.screenSpecsFile
% metaData.unitsFile
% 
% metaData.subjectName
% metaData.sessionDate
% metaData.runName
% metaData.scaleCalName
% metaData.gazeCalName
% metaData.viewDist
% metaData.acqRate
% 
% metaData.timeStamp
% metaData.creator
% metaData.gitVersion
%
%% Populate fields with inputs
metaData.outputDir = reportParams.outputDir;
metaData.projectFolder = reportParams.projectFolder;
if isfield (reportParams, 'projectSubfolder')
    metaData.projectSubfolder = reportParams.projectSubfolder;
end
metaData.eyeTrackingDir = reportParams.eyeTrackingDir;
metaData.stimuliDir = reportParams.stimuliDir;
metaData.screenSpecsFile = reportParams.screenSpecsFile;
metaData.unitsFile = reportParams.unitsFile;
metaData.subjectName = reportParams.subjectName;
metaData.sessionDate = reportParams.sessionDate;
metaData.runName = reportParams.runName;
metaData.scaleCalName = reportParams.scaleCalName;

if isfield (reportParams, 'gazeCalName')
   metaData.gazeCalName = reportParams.gazeCalName;
   load (metaData.dropboxPaths.screenSpecsFile);
   metaData.viewDist = SC3TScreenSizeMeasurements.distanceToScreen;
    if strcmp (SC3TScreenSizeMeasurements.units, 'cm')
        metaData.viewDist = metaData.viewDist * 10;
    end
end
%% Get timestamp
formatOut = 'mmddyy_HHMMSS';
timestamp = datestr((datetime('now')),formatOut);
metaData.timeStamp = timestamp;
%% Get creator
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
metaData.creator = userName;

%% Get git version

% NEED TO WRITE THIS
