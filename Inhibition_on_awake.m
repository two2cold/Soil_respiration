clear;

%% Parameters
k_subC1=0.02/24/12;%Empirical factor of decomposition rate, labile                1/hour
k_subC2=0.004/24/12;%Empirical factor of decomposition rate, recalcitrant                1/hour
f_s=0.1;%Portion for microbe growth                                   unitless
f_e=1-f_s;%Portion for microbe respiration                            unitless
M_B=0.001/24;%Mortality rate of active biomass                        1/hour
M_BD=M_B/10;%Mortality rate of dormant biomass                        1/hour
Psi_sat=-0.02;%Soil water potential at saturation
b=4.9;%Exponent of the water retention curve                          unitless
k_tran1=1;%Transform between active and dormant, fast                 1/hour
k_tran2=1/60;%slow                                                       1/hour
Psi_AD1=Psi_sat*0.25^(-b);%Water potential at 50% of the maximum rate k_AD, fast
Psi_AD2=Psi_sat*0.55^(-b);%slow
Psi_DA1=Psi_AD1;%Water potential at 50% of the maximum rate k_DA, fast
Psi_DA2=Psi_AD2;%slow
n=1;%Empirical factor                                                 unitless
k_CB1=15000;%Carbon usage at 50% of the maximum rate U, fast           gC/m3 water diluted
k_CB2=30000;%Carbon usage at 50% of the maximum rate U, slow           gC/m3 water diluted
k_RsolC=0.0/24;%Empirical factor of respiration rate of soluble organic carbon

%% Inputs
%time_pause=14*24;
%s(1:time_pause)=0.00001;s(time_pause:time_pause+500)=0.7;%soil moisture
s(1:200)=0.66;
%s(201:400)=0.7;
%s=0.01:0.01:0.9;
litterFall=0;%litter fall input                                    gC/m3

%%%%%Aromatic input
%aro=7930;%                                                         ugC/g soil
%aro=2620;%                                                    ugC/g soil
%aro=7530;%                                                    ugC/g soil

%%%%%Aliphatic input
%ali=14050;%                                                        ugC/g soil
%ali=16970;%                                                  ugC/g soil
%ali=3460;%                                                   ugC/g soil

totC(1:length(s)+1)=20000*20/12.8/s(1);%total carbon                    gC/m3 water diluted
%20000 for upper, 14000 for middle, and 9000 for lower
subC1=1/3*totC*0.9;%substrate carbon fast              gC/m3 water diluted
subC2=2/3*totC*0.9;%substrate carbon slow              gC/m3 water diluted
solC1=1/3*totC*0.015;%soluble carbon fast           gC/m3 water diluted
solC2=2/3*totC*0.008;%soluble carbon slow            gC/m3 water diluted
C_B1=totC*0;%starting active biomass, fast                    gC/m3 water diluted
C_B2=totC*0;%starting active biomass, slow                    gC/m3 water diluted
C_BD1=1/3*totC*0.1*s(1);%starting dormant biomass, fast       gC/m3 water
C_BD2=2/3*totC*0.1*s(1);%starting dormant biomass, slow                gC/m3 water

%% Calculations
%k_U1=0.8*(0.7-s);%Number of soluble carbon needed for each microbes per hour, fast
%k_U2=1.2*(s-0.4);%slow

a=3;%Order of inhibition factor
k_U1(1:length(s))=1;%Number of soluble carbon needed for each microbes per hour, fast
k_U2(1:length(s))=4;%slow

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
    Psi(i)=Psi_sat*s(i)^(-b);

    f_AD1(i)=-Psi(i)/((-Psi(i))+(-Psi_AD1));
    f_DA1(i)=-Psi_DA1/(20*(-Psi(i))+(-Psi_DA1));
    f_AD2(i)=-Psi(i)/((-Psi(i))+(-Psi_AD2));
    f_DA2(i)=-Psi_DA2/(20*(-Psi(i))+(-Psi_DA2));
    
    P_AD1(i)=k_tran1*f_AD1(i)*C_B1(i);
    P_DA1(i)=k_tran1*f_DA1(i)*C_BD1(i)*(1-(nthroot(s(1)*2-1,a)+1)/2);
    P_AD2(i)=k_tran2*f_AD2(i)*C_B2(i);
    P_DA2(i)=k_tran2*f_DA2(i)*C_BD2(i)*(nthroot(s(1)*2-1,a)+1)/2;
    
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
plot(1:length(s),T_resp*2.7/20*12.8*s(1),'r-','LineWidth',1);
%plot(1:length(s),f_DA1,'k-','LineWidth',3);
%semilogy(s,-Psi);
set(gca,'fontsize',14);
ylim([0 9]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m3/hour)','FontSize',14);
%legend('Incubation for upper soil 66%','model fitting for upper soil 66%','Incubation for upper soil 33%','model fitting for upper soil 33%','NorthEast');
%title({'Reactive model fitting';'for upper soil 33% soil moisture'},'FontSize',22,'FontWeight','bold');