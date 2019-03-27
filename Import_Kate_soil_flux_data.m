%% Plotting soil flux from Kate
clear;

%% Import data
workingDir = '~/Documents/Works/Papers/3/drive-download-20181203T205820Z-001/';
table = readtable([workingDir,'BM_17AUG16_EGMSRCFlux_KM.csv'],'HeaderLines',4,'ReadVariableNames',true);
SM = table.SoilMoisture;
F = table.L1;

table2 = readtable([workingDir,'../BM_16Jul8_EGMSRCFluxSpatial_MM.csv'],'ReadVariableNames',true);
SM2 = [table2.SoilMoisture;table2.SoilMoisture2;table2.SoilMoisture3;table2.SoilMoisture4];
F2 = [table2.L;table2.L2;table2.L3;table2.L4];
lat = table2.Lat;
lon = table2.Lon;

% Append the second dataset to the first and parse out NaN numbers
SM_total = [SM;SM2(1:64);SM2(74:end)];
F_total = [F;F2(1:64);F2(74:end)];

fname='~/Documents/Works/Papers/3/drive-download-20181203T205820Z-001/RMBLgeophOhm.tif'; %Background map from ArcGis basemap
info = imfinfo(fname);
A = imread(fname, 1);
siz=size(A);
cellsizex=info(1).ModelPixelScaleTag(1); %%
cellsizey=info(1).ModelPixelScaleTag(2); %%
xst=info(1).ModelTiepointTag(4);
yst=info(1).ModelTiepointTag(5);
xp=xst:cellsizex:xst+cellsizex*(siz(2)-1);
yp=yst:-cellsizey:yst-cellsizey*(siz(1)-1);%yp=fliplr(yp);

load KateSite.mat ka1   %%%soil EC data
TEST=ka1;
TEST2=table2array(TEST(:,[1:3 5:14]));

%% Linear fitting
params = FitLinear(SM_total,F_total); % R-square: 0.1544
range = min(SM_total):0.01:max(SM_total);

%% Reconstruct RGB
dSM = zeros(1,length(SM_total));
for i = 2:length(SM_total)
    dSM(i) = SM_total(i) - SM_total(i-1);
end
dSMColor = zeros(length(dSM),3);
min = min(dSM);
max = max(dSM);
for i = 1:length(dSM)
    dSMColor(i,1) = (dSM(i) - min)/(max - min);
    dSMColor(i,2) = 1-(dSM(i) - min)/(max - min);
    dSMColor(i,3) = 1-(dSM(i) - min)/(max - min);
end

%% Plotting
% scatter(SM_total,F_total,50,dSMColor,'filled');
% set(gca,'box','off');
% set(gca, 'FontName', 'Times New Roman');
% set(gca,'FontSize',18);
% xlabel('VWC');
% ylabel('Surface C flux (g/m^2/yr)');

figure; 
imagesc(xp,yp,A)
axis image
set(gca,'ydir','normal')
hold on
colormap('jet')
scatter(TEST2(:,2),TEST2(:,1),10,TEST2(:,6),'filled')%%%column 6 (in TEST2) is averaged soil EC (mS/m) in top 1 m
caxis([3 12])
colorbar
% plot(lat,lon,'ko')
title('ECtop1m [mS/m]')

%% In terms of time
% PlotYYSmooth(F,SM,6)
% PlotYYSmooth(table2.L4,table2.SoilMoisture4,6)

%% Additional equations
function result = Smooth(matrixIn,smoothOver)
    % Take matrixIn and calculate the average of every smoothOver of numbers
    result = zeros(1,ceil(length(matrixIn)/smoothOver));
    if length(result) == 1
        result = mean(matrixIn);
    else
        for i = 1:length(result)-1
            result(i) = mean(matrixIn(((i-1)*smoothOver+1):i*smoothOver));
        end
        result(end) = mean(matrixIn((length(result)-1)*smoothOver+1:end));
    end
end

function PlotYYSmooth(yleft,yright,smoothOver)
    % Plot a dual y plot
    yleft = Smooth(yleft,smoothOver);
    yright = Smooth(yright,smoothOver);
    yyaxis left;
    plot(1:length(yleft),yleft,'LineWidth',2); 
    ylabel('Surface C flux (g/m^2/yr)');
    yyaxis right;
    plot(1:length(yright),yright,'LineWidth',2);
    set(gca,'box','off');
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'FontSize',18);
    ylabel('VWC');
    xlabel('#');
end