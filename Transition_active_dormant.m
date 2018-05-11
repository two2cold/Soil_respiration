%% Transition between active and dormant biomass alone
clear;

%% Parameters input
k_subC=0.03/24;%Empirical factor of decomposition rate per day
f_s=0.2;%Portion for microbe growth
f_e=1-f_s;%Portion for microbe respiration
M_B=0.001/24;%Mortality rate of active biomass
M_BD=M_B/10;%Mortality rate of dormant biomass
Psi_sat=-0.002;%Soil water potential at saturation
b=4.9;%Exponent of the water retention curve
Psi_AD=Psi_sat*0.35^(-b);%Water potential at 50% of the maximum rate k_AD
Psi_DA=Psi_AD;%Water potential at 50% of the maximum rate k_DA
k_U=1/24;%Number of soluble carbon needed for each microbes per day
n=1;%Empirical factor
k_CB=150000;%Carbon usage at 50% of the maximum rate U
k_RsolC=0/24;%Empirical factor of respiration rate of soluble organic carbon

%% Initial condition
time_pause=500;
s(1:time_pause)=0.4;s(time_pause:1000)=0.7;%soil moisture
C_B(1:length(s)+1)=0;%starting active biomass, fast                  gC/m3
C_BD(1:length(s)+1)=6250;%starting dormant biomass, fast             gC/m3

%% Calculations
Psi=zeros(1,length(s));
f_AD=zeros(1,length(s));
f_DA=zeros(1,length(s));
P_AD=zeros(1,length(s));
P_DA=zeros(1,length(s));

for i=1:length(s)
    Psi(i)=Psi_sat*s(i)^(-b);

    f_AD(i)=-Psi(i)/((-Psi(i))+(-Psi_AD));
    f_DA(i)=-Psi_DA/(20*(-Psi(i))+(-Psi_DA));
    P_AD(i)=f_AD(i)*C_B(i)/24;
    P_DA(i)=f_DA(i)*C_BD(i)/24;
    
    C_B(i+1)=C_B(i)+P_DA(i)-P_AD(i);
    C_BD(i+1)=C_BD(i)+P_AD(i)-P_DA(i);
end

%% Outputs
plot(1:length(s)+1,C_B,'b-','LineWidth',1);hold on;
plot(1:length(s)+1,C_BD,'r-','LineWidth',1);
set(gca,'fontsize',14);
xlabel('Time (hours)','FontSize',20);
ylabel('Biomass concentration (gC/m^3)','FontSize',20);
legend({'Concentration of';'active biomass'},{'Concentration of';'dormant biomass'},'Location','Best');