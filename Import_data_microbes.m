%% Import data from Crunch output
clear;

fileNumber=34;
files=cell(1,fileNumber);
for n=1:fileNumber
    filename=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/MultipleRaining/volume%d.out',n);
    files{n}=importdata(filename,' ',3);
end

t=[.04 .3 .5 .7 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.7 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5];

micro_active=zeros(1,fileNumber);
micro_dormant=zeros(1,fileNumber);

for n=1:fileNumber
    micro_active(n)=files{n}.data(1,6);
    micro_dormant(n)=files{n}.data(1,7);
end

%% Parameters
k_subC1=0.02/24/12;%Empirical factor of decomposition rate, labile                1/hour
k_subC2=0.004/24/12;%Empirical factor of decomposition rate, recalcitrant                1/hour
f_s=0.1;%Portion for microbe growth                                   unitless
f_e=1-f_s;%Portion for microbe respiration                            unitless
M_B=0.001/24;%Mortality rate of active biomass                        1/hour
M_BD=M_B/10;%Mortality rate of dormant biomass                        1/hour
Psi_sat=-0.2;%Soil water potential at saturation
b=4.9;%Exponent of the water retention curve                          unitless
k_tran1=1;%Transform between active and dormant, fast                 1/hour
k_tran2=1/60;%slow                                                       1/hour
Psi_AD1=0.25^(-b);%Water potential at 50% of the maximum rate k_AD, fast
Psi_AD2=0.55^(-b);%slow
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
k_U1(1:length(s))=1*(1-(nthroot(s(1)*2-1,a)+1)/2);%Number of soluble carbon needed for each microbes per hour, fast
k_U2(1:length(s))=4*(nthroot(s(1)*2-1,a)+1)/2;%slow

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
%    if solC1(i)==0&&C_B1(i)==0
%        U1(i)=0;
%    else
        U11(i)=k_U1(i)*C_B1(i)*solC1(i)^n/(solC1(i)^n+k_CB1^n);
        U12(i)=k_U2(i)*C_B2(i)*solC1(i)^n/(solC1(i)^n+k_CB1^n);
%    end
%    if solC1(i)==0&&C_B2(i)==0
%        U2(i)=0;
%    else
        U21(i)=0*k_U1(i)*C_B1(i)*solC2(i)^n/(solC2(i)^n+k_CB2^n);
        U22(i)=k_U2(i)*C_B2(i)*solC2(i)^n/(solC2(i)^n+k_CB2^n);
%    end
    
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
disp(C_B2(2)/C_BD2(2));
disp(micro_active(1)/micro_dormant(1));
plot(1:length(s)+1,C_B2,'b');hold on;
plot(t(1:fileNumber)*24,micro_active*15650,'r');
