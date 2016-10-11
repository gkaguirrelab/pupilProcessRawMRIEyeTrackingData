% This script makes an animation of the gaze direction for 4 subjects
% during Connectiome Session2 Mov3.

%% Define paths
savepath = '/Users/giulia/Desktop/TOMEcompareMOV4' ;

subjects = { ...
    'TOME_3001' ...
    'TOME_3002' ...
    'TOME_3003' ...
    'TOME_3005' ...
    };
sessions = { ...
    '081916' ...
    '082616' ...
    '091616' ...
    '100316' ...
    };
gazeCals = { ...
    'LTcal_081916_141343.mat' ...
    'LTcal_082616_141133.mat' ...
    'LTcal_091616_100736.mat' ...
    'LTcal_100316_092338.mat' ...
    };
scaleCals = { ...
    'TOME_3001_081916ScaleCal.mat' ...
    'TOME_3002_082616ScaleCal.mat' ...
    'TOME_3003_091616ScaleCal.mat' ...
    'TOME_3005_100316ScaleCal.mat' ...
    };
%% calibrate for every run
for rr = 1: length(subjects)
    path = fullfile('/Users/giulia/Dropbox-Aguirre-Brainard-Lab/TOME_data/session2_spatialStimuli', subjects{rr} , sessions {rr}, 'EyeTracking');
    load (fullfile(path, 'tfMRI_MOVIE_PA_run03_report.mat'))
    load (fullfile(path, scaleCals{rr}))
    load (fullfile(path, gazeCals{rr}))
    [PupilData] = pupilPETD_main(Report,ScaleCal,CalMat,Rpc);
    savestr = fullfile(savepath, [subjects{rr} '_MOV3.mat']);
    save(savestr, 'PupilData');
    clear PupilData
end

%% extract ecc and pol for every run (starting from time zero)
for rr = 1: length(subjects)
    load (fullfile(savepath, [subjects{rr} '_MOV3.mat']));
    start = find([PupilData.RelativeTime] == 0);
    for ii = 1:start+20160
        Ecc(ii,rr) = PupilData(ii).Ecc;
        Pol(ii,rr) = PupilData(ii).Pol;
        X(ii,rr) = PupilData(ii).GazeX;
        Y(ii,rr) = PupilData(ii).GazeY;
    end
    clear PupilData
end

%% Make animated polar plot
writerObj = VideoWriter(fullfile(savepath,'Polar15fps4subj.avi'),'Motion JPEG AVI');
writerObj.FrameRate =15;
open(writerObj);
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');
time = 0:1/60:336/10;
for k = 1:4:20160/10
    t = 0 : .01 : 2 * pi;
    P = polar(t, 25 * ones(size(t)));
    set(P, 'Visible', 'off')
    hold on
    S1 = polar(Pol(k,1),Ecc(k,1),'o');
    hold on
    S2 = polar(Pol(k,2),Ecc(k,2),'o');
    hold on
    S3 = polar(Pol(k,3),Ecc(k,3),'o');
    hold on
    S4 = polar(Pol(k,4),Ecc(k,4),'o');
    str = ['Time = ', num2str(time(k))];
    text(20.*cos(4),20.*sin(4),str,...
        'HorizontalAlignment','left',...
        'VerticalAlignment','bottom')
    view([180 90])
    view ([90, - 90])
    title('Unfiltered Gaze direction in terms of Eccentricity and Polar Angle')
    l = legend ([S1, S2, S3, S4], 'TOME_3001','TOME_3002','TOME_3003','TOME_3005');
    set (l, 'Interpreter', 'none')
    frame = getframe;
    writeVideo(writerObj,frame);
    hold off
end

close(writerObj);
close all

%% Make animated cartesian plot
writerObj = VideoWriter(fullfile(savepath,'Cartesian15fps4subj.avi'),'Motion JPEG AVI');
writerObj.FrameRate =15;
open(writerObj);
axis([-697.347/2 697.347/2 -392.257/2 392.257/2]) %screen dimensions in mm
set(gca,'YDir', 'reverse')
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');
time = 0:1/60:336/10;
for k = 1:4:20160/10
    axis([-697.347/2 697.347/2 -392.257/2 392.257/2]) %screen dimensions in mm
    set(gca,'YDir', 'reverse')
    S1 = plot(X(k,1),Y(k,1),'.','MarkerSize', 15);
    hold on
    axis([-697.347/2 697.347/2 -392.257/2 392.257/2]) %screen dimensions in mm
    set(gca,'YDir', 'reverse')
    S2 = plot(X(k,2),Y(k,2),'.','MarkerSize', 15);
    hold on
    axis([-697.347/2 697.347/2 -392.257/2 392.257/2]) %screen dimensions in mm
    set(gca,'YDir', 'reverse')
    S3 = plot(X(k,3),Y(k,3),'.','MarkerSize', 15);
    hold on
    axis([-697.347/2 697.347/2 -392.257/2 392.257/2]) %screen dimensions in mm
    set(gca,'YDir', 'reverse')
    S4 = plot(X(k,4),Y(k,4),'.','MarkerSize', 15);
    str = ['Time = ', num2str(time(k))];
    text(-300,-150,str)
    title('Unfiltered Gaze direction in mm from center of the monitor')
    l = legend ([S1, S2, S3, S4], 'TOME_3001','TOME_3002','TOME_3003','TOME_3005');
    set (l, 'Interpreter', 'none')
    frame = getframe;
    writeVideo(writerObj,frame);
    hold off
end

close(writerObj);
close all