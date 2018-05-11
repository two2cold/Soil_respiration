clear;

x_axis=[0 33 66 100];
top=[0.204 4.193 6.490 3.490];
mid=[0.417 2.301 3.017 1.594];
bot=[0.549 1.726 1.538 0.824];

top_1=zeros(1,100);
mid_1=zeros(1,100);
bot_1=zeros(1,100);
for i=0:100
    top_1(i+1)=-1.579e-05*i^3+0.0007863*i^2+0.1121*i+0.204;
    mid_1(i+1)=-4.122e-06*i^3-0.0001282*i^2+0.06581*i+0.417;
    bot_1(i+1)=3.983e-06*i^3-0.001021*i^2+0.06502*i+0.549;
end

plot(0:100,top_1,'b--','LineWidth',1);hold on;
plot(0:100,mid_1,'r--','LineWidth',1);
plot(0:100,bot_1,'k--','LineWidth',1);
plot(x_axis,top,'b^','MarkerSize',8);hold on;
plot(x_axis,mid,'r^','MarkerSize',8);
plot(x_axis,bot,'k^','MarkerSize',8);
set(gca,'fontsize',14);
%ylim([0 6]);
xlabel('Soil moisture (%)','FontSize',14);
ylabel('Respiration rate (gC/m3/hour)','FontSize',14);
legend('Upper depth(0-52cm)','Mid depth(63-108cm)','Lower depth(112-165cm)','Location','NorthWest');
%title({'Respiration rate in different soil moisture';'on the first day of incubation'},'FontSize',22,'FontWeight','bold');