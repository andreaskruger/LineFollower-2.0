function [map, min_x, min_y, max_x, max_y, start_x, start_y, start_angle] = generate_map(nr_points, nr_spline_pts, map_offset, angle_cutoff, padding, sensor_size);

pts_list = zeros(nr_points,2);
angle = zeros(nr_points-1,1);
u = zeros(10,3);
v = zeros(10,3);
j = 0;
mag_min = 500;
mag_max = 3000;
map_size_x = 5000;
map_size_y = 5000;

for i=0:nr_points-2
    magnitude = randi([mag_min mag_max],1);
    pts_list(i+1,1) = map_offset + magnitude*cos(i*(pi/4));
    pts_list(i+1,2) = map_offset + magnitude*sin(i*(pi/4));
    if (i > 1)
        j = j+1;
        while 1   
            u(j,:) = [(pts_list(i-1,1) - pts_list(i,1)), (pts_list(i-1,2) - pts_list(i,2)), 0];
            v(j,:) = [(pts_list(i+1,1) - pts_list(i,1)), (pts_list(i+1,2) - pts_list(i,2)), 0];
            angle(j) = rad2deg(atan2(norm(cross(u(j,:),v(j,:))),dot(u(j,:),v(j,:))));
            if angle(j) < angle_cutoff
                disp('Recalculate the point, to sharp angle')
                pts_list(i+1,1) = 100 + round(magnitude*cos(i*(pi/4)));
                pts_list(i+1,2) = 100 + round(magnitude*sin(i*(pi/4)));
            end
            if angle(j) > angle_cutoff - 1
                break;
            end
        end
    end
    if i == nr_points-2
        j = j+1;
        while 1
            u(j,:) = [(pts_list(2,1) - pts_list(1,1)), (pts_list(2,2) - pts_list(1,2)), 0];
            v(j,:) = [(pts_list(i+1,1) - pts_list(1,1)), (pts_list(i+1,2) - pts_list(1,2)), 0];
            angle(j) = rad2deg(atan2(norm(cross(u(j,:),v(j,:))),dot(u(j,:),v(j,:))));
            if angle(j) < angle_cutoff
                disp('Recalculate the point, to sharp angle')
                pts_list(i+1,1) = 100 + round(magnitude*cos(i*(pi/4)));
                pts_list(i+1,2) = 100 + round(magnitude*sin(i*(pi/4)));
            end
            if angle(j) > angle_cutoff - 1
                break;
            end
        end
    end
end
pts_list(end,1) = pts_list(1,1);
pts_list(end,2) = pts_list(1,2);

t = cumsum([0;sqrt(sum(diff(pts_list,1,1).^2,2))]);
ti = linspace(t(1),t(end),nr_spline_pts);
xyzi = interp1(t,pts_list,ti,'spline');
figure(1)
plot(pts_list(:,1),pts_list(:,2),'or',xyzi(:,1),xyzi(:,2),'b');
hold on
plot(pts_list(:,1),pts_list(:,2))
hold on
plot(pts_list(1,1),pts_list(1,2),'*', 'LineWidth',2)
% axis equal
% title('Path');
% legend('','Path for map','Generated points');

map = zeros(map_size_x, map_size_y);
path = round(xyzi);

for i=1:length(path)
    map(path(i,2) - sensor_size:path(i,2) + sensor_size, path(i,1) - sensor_size:path(i,1) + sensor_size) = 1;
end
min_x = min(path(:,1))-sensor_size;
max_x = max(path(:,1))+sensor_size;
min_y = min(path(:,2))-sensor_size;
max_y = max(path(:,2))+sensor_size;

hold on
plot([min_x,max_x],[max_y,max_y])
plot([max_x,max_x],[max_y,min_y])
plot([max_x,min_x],[min_y,min_y])
plot([min_x,min_x],[min_y,max_y])
hold off
%start_y = min(xyzi(:,2));
%start_x = round(xyzi((find(xyzi(:,2) == start_y)),1));
%start_y = size(complete_map,2) - padding + sensor_size*1.5;
start_x = path(1,1);;
start_y =path(1,2);
vector1 = [(path(50,1) - path(1,1)), (path(50,2) - path(1,2)), 0];
vector2 = [1, 0, 0];
start_angle = rad2deg(atan2(norm(cross(vector1,vector2)),dot(vector2,vector1)));



