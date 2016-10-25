function [reportToProcess, reportParams] = identifyReportsToProcess(dropboxDir,params)

%  [reportToProcess, reportParamsStruct] = identifyReportsToProcess(dropboxDir,params)


% INPUTS
%
% dropBoxDir
% params.outputDir = 'TOME_analysis';
% params.projectFolder = 'TOME_data';
% params.subjNaming = 'TOME_3*';
% params.eyeTrackingDir = 'EyeTracking';
% params.stimuliDir = 'TOME_materials/StimulusFiles';
% params.screenSpecsFile = 'TOME_materials/hardwareSpecifications/SC3TScreenSizeMeasurements.mat';
% params.unitsFile = 'TOME_materials/hardwareSpecifications/unitsFile.mat';


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




%% FIND ALL FOLDERS SEPARATELY
% look for Sessions in dropboxDir
sessions = dir(fullfile(dropboxDir, params.projectFolder, params.projectSubfolder));
for cc = 1 : length(sessions) % loop in sessions 
    % look for subjects in each session
    subjects = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, params.subjNaming));
    if isempty(subjects)
        continue
    else
        for ss = 1 : length(subjects) % loop in subjects
            % look for dates in each subject and check if folder is valid
            datesTMP = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, subjects(ss).name));
            cnt = 1;
            for jj = 1:length(datesTMP) % check if valid
                if datesTMP(jj).isdir && ~strcmp(datesTMP(jj).name,'.') && ~strcmp(datesTMP(jj).name,'..')
                    dates(cnt) = datesTMP(jj);
                    cnt = cnt +1;
                end
            end
            for dd = 1:length(dates) % loop in dates 
                % look for scale cal in each date (there is only one Scale
                % calibration file)
                ScaleCal = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, subjects(ss).name,dates(dd).name,params.eyeTrackingDir,'*ScaleCal*.mat'));
                % look for runs in each date
                runs = dir(fullfile(dropboxDir, params.projectFolder, sessions(cc).name, subjects(ss).name,dates(dd).name,params.eyeTrackingDir,'*report.mat'));
                for rr = 1 :length(runs) %loop in runs
                    % add fields in reportToProcess
                    reportToProcess{cc,ss,dd,rr} = {sessions(cc).name, subjects(ss).name, dates(dd).name, runs(rr).name};
                    % if the report is not empty, create the
                    % reportParamStruct
                    if ~isempty(reportToProcess{cc,ss,dd,rr})
                        reportParams{cc,ss,dd,rr}.outputDir = params.outputDir;
                        reportParams{cc,ss,dd,rr}.projectFolder = params.projectFolder;
                        reportParams{cc,ss,dd,rr}.projectSubfolder = sessions(cc).name;
                        reportParams{cc,ss,dd,rr}.eyeTrackingDir = params.eyeTrackingDir;
                        reportParams{cc,ss,dd,rr}.stimuliDir = params.stimuliDir;
                        reportParams{cc,ss,dd,rr}.screenSpecsFile = params.screenSpecsFile;
                        reportParams{cc,ss,dd,rr}.unitsFile = params.unitsFile;
                        reportParams{cc,ss,dd,rr}.subjectName = subjects(ss).name;
                        reportParams{cc,ss,dd,rr}.sessionDate = dates(dd).name;
                        reportParams{cc,ss,dd,rr}.runName = runs(rr).name;
                        reportParams{cc,ss,dd,rr}.scaleCalName = ScaleCal.name;
                        %%% NEED TO WRITE CODE FOR GAZECAL
%                         reportParams{cc,ss,dd,rr}.GazeCalName  % code looks for it
                   
                        
                    end   
                end
            end
        end
    end
end
