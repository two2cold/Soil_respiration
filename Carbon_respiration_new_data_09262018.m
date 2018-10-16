clear;

%% Parameters DM2
k_subC1=0.08/24/12;%Empirical factor of solubilization rate, labile                1/hour
k_subC2=0.04/24/12;%Empirical factor of solubilization rate, recalcitrant                1/hour
% For 0-10 cm k_subC1 = 0.08/24/12, k_subC2=0.04/24/12
% For 0-50 cm k_subC1=0.025/24/12, k_subC2=0.02/24/12
% For 10-50 cm k_subC1=0.0005/24/12, k_subC2=0.0001/24/12
f_s=0.1;%Portion for microbe growth                                   unitless
f_e=1-f_s;%Portion for microbe respiration                            unitless
M_B=0.001/24;%Mortality rate of active biomass                        1/hour
M_BD=M_B/10;%Mortality rate of dormant biomass                        1/hour
Psi_sat=-0.2;%Soil water potential at saturation
b=4.9;%Exponent of the water retention curve                          unitless
k_tran1=1;%Transform between active and dormant, fast                 1/hour
k_tran2=1;%slow                                                       1/hour
% For 0-10 cm and 0-50 cm k_tran2=1
% For 10-50 cm k_tran2=1/120
Psi_AD1=0.25^(-b);%Water potential at 50% of the maximum rate k_AD, fast
Psi_AD2=0.35^(-b);%slow
% For 0-10 cm and 0-50 cm Psi_AD2=0.35^(-b)
% For 10-50 cm Psi_AD2=0.55^(-b)
Psi_DA1=Psi_AD1;%Water potential at 50% of the maximum rate k_DA, fast
Psi_DA2=Psi_AD2;%slow
n=1;%Empirical factor                                                 unitless
k_CB1=15000;%Carbon usage at 50% of the maximum rate U, fast           gC/m3 water diluted
k_CB2=45000;%Carbon usage at 50% of the maximum rate U, slow           gC/m3 water diluted
k_RsolC=0.0/24;%Empirical factor of respiration rate of soluble organic carbon

%% Inputs
%time_pause=14*24;
%s(1:240) = 0.1; s(241:480) = 0.6; s(481:1200) = 0.1; s(1201:1680) = 0.6; s(1681:1920) = 0.1; %soil moisture
s(1:80)=0.66;
litterFall=0;%litter fall input                                    gC/m3

totC(1:length(s)+1)=0.025*1518720/s(1);%total carbon                    gC/m3 water diluted
%0.02 for upper, 0.014 for middle, and 0.009 for lower
% For 0-10 0.025
% For 0-50 0.02
% For 10-50 0.017
subC1=1/4*totC*0.9;%substrate carbon fast              gC/m3 water diluted
subC2=3/4*totC*0.9;%substrate carbon slow              gC/m3 water diluted
solC1=1/4*totC*0.012;%soluble carbon fast           gC/m3 water diluted
solC2=3/4*totC*0.012;%soluble carbon slow            gC/m3 water diluted
% For 0-10 cm and 0-50 cm solC1=1/4*totC*0.012, solC2=3/4*totC*0.012
% For 10-50 cm solC1=1/4*totC*0.01, solC2=3/4*totC*0.01
C_B1=totC*0;%starting active biomass, fast                    gC/m3 water diluted
C_B2=totC*0;%starting active biomass, slow                    gC/m3 water diluted
C_BD1=1/4*totC*0.1*s(1);%starting dormant biomass, fast       gC/m3 water
C_BD2=3/4*totC*0.1*s(1);%starting dormant biomass, slow                gC/m3 water

%% Calculations
%k_U1=0.8*(0.7-s);%Number of soluble carbon needed for each microbes per hour, fast
%k_U2=1.2*(s-0.4);%slow

