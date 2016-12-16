%% define calibration targets
% Define the diameter of the fixation points (in degrees)
degFix = 0.2;

calTargets = [-7 -7;0 -7;7 -7;-7 0;0 0;7 0;-7 7;0 7;7 7];
calTargets = calTargets(randperm(size(calTargets,1)),:);

%% Calculate screen features

screenSize = 32; %inches
Res.width= 1920; %pixel/inch
Res.height= 1080; %pixel/inch

viewDist = 1065; %mm

inch2mm = 25.4;
screenW = sind(atand(Res.width/Res.height))*screenSize*inch2mm; %mm
screenH = sind(atand(Res.height/Res.width))*screenSize*inch2mm; %mm

pixSize = screenW/Res.width; %mm (assuming square px)

pixPerMM = 1/pixSize; %px/mm

%% calculate target positions in terms of DOVA

% degrees of visual angle (DOVA) per mm
DOVA = rad2deg(calc_visual_angle(1,viewDist)); %deg

% mm per DOVA 
mmPerDOVA = 2*viewDist*tand(1/2); %mm/DOVA

%pixel per degree of visual angle
pixPerDOVA = mmPerDOVA/pixSize; %px/DOVA 

% take center as reference
cnrTargetDOVA = [0 0];

% target distances in pixels from center
tgtLocsPX(:,1) = round(calTargets(:,1)*pixPerDOVA+cnrTargetDOVA(1)); %in px
tgtLocsPX(:,2) = round(calTargets(:,2)*pixPerDOVA+cnrTargetDOVA(2)); %in px
figure
plot(tgtLocsPX(:,1),tgtLocsPX(:,2), 'o')
title ('target location in pixels from center')

% target distances in mm from center
tgtLocsMM(:,1) = round(tgtLocsPX(:,1) * pixSize); %mm
tgtLocsMM(:,2) = round(tgtLocsPX(:,2) * pixSize); %mm
figure
plot(tgtLocsMM(:,1),tgtLocsMM(:,2), 'o')
title ('target location in mm from center')

% targets 
MYtargets(:,:) = calTargets(:,:)*mmPerDOVA;  %Location of targets in mm

MYTargetsDOVA = rad2deg(atan(sqrt((MYtargets(:,1)).^2 + (MYtargets(:,2)).^2) ./ viewDist));

MYTargetsDOVA2 = rad2deg(atan(sqrt((tgtLocsMM(:,1)).^2 + (tgtLocsMM(:,2).^2)) ./ viewDist));

%% CRS
% mm per degree
degPerMM = tand(1)*viewDist;

% calculate pixels per degree
pixPerDeg = degPerMM/pixSize;

% target location in pixels
cnrTarget = [round(Res.width/2) round(Res.height/2)];
tgtLocsPX(:,1) = round(calTargets(:,1)*pixPerDeg+cnrTarget(1)); 
tgtLocsPX(:,2) = round(calTargets(:,2)*pixPerDeg+cnrTarget(2));
targets(:,:) = calTargets(:,:)*degPerMM;
plot(targets(:,1),targets(:,2), 'o');

TargetsDOVA = rad2deg(atan(sqrt((targets(:,1)).^2 + (targets(:,2)).^2) ./ viewDist));