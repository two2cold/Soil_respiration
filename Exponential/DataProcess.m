%% Data processing
clear;

%% Import data
workingDir = '~/Documents/Works/Papers/3/sidb-master/data/CompileYuchen.xlsx';
data = xlsread(workingDir,'Exp decrease','A13:H52');

%% Plot params vs Temperature
iMoi = 2;
iCol = 3;
figure;
plot(data(iMoi:2:10,8),data(iMoi:2:10,iCol),'-*','LineWidth',2,'MarkerSize',12); hold on;
plot(data((10+iMoi):2:20,8),data((10+iMoi):2:20,iCol),'-*','LineWidth',2,'MarkerSize',12);
plot(data((20+iMoi):2:30,8),data((20+iMoi):2:30,iCol),'-*','LineWidth',2,'MarkerSize',12);
plot(data((30+iMoi):2:40,8),data((30+iMoi):2:40,iCol),'-*','LineWidth',2,'MarkerSize',12);
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
% ylim([0 12]);
xlabel('Temperature','FontSize',22);
if iCol == 2
    ylabel('peakValue','FontSize',22);
elseif iCol == 3
    ylabel('Lambda','FontSize',22);
elseif iCol == 4
    ylabel('Equilibrium value','FontSize',22);
end
legend('Graminoid 10 cm','Shrub 10 cm','Graminoid 30 cm','Shrub 30 cm');
% title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

% Q10 value calculation
Q10Cal(data(iMoi:2:10,8),data(iMoi:2:10,iCol));

%% Plot integration vs temperature
iMoi = 2;
% integration calculation
for i=1:size(data,1)
    inte(i) = 0;
    for j=1:49
        inte(i) = inte(i) + ExponentialFunc(j,data(i,1),data(i,2),data(i,3),data(i,4)) - data(i,4);
    end
end

figure;
plot(data(iMoi:2:10,8),inte(iMoi:2:10),'*','LineWidth',2,'MarkerSize',12); hold on;
plot(data((10+iMoi):2:20,8),inte((10+iMoi):2:20),'*','LineWidth',2,'MarkerSize',12);
plot(data((20+iMoi):2:30,8),inte((20+iMoi):2:30),'*','LineWidth',2,'MarkerSize',12);
plot(data((30+iMoi):2:40,8),inte((30+iMoi):2:40),'*','LineWidth',2,'MarkerSize',12);
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
% ylim([0 12]);
xlabel('Temperature','FontSize',22);
ylabel('Integrated value','FontSize',22);
legend('Graminoid 10 cm','Shrub 10 cm','Graminoid 30 cm','Shrub 30 cm');
% title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

%% Plot params vs moisture
iCol = 4;
figure;
plot(data(:,7),data(:,iCol),'*','LineWidth',2,'MarkerSize',12); hold on;
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
xlim([20 80]);
xlabel('Moisture (%)','FontSize',22);
if iCol == 2
    ylabel('peakValue','FontSize',22);
elseif iCol == 3
    ylabel('Lambda','FontSize',22);
elseif iCol == 4
    ylabel('Equilibrium value','FontSize',22);
end
% legend('Graminoid 10 cm','Shrub 10 cm','Graminoid 30 cm','Shrub 30 cm');
% title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

%% Plot params vs Depth
iCol = 4;
figure;
plot(data(:,6),data(:,iCol),'*','LineWidth',2,'MarkerSize',12); hold on;
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
xlim([0 40]);
xlabel('Depth (cm)','FontSize',22);
if iCol == 2
    ylabel('peakValue','FontSize',22);
elseif iCol == 3
    ylabel('Lambda','FontSize',22);
elseif iCol == 4
    ylabel('Equilibrium value','FontSize',22);
end
% legend('Graminoid 10 cm','Shrub 10 cm','Graminoid 30 cm','Shrub 30 cm');
% title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

%% Plot sensitivity
figure;
timeBradleyCook = [1 7 14 28 49];
dataBradleyCook = [19.58029197 12.17153285 9.178832117 4.306569343 5.237226277];
for i=1:timeBradleyCook(end)
    simulated(i) = ExponentialFunc(i,data(1,1),data(1,2),data(1,3),data(1,4));
    simulatedHigh(i) = ExponentialFunc(i,data(1,1),data(1,2),data(1,3)*2,data(1,4));
    simulatedLow(i) = ExponentialFunc(i,data(1,1),data(1,2),data(1,3)/2,data(1,4));
end
plot(1:timeBradleyCook(end),simulated,'LineWidth',2,'MarkerSize',12); hold on;
plot(1:timeBradleyCook(end),simulatedHigh,'LineWidth',2,'MarkerSize',12);
plot(1:timeBradleyCook(end),simulatedLow,'LineWidth',2,'MarkerSize',12);
plot(timeBradleyCook,dataBradleyCook,'*','LineWidth',2,'MarkerSize',12);
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
xlabel('Time (days)','FontSize',22);
ylabel('Respiration rate (mgC/gC/day)');
legend('Best fit','Decrease half live /2','Increase half live *2','Real data');
% title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

%% Haddix2011
dataHaddix = xlsread(workingDir,'Exp decrease','A54:H83');

iCol = 3;
figure;
for i=1:10
    plot(dataHaddix((i-1)*3+1:i*3,8),dataHaddix((i-1)*3+1:i*3,iCol),'-*','LineWidth',2,'MarkerSize',12); hold on;
end
set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
% ylim([0 12]);
xlabel('Temperature','FontSize',22);
if iCol == 2
    ylabel('peakValue','FontSize',22);
elseif iCol == 3
    ylabel('Lambda','FontSize',22);
elseif iCol == 4
    ylabel('Equilibrium value','FontSize',22);
end
legend('Graminoid 10 cm','Shrub 10 cm','Graminoid 30 cm','Shrub 30 cm');
% title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

% Q10 value calculation
%Q10Cal(dataHaddix(iMoi:2:10,8),dataHaddix(iMoi:2:10,iCol));