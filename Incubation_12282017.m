%% Incubation 12/28/2017
clear;

%% Import data
data = xlsread('/Users/yuchenliu/Documents/Works/Respiration_data_12.28.2017.xlsx','Sheet1','C2:J22');
time = data(1,:);
moisture1 = [20 40 60 70 80 90 100];
moisture2 = [30 60 90];
moisture3 = 60;
depth = [5 15 25 45 55];

%% Calculation and rearrangement
time_used = time;
for i = 1:size(data,2) - 1
    time_used(i+1) = time(i+1) - time(i);
end
data_hour = data;
for i = 1:size(data,1)
    data_hour(i,:) = data(i,:)./time_used;
end
resp_0_10 = data_hour(2:10,:);
resp_10_20 = data_hour(11:14,:);
resp_20_30 = data_hour(15:18,:);
resp_40_50 = data_hour(19:20,:);
resp_53_60 = data_hour(21,:);

%% Plotting
plot(time,resp_10_20);