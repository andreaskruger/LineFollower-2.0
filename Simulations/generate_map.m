function [map, min_x, min_y, max_x, max_y, start_x, start_y, start_angle] = generate_map(nr_points, nr_spline_pts, map_offset, angle_cutoff, padding, size_path_line);
% 
% Note: This function will take in some inputs and generate a random map
% done with a sett of points around a circle with random magnitude. Between
% the random points spline curves will be fitted to create a continues
% curve with many points. This curve is then discretized and put into
% matrix form to be represented as a map.
% The discrete map will have a path of thickness 1, this line will be
% thickened with a set nr of pixels. From this generated map a reasonable
% start position will be calculated along with a direction for the robot to
% face. 
% As an extra saftey feature the random point will be recalculated if the
% spline curve between 3 points is "too sharp".
% 
% Input -----
% nr_points: Nr of points to be generated on a circle, these are the points
% to have a random magnitude.
% nr_spline_pts: Nr of spline points to add add between all the generated
% pts.
% map_offset: Offset so that the map is not centerd around (0,0)
% angle_cutoff: At what angle to recalculate the first set of points(degrees)
% padding: NOT IN USE
% size_path_line: size of the generated line to follow(given in nr pixels)
% 
% Output ----- 
% map: 
% min_x: 
% min_y: 
% max_x: 
% max_y: 
% start_x: 
% start_y: 
% start_angle:

pts_list = zeros(nr_points,2);
angle = zeros(nr_points-1,1);
u = zeros(10,3);
v = zeros(10,3);
j = 0;
mag_min = 500;
mag_max = 2500;
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
figure;
plot(pts_list(:,1),pts_list(:,2),'or',xyzi(:,1),xyzi(:,2),'b');
hold on
plot(pts_list(:,1),pts_list(:,2))
hold on
plot(pts_list(1,1),pts_list(1,2),'*', 'LineWidth',2)
map = zeros(map_size_x, map_size_y);
path = round(xyzi);
for i=1:length(path)
    map(path(i,2) - size_path_line:path(i,2) + size_path_line, path(i,1) - size_path_line:path(i,1) + size_path_line) = 1;
end
min_x = min(path(:,1))-size_path_line;
max_x = max(path(:,1))+size_path_line;
min_y = min(path(:,2))-size_path_line;
max_y = max(path(:,2))+size_path_line;

hold on
plot([min_x,max_x],[max_y,max_y],'k')
plot([max_x,max_x],[max_y,min_y],'k')
plot([max_x,min_x],[min_y,min_y],'k')
plot([min_x,min_x],[min_y,max_y],'k')
hold off
legend('Generated points','Path for map','Generated lines','Start location', 'Min/Max value box around the path');
axis equal
title('Path');

start_x = path(1,1);;
start_y =path(1,2);
vector1 = [(path(50,1) - path(1,1)), (path(50,2) - path(1,2)), 0];
vector2 = [1, 0, 0];
start_angle = rad2deg(atan2(norm(cross(vector1,vector2)),dot(vector2,vector1)));



