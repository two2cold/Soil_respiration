%% Plotting
clear;

%% parameters
lagTime = 24;
peakValue = 7;
lambda = 0.1;
equiValue = 2;

%% Increase by a constant and Q10
for i=1:200
    original(i) = ExponentialFunc(i,lagTime,peakValue,lambda,equiValue);
    plusConstant(i) = ExponentialFunc(i,lagTime,peakValue+2,lambda,equiValue+2);
    timeConstant(i) = ExponentialFunc(i,lagTime,peakValue*1.5,lambda,equiValue*1.5);
end

% Plotting
figure;
plot(1:200,original,'k','LineWidth',2);hold on;
plot(1:200,plusConstant,'r','LineWidth',2);
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
xlabel('Time (hour)','FontSize',21);
ylabel('Respiration rate','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
legend('Original','peakR and equiR increased by 2');

figure;
plot(1:200,original,'k','LineWidth',2);hold on;
plot(1:200,timeConstant,'r','LineWidth',2);
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
xlabel('Time (hour)','FontSize',21);
ylabel('Respiration rate','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
legend('Original','peakR and equiR time 1.5');
set(gca,'box','off');

%% Plotting stdev/average for lambda at different temperatures
data = [0.174378939	0.576847319	0.160022674	0.099553965	0.237026954	0.072013531	0.854613837	0.493626547	0.115872399	0.042872363	0.32974936	0.269483419	0.241954394	0.2255482	0.357497853	0.761719845	0.627184293	0.149896366];
figure;
plot(data,'k*','LineWidth',2);
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
xlabel('Study number','FontSize',21);
ylabel({'Stdev/average for lambda','at different temperatures'},'FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');