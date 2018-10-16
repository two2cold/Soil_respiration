%% Read text file
clear;

%% Read in file
workingDir = "~/Documents/Works/EGM data/18090310.TXT";
fileID = fopen(workingDir);
raw = textscan(fileID,'%s %s %s %n %n %n %d %n %d %d %d %n %d %n %d %d %d','Delimiter',',');

%% Data processing
CO2 = raw{1,6};
howManyDays = 2;
howManyMinutes = 60; % Plot every how many minutes
CO2 = CO2(60*10:60*howManyMinutes:howManyDays*24*60*60+1);
CO2 = ppm2ugcm3soil(CO2,833.5,75);
respirationRate = zeros(1,length(CO2));
for i=2:length(CO2)
    respirationRate(i) = (CO2(i) - CO2(i-1))*60/howManyMinutes; % ug-C/cm3-soil/h
end
% plot(CO2);
plot((1:length(respirationRate))/60*howManyMinutes,respirationRate,'k','LineWidth',2); hold on;
ylim([0 10]);
xlabel('Time (hours)','FontSize',22);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',22);
%legend('Model output','Real data');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'fontsize',22);
set(gca,'FontName','Times New Roman');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');