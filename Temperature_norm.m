%% Temperature normalization
clear;
workingDir = '/Users/yuchenliu/Documents/Works/Posters and presentations/Goldschmidt/2018/Workbook2.xlsx';

%% Read excel
respData = xlsread(workingDir,'Sheet2','G2:G1927');
timeData = xlsread(workingDir,'Sheet2','F2:F1927');