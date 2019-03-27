%% Import ER_C14_gas
clear;

%% Import data
fileName = '~/Documents/Works/ER_C14_gas.xlsx';
fieldDepth = xlsread(fileName,'dataForImport','A1:A5');
field14CFM = xlsread(fileName,'dataForImport','B1:B5');
incubationDepth = xlsread(fileName,'dataForImport','A7:A14');
incubation14CFM = xlsread(fileName,'dataForImport','B7:B14');
incubationBWDepth = xlsread(fileName,'dataForImport','A17:A22');
incubationBW14CFM = xlsread(fileName,'dataForImport','B17:B22');

%% Data processing
fitField = pchip(fieldDepth,field14CFM,1:100);
fractionHetero = zeros(1,length(incubationDepth));
for i=1:length(incubationDepth)
    fractionHetero(i) = (fitField(incubationDepth(i)) - 1)/(incubation14CFM(i) - 1);
end

%% Linear regression
b1 = [ones(length(fractionHetero),1) fractionHetero']\incubationDepth;

%% Plotting
% plot(fractionHetero,incubationDepth,'*','MarkerSize',12,'LineWidth',3); hold on;
% plot(fractionHetero,fractionHetero*b1(2)+b1(1),'LineWidth',3);
plot(field14CFM,fieldDepth,'*','MarkerSize',12,'LineWidth',3);
set(gca,'ydir','reverse');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
xlabel('Fraction modern','FontSize',21);
ylabel('Depth (cm)','FontSize',21);
% legend('Calculated','Linear regression');