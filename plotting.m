%% Plotting
clear;

%% GES-11
moiFitting=0:100;
respFitting2=(-0.01444*moiFitting.^3-1.589*moiFitting.^2+387.3*moiFitting-1.465e-12)/10;
respFitting3=(-1.771*moiFitting.^2+240.1*moiFitting+269.4)/10;
respFitting5=(-0.7827*moiFitting.^2+127.4*moiFitting+96.72)/10;
respFitting7=(-0.4811*moiFitting.^2+88.59*moiFitting+55.78)/10;

%CO2(atm)*d13Ca + Sz*(1.0044*d13Cr + 4.4) = (CO2(atm) + Sz)*d13Cs
d13C2=(400*-7 + (respFitting2)*(1.0044*-27 + 4.4))./(respFitting2+400);
d13C3=(400*-7 + (respFitting3)*(1.0044*-27 + 4.4))./(respFitting3+400);
d13C5=(400*-7 + (respFitting5)*(1.0044*-27 + 4.4))./(respFitting5+400);
d13C7=(400*-7 + (respFitting7)*(1.0044*-27 + 4.4))./(respFitting7+400);

plot(moiFitting,d13C2,'LineWidth',1);hold on;
plot(moiFitting,d13C3,'LineWidth',1);
plot(moiFitting,d13C5,'LineWidth',1);
plot(moiFitting,d13C7,'LineWidth',1);
set(gca,'fontsize',14);
xlabel('soil moisture (%)','FontSize',14);
ylabel('d13C of the speleothem','FontSize',14);
%ylim([-20 0]);
legend('second day','third day','fifth day','seventh day');

%% VWC
% VWC=csvread('/Users/yuchenliu/Documents/Works/Bradley Hillslope VWC.csv',2,10)/0.64;
% depth=[10 20 30 50 75 100 130];
% real=zeros(7,25);
% for i=1:7
%     real(i,:)=VWC(1:25,i);
% end
% plot(real,depth);hold on;
% plot(VWC(1:150,10),1:150,'k','linewidth',3);
% set(gca,'ydir','reverse');
% set(gca,'fontsize',21);
% xlabel('Se','FontSize',21);
% ylabel('Depth (cm)','FontSize',21);