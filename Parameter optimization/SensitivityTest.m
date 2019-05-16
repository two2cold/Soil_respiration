%% Sensitivity test
clear;

%% Incubation data
x_real = [1,24,48,72,96,135,186]; % Time [hour]
y_real = cell(1,2);
y_real{1} = [0 6.490 7.314 4.350 3.054 2.076 1.741]; % gC/m3-soil/hour
y_real{2} = [0 4.193 3.017 2.281 1.916 1.407 1.192];

%% DM
FDM = @(p) RSSDM(x_real,y_real{1},p,0.66,0.02) + RSSDM(x_real,y_real{2},p,0.33,0.02);
bestParams = [0.000116450683361297,1.02674575240912e-05,15000,45000,0.0243992119340656,0.00568794719957349];
lowestRSS = 0.7997;
% (FDM(bestParams) - lowestRSS)/lowestRSS
% resultPercentage = zeros(1,length(bestParams));
% for i=1:length(bestParams)
%     ParamsHigh = bestParams;
%     ParamsLow = bestParams;
%     ParamsHigh(i) = ParamsHigh(i)*1.1;
%     ParamsLow(i) = ParamsHigh(i)*0.9;
%     RSSTemp = max(FDM(ParamsHigh),FDM(ParamsLow));
%     resultPercentage(i) = (RSSTemp - lowestRSS)/lowestRSS;
% end

%% FO
FFO = @(p) RSSFO(x_real(2:end),y_real{1}(2:end),p,0.66,0.02) + RSSFO(x_real(2:end),y_real{2}(2:end),p,0.33,0.02);
bestParamsFO = [0.0153253226052140,5.00000000000000e-05,0.0226625340658893];
lowestRSSFO = 8.4964;
(FFO(bestParamsFO) - lowestRSSFO)/lowestRSSFO
resultPercentageFO = zeros(1,length(bestParamsFO));
for i=1:length(bestParamsFO)
    ParamsHighFO = bestParamsFO;
    ParamsLowFO = bestParamsFO;
    ParamsHighFO(i) = ParamsHighFO(i)*1.1;
    ParamsLowFO(i) = ParamsHighFO(i)*0.9;
    RSSTemp = max(FFO(ParamsHighFO),FFO(ParamsLowFO));
    resultPercentageFO(i) = (RSSTemp - lowestRSSFO)/lowestRSSFO;
end