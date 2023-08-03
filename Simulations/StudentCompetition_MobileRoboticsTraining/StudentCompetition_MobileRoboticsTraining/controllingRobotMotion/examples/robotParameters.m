%Robot Parameters
% Copyright 2017 The MathWorks, Inc.

wheelR = 0.052; %Wheel radius
axleLength = 0.28; %Distance between wheels
ticksPerRot = 627.2; % Ticks per rotation for encoders
load wheelMotorLUT %Look up table for VEX motors
Ts = 0.01; %Sample time