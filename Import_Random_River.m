%% Import_data_Mattsoilmoisture
clear;

%% Data input
filename=sprintf('~/Documents/Works/Papers/3/RandomMapGenerator/aqrate%d.out',1); 
% filename=sprintf('~/Documents/Works/Papers/3/RandomMapGenerator/gases%d.out',1); 
files=importdata(filename,' ',3);

%% Import data from excel
workingDir = '/Users/yuchenliu/Documents/Works/Posters and presentations/Goldschmidt/2018/Workbook2.xlsx';
CO2Profile = xlsread(workingDir,'Sheet1','C3:H9');
CO2Depth = [25 50 75 100 150 180]; % cm

%% Data process
depth = size(files.data,1);
profileNum = 7;
CO2Fit = zeros(121,profileNum);
for i=1:profileNum
    CO2Fit(:,i) = pchip(CO2Depth(1:4),CO2Profile(i,1:4),10:130);
end

%% Plotting
plot(files.data(:,2)*1000000,1:depth,'-','LineWidth',2);hold on;
set(gca,'ydir','reverse');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
% xlim([0 100]);
xlabel('CO2 concentration (ppm)','FontSize',21);
ylabel('Depth (cm)','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
% legend('June 14, 2016','June 15, 2016','July 12, 2016','July 15, 2016','July 18, 2016','August 11, 2016','Location','Best');

%% August 6th 2018, Try function DiffusionReactionSolve
% respirationRatePPM = DiffusionReactionSolve(CO2Depth(1:4),CO2Profile(1,1:4),[10 130],0.16,1);
% figure;
% plot(respirationRatePPM,10:depth+9);