a=3;%Order of inhibition factor
k_U1(1:length(s))=1*(1-(nthroot(s(1)*2-1,a)+1)/2);%Number of soluble carbon needed for each microbes per hour, fast
k_U2(1:length(s))=0.6*(nthroot(s(1)*2-1,a)+1)/2;%slow
% For 0-10 cm k_U1(1:length(s))=1*(1-(nthroot(s(1)*2-1,a)+1)/2), k_U2(1:length(s))=0.6*(nthroot(s(1)*2-1,a)+1)/2
% For 0-50 cm k_U1(1:length(s))=0.55*(1-(nthroot(s(1)*2-1,a)+1)/2), k_U2(1:length(s))=0.2*(nthroot(s(1)*2-1,a)+1)/2
% For 10-50 cm k_U1(1:length(s))=1*(1-(nthroot(s(1)*2-1,a)+1)/2), k_U2(1:length(s))=8*(nthroot(s(1)*2-1,a)+1)/2

D1=zeros(1,length(s));
D2=zeros(1,length(s));
U11=zeros(1,length(s));
U12=zeros(1,length(s));
U21=zeros(1,length(s));
U22=zeros(1,length(s));
R_solC=zeros(1,length(s));
T_resp=zeros(1,length(s));
Psi=zeros(1,length(s));
f_AD1=zeros(1,length(s));
f_DA1=zeros(1,length(s));
f_AD2=zeros(1,length(s));
f_DA2=zeros(1,length(s));
P_AD1=zeros(1,length(s));
P_DA1=zeros(1,length(s));
P_AD2=zeros(1,length(s));
P_DA2=zeros(1,length(s));

for i=1:length(s)
    Psi(i)=s(i)^(-b);

    f_AD1(i)=-Psi(i)/((-Psi(i))+(-Psi_AD1));
    f_DA1(i)=-Psi_DA1/(20*(-Psi(i))+(-Psi_DA1));
    f_AD2(i)=-Psi(i)/((-Psi(i))+(-Psi_AD2));
    f_DA2(i)=-Psi_DA2/(20*(-Psi(i))+(-Psi_DA2));
    
    P_AD1(i)=k_tran1*f_AD1(i)*C_B1(i);
    P_DA1(i)=k_tran1*f_DA1(i)*C_BD1(i);
    P_AD2(i)=k_tran2*f_AD2(i)*C_B2(i);
    P_DA2(i)=k_tran2*f_DA2(i)*C_BD2(i);
    
    D1(i)=k_subC1*subC1(i);
    D2(i)=k_subC2*subC2(i);
    U11(i)=k_U1(i)*C_B1(i)*solC1(i)^n/(solC1(i)^n+k_CB1^n);
    U12(i)=k_U2(i)*C_B2(i)*solC1(i)^n/(solC1(i)^n+k_CB1^n);
    U21(i)=0*k_U1(i)*C_B1(i)*solC2(i)^n/(solC2(i)^n+k_CB2^n);
    U22(i)=k_U2(i)*C_B2(i)*solC2(i)^n/(solC2(i)^n+k_CB2^n);
    
    R_solC(i)=k_RsolC*solC1(i);
    subC1(i+1)=subC1(i)+litterFall-D1(i);
    subC2(i+1)=subC2(i)+litterFall-D2(i);
    solC1(i+1)=solC1(i)+D1(i)-U11(i)-U12(i)-R_solC(i)+M_BD*C_BD1(i)+M_B*C_B1(i);
    solC2(i+1)=solC2(i)+D2(i)-U21(i)-U22(i)-R_solC(i)+M_BD*C_BD2(i)+M_B*C_B2(i);
    C_B1(i+1)=C_B1(i)+f_s*(U11(i)+U21(i))+P_DA1(i)-P_AD1(i)-M_B*C_B1(i);
    C_B2(i+1)=C_B2(i)+f_s*(U22(i)+U12(i))+P_DA2(i)-P_AD2(i)-M_B*C_B2(i);
    C_BD1(i+1)=C_BD1(i)+P_AD1(i)-P_DA1(i)-M_BD*C_BD1(i);
    C_BD2(i+1)=C_BD2(i)+P_AD2(i)-P_DA2(i)-M_BD*C_BD2(i);
    T_resp(i)=f_e*(U11(i)+U12(i)+U21(i)+U22(i))+R_solC(i);
end

