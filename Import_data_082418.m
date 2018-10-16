%% Import data from One_day_incubation_08_24_18
clear;

%% Import
workingDir = "~/Documents/Works/One_day_incubation_08_24_18.xlsx";
raw = xlsread(workingDir,'Sheet1','A2:B30');

%% Data storage and unit conversion
time = raw(:,1)';
concentration = raw(:,2)';
for i=length(time):-1:2
    time(i) = (time(i) - time(i-1))*24*60;
end
time(1) = 0;
timeDif = time;
for i=2:length(time)
    time(i) = time(i-1) + time(i);
end

%% Calculate respiration rate
concentrationDif = concentration;
for i=2:length(concentration)
    concentrationDif(i) = concentration(i) - concentration(i-1);
end
concentrationDif(1) = 0;

concentrationDif = ppm2ugcm3soil(concentrationDif,833.5,75); % Convert to ug-C/cm3-soil
respirationRate = concentrationDif./(timeDif/60); % ug-C/cm3-soil/h
% respirationRate(1) = 0;

f = fit(time(2:end)',respirationRate(2:end)','exp1');

%% Plotting
plot(time/60,respirationRate,'k^','MarkerSize',12,'LineWidth',2); hold on;
plot(f);
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
ylim([0 4]);
xlabel('Time (minutes)');
ylabel('Respiration rate (gC/m^3/h)');
legend('Incubation data','exponential fitting');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');