clear;
gas1=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases1.out',' ',3);
gas2=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases2.out',' ',3);
gas3=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases3.out',' ',3);
gas4=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases4.out',' ',3);
gas5=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases5.out',' ',3);
gas6=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases6.out',' ',3);
gas7=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases7.out',' ',3);
gas8=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases8.out',' ',3);
gas9=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases9.out',' ',3);
gas10=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases10.out',' ',3);
gas11=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases11.out',' ',3);
gas12=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases12.out',' ',3);
gas13=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases13.out',' ',3);
gas14=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases14.out',' ',3);
gas15=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases15.out',' ',3);
gas16=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases16.out',' ',3);
gas17=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases17.out',' ',3);
gas18=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases18.out',' ',3);
gas19=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases19.out',' ',3);
gas20=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/gases20.out',' ',3);

CO2=zeros(1,20);
CO2(1)=gas1.data(1,3);
CO2(2)=gas2.data(1,3);
CO2(3)=gas3.data(1,3);
CO2(4)=gas4.data(1,3);
CO2(5)=gas5.data(1,3);
CO2(6)=gas6.data(1,3);
CO2(7)=gas7.data(1,3);
CO2(8)=gas8.data(1,3);
CO2(9)=gas9.data(1,3);
CO2(10)=gas10.data(1,3);
CO2(11)=gas11.data(1,3);
CO2(12)=gas12.data(1,3);
CO2(13)=gas13.data(1,3);
CO2(14)=gas14.data(1,3);
CO2(15)=gas15.data(1,3);
CO2(16)=gas16.data(1,3);
CO2(17)=gas17.data(1,3);
CO2(18)=gas18.data(1,3);
CO2(19)=gas19.data(1,3);
CO2(20)=gas20.data(1,3);

CO2_increase=zeros(1,20);
CO2_increase(1)=CO2(1);
for i=2:20
    CO2_increase(i)=CO2(i)-CO2(i-1);
end

x_real=[24, 48.5,72.5, 96, 139.5, 186.5];
%y_real=[204.665, 225.938, 137.183, 98.362, 72.249, 56.084];%umol/g C/day
y_real=[132.219, 93.210, 71.918, 61.692, 48.943, 38.396];
plot(x_real,y_real/2*0.01457,'k*','MarkerSize',10); hold on;% converting to ug C/g soil/hour
plot(12:12:240,CO2_increase*1000/22.4*12/12,'-','LineWidth',3);
set(gca,'fontsize',18);
xlabel('Time (hour)','FontSize',20,'FontWeight','bold');
ylabel('Respiration rate (ug CO2-C/g soil/hour)','FontSize',20,'FontWeight','bold');
%set(gca,'ydir','reverse');
ylim([0 3]);
%legend('12 hours','48 hours','84 hours','120 hours','Location','NorthEast');
title({'Reactive model fitting','for upper soil 33% soil moisture'},'FontSize',22,'FontWeight','bold');