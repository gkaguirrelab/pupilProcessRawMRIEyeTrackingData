function [metaData] = makeMetaData(outputDir,projectFolder,projectSubfolder,eyeTrackingFolder,stimuliDir,screenSpecsFile,unitsFile,subjectName,sessionDate,runName,ScaleCalName,GazeCalName)
%  [metaData] = makeMetaData(outputDir,projectFolder,projectSubfolder,eyeTrackingFolder,stimuliDir,screenSpecsFile,unitsFile,subjectName,sessionDate,runName,ScaleCalName,GazeCalName)
%  This functon will create the metadata fields for stimulus Response
%  Structs
%
% Paths
%     metaData.dropboxPaths.outputDir
%     metaData.dropboxPaths.projectFolder
%     metaData.dropboxPaths.projectSubfolder
%     metaData.dropboxPaths.eyeTrackingfolder
%     metaData.dropboxPaths.stimuliDir
%     metaData.dropboxPaths.screenSpecsFile
%     metaData.dropboxPaths.unitsFile
%
% Names
%     metaData.names.subjectName
%     metaData.names.sessionDate
%     metaData.names.runName
%     metaData.names.ScaleCalName
%     metaData.names.GazeCalName
%
% Misc
%    metaData.misc.timeStamp
%    metaData.misc.creator
%    metaData.misc.gitVersion
%
%% Populate fields with inputs
metaData.dropboxPaths.outputDir = outputDir;
metaData.dropboxPaths.projectFolder = projectFolder;
if ischar(projectSubfolder)
    metaData.dropboxPaths.projectSubfolder = projectSubfolder;
end
metaData.dropboxPaths.eyeTrackingFolder = eyeTrackingFolder;
metaData.dropboxPaths.stimuliDir = stimuliDir;
metaData.dropboxPaths.screenSpecsFile = screenSpecsFile;
metaData.dropboxPaths.unitsFile = unitsFile;
metaData.names.subjectName = subjectName;
metaData.names.sessionDate = sessionDate;
metaData.names.runName = runName;
metaData.names.ScaleCalName = ScaleCalName;
if ischar(GazeCalName)
    metaData.names.GazeCalName = GazeCalName;
end

%% Get timestamp
formatOut = 'mmddyy_HHMMSS';
timestamp = datestr((datetime('now')),formatOut);
metaData.misc.timeStamp = timestamp;
%% Get creator
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
metaData.misc.creator = userName;

%% Get git version

% NEED TO WRITE THIS
