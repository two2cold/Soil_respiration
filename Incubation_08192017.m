%% Plotting for incubation 08/19/2017
clear;

%% Read in data from excel
data = xlsread('/Users/yuchenliu/Documents/Works/Respiration_data_08.19.2017.xlsx','Sheet1','C2:R21');
time = data(1,:);
resp_depth = data(2:13,:);
resp_moi = data(14:20,:);
depth = [5 15 25 35 45 55 65 75];
moisture = [10 20 30 40 50 80 90];

%% Data calculation and rearrangement
time_used = zeros(1,16);
for i = 1:15
    time_used(i+1) = time(i+1) - time(i);
end
resp_depth_hour = resp_depth;
resp_moi_hour = resp_moi;
for i = 1:12
    resp_depth_hour(i,2:16) = resp_depth_hour(i,2:16)./time_used(2:16);
end
for i = 1:7
    resp_moi_hour(i,2:16) = resp_moi(i,2:16)./time_used(2:16);
end
resp_depth_hour_ave = zeros(8,16);
resp_depth_hour_ave(1,:) = (resp_depth_hour(1,:) + resp_depth_hour(2,:))/2;
resp_depth_hour_ave(2,:) = (resp_depth_hour(3,:) + resp_depth_hour(4,:))/2;
resp_depth_hour_ave(3,:) = resp_depth_hour(5,:);
resp_depth_hour_ave(4,:) = resp_depth_hour(6,:);
resp_depth_hour_ave(5,:) = (resp_depth_hour(7,:) + resp_depth_hour(8,:))/2;
resp_depth_hour_ave(6,:) = resp_depth_hour(9,:);
resp_depth_hour_ave(7,:) = resp_depth_hour(10,:);
resp_depth_hour_ave(8,:) = (resp_depth_hour(11,:) + resp_depth_hour(12,:))/2;

%% Unit conversion
% Assuming 220 mL headspace gas
resp_depth_hour_ave = resp_depth_hour_ave*220*1e-6; % Convert to mL-CO2/h
resp_depth_hour_ave = resp_depth_hour_ave*1e-3; % Convert to L-CO2/h
% Assuming CO2 is 24.4 L/mol
resp_depth_hour_ave = resp_depth_hour_ave/24.4; % Convert to mol-CO2/h
resp_depth_hour_ave = resp_depth_hour_ave*12; % Convert to g-C/h
% Used 20 g of dry soil samples
resp_depth_hour_ave = resp_depth_hour_ave/(20/2.6); % Convert to g-C/cm3-soil/h
resp_depth_hour_ave = resp_depth_hour_ave*1e6; % Convert to ug-C/g-soil/h

% Doing the same thing for resp_moi_hour
resp_moi_hour = resp_moi_hour*220*1d-6*1d-3/24.4*12/(20/2.6)*1d6;

%% Plotting
% figure;
% plot(time,resp_depth_hour_ave);
% figure;
% plot(time,resp_moi_hour);
incubation3dplot(time, moisture, resp_moi_hour)