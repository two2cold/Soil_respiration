clear;

% t=[.04 .3 .5 .7 .9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.2 2.4 2.6 2.8 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 9 10 11]; %...
%    12 13 14 15 16 17 18 19 20 21 22 23 24 25 ...
%    25.1 25.3 25.5 25.7 25.9 26.1 26.3 26.5 26.7 26.9 27.1 27.3 27.5 27.7 28 28.5 29 29.5 30 31 32 33 34 35 36 37 38];

t = [25.1 25.3 25.5 25.7 25.9 26.1 26.3 26.5 26.7 26.9 27.1 27.3 27.5 27.7 28 28.5 29 29.5 30 31 32 33 34 35 36 37 38];

fileNumber=length(t);
files=cell(1,fileNumber);
for n=1:fileNumber
    filename=sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/BCtop 01042018/AqRate%d.out',n); % The directory of the output files
    files{n}=importdata(filename,' ',3);
end

% O2=zeros(1,fileNumber);
CO2=zeros(1,fileNumber);

CUE_fast = 0.2;
CUE_slow = 0.2;

for n=1:fileNumber
%     O2(n)=files{n}.data(1,2);
    CO2(n)=files{n}.data(1,2)*(1-CUE_fast);% + files{n}.data(1,3)*(1-CUE_slow) + files{n}.data(1,4)*(1-CUE_slow);%mol/kgH2O/year
end

x_real=[0 24 48 72 99 123 147 195 267 603 627 651 699 747 819 915];
y_real60=[0 259.2039907 174.0561513 146.1212134 144.2409772 110.1281204 91.72866614 144.7781876 ...
    245.1022192 0 138.7345712 103.8158989 149.8816858 113.8885928 134.0339807 167.4753246]; % gC/m3/hour
y_real10 = [0 81.25306444 45.79718178 34.91867232 31.49395638 25.78609648 19.33957236 25.6517939 ...
    45.12566885 0 47.94602315 25.92039907 33.23989 28.20354303 33.97855422 39.75356541];
y_real20 = [0 158.4770513 89.71412735 71.58327826 62.85361018 44.99136626 38.27623697 57.75011192 ...
    105.2932273 0 95.08623079 56.27278347 79.10422307 64.46524121 74.40363257 86.75947046];
y_real30 = [0 202.7969046 120.8723273 99.24961095 92.40017907 73.86642222 64.46524121 95.48913854 ...
    171.6387047 0 107.5763713 68.49431879 101.5327549 83.80481358 103.8158989 118.4548807];
y_real40 = [0 231.0004477 145.0467927 117.6490652 112.1426592 86.08795753 74.13502739 106.7705558 ...
    189.6352512 0 116.0374342 75.88096101 111.3368437 92.40017907 114.0228954 131.0793238];
y_real50 = [0 249.8028097 156.0596048 129.064785 123.9612867 99.92112388 83.93911616 124.6327997 ...
    214.2126244 0 125.0357074 85.95365495 134.1682833 105.2932273 130.8107186 150.150291];
y_real80 = [0 283.3784562 177.2794133 154.9851841 153.1049479 NaN 89.71412735 142.4950436 237.715577 ...
    0 138.3316634 105.5618325 161.163103 118.1862756 143.0322539 173.5189409];
y_real90 = [0 282.0354303 187.3521073 169.6241659 173.2503358 122.7525635 99.11530836 153.6421582 ...
    255.4435183 0 139.0031764 113.3513825 165.1921806 122.2153531 152.4334349 186.9491995];

for i = 2:length(x_real)
    y_real10(i) = y_real10(i)/(x_real(i) - x_real(i - 1));
    y_real20(i) = y_real20(i)/(x_real(i) - x_real(i - 1));
    y_real30(i) = y_real30(i)/(x_real(i) - x_real(i - 1));
    y_real40(i) = y_real40(i)/(x_real(i) - x_real(i - 1));
    y_real50(i) = y_real50(i)/(x_real(i) - x_real(i - 1));
    y_real60(i) = y_real60(i)/(x_real(i) - x_real(i - 1));
    y_real80(i) = y_real80(i)/(x_real(i) - x_real(i - 1));
    y_real90(i) = y_real90(i)/(x_real(i) - x_real(i - 1));
end

% Se(1:34) = 0.2;
% Se(35:48) = 0.1;
% Se(49:75) = 0.2;
figure;
dataUsed = 90;
leg = sprintf('Incubation data for %d%% Se',dataUsed);
% plot(t(1:fileNumber)*24,CO2_increase*39.68,'-','LineWidth',1); hold on; % converting to gC/m3/hour
% plot(t(1:fileNumber)*24,CO2*1000*0.64/0.36.*Se*12/4*0.9/365/24,'r-','LineWidth',1);hold on; % converting to gC/m3/hour
plot(t(1:fileNumber)*24,CO2*1000*0.64/0.36*12/4/365/24,'r-','LineWidth',1);hold on; % converting to gC/m3/hour
plot(x_real,y_real90,'k^','MarkerSize',10);
xlim([600 920]);
ylim([0 8]);
set(gca,'fontsize',22);
set(gca,'FontName','Times New Roman');
xlabel('Time (hours)','FontSize',22);
ylabel_text = sprintf('Respiration rate\n(gC/m^3/hour)');
ylabel(ylabel_text,'FontSize',22);
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
legend('Model fitting line',leg,'Location','NorthEast');
