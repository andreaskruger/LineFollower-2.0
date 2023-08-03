clc
clear variables
close all
%%
%load('map.mat');
%img = mapForSim.lineFollowingMap;
img = imread('map_small.jpg');
img = im2gray(img);
img = im2bw(img);
img = double(img);
img = imcomplement(img);
img = flipud(img);
imshow(img)
%%
clc
close all
pixel = 2;
offset_x = 80;                          %Offset for start position
offset_y = 165;                         %Offset for start position
v1 = 40;                                %Left  wheel velocity
v2 = 40;                                %Right wheel velocity
initialState = [0; 0; 0];
spacing = 6;                            %Spacing between sensors 
length_body = 15;                       %distance between center and centor of sensors

plots = 'sensor';   
%plots = 'values';
%plots = 'all';

out = sim('simLink_line');

out0 = out.simout.signals.values;  %States [x,y,theta]
out1 = out.simout1.signals.values;  %Sensor center [sensor_mid_x,sensor_mid_y]
out2 = out.simout2.signals.values;  %sensor locations [x1, y1, x2, y2 x3, y3, x4, y4, x5, y5, x6, y6, x7, y7]
out3 = out.simout3.signals.values;  %Sensor values [sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7]
out4 = out.simout4.signals.values;  %Speed after control [Speed]

sensor_x = 1;
sensor_y = 2;
%figure;
%img_sensor = img(out2(1,sensor_y) + offset_y - pixel:out2(1,sensor_y) + offset_y + pixel, out2(1,sensor_x) + offset_x - pixel:out2(1,sensor_x) + offset_x + pixel);
%imshow(img_sensor);


if(strcmp(plots,'sensor')||strcmp(plots,'all'))
    figure;
    RI = imref2d(size(img));
    RI.XWorldLimits = [0 500];
    RI.YWorldLimits = [0 500];
    for i=1:length(out0)
        imshow(imcomplement(img),RI);
        set(gca,'YDir','normal')
        hold on
        plot(out0(i,1) + offset_x,out0(i,2) + offset_y,'LineWidth',1.5);
        plot(out2(i,1) + offset_x,out2(i,2) + offset_y,'b*');
        plot(out2(i,3) + offset_x,out2(i,4) + offset_y,'b*');
        plot(out2(i,5) + offset_x,out2(i,6) + offset_y,'b*');
        plot(out2(i,7) + offset_x,out2(i,8) + offset_y,'b*');
        plot(out2(i,9) + offset_x,out2(i,10) + offset_y,'b*');
        plot(out2(i,11) + offset_x,out2(i,12) + offset_y,'b*');
        plot(out2(i,13) + offset_x,out2(i,14) + offset_y,'b*');
        plot(out0(i,1) + offset_x,out0(i,2) + offset_y,'o','MarkerFaceColor',[1,0,0]);
        axis equal
        hold off
        pause(0.001);
    end
end

if(strcmp(plots,'values')||strcmp(plots,'all'))
    figure;
    plot(out3(1,:),out.simout3.time)
    hold on
    plot(out3(2,:),out.simout3.time)
    plot(out3(3,:),out.simout3.time)
    plot(out3(4,:),out.simout3.time)
    plot(out3(5,:),out.simout3.time)
    plot(out3(6,:),out.simout3.time)
    plot(out3(7,:),out.simout3.time)
    legend('sensor 1', 'sensor 2', 'sensor 3', 'sensor 4', 'sensor 5', 'sensor 6', 'sensor 7');
end




