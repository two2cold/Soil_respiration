%% Parameter optimization for high-resolution incubation dataset
clear;

%% Incubation data
workingDir = "~/Documents/Works/Respiration_data_09.08.2018.xlsx";
raw = xlsread(workingDir, "Sheet1", "B2:AD9");

% Normalize to 1 hour
time = raw(1,:) + 1;
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
meanLow40 = zeros(1,size(raw,2));
for i=1:length(meanFinal)
    meanFinal(i) = ((rateFinal(3,i) + rateFinal(4,i))/2 + rateFinal(1,i) + rateFinal(2,i) + rateFinal(5,i) + rateFinal(6,i))/5;
    meanLow40(i) = ((rateFinal(3,i) + rateFinal(4,i))/2 + rateFinal(2,i) + rateFinal(5,i) + rateFinal(6,i))/4;
end

%% Optimization DM
F = @(p) RSSDM(time,rateFinal(1,:),p,0.66,0.025);
% For 0-10 0.025
% For 0-50 0.02
% For 10-50 0.017
x0 = [0.08/24/12,0.04/24/12,15000,45000,0.012,0.012];
l = [0,0,15000,45000,0,0]; % Lower bound of the parameters
h = [inf,inf,15000,45000,inf,inf]; % Upper bound of the parameters
options = optimoptions('fmincon','Display','iter');
[x, fval, exitflag, output] = fmincon(F,x0,[],[],[],[],l,h,[],options);

%% Optimization FO
F2 = @(p) RSSFO(time(5:end),meanFinal(5:end),p,0.66,0.02);
x0_FO = [2e-2,5e-5,0.02];
l = [0,5e-5,0];
h = [inf,5e-5,inf];
options = optimoptions('fmincon','Display','iter');
[x_FO, fval_FO, exitflag_FO, output_FO] = fmincon(F2,x0_FO,[],[],[],[],l,h,[],options);

%% Plotting
respCurve1 = zeros(1,max(time));
respCurve1O = zeros(1,max(time));
for i = 1:max(time)
    respCurve1(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.66,x(5),x(6),0.025);
    respCurve1O(i) = CarbonRespirationFunc(x0(1),x0(2),x0(3),x0(4),i,0.66,x0(5),x0(6),0.025);
end
plot(1:max(time),respCurve1); hold on;
plot(1:max(time),respCurve1O);
% plot(1:max(x_real),respCurve2);
plot(time,rateFinal(1,:),'*');
% plot(x_real,y_real{2},'^');
set(gca,'fontsize',14);
% ylim([0 12]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',14);
%legend('Model output','Real data');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

%% Plotting FO
respCurveFO1 = zeros(1,max(time));
respCurveFO1O = zeros(1,max(time));
for i = 1:max(time)
    respCurveFO1(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.66,i,x_FO(3),0.02);
    respCurveFO1O(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.66,i,x_FO(3),0.02);
end
plot(1:max(time),respCurveFO1); hold on;
plot(1:max(time),respCurveFO1O,'--');
plot(time,meanFinal,'*');
set(gca,'fontsize',14);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',14);
%legend('Model output','Real data');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');