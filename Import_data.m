clear;

fileNumber=34;
files=cell(1,fileNumber);
for n=1:fileNumber
    filename=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/AqRate%d.out',n);
    files{n}=importdata(filename,' ',3);
end

t=[.04 .3 .5 .7 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.7 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5];

%O2=zeros(1,fileNumber);
CO2=zeros(1,fileNumber);

for n=1:fileNumber
%    O2(n)=files{n}.data(1,2);
    CO2(n)=files{n}.data(1,2)+files{n}.data(1,3)+files{n}.data(1,4);%mol/kgH2O/year
end

% CO2_increase=zeros(1,fileNumber);
% 
% CO2_increase(1)=CO2(1)/t(1);
% for i=2:fileNumber
%     CO2_increase(i)=(CO2(i)-CO2(i-1))/(t(i)-t(i-1));
% end

Se=0.33;
%plot(t(1:fileNumber)*24,CO2_increase*39.68,'-','LineWidth',1);hold on;%converting to gC/m3/hour
plot(t(1:fileNumber)*24,CO2*1000*0.64/0.36*Se*12/4*0.9/365/24,'r-','LineWidth',1);hold on;%converting to gC/m3/hour
x_real=[24, 48.5,72.5, 96, 139.5, 186.5];
y_real1=[6.490 7.314 4.350 3.054 2.076 1.741];%gC/m3/hour
y_real2=[4.193 3.017 2.281 1.916 1.407 1.192];%gC/m3/hour
y_real3=[3.017 4.394 2.813 1.661 1.112 1.052];
y_real4=[2.301 1.919 1.507 1.052 0.790 0.743];
y_real5=[1.538 1.149 0.897 0.509 0.378 0.392];
y_real6=[1.726 0.919 0.633 0.342 0.224 0.234];
plot(x_real,y_real5,'k^','MarkerSize',8);
plot(x_real,y_real6,'r^','MarkerSize',8);
xlim([0 200]);
ylim([0 9]);
set(gca,'fontsize',14);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m3/hour)','FontSize',14);
%ylim([0 8]);
%legend('Real data for upper soil 66%','model fitting line','Location','NorthEast');
%title({'Reactive model fitting';'for upper soil 66% soil moisture'},'FontSize',22,'FontWeight','bold');
