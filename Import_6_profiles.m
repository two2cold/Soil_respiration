%% Import_data_Mattsoilmoisture
clear;

%% Data input
depth = 121;
profileNum = 6;
files=cell(1,profileNum);
for n=1:profileNum
    % Use the last file (quasi-equilibrium data)
    filename=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/MattSoilMoisture/GaussNewton/Profile%d/gases9.out',n); 
    files{n}=importdata(filename,' ',3);
end

%% Import data from excel
workingDir = '/Users/yuchenliu/Documents/Works/Posters and presentations/Goldschmidt/2018/Workbook2.xlsx';
CO2Profile = xlsread(workingDir,'Sheet1','C3:H9');
CO2Depth = [25 50 75 100 150 180]; % cm

%% Data process
CO2Fit = zeros(depth,profileNum);
for i=1:profileNum
    CO2Fit(:,i) = pchip(CO2Depth(1:4),CO2Profile(i,1:4),10:130);
end
CO2Percentage = zeros(depth,profileNum);
for j=1:profileNum 
    for i=1:depth
        CO2Percentage(i,j) = 1 - files{j}.data(i,3)*1e6/CO2Fit(i,j);
    end
end
CO2Auto = zeros(depth,profileNum);
for j=1:profileNum 
    for i=1:depth
        CO2Auto(i,j) = CO2Fit(i,j) - files{j}.data(i,3)*1e6;
    end
end

%% Plotting
for i=1:profileNum
    plot(CO2Percentage(:,i)*100,10:depth+9,'-','LineWidth',2);hold on;
    %plot(CO2Auto(:,i),10:depth+9,'-','LineWidth',2);hold on;
end
set(gca,'ydir','reverse');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
xlim([0 100]);
xlabel('Percentage of Autotroph (%)','FontSize',21);
ylabel('Depth (cm)','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
legend('June 14, 2016','June 15, 2016','July 12, 2016','July 15, 2016','July 18, 2016','August 11, 2016','Location','Best');

%% August 6th 2018, Try function DiffusionReactionSolve
respirationRatePPM = DiffusionReactionSolve(CO2Depth(1:4),CO2Profile(1,1:4),[10 130],0.16,1);
figure;
plot(respirationRatePPM,10:depth+9);
