%%
clear;

%%
t=[24 48.5 72.5 96 139.5 186.5];
moisture0=[0.204 0.110 0.086 0.050 0.032 0.037];%
moisture33=[4.193 3.017 2.281 1.916 1.407 1.192];
moisture66=[6.490 7.314 4.350 3.054 2.076 1.741];
moisture100=[3.490 4.005 3.593 2.800 2.093 2.066];

moisture = [0 0.33 0.66 0.99];
top = [0.204 4.193 6.490 3.490];
mid = [0.417 2.301 3.017 1.594];
bottom = [0.549 1.726 1.538 0.824];
TOCpercentage = [2.04 1.4 0.9];
top = top/1e6/2.6/TOCpercentage(1)*100;
mid = mid/1e6/2.6/TOCpercentage(2)*100;
bottom = bottom/1e6/2.6/TOCpercentage(3)*100;

%% 

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

% plot(t,moisture0,'g^','MarkerSize',8);hold on;
% plot(t,moisture33,'r^','MarkerSize',8);
% plot(t,moisture66,'k^','MarkerSize',8);
% plot(t,moisture100,'b^','MarkerSize',8);
% % plot(moisture,top,'b^--','MarkerSize',8);hold on;
% % plot(moisture,mid,'r^--','MarkerSize',8);
% % plot(moisture,bottom,'k^--','MarkerSize',8);
% % set(gca,'fontsize',18);
% % set(gca, 'FontName', 'Times New Roman');
% % set(gca,'XColor','k');
% % set(gca,'YColor','k');
% % set(gca,'box','off');
% % % xlim([0 200]);
% % xlabel('Effective saturation, Se (-)');
% % ylabel('Respiration rate (gC/g-TOC/hour)');
% % legend('Shallow depth','Intermediate depth','Deep depth','Location','NorthEast');
%title({'Respiration rate of upper soil';'in different soil moisture'},'FontSize',22,'FontWeight','bold');

%%
% x_real=[1 24, 48.5,72.5, 96, 139.5, 186.5];
% x_test=[0,24,48,72,99,123,147,195,267];
% y_real=cell(1,6);
% y_real{1}=[0 6.490 7.314 4.350 3.054 2.076 1.741];%gC/m3-soil/hour
% y_real{2}=[0 4.193 3.017 2.281 1.916 1.407 1.192];%gC/m3-soil/hour
% y_real{3}=[0 3.017 4.394 2.813 1.661 1.112 1.052];
% y_real{4}=[0 2.301 1.919 1.507 1.052 0.790 0.743];
% y_real{5}=[0 1.538 1.149 0.897 0.509 0.378 0.392];
% y_real{6}=[0 1.726 0.919 0.633 0.342 0.224 0.234];
% 
% y_real{1} = y_real{1}/1e6/2.6/TOCpercentage(1)*100;
% y_real{2} = y_real{2}/1e6/2.6/TOCpercentage(1)*100;
% y_real{3} = y_real{3}/1e6/2.6/TOCpercentage(2)*100;
% y_real{4} = y_real{4}/1e6/2.6/TOCpercentage(2)*100;
% y_real{5} = y_real{5}/1e6/2.6/TOCpercentage(3)*100;
% y_real{6} = y_real{6}/1e6/2.6/TOCpercentage(3)*100;
% 
% for i=1:6
%     plot(x_real,y_real{i},'^--','MarkerSize',8);hold on;
% end
% set(gca,'fontsize',18);
% set(gca, 'FontName', 'Times New Roman');
% set(gca,'XColor','k');
% set(gca,'YColor','k');
% set(gca,'box','off');
% xlabel('Time (hour)');
% ylabel('Respiration rate (gC/g-TOC/hour)');
% legend('Shallow 66% Se','Shallow 33% Se','Intermediate 66% Se','Intermediate 33% Se','Deep 66% Se','Deep 33% Se');

%% Peak respiration rate vs TOC
rate = [10.6517    2.9831    2.6725    2.2153    2.4996    2.7428    2.0395    0.9553];
TOCPercentage = [2.8 1.76 1.82 1.64 1.65 1.74 1.71 1.67];
rate2 = [27.5684    5.4533    6.0821    5.9791    4.3271    3.6983 7.0058];
TOCPercentage2 = [2.8 1.76 1.82 1.82 1.64 1.65, 2];
rate3 = [7.314 4.394 1.538];
TOCPercentage3 = [2.04 1.4 0.9];
rate4 = [5.6555    2.3882    2.6549    2.2153    2.4996    1.8754    2.0395    0.8410];
plot(TOCPercentage,rate,'*','MarkerSize',8); hold on;
plot(TOCPercentage2,rate2,'^','MarkerSize',8);
plot(TOCPercentage3,rate3,'o','MarkerSize',8);
plot(TOCPercentage,rate4,'>','MarkerSize',15);
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
xlabel('TOC percentage (%)');
ylabel('Respiration rate (gC/m3/hour)');
legend('BCT Low resolution','BCT High resolution','BM (reported)');