%% Plot gaze position on screen (coordinates in mm from the center)
writerObj = VideoWriter('Gaze12fps.avi','Motion JPEG AVI');
writerObj.FrameRate =12;
open(writerObj);
x = [PupilData.GazeX];
y = [PupilData.GazeY];
t = [PupilData.RelativeTime];
axis([-697.347/2 697.347/2 -392.257/2 392.257/2]) %screen dimensions in mm
set(gca,'YDir', 'reverse')
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');
for k = 1:5:length([PupilData.Width])/60
    plot(x(k),y(k),'.','MarkerSize', 15);
    str = ['Time = ', num2str(t(k))];
    text(-300,-150,str)
    frame = getframe;
    writeVideo(writerObj,frame);
end

close(writerObj);
close all

%% Make animated polar plot

writerObj = VideoWriter('PolarGaze12fpsFlip.avi','Motion JPEG AVI');
writerObj.FrameRate =12;
open(writerObj);
rho = [PupilData.Ecc];
theta = [PupilData.Pol];
time = [PupilData.RelativeTime];
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');
for k = 1:5:length([PupilData.Width])/60
    t = 0 : .01 : 2 * pi;
    P = polar(t, 25 * ones(size(t)));
    set(P, 'Visible', 'off')
    hold on
    polar(theta(k),rho(k),'o');
    str = ['Time = ', num2str(time(k))];
    text(20.*cos(4),20.*sin(4),str,...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
    view([180 90])
    view ([90, - 90]) 
    frame = getframe;
    writeVideo(writerObj,frame);
    hold off
end

close(writerObj);
close all

%% put video behind cartesian plot
% 
% pixar = VideoReader(' ' , 'CurrentTime'. 1228)
