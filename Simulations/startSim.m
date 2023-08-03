clc
clear variables
close all
%%
load('map.mat');
img = mapForSim.lineFollowingMap;
%img = imread('test.jpg');
img = im2gray(img);
img = imcomplement(img);
img = padarray(img,[1000,1000],0,"both");
img = flipud(img);
%%
clc
close all
pixel = 1;
offset_x = 1324;
offset_y = 1845;
v1 = 1;
v2 = 1;
initialState = [0; 0; 0];
spacing = 0.03; 

out = sim('simLink_line');

out0 = out.simout1.signals.values;  %States [x,y,theta]
out1 = out.simout1.signals.values;  %Sensor center [sensor_mid_x,sensor_mid_y]
out2 = out.simout2.signals.values;  %sensor locations [x1, x2, x3, y1, y2, y3]
out3 = out.simout3.signals.values;  %Sensor values [sensor1, sensor2, sensor3]
out1 = out.simout1.signals.values;  %Speed after control [Speed]

figure;
RI = imref2d(size(img));
RI.XWorldLimits = [0 3000];
RI.YWorldLimits = [0 3000];
imshow(imcomplement(img),RI);
hold on
set(gca,'YDir','normal')
plot(out0(:,1)+offset_x,out0(:,2)+offset_y,'LineWidth',1.5);
plot(out2(:,1)+offset_x,out2(:,4)+offset_y,'*');
plot(out2(:,2)+offset_x,out2(:,5)+offset_y,'*');
plot(out2(:,3)+offset_x,out2(:,6)+offset_y,'*');
axis equal

