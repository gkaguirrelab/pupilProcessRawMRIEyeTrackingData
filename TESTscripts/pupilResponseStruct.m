% Pupil Response Test script

%% inputs
projectFolder = 'TOME_data'; 
projectSubfolder = 'session2_spatialStimuli';
outputDir = 0 ;
stimuliDir = 'TOME_materials/StimulusFiles';
screenSpecsFile = '/Users/giulia/Dropbox-Aguirre-Brainard-Lab/TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
unitsFile = 0;
subjectName = 'TOME_3001';
sessionDate = '081916';
runName = 'tfMRI_RETINO_PA_run01';
ScaleCalName = 'TOME_3001_081916ScaleCal';
GazeCalName = 'LTcal_081916_133549';

%% make metadata
[metaData] = makeMetaData(projectFolder,projectSubfolder,outputDir,stimuliDir,screenSpecsFile,unitsFile,subjectName,sessionDate,runName,ScaleCalName,GazeCalName);

%% make full response structure
[response] = pupilPETD_main(metaData);
