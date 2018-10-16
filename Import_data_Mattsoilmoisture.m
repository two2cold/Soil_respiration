%% Import_data_Mattsoilmoisture
clear;

%% Data input
depth = 130;
fileNumber=9;
files=cell(1,fileNumber);
for n=1:fileNumber
    filename=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/MattSoilMoisture/GaussNewton/Profile_No_Auto/gases%d.out',n);
    files{n}=importdata(filename,' ',3);
end

CO2=zeros(depth,fileNumber);

for n=1:fileNumber
    for m=1:depth
%        CO2(m,n)=files{n}.data(m,2)+files{n}.data(m,3)+files{n}.data(m,4);%mol/kgH2O/year
        CO2(m,n)=files{n}.data(m,3);%mol/kgH2O/year
    end
end

t=[1 2 3 4 5 10 15 20 25];

%% Set up a dichotomized method to find the best respiration rate
% Calculate the integration of the model output and Cerling and Quade output
lowBoundaryRespirationRate = 0;
highBoundaryRespirationRate = 100;
integrateThisModel = sum(CO2(:,9)*1000000);
timeCount = 0;
while true
    integrateMidRespirationRate = sum(CerlingAndQuade(1:130,100,0.05,(lowBoundaryRespirationRate + highBoundaryRespirationRate)/2));
    if abs(integrateMidRespirationRate - integrateThisModel) <= 0.01
        bestRespirationRate = (lowBoundaryRespirationRate + highBoundaryRespirationRate)/2;
        break;
    end
    if integrateMidRespirationRate < integrateThisModel
        lowBoundaryRespirationRate = (lowBoundaryRespirationRate + highBoundaryRespirationRate)/2;
    else
        highBoundaryRespirationRate = (lowBoundaryRespirationRate + highBoundaryRespirationRate)/2;
    end
end
disp(bestRespirationRate);

%% Plotting
hold on;
% plot(CO2(:,1)*1000000,1:depth,'--','LineWidth',1);hold on;%converting to ppm
% plot(CO2(:,2)*1000000,1:depth,'--','LineWidth',1);
% plot(CO2(:,3)*1000000,1:depth,'--','LineWidth',1);
% plot(CO2(:,4)*1000000,1:depth,'--','LineWidth',1);
% plot(CO2(:,5)*1000000,1:depth,'--','LineWidth',1);
% plot(CO2(:,6)*1000000,1:depth,'--','LineWidth',1);
% plot(CO2(:,7)*1000000,1:depth,'--','LineWidth',1);
% plot(CO2(:,8)*1000000,1:depth,'b-','LineWidth',1);
plot(CO2(:,9)*1000000,1:depth,'r-','LineWidth',1); hold on;
plot(CerlingAndQuade(1:130,100,0.05,bestRespirationRate),1:depth,'--','LineWidth',1);
set(gca,'ydir','reverse');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
% xlim([0 15000]);
xlabel('CO_2 concentration (ppm)','FontSize',21);
ylabel('Depth (cm)','FontSize',21);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
%legend('1st day','2nd day','3rd day','4th day','5th day','10th day','15th day','20th day','25th day','Location','Best');

%% Plotting
% a=[0 25 50 75 100 150];
% b=[400	7098	8001	9624	11850	8282];
% c=[400	6888	8029	9530	11394	8175];
% d=[400	7227	8624	9591	11612	8497];
% e=[400	6754	8032	9424	10862	9159];
% f=[400	6587	7903	8276	10605	9547];
% g=[400	6531	7070	8701	10403	9922];
% ave=1/6*(b+c+d+e+f+g);
% x=1:150;
% y=-0.901*x.^2+186.4*x+1174;
% 
% plot(b,a,'k',c,a,'k',d,a,'k',e,a,'k',f,a,'k',g,a,'k','LineWidth',1); hold on;
% set(gca,'fontsize',14);
% set(gca,'ydir','reverse');
%legend('fast-responding microbe','slow-responding microbe');

%% proportion
% prop_sub=[CO2(1,9),CO2(25,9),CO2(50,9),CO2(75,9),CO2(100,9),CO2(150,9)];
% prop=ave-prop_sub*1000000;
% plot(prop,[0 25 50 75 100 150],'k','LineWidth',1);
% set(gca,'fontsize',14);
% set(gca,'ydir','reverse');
% xlim([0 7000]);
% xlabel('difference between Crunch output and in situ measurement (ppm)','FontSize',14);
% ylabel('Depth (cm)','FontSize',14);