%% Parameter input FO1
s_fc = 0.6; % soil moisture at field capacity for litter fast
k_d = 4.17E-05; % microbial mortality rate, 1/hour
k_l = 0.5E-01; % decomposition rate constant of litter pool fast, 1/hour
k_s = 3.4E-04; % solubilization rate constant of substrate fast, 1/hour
% For 0-10 cm k_l = 0.5E-01, k_s = 4.0E-04
% For 0-50 cm k_l = 1.35E-02, k_s = 1.2E-04
% For 10-50 cm k_l = 0.8E-02, k_s = 1.0E-06
r_r = 0.9; % fraction respirated
r_g = 1-r_r; % fraction growth

%% Initializaion
%s(1:240) = 0.1; s(241:480) = 0.6; s(481:1200) = 0.1; s(1201:1680) = 0.6; s(1681:1920) = 0.1; % soil moisture
t = length(s); % simulation time, hour
C_l = zeros(1,t); % initializing carbon concentration in litter pool fast
C_s = zeros(1,t); % initializing carbon concentration in soluble carbon pool fast
C_b = zeros(1,t); % initializing carbon concentration in biomass pool fast
ADD = zeros(1,t); % initializing carbon concentration in external input
BD = zeros(1,t-1); % initializing microbial mortality rate fast
DEC_l = zeros(1,t-1); % initializing microbial respiration rate of fast microbes
f_d = zeros(1,t-1); % initializing nondimensional factor fast

%% Initial condition
dimentionless = 1.2;
C_total = 0.025*1518720; % total carbon concentration, converted from volume fraction to gC/m3H2O
% For 0-10 0.025
% For 0-50 0.02
% For 10-50 0.017
C_l(1) = 0.88*C_total; % carbon concentration in litter pool fast, gC/m3
C_s(1) = dimentionless*0.015*C_total; % carbon concentration in soluble pool fast, gC/m3
C_b(1) = 0.1*C_total; % carbon concentration in biomass pool fast, gC/m3
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
    if s(i)<=s_fc % calculating nondimensional factors 1
        f_d(i) = s(i)/s_fc;
    else
        f_d(i) = s_fc/s(i);
    end
    DEC_l(i) = k_l*f_d(i)*C_s(i); % calculating microbial respiration rate fast    
    
    % Mass balance calculations
    C_s(i+1) = C_s(i)+k_s*f_d(i)*C_l(i)-DEC_l(i)+BD(i);
    C_l(i+1) = C_l(i)+ADD(i)-k_s*f_d(i)*C_l(i);
    C_b(i+1) = C_b(i)+r_g*DEC_l(i)-BD(i);
end

%% Read in data
workingDir = "~/Documents/Works/Respiration_data_09.08.2018.xlsx";
raw = xlsread(workingDir, "Sheet1", "B2:AD9");

% Normalize to 1 hour
time = raw(1,:);
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

%% residual sum of squares
dataUsed = 1;

rss = 0;
for i = 1:length(time)
    rss = rss + (f_e*T_resp(round(time(i))+1)*2.7/1.51872*s(1) - rateFinal(dataUsed,i))^2;
    aic = length(time)*log(rss/length(time)) + 2*18;
end
disp("DM2 AIC = "); disp(aic);

rss_FO = 0;
for i = 1:length(time)
    rss_FO = rss_FO + (r_r*DEC_l(round(time(i))+1) - rateFinal(dataUsed,i))^2;
    aic_FO = length(time)*log(rss_FO/length(time)) + 2*7;
end
disp("FO1 AIC = "); disp(aic_FO);

%% Outputs
plot(time,rateFinal(1,:),'^','MarkerSize',10,'LineWidth',2); hold on;
plot(1:t-1,r_r*DEC_l(1:t-1),'r--','LineWidth',2);hold on;
plot((1:length(s)-1),f_e*T_resp(1:length(s)-1)*2.7/1.51872*s(1),'k--','LineWidth',2); hold on;

set(gca,'fontsize',22);
set(gca, 'FontName', 'Times New Roman');
% ylim([0 12]);
xlabel('Time (hours)','FontSize',22);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',22);
legend('Incubation data','FO1','DM2');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');