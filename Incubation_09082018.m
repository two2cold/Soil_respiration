%% Read respiration file 09/08/2018
clear;

%% Read in data
workingDir = "~/Documents/Works/Respiration_data_09.08.2018.xlsx";
raw = xlsread(workingDir, "Sheet1", "B2:AD9");

% Normalize to 1 hour
ratePerHour = zeros(size(raw,1)-1,size(raw,2));
for i=2:size(raw,2)
    ratePerHour(:,i) = raw(2:end,i)/(raw(1,i) - raw(1,i-1));
end
ratePerHour(2:6,6) = ratePerHour(2:6,6)/2;
ratePerHour(2:6,8) = ratePerHour(2:6,8)/2;
ratePerHour(2:6,5) = (ratePerHour(2:6,4) + ratePerHour(2:6,6))/2;
ratePerHour(2:6,7) = (ratePerHour(2:6,6) + ratePerHour(2:6,8))/2;
rateFinal = ppm2ugcm3soil(ratePerHour,833.5,75);
meanFinal = zeros(1,size(raw,2));
for i=1:length(meanFinal)
    meanFinal(i) = ((rateFinal(3,i) + rateFinal(4,i))/2 + rateFinal(1,i) + rateFinal(2,i) + rateFinal(5,i) + rateFinal(6,i))/5;
end
% figure;
plot(raw(1,:),rateFinal,'-o','LineWidth',2,'MarkerSize',4);
% plot(raw(1,:),rateFinal(7,:),'-','LineWidth',2); hold on;
% plot(raw(1,:),meanFinal,'--','LineWidth',2);
% plot([0 24 48 72],[0,mean(rateFinal(7,1:16)),mean(rateFinal(7,17:23)),mean(rateFinal(7,24:29))],'*','LineWidth',2,'MarkerSize',8);
% plot([0 24 48 72],[0 6.490 7.314 4.350],'^','LineWidth',2,'MarkerSize',8);
set(gca,'fontsize',22);
set(gca,'FontName','Times New Roman');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
xlabel('Time (hours)','FontSize',22);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',22);
% legend('Model simulation','0-50 cm mix','Average of 0-50 cm','Current dataset','Previous dataset');
legend('0-10 cm','10-20 cm','20-30 cm','20-30 cm Rep','30-40 cm','40-50 cm','0-50 cm mix','Average of 0-50 cm','Current dataset','Previous dataset');