clear;
gas1=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases1.out',' ',3);
gas2=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases2.out',' ',3);
gas3=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases3.out',' ',3);
gas4=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases4.out',' ',3);
gas5=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases5.out',' ',3);
gas6=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases6.out',' ',3);
gas7=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases7.out',' ',3);
gas8=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases8.out',' ',3);
gas9=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases9.out',' ',3);
gas10=importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/ActiveDormant/Soil_profile_noAD/gases10.out',' ',3);

t=0.5:0.5:5;

O2=zeros(10,200);
for i=1:200
    O2(1,i)=gas1.data(i,2);
end
for i=1:200
    O2(2,i)=gas2.data(i,2);
end
for i=1:200
    O2(3,i)=gas3.data(i,2);
end
for i=1:200
    O2(4,i)=gas4.data(i,2);
end
for i=1:200
    O2(5,i)=gas5.data(i,2);
end
for i=1:200
    O2(6,i)=gas6.data(i,2);
end
for i=1:200
    O2(7,i)=gas7.data(i,2);
end
for i=1:200
    O2(8,i)=gas8.data(i,2);
end
for i=1:200
    O2(9,i)=gas9.data(i,2);
end
for i=1:200
    O2(10,i)=gas10.data(i,2);
end

CO2=zeros(10,200);
for i=1:200
    CO2(1,i)=gas1.data(i,3);
end
for i=1:200
    CO2(2,i)=gas2.data(i,3);
end
for i=1:200
    CO2(3,i)=gas3.data(i,3);
end
for i=1:200
    CO2(4,i)=gas4.data(i,3);
end
for i=1:200
    CO2(5,i)=gas5.data(i,3);
end
for i=1:200
    CO2(6,i)=gas6.data(i,3);
end
for i=1:200
    CO2(7,i)=gas7.data(i,3);
end
for i=1:200
    CO2(8,i)=gas8.data(i,3);
end
for i=1:200
    CO2(9,i)=gas9.data(i,3);
end
for i=1:200
    CO2(10,i)=gas10.data(i,3);
end

CO2=CO2';
O2=O2';

CO2_increase=zeros(200,10);
for i=1:200
    CO2_increase(i,1)=CO2(i,1)/0.5;
end
for i=1:200
    for j=2:10
        CO2_increase(i,j)=(CO2(i,j)-CO2(i,j-1))/0.5;
    end
end

%pcolor(t,0.25:0.25:5,CO2);
%for i=1:20
%    plot(t,CO2_increase(i,:));hold on;
%end
plot(CO2(:,1),0.02:0.02:4,'-','LineWidth',3);hold on;
plot(CO2(:,2),0.02:0.02:4,'-','LineWidth',3);
plot(CO2(:,3),0.02:0.02:4,'-','LineWidth',3);
plot(CO2(:,4),0.02:0.02:4,'-','LineWidth',3);
set(gca,'fontsize',18);
xlabel('Cumulated CO2 (bar)','FontSize',20,'FontWeight','bold');
ylabel('depth (meter)','FontSize',20,'FontWeight','bold');
set(gca,'ydir','reverse');
%ylim([0 3]);
legend('12 hours','24 hours','36 hours','48 hours','Location','NorthEast');
title({'Soil column with moisture gradient';'modeled by Crunch'},'FontSize',22,'FontWeight','bold');