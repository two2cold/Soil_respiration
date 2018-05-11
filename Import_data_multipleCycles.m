%% Import data for simulation with multiple dry-wet cycles
clear;

%% Import data
fileNumber=80;
files=cell(1,fileNumber);
for n=1:fileNumber
    filename=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/MultipleRaining/AqRate%d.out',n);
    files{n}=importdata(filename,' ',3);
end

files2=cell(1,fileNumber);
for n=1:fileNumber
    filename2=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/MultipleRaining/totcon%d.out',n);
    files2{n}=importdata(filename2,' ',3);
end

t=1:80;

%% Calculation
%O2=zeros(1,fileNumber);
CO2=zeros(1,fileNumber);
acetate=zeros(1,fileNumber);
for n=1:fileNumber
%    O2(n)=files{n}.data(1,2);
    CO2(n)=files{n}.data(1,2)+files{n}.data(1,3)+files{n}.data(1,4);%mol/kgH2O/year
    acetate(n)=files2{n}.data(1,2)+files2{n}.data(1,3);
end

Se(1:10) = 0.2; Se(11:20) = 0.6; Se(21:50) = 0.2; Se(51:70) = 0.6; Se(71:80) = 0.2;

% Convert from mol/kgW to gC/m3
acetate=acetate*1000*0.64/0.36.*Se*12/4;

[ax,h1,h2] = plotyy(t(1:fileNumber),CO2*1000*0.64/0.36.*Se*12/4*0.9/365/24,t(1:fileNumber),acetate);hold on;%converting to gC/m3/hour
set(ax(1),'ylim',[0,25],'ytick',0:5:25);
%set(ax(2),'ylim',[0,1],'ytick',0:0.2:1);
set(ax(1),'Ycolor','k')
set(ax(2),'Ycolor','k')
set(gca,'fontsize',14);
xlabel('Time (days)','FontSize',14);
ylabel('Respiration rate (gC/m3/hour)','FontSize',14);
%ylim([0 8]);
%legend('Real data for upper soil 66%','model fitting line','Location','NorthEast');
%title({'Reactive model fitting';'for upper soil 66% soil moisture'},'FontSize',22,'FontWeight','bold');
