%% Read 13C data from Yuchen masterfile 2016
clear;

%% Import data
workingDir = '~/Documents/Works/';
rawData = xlsread([workingDir,'Yuchen Masterfile 2016.xlsx'],'Final Data','B2:B141');

%% Data processing and plotting
time = (1:7)*24;
setsOfSamples = length(rawData)/7;
for i = 1:setsOfSamples
    plot(time,rawData((i*7-6):(i*7))); hold on;
end
set(gca,'fontsize',18);
set(gca,'FontName','Times New Roman');
xlabel('Time (hours)','FontSize',20);
ylabel('\delta^{13}C','FontSize',20);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');