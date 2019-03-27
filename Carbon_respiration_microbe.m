clear;

%% Parameters
k_subC1=1.22e-4;%Empirical factor of solubilization rate, labile                1/hour
k_subC2=5.6e-6;%Empirical factor of solubilization rate, recalcitrant                1/hour
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
k_CB2=45000;%Carbon usage at 50% of the maximum rate U, slow           gC/m3 water diluted
k_RsolC=0.0/24;%Empirical factor of respiration rate of soluble organic carbon

%% Inputs
%time_pause=14*24;
%s(1:240) = 0.1; s(241:480) = 0.6; s(481:1200) = 0.1; s(1201:1680) = 0.6; s(1681:1920) = 0.1; %soil moisture
s(1:200)=0.33;
litterFall=0;%litter fall input                                    gC/m3

totC(1:length(s)+1)=0.009*1518720/s(1);%total carbon                    gC/m3 water diluted
%0.02 for upper, 0.014 for middle, and 0.009 for lower
subC1=1/4*totC*0.9;%substrate carbon fast              gC/m3 water diluted
subC2=3/4*totC*0.9;%substrate carbon slow              gC/m3 water diluted
solC1=1/4*totC*0.024;%soluble carbon fast           gC/m3 water diluted
solC2=3/4*totC*0.006;%soluble carbon slow            gC/m3 water diluted
C_B1=totC*0;%starting active biomass, fast                    gC/m3 water diluted
C_B2=totC*0;%starting active biomass, slow                    gC/m3 water diluted
C_BD1=1/4*totC*0.1*s(1);%starting dormant biomass, fast       gC/m3 water
C_BD2=3/4*totC*0.1*s(1);%starting dormant biomass, slow                gC/m3 water

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

%% Integration of the plot
inteT = zeros(1,length(s)-1);
inteT(1) = T_resp(1);
for i=2:length(s)-1
    inteT(i) = inteT(i-1)+T_resp(i);
end

%% Real data
x_real=[1 24, 48.5,72.5, 96, 139.5, 186.5];
x_test=[0,24,48,72,99,123,147,195,267];
y_real=cell(1,7);
y_real{1}=[0 6.490 7.314 4.350 3.054 2.076 1.741];%gC/m3-soil/hour
y_real{2}=[0 4.193 3.017 2.281 1.916 1.407 1.192];%gC/m3-soil/hour
y_real{3}=[0 3.017 4.394 2.813 1.661 1.112 1.052];
y_real{4}=[0 2.301 1.919 1.507 1.052 0.790 0.743];
y_real{5}=[0 1.538 1.149 0.897 0.509 0.378 0.392];
y_real{6}=[0 1.726 0.919 0.633 0.342 0.224 0.234];
y_test = cell(1,8);
y_test{1}=[0,10.6517418032787,7.03571721311476,5.91926229508197,5.15737704918033,4.45409836065574,3.55448770491803,2.79553278688525,3.15987021857924];%gC/m3-soil/hour
y_test{2}=[0,1.78603483606557,2.57282786885246,2.98307377049180,2.48491803278689,1.82559426229508,1.54721311475410,1.06810450819672,1.02659153005465];
y_test{3}=[0,1.26004098360656,2.04536885245902,2.67245901639344,1.98480874316940,1.48860655737705,1.21315573770492,0.779467213114754,0.851748633879782];
y_test{4}=[0,1.04319672131148,1.58237704918033,2.21532786885246,1.60451730418944,1.21901639344262,1.02561475409836,0.659323770491803,0.632950819672131];
y_test{5}=[0,1.11645491803279,1.21315573770492,2.02778688524590,1.40916211293260,1.05052254098361,0.896680327868853,0.574344262295082,0.554808743169399];
y_test{6}=[0,1.58237704918033,1.99262295081967,2.74278688524590,1.76601092896175,1.37139344262295,1.17213114754098,0.779467213114754,0.769699453551913];
y_test{7}=[0,0.879098360655738,0.996311475409836,1.42413934426230,1.33883424408015,1.06663934426230,0.826352459016393,0.521598360655738,0.519644808743169];
y_test{8}=[0,0.946495901639344,0.923053278688525,0.890819672131148,0.856958105646630,0.955286885245902,0.852725409836066,0.515737704918033,0.519644808743169];
y_test_ave = (y_test{1} + y_test{2})/2;
for i = 1:2
    matrixz(i,1:7) = y_real{i};
end
matrixmoi = [0.66 0.33];

%% Integration of real
% Use linear rate to integrate
inte = cell(1,6);
intereal = cell(1,6);
for i=1:6
    inte{i} = fit(x_real',y_real{i}','cubicinterp');
end
for n=1:6
    intereal{n} = ones(1,length(s)-1);
    for i=2:length(s)-1
            intereal{n}(i) = intereal{n}(i-1)+inte{n}(i);
    end
end

%% residual sum of squares
rss = 0;
for i = 1:7
    rss = rss + (f_e*T_resp(round(x_real(i)))*2.7/1.51872*s(1) - y_real{6}(i))^2;
    aic = 7*log(rss/7) + 2*18;
end
disp(aic);

%% Outputs
plot(x_real,y_real{6},'r^','MarkerSize',8); hold on;
% for i=1:5
%     plot(x_test,y_test{i},'^','MarkerSize',8); hold on;
% end
% plot(1:length(s)-1,inte{1}(1:length(s)-1),'k--');hold on;

plot((1:length(s)-1),f_e*T_resp(1:length(s)-1)*2.7/1.51872*s(1),'k--','LineWidth',1); hold on;

%plot(1:length(s)-1,f_e*inteT*2.7/1.51872*s(1),'k-.','LineWidth',1); hold on;
%plot(1:length(s)-1,f_e*intereal{1}); hold on;

%plot(1:length(s)-1,intereal{1}./(inteT*2.7/1.51872*s(1)),'b--');hold on;

%semilogy(s,-Psi);
set(gca,'fontsize',14);
ylim([0 12]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m^3/hour)','FontSize',14);
%legend('Model output','Real data');
%title('Process based model','FontSize',22,'FontWeight','bold');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');