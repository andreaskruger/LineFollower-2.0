clc
clear variables
close all
%%
map = generate_map(9, 10000, 2000, 30, 500);

figure;
map = im2gray(map);
map = im2bw(map);
map = double(map);
map = imcomplement(map);
map = flipud(map);
imshow(map)
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
out = sim('simLink_line');

out0 = out.simout.signals.values;  %States [x,y,theta]
out1 = out.simout1.signals.values;  %Sensor center [sensor_mid_x,sensor_mid_y]
out2 = out.simout2.signals.values;  %sensor locations [x1, y1, x2, y2 x3, y3, x4, y4, x5, y5, x6, y6, x7, y7]
out3 = out.simout3.signals.values;  %Sensor values [sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7]
out4 = out.simout4.signals.values;  %Speed after control [Speed]

sensor_x = 1;
sensor_y = 2;
%figure;
%map_sensor = map(out2(1,sensor_y) + offset_y - pixel:out2(1,sensor_y) + offset_y + pixel, out2(1,sensor_x) + offset_x - pixel:out2(1,sensor_x) + offset_x + pixel);
%imshow(map_sensor);


if(strcmp(plots,'sensor')||strcmp(plots,'all'))
    figure;
    RI = imref2d(size(map));
    RI.XWorldLimits = [0 length(map(:,1))];
    RI.YWorldLimits = [0 length(map(:,2))];
    for i=1:length(out0)
        imshow(imcomplement(map),RI);
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



