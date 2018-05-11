clear;
gas1=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate1.out',' ',3);
gas2=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate2.out',' ',3);
gas3=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate3.out',' ',3);
gas4=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate4.out',' ',3);
gas5=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate5.out',' ',3);
gas6=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate6.out',' ',3);
gas7=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate7.out',' ',3);
gas8=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate8.out',' ',3);
gas9=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate9.out',' ',3);
gas10=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate10.out',' ',3);
gas11=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate11.out',' ',3);
gas12=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate12.out',' ',3);
gas13=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate13.out',' ',3);
gas14=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate14.out',' ',3);
gas15=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate15.out',' ',3);
gas16=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate16.out',' ',3);
gas17=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate17.out',' ',3);
gas18=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate18.out',' ',3);
gas19=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate19.out',' ',3);
gas20=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/RepTest/AqRate20.out',' ',3);

t=0.5:0.5:10;

uptake=zeros(20,200);
for i=1:200
    uptake(1,i)=gas1.data(i,2);
end
for i=1:200
    uptake(2,i)=gas2.data(i,2);
end
for i=1:200
    uptake(3,i)=gas3.data(i,2);
end
for i=1:200
    uptake(4,i)=gas4.data(i,2);
end
for i=1:200
    uptake(5,i)=gas5.data(i,2);
end
for i=1:200
    uptake(6,i)=gas6.data(i,2);
end
for i=1:200
    uptake(7,i)=gas7.data(i,2);
end
for i=1:200
    uptake(8,i)=gas8.data(i,2);
end
for i=1:200
    uptake(9,i)=gas9.data(i,2);
end
for i=1:200
    uptake(10,i)=gas10.data(i,2);
end
for i=1:200
    uptake(11,i)=gas11.data(i,2);
end
for i=1:200
    uptake(12,i)=gas12.data(i,2);
end
for i=1:200
    uptake(13,i)=gas13.data(i,2);
end
for i=1:200
    uptake(14,i)=gas14.data(i,2);
end
for i=1:200
    uptake(15,i)=gas15.data(i,2);
end
for i=1:200
    uptake(16,i)=gas16.data(i,2);
end
for i=1:200
    uptake(17,i)=gas17.data(i,2);
end
for i=1:200
    uptake(18,i)=gas18.data(i,2);
end
for i=1:200
    uptake(19,i)=gas19.data(i,2);
end
for i=1:200
    uptake(20,i)=gas20.data(i,2);
end

sleep=zeros(20,200);
for i=1:200
    sleep(1,i)=gas1.data(i,3);
end
for i=1:200
    sleep(2,i)=gas2.data(i,3);
end
for i=1:200
    sleep(3,i)=gas3.data(i,3);
end
for i=1:200
    sleep(4,i)=gas4.data(i,3);
end
for i=1:200
    sleep(5,i)=gas5.data(i,3);
end
for i=1:200
    sleep(6,i)=gas6.data(i,3);
end
for i=1:200
    sleep(7,i)=gas7.data(i,3);
end
for i=1:200
    sleep(8,i)=gas8.data(i,3);
end
for i=1:200
    sleep(9,i)=gas9.data(i,3);
end
for i=1:200
    sleep(10,i)=gas10.data(i,3);
end
for i=1:200
    sleep(11,i)=gas11.data(i,3);
end
for i=1:200
    sleep(12,i)=gas12.data(i,3);
end
for i=1:200
    sleep(13,i)=gas13.data(i,3);
end
for i=1:200
    sleep(14,i)=gas14.data(i,3);
end
for i=1:200
    sleep(15,i)=gas15.data(i,3);
end
for i=1:200
    sleep(16,i)=gas16.data(i,3);
end
for i=1:200
    sleep(17,i)=gas17.data(i,3);
end
for i=1:200
    sleep(18,i)=gas18.data(i,3);
end
for i=1:200
    sleep(19,i)=gas19.data(i,3);
end
for i=1:200
    sleep(20,i)=gas20.data(i,3);
end

sleep=sleep';
uptake=uptake';

sleep_increase=zeros(200,20);
for i=1:200
    sleep_increase(i,1)=sleep(i,1)/0.5;
end
for i=1:200
    for j=2:20
        sleep_increase(i,j)=(sleep(i,j)-sleep(i,j-1))/0.5;
    end
end

%pcolor(t,0.25:0.25:5,CO2);
%set(gca,'YDir','reverse');
for i=1:200
    plot(t,uptake(i,:));hold on;
end
set(gca,'fontsize',18);
xlabel('Time (days)','FontSize',20,'FontWeight','bold');
ylabel('CO2 respiration (ug C-CO2/g soil/hour)','FontSize',20,'FontWeight','bold');
%xlim([0 0.25]);
%legend('1','2','3','4','5','6','7','8','9','10','Location','best');
title({'Soil column with moisture gradient';'modeled by Crunch'},'FontSize',22,'FontWeight','bold');