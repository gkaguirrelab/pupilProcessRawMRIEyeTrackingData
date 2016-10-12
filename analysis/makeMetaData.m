function [metaData] = makeMetaData(projectFolder,projectSubfolder,outputDir,stimuliDir,screenSpecsFile,unitsFile,subjectName,sessionDate,runName,ScaleCalName,GazeCalName)


%%
% Paths
%     metaData.dropboxPaths.projectFolder
%     metaData.dropboxPaths.projectSubfolder
%     metaData.dropboxPaths.outputDir
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
% RefValues
%     metaData.refValues.screenSpecs
%                               .width
%                               .height
%                               .diag
%                               .viewDist
%                               .units
%     metaData.refValues.livetrackReport
%     metaData.refValues.scaleCal
%                             all scaleCal fields
%     metaData.refValues.gazeCal
%                               .Ldat
%                               .Lcal
%                               .Rpc
% Misc
%    metaData.misc.timeStamp
%    metaData.misc.creator
%    metaData.misc.gitVersion
%

%% Populate fields with inputs
metaData.dropboxPaths.projectFolder = projectFolder;
if ischar(projectSubfolder)
    metaData.dropboxPaths.projectSubfolder = projectSubfolder;
end
metaData.dropboxPaths.outputDir = outputDir;
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

%% automatically populate the other fields
[~, tmpName] = system('whoami');
userName = strtrim(tmpName);
dropboxDir = ['/Users/' userName '/Dropbox-Aguirre-Brainard-Lab/'];
if isfield(metaData.dropboxPaths, 'projectSubfolder')
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectSubfolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,'Eyetracking'));
else
    dataPath =  (fullfile(dropboxDir,metaData.dropboxPaths.projectFolder, ...
        metaData.names.subjectName,metaData.names.sessionDate,'Eyetracking'));
end
metaData.refValues.screenSpecs = load(screenSpecsFile);
metaData.refValues.livetrackReport = load (fullfile(dataPath,[metaData.names.runName '_report.mat']));
metaData.refValues.scaleCal = load (fullfile(dataPath,[metaData.names.ScaleCalName '.mat']));
if ischar(GazeCalName)
    metaData.refValues.gazeCal = load (fullfile(dataPath,[metaData.names.GazeCalName '.mat']));
end
% set timestamp
formatOut = 'mmddyy_HHMMSS';
timestamp = datestr((datetime('now')),formatOut);
metaData.misc.timeStamp = timestamp;
metaData.misc.creator = userName;
