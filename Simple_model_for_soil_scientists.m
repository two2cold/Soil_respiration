%% Simple model for soil scientests
clear;

%% Parameter input
s_fc = 0.25; % soil moisture at field capacity for litter fast
s_fc2 = 0.55; % soil moisture at field capacity for litter slow
k_d = 4.17E-05; % microbial mortality rate, 1/hour
k_l = 4.0E-02; % decomposition rate constant of litter pool fast, 1/hour
k_l2 = 2.0E-02; % decomposition rate constant of litter pool slow, 1/hour
k_s = 5.0E-04; % solubilization rate constant of substrate fast, 1/hour
k_s2 = 5.0E-05; % solubilization rate constant of substrate slow, 1/hour
r_r = 0.9; % fraction respirated
r_g = 1-r_r; % fraction growth

%% Initializaion
%s(1:240) = 0.1; s(241:480) = 0.6; s(481:1200) = 0.1; s(1201:1680) = 0.6; s(1681:1920) = 0.1; % soil moisture
s(1:200) = 0.33;
t = length(s); % simulation time, hour
C_l = zeros(1,t); % initializing carbon concentration in litter pool fast
C_l2 = zeros(1,t); % initializing carbon concentration in litter pool slow
C_s = zeros(1,t); % initializing carbon concentration in soluble carbon pool fast
C_s2 = zeros(1,t); % initializing carbon concentration in soluble carbon pool slow
C_b = zeros(1,t); % initializing carbon concentration in biomass pool fast
C_b2 = zeros(1,t); % initializing carbon concentration in biomass pool slow
ADD = zeros(1,t); % initializing carbon concentration in external input
BD = zeros(1,t-1); % initializing microbial mortality rate fast
BD2 = zeros(1,t-1); % initializing microbial mortality rate slow
DEC_l = zeros(1,t-1); % initializing microbial respiration rate of fast microbes
DEC_l2 = zeros(1,t-1); % initializing microbial respiration rate of slow microbes
f_d = zeros(1,t-1); % initializing nondimensional factor fast
f_d2 = zeros(1,t-1); % initializing nondimensional factor slow

%% Initial condition
C_total = 0.009*1518720; % total carbon concentration, converted from volume fraction to gC/m3H2O
C_l(1) = 1/4*C_total*0.9; % carbon concentration in litter pool fast, gC/m3
C_l2(1) = 3/4*C_total*0.9; % carbon concentration in litter pool slow, gC/m3
C_s(1) = 1/4*C_total*0.025; % carbon concentration in soluble pool fast, gC/m3
C_s2(1) = 3/4*C_total*0.02; % carbon concentration in soluble pool slow, gC/m3
C_b(1) = 1/4*C_total*0.1; % carbon concentration in biomass pool fast, gC/m3
C_b2(1) = 3/4*C_total*0.1; % carbon concentration in biomass pool slow, gC/m3
ADD(1:t) = 0; % carbon concentration in external input, gC/m3/day

%% Input checking
for i = 1:length(s)
    if s(i)<0 || s(i)>1
        error('Soil moiture input is wrong');
    end
end

%% Carbon pool calculation
for i = 1:t-1
    BD(i) = k_d*C_b(i); % calculating microbial mortality
    BD2(i) = k_d*C_b2(i); % calculating microbial mortality
    if s(i)<=s_fc % calculating nondimensional factors 1
        f_d(i) = s(i)/s_fc;
    else
        f_d(i) = s_fc/s(i);
    end
    if s(i)<=s_fc2 % calculating nondimensional factors 1
        f_d2(i) = s(i)/s_fc2;
    else
        f_d2(i) = s_fc2/s(i);
    end
    DEC_l(i) = k_l*f_d(i)*C_s(i); % calculating microbial respiration rate fast
    DEC_l2(i) = k_l2*f_d2(i)*C_s2(i); % calculating microbial respiration rate slow
    
    
    % Mass balance calculations
    C_s(i+1) = C_s(i)+k_s*f_d(i)*C_l(i)-DEC_l(i)-k_l2*f_d2(i)*C_s(i)+BD(i);
    C_s2(i+1) = C_s2(i)+k_s2*f_d2(i)*C_l2(i)-DEC_l2(i)+BD2(i);
    C_l(i+1) = C_l(i)+ADD(i)-k_s*f_d(i)*C_l(i);
    C_l2(i+1) = C_l2(i)+ADD(i)-k_s2*f_d2(i)*C_l2(i);
    C_b(i+1) = C_b(i)+r_g*DEC_l(i)-BD(i);
    C_b2(i+1) = C_b2(i)+r_g*(k_l2*f_d2(i)*C_s(i)+DEC_l2(i))-BD2(i);
end

%% Integration of the plot
inteDEC = zeros(1,t-1);
inteDEC(1) = DEC_l(1);
for i=2:t-1
    inteDEC(i) = inteDEC(i-1)+DEC_l(i);
end

%% Real data
x_real=[1 24, 48.5,72.5, 96, 139.5, 186.5];
y_real=cell(1,6);
y_real{1}=[0 6.490 7.314 4.350 3.054 2.076 1.741];%gC/m3-soil/hour
y_real{2}=[0 4.193 3.017 2.281 1.916 1.407 1.192];%gC/m3-soil/hour
y_real{3}=[0 3.017 4.394 2.813 1.661 1.112 1.052];
y_real{4}=[0 2.301 1.919 1.507 1.052 0.790 0.743];
y_real{5}=[0 1.538 1.149 0.897 0.509 0.378 0.392];
y_real{6}=[0 1.726 0.919 0.633 0.342 0.224 0.234];

%% Integration of real
% Use linear rate to integrate
inte = cell(1,6);
intereal = cell(1,6);
for i=1:6
    inte{i} = fit(x_real',y_real{i}','cubicinterp');
end
for n=1:6
    intereal{n} = zeros(1,t-1);
    for i=1:t-1
        if i==1
            intereal{n}(1) = inte{n}(1);
        else
            intereal{n}(i) = intereal{n}(i-1)+inte{n}(i);
        end
    end
end

%% residual sum of squares
rss = 0;
for i = 1:7
    rss = rss + (r_r*DEC_l(round(x_real(i))) - y_real{6}(i))^2;
    aic = 7*log(rss/7) + 2*7;
end
disp(aic);

%% Plotting
%plot(x_real,y_real{1},'k^','MarkerSize',8); hold on;
plot(x_real,y_real{1},'r^','MarkerSize',8); hold on;
%plot(1:t-1,r_r*inteDEC,'k--'); hold on;
%plot(1:t-1,r_r*intereal{1},'b--'); hold on;
%plot(1:t-1,intereal{1}(1:t-1)./inteDEC(1:t-1),'r--');hold on;
%plot(1:t-1,inte{1}(1:t-1),'k--');hold on;
plot(1:t-1,r_r*(DEC_l(1:t-1) + DEC_l2(1:t-1)),'k--');hold on;
%plot(1:t,s);
%ylim([0 1.2]);
set(gca,'fontsize',14);
xlabel('Time (hours)','FontSize',14);
ylabel('Cumulative CO2 (gC/m3)','FontSize',14);
legend('Incubation for shallow soil 66% Se','Model output for one micriobial population','Model output for two micriobial populations');
%title('Simple first-order model','FontSize',22,'FontWeight','bold');