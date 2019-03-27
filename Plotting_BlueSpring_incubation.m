%% Plotting
t=[24	48	72	96	120	144	168	216];
a1=[2.027	6.408	4.348	3.008	2.282	1.949	1.596	1.275];
a2=[2.354	9.416	4.989	3.727	3.060	2.727	2.289	1.880];
a3=[1.014	5.493	4.414	3.721	3.315	2.936	2.707	2.236];
b1=[1.805	5.395	4.100	2.877	2.210	1.916	1.609	1.318];
b2=[2.093	8.501	4.682	3.466	2.858	2.531	2.210	1.877];
b3=[1.027	4.839	3.786	3.132	2.786	2.616	2.439	2.184];
c1=[0.530	1.582	1.602	1.229	0.955	0.804	0.660	0.517];
c2=[0.523	1.909	1.857	1.419	1.157	0.994	0.830	0.682];
c3=[0.320	1.569	1.582	1.275	1.105	0.991	0.866	0.717];
d1=[0.301	0.844	0.883	0.667	0.553	0.476	0.405	0.319];
d2=[0.248	0.915	0.981	0.700	0.569	0.491	0.420	0.333];
d3=[0.173	0.804	1.020	0.837	0.677	0.579	0.499	0.398];

subplot(2,2,1)
plot(t,a1,'r-^','MarkerSize',8); hold on;
plot(t,a2,'k-^','MarkerSize',8);
plot(t,a3,'b-^','MarkerSize',8);
set(gca,'fontsize',14);
ylim([0 10]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/g-soil/hour)','FontSize',14);
legend('30% soil moisture','60% soil moisture','100% soil moisture');

subplot(2,2,2)
plot(t,b1,'r-^','MarkerSize',8); hold on;
plot(t,b2,'k-^','MarkerSize',8);
plot(t,b3,'b-^','MarkerSize',8);
set(gca,'fontsize',14);
ylim([0 10]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/g-soil/hour)','FontSize',14);
legend('30% soil moisture','60% soil moisture','100% soil moisture');

subplot(2,2,3)
plot(t,c1,'r-^','MarkerSize',8); hold on;
plot(t,c2,'k-^','MarkerSize',8);
plot(t,c3,'b-^','MarkerSize',8);
set(gca,'fontsize',14);
ylim([0 10]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/g-soil/hour)','FontSize',14);
legend('30% soil moisture','60% soil moisture','100% soil moisture');

subplot(2,2,4)
plot(t,d1,'r-^','MarkerSize',8); hold on;
plot(t,d2,'k-^','MarkerSize',8);
plot(t,d3,'b-^','MarkerSize',8);
set(gca,'fontsize',14);
ylim([0 10]);
xlabel('Time (hours)','FontSize',14);
ylabel('Respiration rate (gC/g-soil/hour)','FontSize',14);
legend('30% soil moisture','60% soil moisture','100% soil moisture');
