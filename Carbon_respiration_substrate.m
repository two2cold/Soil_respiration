clear;

%% Parameters
k_sub_aro=0.027/12/24;%Empirical factor of decomposition rate of Aromatic per day
k_sub_ali=0.004/12/24;%Empirical factor of decomposition rate of Aliphatic per day

f_s=0.1;%Portion for microbe growth
f_e=1-f_s;%Portion for microbe respiration
M_B=0.001/24;%Mortality rate of active biomass
M_BD=M_B/10;%Mortality rate of dormant biomass
Psi_sat=-0.02;%Soil water potential at saturation
b=4.9;%Exponent of the water retention curve
k_tran=1/60;%Transform between active and dormant, fast                 1/hour
Psi_AD=Psi_sat*0.55^(-b);%Water potential at 50% of the maximum rate k_AD
Psi_DA=Psi_AD;%Water potential at 50% of the maximum rate k_DA
k_U=2.5;%Number of soluble carbon needed for each microbes per day
n=1;%Empirical factor
k_CB_aro=15000;%Carbon usage at 50% of the maximum rate U
k_CB_ali=45000;
k_RsolC=0/24;%Empirical factor of respiration rate of soluble organic carbon

%% Inputs
%time_pause=14*24;
%s(1:time_pause)=0.00001;s(time_pause:time_pause+500)=0.7;%soil moisture
s(1:200)=0.33;
%s=0.1:0.01:0.9;

%litterFall_poly=0;%Polysaccharide input
litterFall_aro=0;%Aromatic input
%litterFall_amide=0;%Amide input
litterFall_ali=0;%Aliphatic input

totC(1:length(s)+1)=0.02*1518720/s(1);%total carbon                    gC/m3 water diluted
%20000 for upper, 14000 for middle, and 9000 for lower
sub_aro=1/4*totC*0.9;%substrate carbon fast              gC/m3 water diluted
sub_ali=3/4*totC*0.9;%substrate carbon slow              gC/m3 water diluted
sol_aro=1/4*totC*0.025;%soluble carbon fast           gC/m3 water diluted
sol_ali=3/4*totC*0.006;%soluble carbon slow            gC/m3 water diluted
C_B=totC*0;%starting active biomass, slow                    gC/m3 water diluted
C_BD=totC*0.1*s(1);%starting dormant biomass, slow                gC/m3 water

%% Calculations
D_aro=zeros(1,length(s));
D_ali=zeros(1,length(s));

U_aro=zeros(1,length(s));
U_ali=zeros(1,length(s));

R_sol_aro=zeros(1,length(s));
R_sol_ali=zeros(1,length(s));

T_resp=zeros(1,length(s));
Psi=zeros(1,length(s));
f_AD=zeros(1,length(s));
f_DA=zeros(1,length(s));
P_AD=zeros(1,length(s));
P_DA=zeros(1,length(s));

for i=1:length(s)
    Psi(i)=Psi_sat*s(i)^(-b);

    f_AD(i)=-Psi(i)/((-Psi(i))+(-Psi_AD));
    f_DA(i)=-Psi_DA/((-20*Psi(i))+(-Psi_DA));
    P_AD(i)=k_tran*f_AD(i)*C_B(i);
    P_DA(i)=k_tran*f_DA(i)*C_BD(i);
    
    D_aro(i)=k_sub_aro*sub_aro(i);
    D_ali(i)=k_sub_ali*sub_ali(i);
    
    if sol_aro(i)==0&&C_B(i)==0
        U_aro(i)=0;
    else
        U_aro(i)=k_U*C_B(i)*sol_aro(i)^n/(sol_aro(i)^n+k_CB_aro^n);
    end
    
    if sol_ali(i)==0&&C_B(i)==0
        U_ali(i)=0;
    else
        U_ali(i)=k_U*C_B(i)*sol_ali(i)^n/(sol_ali(i)^n+k_CB_ali^n);
    end
    
    R_sol_aro(i)=k_RsolC*sol_aro(i);
    R_sol_ali(i)=k_RsolC*sol_ali(i);
    sub_aro(i+1)=sub_aro(i)+litterFall_aro-D_aro(i);
    sub_ali(i+1)=sub_ali(i)+litterFall_ali-D_ali(i)+M_B*C_B(i)+M_BD*C_BD(i);
    sol_aro(i+1)=sol_aro(i)+D_aro(i)-U_aro(i)-R_sol_aro(i);
    sol_ali(i+1)=sol_ali(i)+D_ali(i)-U_ali(i)-R_sol_ali(i);
    C_B(i+1)=C_B(i)+f_s*(U_aro(i)+U_ali(i))+P_DA(i)-P_AD(i)-M_B*C_B(i);
    C_BD(i+1)=C_BD(i)+P_AD(i)-P_DA(i)-M_BD*C_BD(i);
    T_resp(i)=f_e*(U_aro(i)+U_ali(i))+R_sol_aro(i)+R_sol_ali(i);
end

%% Outputs
x_real=[24, 48.5,72.5, 96, 139.5, 186.5];
y_real1=[6.490 7.314 4.350 3.054 2.076 1.741];%gC/m3-soil/hour
y_real2=[4.193 3.017 2.281 1.916 1.407 1.192];%gC/m3-soil/hour
y_real3=[3.017 4.394 2.813 1.661 1.112 1.052];
y_real4=[2.301 1.919 1.507 1.052 0.790 0.743];
y_real5=[1.538 1.149 0.897 0.509 0.378 0.392];
y_real6=[1.726 0.919 0.633 0.342 0.224 0.234];
plot(x_real,y_real1,'k^','MarkerSize',8); hold on;
plot(x_real,y_real2,'r^','MarkerSize',8); hold on;
plot(1:length(s),T_resp*2.7/1.51872*s(1),'r-','LineWidth',1);
set(gca,'fontsize',14);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (umol/g C/day)','FontSize',14);
ylim([0 9]);
%legend('Real data for upper soil 66%','model fitting line','Location','NorthEast');
%title({'Reactive model fitting';'for upper soil 33% soil moisture'},'FontSize',22,'FontWeight','bold');