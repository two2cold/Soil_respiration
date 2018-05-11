clear;

t=[24 48.5 72.5 96 139.5 186.5];
moisture0=[0.204 0.110 0.086 0.050 0.032 0.037];%
moisture33=[4.193 3.017 2.281 1.916 1.407 1.192];
moisture66=[6.490 7.314 4.350 3.054 2.076 1.741];
moisture100=[3.490 4.005 3.593 2.800 2.093 2.066];

%[xData, yData] = prepareCurveData( t, moisture66 );
%ft = 'pchipinterp';
%[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
%moisture0_1=spcrv([[t(1) t t(end)];[moisture0(1) moisture0 moisture0(end)]],3,1000);
%moisture33_1=spcrv([[t(1) t t(end)];[moisture33(1) moisture33 moisture33(end)]],3,1000);
%moisture66_1=spcrv([[t(1) t t(end)];[moisture66(1) moisture66 moisture66(end)]],3,1000);
%moisture100_1=spcrv([[t(1) t t(end)];[moisture100(1) moisture100 moisture100(end)]],3,1000);

%plot(moisture0_1(1,:),moisture0_1(2,:),'g-','LineWidth',3);hold on;
%plot(moisture33_1(1,:),moisture33_1(2,:),'r-','LineWidth',3);
%plot(fitresult);
%plot(moisture66_1(1,:),moisture66_1(2,:),'k-','LineWidth',3);
%plot(moisture100_1(1,:),moisture100_1(2,:),'b-','LineWidth',3);
plot(t,moisture0,'g^','MarkerSize',8);hold on;
plot(t,moisture33,'r^','MarkerSize',8);
plot(t,moisture66,'k^','MarkerSize',8);
plot(t,moisture100,'b^','MarkerSize',8);
set(gca,'fontsize',14);
xlim([0 200]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/m3/hour)','FontSize',14);
legend('Soil moisture: 0%','Soil moisture: 33%','Soil moisture: 66%','Soil moisture: 100%','Location','NorthEast');
%title({'Respiration rate of upper soil';'in different soil moisture'},'FontSize',22,'FontWeight','bold');