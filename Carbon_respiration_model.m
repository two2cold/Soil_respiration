clear;

%% Parameters
k_subC=0.012/24/12;%Empirical factor of decomposition rate                1/hour
f_s=0.1;%Portion for microbe growth                                   unitless
f_e=1-f_s;%Portion for microbe respiration                            unitless
M_B=0.001/24;%Mortality rate of active biomass                        1/hour
M_BD=M_B/10;%Mortality rate of dormant biomass                        1/hour
Psi_sat=-0.002;%Soil water potential at saturation
b=4.9;%Exponent of the water retention curve                          unitless
k_tran=1/60;%Transform between active and dormant                    1/hour
Psi_AD=Psi_sat*0.55^(-b);%Water potential at 50% of the maximum rate k_AD
Psi_DA=Psi_AD;%Water potential at 50% of the maximum rate k_DA
n=1;%Empirical factor                                                 unitless
k_CB=45000;%Carbon usage at 50% of the maximum rate U, fast           gC/m3
k_RsolC=0.0/24;%Empirical factor of respiration rate of soluble organic carbon

%% Inputs
%time_pause=14*24;
%s(1:time_pause)=0.00001;s(time_pause:time_pause+500)=0.7;%soil moisture
s(1:200)=0.33;%has to be in a range of 0.4-0.7
%s(201:400)=0.7;
%s=0.01:0.01:0.9;
litterFall=0;%litter fall input                                       gC/m3

totC(1:length(s)+1)=0.02*1518720/s(1);%total carbon                    gC/m3 water diluted
%20000 for upper, 14000 for middle, and 9000 for lower
subC=totC*0.9;%substrate carbon fast              gC/m3 water diluted
solC=totC*0.007;%soluble carbon fast           gC/m3 water diluted
C_B=totC*0;%starting active biomass, fast                    gC/m3 water diluted
C_BD=totC*0.1*s(1);%starting dormant biomass, fast       gC/m3 water

%% Calculations
k_U=8;%Number of soluble carbon needed for each microbes per hour

D=zeros(1,length(s));
U=zeros(1,length(s));
R_solC=zeros(1,length(s));
T_resp=zeros(1,length(s));
Psi=zeros(1,length(s));
f_AD=zeros(1,length(s));
f_DA=zeros(1,length(s));
P_AD=zeros(1,length(s));
P_DA=zeros(1,length(s));

for i=1:length(s)
    Psi(i)=Psi_sat*s(i)^(-b);

    f_AD(i)=-Psi(i)/((-Psi(i))+(-Psi_AD));
    f_DA(i)=-Psi_DA/(20*(-Psi(i))+(-Psi_DA));
    
    P_AD(i)=k_tran*f_AD(i)*C_B(i);
    P_DA(i)=k_tran*f_DA(i)*C_BD(i);
    
    D(i)=k_subC*subC(i);
    if solC(i)==0&&C_B(i)==0
        U(i)=0;
    else
        U(i)=k_U*C_B(i)*solC(i)^n/(solC(i)^n+k_CB^n);
    end
    
    R_solC(i)=k_RsolC*solC(i);
    subC(i+1)=subC(i)+litterFall-D(i);
    solC(i+1)=solC(i)+D(i)-U(i)-R_solC(i)+M_BD*C_BD(i)+M_B*C_B(i);
    C_B(i+1)=C_B(i)+f_s*U(i)+P_DA(i)-P_AD(i)-M_B*C_B(i);
    C_BD(i+1)=C_BD(i)+P_AD(i)-P_DA(i)-M_BD*C_BD(i);
    T_resp(i)=f_e*U(i)+R_solC(i);
end

%% Outputs
x_real=[24, 48.5,72.5, 96, 139.5, 186.5];
y_real1=[6.490 7.314 4.350 3.054 2.076 1.741];%gC/m3/hour
y_real2=[4.193 3.017 2.281 1.916 1.407 1.192];%gC/m3/hour
%y_real3=[3.017 4.394 2.813 1.661 1.112 1.052];
%y_real4=[2.301 1.919 1.507 1.052 0.790 0.743];
%y_real5=[1.538 1.149 0.897 0.509 0.378 0.392];
%y_real6=[1.726 0.919 0.633 0.342 0.224 0.234];
%plot(x_real,y_real1,'k^','MarkerSize',8); hold on;
%plot(x_real,y_real2,'r^','MarkerSize',8); hold on;
plot(1:length(s),T_resp*2.7/1.51872*s(1),'r--','LineWidth',1);
%plot(1:length(s),f_DA1,'k-','LineWidth',3);
%semilogy(s,-Psi);
set(gca,'fontsize',18);
ylim([0 10]);
xlabel('Time (hours)','FontSize',21);
ylabel('Respiration rate (gC/m3/hour)','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
%legend('SEhalf = 0.2','kup = 0.3','kup = 0.4','kup = 0.5','kup = 0.6','Location','NorthEast');
%title({'Reactive model fitting';'for upper soil 33% soil moisture'},'FontSize',22,'FontWeight','bold');clear;
