%% Parameter optimization
clear;

%% Incubation data
CarbonRespirationFunc(0.027/24/12,0.004/24/12,15000,45000,50,0.66,0.025,0.006,0.02)
% BM1 respiration data
x_real = [1,24,48,72,96,135,186]; % Time [hour]
y_real = cell(1,7);
y_real{1} = [0 6.490 7.314 4.350 3.054 2.076 1.741]; % gC/m3-soil/hour
y_real{2} = [0 4.193 3.017 2.281 1.916 1.407 1.192];
y_real{3} = [0 3.017 4.394 2.813 1.661 1.112 1.052];
y_real{4} = [0 2.301 1.919 1.507 1.052 0.790 0.743];
y_real{5} = [0 1.538 1.149 0.897 0.509 0.378 0.392];
y_real{6} = [0 1.726 0.919 0.633 0.342 0.224 0.234];
% BCT respiration data
x_test = [1,24,48,72,99,123,147,195,267]; % Time [hour]
y_test = cell(1,8);
y_test{1} = [0,10.652,7.036,5.919,5.157,4.454,3.554,2.796,3.160];%gC/m3-soil/hour
y_test{2} = [0,1.786,2.573,2.983,2.485,1.826,1.547,1.068,1.027];
y_test{3} = [0,1.260,2.045,2.672,1.985,1.489,1.213,0.779,0.852];
y_test{4} = [0,1.043,1.582,2.215,1.605,1.219,1.026,0.659,0.633];
y_test{5} = [0,1.116,1.213,2.028,1.409,1.051,0.897,0.574,0.555];
y_test{6} = [0,1.582,1.993,2.743,1.766,1.371,1.172,0.779,0.770];
y_test{7} = [0,0.879,0.996,1.424,1.339,1.067,0.826,0.522,0.520];
y_test{8} = [0,0.946,0.923,0.891,0.857,0.955,0.853,0.516,0.520];

%% Optimization DM
F = @(p) RSSDM(x_real,y_real{1},p,0.66,0.02) + RSSDM(x_real,y_real{2},p,0.33,0.02);
x0 = [0.027/24/12,0.004/24/12,15000,45000,0.025,0.006];
l = [0,0,15000,45000,0,0]; % Lower bound of the parameters
h = [inf,inf,15000,45000,inf,inf]; % Upper bound of the parameters
options = optimoptions('fmincon','Display','iter');
[x, fval, exitflag, output] = fmincon(F,x0,[],[],[],[],l,h,[],options);

% Calculate AIC
AICDM = zeros(1,6);
AICDM(1) = length(x_real)*log(RSSDM(x_real,y_real{1},x,0.66,0.02)/length(x_real)) + 2*18;
AICDM(2) = length(x_real)*log(RSSDM(x_real,y_real{2},x,0.33,0.02)/length(x_real)) + 2*18;
AICDM(3) = length(x_real)*log(RSSDM(x_real,y_real{3},x,0.66,0.014)/length(x_real)) + 2*18;
AICDM(4) = length(x_real)*log(RSSDM(x_real,y_real{4},x,0.33,0.014)/length(x_real)) + 2*18;
AICDM(5) = length(x_real)*log(RSSDM(x_real,y_real{5},x,0.66,0.009)/length(x_real)) + 2*18;
AICDM(6) = length(x_real)*log(RSSDM(x_real,y_real{6},x,0.33,0.009)/length(x_real)) + 2*18;

%% Optimization FO
FirstOrderModelFunc(2e-2,5e-5,0.66,1,0.02,0.02)
F2 = @(p) RSSFO(x_real(2:end),y_real{1}(2:end),p,0.66,0.02) + RSSFO(x_real(2:end),y_real{2}(2:end),p,0.33,0.02);
x0_FO = [2e-2,5e-5,0.02];
l = [0,5e-5,0];
h = [inf,5e-5,inf];
options = optimoptions('fmincon','Display','iter');
[x_FO, fval_FO, exitflag_FO, output_FO] = fmincon(F2,x0_FO,[],[],[],[],l,h,[],options);

% Calculate AIC
AICFO = zeros(1,6);
AICFO(1) = length(x_real)*log(RSSFO(x_real,y_real{1},x_FO,0.66,0.02)/length(x_real)) + 2*7;
AICFO(2) = length(x_real)*log(RSSFO(x_real,y_real{2},x_FO,0.33,0.02)/length(x_real)) + 2*7;
AICFO(3) = length(x_real)*log(RSSFO(x_real,y_real{3},x_FO,0.66,0.014)/length(x_real)) + 2*7;
AICFO(4) = length(x_real)*log(RSSFO(x_real,y_real{4},x_FO,0.33,0.014)/length(x_real)) + 2*7;
AICFO(5) = length(x_real)*log(RSSFO(x_real,y_real{5},x_FO,0.66,0.009)/length(x_real)) + 2*7;
AICFO(6) = length(x_real)*log(RSSFO(x_real,y_real{6},x_FO,0.33,0.009)/length(x_real)) + 2*7;

%% Plotting DM
respCurve1 = zeros(1,max(x_real));
respCurve2 = zeros(1,max(x_real));
respCurve3 = zeros(1,max(x_real));
respCurve4 = zeros(1,max(x_real));
respCurve5 = zeros(1,max(x_real));
respCurve6 = zeros(1,max(x_real));
for i = 1:max(x_real)
    respCurve1(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.66,x(5),x(6),0.02);
    respCurve2(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.33,x(5),x(6),0.02);
    respCurve3(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.66,x(5),x(6),0.014);
    respCurve4(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.33,x(5),x(6),0.014);
    respCurve5(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.66,x(5),x(6),0.009);
    respCurve6(i) = CarbonRespirationFunc(x(1),x(2),x(3),x(4),i,0.33,x(5),x(6),0.009);
end
plot(1:max(x_real),respCurve1); hold on;
plot(1:max(x_real),respCurve2);
plot(x_real,y_real{1},'*');
plot(x_real,y_real{2},'^');
set(gca,'fontsize',14);
ylim([0 12]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',14);
%legend('Model output','Real data');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');

%% Plotting FO
respCurveFO1 = zeros(1,max(x_real));
respCurveFO2 = zeros(1,max(x_real));
respCurveFO3 = zeros(1,max(x_real));
respCurveFO4 = zeros(1,max(x_real));
respCurveFO5 = zeros(1,max(x_real));
respCurveFO6 = zeros(1,max(x_real));
for i = 1:max(x_real)
    respCurveFO1(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.66,i,x_FO(3),0.02);
    respCurveFO2(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.33,i,x_FO(3),0.02);
    respCurveFO3(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.66,i,x_FO(3),0.014);
    respCurveFO4(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.33,i,x_FO(3),0.014);
    respCurveFO5(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.66,i,x_FO(3),0.009);
    respCurveFO6(i) = FirstOrderModelFunc(x_FO(1),x_FO(2),0.33,i,x_FO(3),0.009);
end
plot(1:max(x_real),respCurveFO1); hold on;
plot(1:max(x_real),respCurveFO2);
plot(x_real,y_real{1},'*');
plot(x_real,y_real{2},'^');
set(gca,'fontsize',14);
ylim([0 12]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',14);
%legend('Model output','Real data');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');