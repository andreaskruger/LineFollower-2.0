function complete_map = generate_map(nr_points, nr_spline_pts, map_offset, angle_cutoff, padding);

pts_list = zeros(nr_points,2);
angle = zeros(nr_points-1,1);
u = zeros(10,3);
v = zeros(10,3);
j = 0;
mag_min = 1000;
mag_max = 2000;
map_size_x = 4000;
map_size_y = 4000;
sensor_size = 10;

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
figure
plot(pts_list(:,1),pts_list(:,2),'or',xyzi(:,1),xyzi(:,2),'b');
hold on
plot(pts_list(:,1),pts_list(:,2))
hold on
plot(pts_list(1,1),pts_list(1,2),'*', 'LineWidth',2)
axis equal
title('Path');
legend('','Path for map','Generated points');

map = zeros(map_size_x, map_size_y);
path = round(xyzi);

for i=1:length(path)
    map(path(i,2) - sensor_size:path(i,2) + sensor_size, path(i,1) - sensor_size:path(i,1) + sensor_size) = 1;
end
min_path_x = min(path(:,1))-10;
max_path_x = max(path(:,1))+10;
min_path_y = min(path(:,2))-10;
max_path_y = max(path(:,2))+10;
complete_map = zeros((max_path_x - min_path_x),(max_path_y - min_path_y));
complete_map = map(min_path_y:max_path_y,min_path_x:max_path_x);
complete_map = padarray(complete_map,[padding, padding],0,'both');