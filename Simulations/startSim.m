clc
clear variables
close all
nr_points = 9;                          % Number of points to generate the map
nr_spline_pts = 10000;                  % How many spline points from those generated map points
map_offset = 2500;                      % offset the map to be in possitive
angle_cutoff = 20;                      % When to recalculate generated points to minimize sharp turns
padding = 500;                          % Add space around the map
sensor_size = 10;                       % Size of sensor in pixels
pixel_conversion = 0.1;                 % Pixel to cm conversion
pixel_sensor = 3;                       % 
pixel_body = 10;
v1 = 50;                                % Left  wheel velocity
v2 = 50;                                % Right wheel velocity

spacing = 2/pixel_conversion;                 % Spacing between sensors 
length_body = pixel_body/pixel_conversion;    % Distance between center and centor of sensors



[map, min_x, min_y, max_x, max_y, offset_x, offset_y,start_angle] = generate_map(nr_points, nr_spline_pts, map_offset, angle_cutoff, padding, sensor_size);
initialState = [0; 0; deg2rad(start_angle)];
map = im2gray(map);
map = im2bw(map);
map = double(map);
map = imcomplement(map);
%map = flipud(map);

plots = 'sensor';   
out = sim('simLink_line');

out0 = out.simout.signals.values;  %States [x,y,theta]
out1 = out.simout1.signals.values;  %Sensor center [sensor_mid_x,sensor_mid_y]
out2 = out.simout2.signals.values;  %sensor locations [x1, y1, x2, y2 x3, y3, x4, y4, x5, y5, x6, y6, x7, y7]
out3 = out.simout3.signals.values;  %Sensor values [sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7]
out4 = out.simout4.signals.values;  %Speed after control [Speed]

sensor_x = 9;
sensor_y = 10;
%figure;
%map_sensor = map(out2(1,sensor_y) + offset_y - pixel_sensor:out2(1,sensor_y) + offset_y + pixel_sensor, out2(1,sensor_x) + offset_x - pixel_sensor:out2(1,sensor_x) + offset_x + pixel_sensor);
%imshow(map_sensor);


if(strcmp(plots,'sensor')||strcmp(plots,'all'))
    figure;
    RI = imref2d(size(map));
    RI.XWorldLimits = [0 size(map,1)];
    RI.YWorldLimits = [0 size(map,2)];
    for i=1:length(out0)
        imshow(map,RI);
        set(gca,'YDir','normal')
        hold on
        plot(out0(i,1) + offset_x,out0(i,2) + offset_y,'LineWidth',1.5);
        plot(out2(i,1) + offset_x,out2(i,2) + offset_y,'*');
        plot(out2(i,3) + offset_x,out2(i,4) + offset_y,'*');
        plot(out2(i,5) + offset_x,out2(i,6) + offset_y,'*');
        plot(out2(i,7) + offset_x,out2(i,8) + offset_y,'*');
        plot(out2(i,9) + offset_x,out2(i,10) + offset_y,'*');
        plot(out2(i,11) + offset_x,out2(i,12) + offset_y,'*');
        plot(out2(i,13) + offset_x,out2(i,14) + offset_y,'*');
        plot(out0(i,1) + offset_x,out0(i,2) + offset_y,'o','MarkerFaceColor',[1,0,0]);
        axis equal
        hold off
        legend('','Sensor 1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Sensor 6','Sensor 7')
        pause(0.001);
    end
end



