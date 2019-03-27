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
resp_0_10 = ppm2ugcm3soil(data_hour(2:10,:),210,25);
resp_10_20 = ppm2ugcm3soil(data_hour(11:14,:),210,25);
resp_20_30 = ppm2ugcm3soil(data_hour(15:18,:),210,25);
resp_40_50 = ppm2ugcm3soil(data_hour(19:20,:),210,25);
resp_53_60 = ppm2ugcm3soil(data_hour(21,:),210,25);

resp_0_10_ave = resp_0_10;
resp_0_10_ave(3,:) = (resp_0_10(3,:) + resp_0_10(4,:))/2;
resp_0_10_ave(4,:) = (resp_0_10(5,:) + resp_0_10(6,:))/2;
resp_0_10_ave(5,:) = resp_0_10(7,:);
resp_0_10_ave(6,:) = resp_0_10(8,:);
resp_0_10_ave(7,:) = resp_0_10(9,:);
resp_0_10_ave = resp_0_10_ave(1:7,:);

%% Plotting
% plot(time,resp_0_10,'LineWidth',2);
plot(moisture1,resp_0_10_ave(:,1),'LineWidth',2);hold on;
plot(moisture1,resp_0_10_ave(:,2),'LineWidth',2);
plot(moisture1,resp_0_10_ave(:,3),'LineWidth',2);
plot(moisture1,resp_0_10_ave(:,4),'LineWidth',2);
% set(gca,'ydir','reverse');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
xlabel('WHC (%)','FontSize',21);
ylabel('Soil respiration rate [g-C/m3/h]','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
legend('Depth 0-10 cm, 24 hours','Depth 0-10 cm, 48 hours','Depth 0-10 cm, 72 hours','Depth 0-10 cm, 96 hours');
% legend('30% WHC','60% WHC','60% WHC Rep','90% WHC');