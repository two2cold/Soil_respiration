%% Extrapolating moisture profiles using data Matt sent, also plotting the CO2 profile.
clear;
workingDir = '/Users/yuchenliu/Documents/Works/Posters and presentations/Goldschmidt/2018/Workbook2.xlsx';

%% Import data from excel
CO2Profile = xlsread(workingDir,'Sheet1','C3:H9');
SeProfile = xlsread(workingDir,'Sheet1','I3:O9');
CO2Depth = [25 50 75 100 150 180]; % cm
SeDepth = [10 20 30 50 75 100 130]; % cm
porosity = 0.4;

%% Fitting
% pchipFitResult = cell(1,length(SeDepth));
linearFitResult = cell(1,length(SeDepth));
fitResult = cell(1,length(SeDepth));
for i = 1:7
    % pchipFitResult{i} = pchip(SeDepth,SeProfile(i,:),10:max(SeDepth));
    % pchipFitResult{i} = pchipFitResult{i}/porosity;
    linearFitResult{i} = polyfit(SeDepth,SeProfile(i,:),1);
    for j = 1:130
        fitResult{i}(j) = linearFitResult{i}(1)*j + linearFitResult{i}(2);
    end
    fitResult{i} = fitResult{i}/porosity;
end

%% Range of summer
ave = zeros(1,length(CO2Depth));
for i=1:length(CO2Depth)-1
    ave = ave + CO2Profile(i,:);
end
ave = ave/(length(CO2Depth)-1);
SD = std(CO2Profile(1:6,:));
aveLow = ave - SD;
aveHigh = ave + SD;

aveMoi = zeros(1,length(SeDepth));
for i=1:length(SeDepth)-1
    aveMoi = aveMoi + SeProfile(i,:);
end
aveMoi = aveMoi/(length(SeDepth)-1);
SDMoi = std(SeProfile(1:6,:));
aveMoiLow = aveMoi - SDMoi;
aveMoiHigh = aveMoi + SDMoi;

%% Set up a dichotomized method to find the best respiration rate
% Calculate the integration of the model output and Cerling and Quade output
bestRespirationRate = zeros(1,6);
for i=1:6 % Which profile
    integrateObservation = sum(CO2Profile(i,1:4));
    lowBoundaryRespirationRate = 0;
    highBoundaryRespirationRate = 100;
    timeCount = 0;
    while true
        integrateMidRespirationRate = sum(CerlingAndQuade(CO2Depth(1:4),100,0.05,(lowBoundaryRespirationRate + highBoundaryRespirationRate)/2));
        if abs(integrateMidRespirationRate - integrateObservation) <= 0.01
            bestRespirationRate(i) = (lowBoundaryRespirationRate + highBoundaryRespirationRate)/2;
            break;
        end
        if integrateMidRespirationRate < integrateObservation
            lowBoundaryRespirationRate = (lowBoundaryRespirationRate + highBoundaryRespirationRate)/2;
        else
            highBoundaryRespirationRate = (lowBoundaryRespirationRate + highBoundaryRespirationRate)/2;
        end
        timeCount = timeCount + 1;
        if timeCount > 1000
            printf("Error: no convergence for profile %d",i);
            break;
        end
    end
end
disp(bestRespirationRate);

%% Plotting
% figure;
% for i = 1:6
%     plot(fitResult{i},10:max(SeDepth),'LineWidth',3); hold on;
% end
% set(gca,'ydir','reverse');
% set(gca,'fontsize',18);
% set(gca, 'FontName', 'Times New Roman');
% xlabel('Se','FontSize',21);
% ylabel('Depth','FontSize',21);
% set(gca,'XColor','k');
% set(gca,'YColor','k');
% set(gca,'box','off');
% 
% figure;
for i = 1
    plot(CO2Profile(i,1:4),CO2Depth(1:4),'*','MarkerSize',12,'LineWidth',2); hold on;
%     plot(SeProfile(i,:)/porosity,SeDepth,'-*','MarkerSize',12,'LineWidth',2); hold on;
end
% plot(aveLow(1:4),CO2Depth(1:4),'k-','MarkerSize',12,'LineWidth',2);
% plot(aveHigh(1:4),CO2Depth(1:4),'k-','MarkerSize',12,'LineWidth',2);
% plot(aveMoiLow/porosity,SeDepth,'k-','MarkerSize',12,'LineWidth',2);
% plot(aveMoiHigh/porosity,SeDepth,'k-','MarkerSize',12,'LineWidth',2);
set(gca,'ydir','reverse');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
%ylim([10 145]);
xlim([0 16000]);
xlabel('CO_2 concentration (ppm)','FontSize',21);
ylabel('Depth (cm)','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
% legend('6/14/16','6/15/16','7/12/16','7/15/16','7/18/16','8/11/16','10/20/16','Location','Best');
% legend('1st day','2nd day','3rd day','4th day','5th day','10th day','15th day','20th day','25th day','Field measurement','Location','Best');
