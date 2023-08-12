clc
clear variables
close all
nr_points = 9;                          % Number of points to generate the map
nr_spline_pts = 10000;                  % How many spline points from those generated map points
map_offset = 2500;                      % offset the map to be in possitive
angle_cutoff = 30;                      % When to recalculate generated points to minimize sharp turns
padding = 500;                          % Add space around the map
line_size = 10;                         % Size of the line to follow in the map.
sensor_size = 10;                       % Size of sensor in pixels
pixel_conversion = 0.1;                 % Pixel to cm conversion
pixel_sensor = 3;                       % pixel_sensor x pixel_sensor + 1 matrix sensor size.
pixel_body = 10;                        % Amount of pixels for the body
velocity_left = 80;                     % Left  wheel velocity
velocity_right = 80;                    % Right wheel velocity
reading_noise = 0;                      % Power of white noise added to the sensor reading
Position_noise = 0;                     % Power of white noise added to the position
Plot_delay = 0.001;                     % Added delay to the plot for the simulation


spacing = 2/pixel_conversion;                           % Spacing between sensors 
length_body = pixel_body/pixel_conversion;              % Distance between center and centor of sensors
length_close_sensor = pixel_body/pixel_conversion;      % Distance between center and centor of the close set of sensors


% Call the function  to generate the map, matrix with 0 and one. offset_x
% and offset_y is the start position for the robot with an initial angle of
% start_angle
[map, min_x, min_y, max_x, max_y, offset_x, offset_y,start_angle] = generate_map(nr_points, nr_spline_pts, map_offset, angle_cutoff, padding, line_size);
initialState = [0; 0; deg2rad(start_angle)];
% Process the image(map)
map = im2gray(map);
map = im2bw(map);
map = double(map);
map = imcomplement(map);
%map = flipud(map);

% Run the simulation in simulinkk
plots = 'sensor';   
out = sim('simLink_line');

% All the saved tables from simulink
out0 = out.simout.signals.values;  %States [x,y,theta]
out1 = out.simout1.signals.values;  %Sensor center [sensor_mid_x,sensor_mid_y]
out2 = out.simout2.signals.values;  %sensor locations [x1, y1, x2, y2 x3, y3, x4, y4, x5, y5, x6, y6, x7, y7]
out3 = out.simout3.signals.values;  %Sensor values [sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7]
out4 = out.simout4.signals.values;  %Speed after control [Speed]

% Test the sensors to see what they "see"
%sensor_x = 9;
%sensor_y = 10;
%figure;
%map_sensor = map(out2(1,sensor_y) + offset_y - pixel_sensor:out2(1,sensor_y) + offset_y + pixel_sensor, out2(1,sensor_x) + offset_x - pixel_sensor:out2(1,sensor_x) + offset_x + pixel_sensor);
%imshow(map_sensor);

% Plot the simulation of the robot ontop of the map.
if(strcmp(plots,'sensor')||strcmp(plots,'all'))
    figure;
    RI = imref2d(size(map));
    RI.XWorldLimits = [0 size(map,1)];                                                      % Set axis limit for the map to relate the 
    RI.YWorldLimits = [0 size(map,2)];                                                      % map to the x,y values from the simulation
    length(out0)
    for i=1:length(out0)
        imshow(map,RI);                                                                     % Show the map and plot ontop of it
        set(gca,'YDir','normal')
        hold on
        xmin = out0(i,1) + offset_x -length_body;
        xmax = out0(i,1) + offset_x + length_body;
        ymin = out0(i,2) + offset_y - length_body;
        ymax = out0(i,2) + offset_y + length_body;
        rect = polyshape([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin]);            % Plot a rectangle the size of the body
        plot(rotate(rect,rad2deg(out1(i,3)),[out0(i,1) + offset_x,out0(i,2) + offset_y]));  % Rotate the body according to the movement
        plot(out2(i,1) + offset_x,out2(i,2) + offset_y,'b*');                               % Print all the sensors 
        plot(out2(i,3) + offset_x,out2(i,4) + offset_y,'b*');
        plot(out2(i,5) + offset_x,out2(i,6) + offset_y,'b*');
        plot(out2(i,7) + offset_x,out2(i,8) + offset_y,'b*');
        plot(out2(i,9) + offset_x,out2(i,10) + offset_y,'b*');
        plot(out2(i,11) + offset_x,out2(i,12) + offset_y,'b*');
        plot(out2(i,13) + offset_x,out2(i,14) + offset_y,'b*');
        plot(out0(i,1) + offset_x,out0(i,2) + offset_y,'o','MarkerFaceColor',[1,0,0]);      % Mark the center of the robot
        axis equal
        hold off
        legend('','Sensor 1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Sensor 6','Sensor 7', 'Robot position')
        %legend('','','','','','','','', 'Robot position')
        pause(Plot_delay);
    end
end
