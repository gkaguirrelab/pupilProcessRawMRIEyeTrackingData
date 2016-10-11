function [ecc, pol] = LiveTrack_cartToVisual(x,y,f)
% this function converts the cartesian coordinates of the Gaze direction
% from the LiveTrack Report reference system to the standard eccentricity
% and polar position values.
%
% Inputs
% x = X coordinate of the gaze (orizontal growing from left to right)
% y = Y coordinate of the gaze (vertical growing from top to bottom)
% f = viewing distance
% Note that all inputs need to be in the same units (e.g. mm)
%
% Outputs
% ecc = Polar radius in degrees of visual angle of the  gaze
% direction from the center of the screen.
% pol = polar position of the gaze, given as clockwise from 0
% degrees (with the upper vertical meridian being the 0 degree position,
% and the right, horizontal meridian being 90 degrees).

xa = abs(x);
d = hypot(x,y);
if x==0 && y==0
    ecc = 0;
    pol = 0;
else
    if x>0 && y>0
        deltaAng = 90;
    elseif x>0 && y<0
        deltaAng = 0;
    elseif x<0 && y>0
        deltaAng = 180;
    else
        deltaAng = 270;
    end
    ecc = 2*atand(d/(2*f));
    pol = asind(xa/d) + deltaAng;
end