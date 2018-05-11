clear;

t=[24 48.5 72.5 96 139.5 186.5];
bot_33=[-10.881	-11.754	-11.460	-12.945	-14.543	-14.113];
bot_66=[-11.533	-12.401	-14.321	-14.662	-15.996	-15.831];
bot_99=[-12.358	-12.274	-14.904	-16.448	-16.031	-16.301];
mid_33=[-17.182	-21.338	-21.651	-21.493	-22.450	-22.363];
mid_66=[-20.029	-22.101	-22.055	-22.265	-22.811	-23.008];
mid_99=[-18.680	-21.289	-21.093	-21.002	-22.097	-22.277];
top_33=[-22.932	-23.927	-23.069	-23.448	-23.781	-23.599];
top_66=[-23.573	-23.791	-24.570	-25.058	-24.598	-23.852];
top_99=[-23.282	-23.180 -23.098	-22.792	-23.173	-23.260];

bot_33_1=spcrv([[t(1) t t(end)];[bot_33(1) bot_33 bot_33(end)]],3,1000);
bot_66_1=spcrv([[t(1) t t(end)];[bot_66(1) bot_66 bot_66(end)]],3,1000);
bot_99_1=spcrv([[t(1) t t(end)];[bot_99(1) bot_99 bot_99(end)]],3,1000);
mid_33_1=spcrv([[t(1) t t(end)];[mid_33(1) mid_33 mid_33(end)]],3,1000);
mid_66_1=spcrv([[t(1) t t(end)];[mid_66(1) mid_66 mid_66(end)]],3,1000);
mid_99_1=spcrv([[t(1) t t(end)];[mid_99(1) mid_99 mid_99(end)]],3,1000);
top_33_1=spcrv([[t(1) t t(end)];[top_33(1) top_33 top_33(end)]],3,1000);
top_66_1=spcrv([[t(1) t t(end)];[top_66(1) top_66 top_66(end)]],3,1000);
top_99_1=spcrv([[t(1) t t(end)];[top_99(1) top_99 top_99(end)]],3,1000);

plot(bot_33_1(1,:),bot_33_1(2,:),'r-','LineWidth',3);hold on;
plot(bot_66_1(1,:),bot_66_1(2,:),'k-','LineWidth',3);
plot(bot_99_1(1,:),bot_99_1(2,:),'b-','LineWidth',3);
plot(mid_33_1(1,:),mid_33_1(2,:),'r-','LineWidth',3);
plot(mid_66_1(1,:),mid_66_1(2,:),'k-','LineWidth',3);
plot(mid_99_1(1,:),mid_99_1(2,:),'b-','LineWidth',3);
plot(top_33_1(1,:),top_33_1(2,:),'r-','LineWidth',3);
plot(top_66_1(1,:),top_66_1(2,:),'k-','LineWidth',3);
plot(top_99_1(1,:),top_99_1(2,:),'b-','LineWidth',3);
plot(t,bot_33,'r*','MarkerSize',10);
plot(t,bot_66,'k*','MarkerSize',10);
plot(t,bot_99,'b*','MarkerSize',10);
plot(t,mid_33,'r+','MarkerSize',10);
plot(t,mid_66,'k+','MarkerSize',10);
plot(t,mid_99,'b+','MarkerSize',10);
plot(t,top_33,'rx','MarkerSize',10);
plot(t,top_66,'kx','MarkerSize',10);
plot(t,top_99,'bx','MarkerSize',10);

set(gca,'fontsize',18);
xlabel('Time (hours)','FontSize',20,'FontWeight','bold');
ylabel('\delta^{13}C','FontSize',20,'FontWeight','bold');
legend('33% moisture','66% moisture','100% moisture','Location','best');
title({'\delta^{13}C in different depths and soil moistures'},'FontSize',22,'FontWeight','bold');