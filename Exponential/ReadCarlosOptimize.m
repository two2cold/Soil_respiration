%% Optimize exponential decrease
clear;

%% Input data High Resolution incubation 09/08/2018
workingDir = "~/Documents/Works/Respiration_data_09.08.2018.xlsx";
raw = xlsread(workingDir, "Sheet1", "B2:AD9");

TOCPercentage = [2.8 1.76 1.82 1.82 1.64 1.65, 2];

% Normalize to 1 hour
ratePerHour = zeros(size(raw,1)-1,size(raw,2));
for i=2:size(raw,2)
    ratePerHour(:,i) = raw(2:end,i)/(raw(1,i) - raw(1,i-1));
end
ratePerHour(2:6,6) = ratePerHour(2:6,6)/2;
ratePerHour(2:6,8) = ratePerHour(2:6,8)/2;
ratePerHour(2:6,5) = (ratePerHour(2:6,4) + ratePerHour(2:6,6))/2;
ratePerHour(2:6,7) = (ratePerHour(2:6,6) + ratePerHour(2:6,8))/2;
rateFinal = ppm2ugcm3soil(ratePerHour,833.5,75);
meanFinal = zeros(1,size(raw,2));
for i=1:length(meanFinal)
    meanFinal(i) = ((rateFinal(3,i) + rateFinal(4,i))/2 + rateFinal(1,i) + rateFinal(2,i) + rateFinal(5,i) + rateFinal(6,i))/5;
end
rateFinalPerTOC = rateFinal/1e6/2.6;
for i=1:7
    rateFinalPerTOC(i,:) = rateFinalPerTOC(i,:)/TOCPercentage(i)*100;
end

%% Read in studies_list Carlos dataset
workingDir = "~/Documents/Works/Papers/3/sidb-master/data/studies_list.csv";
fileID = fopen(workingDir);
studyList = textscan(fileID,'%s %s %s','Delimiter',',');

%% Read in data from each study Carlos dataset
rawData = cell(1,length(studyList{1})-1);
for i = 1:length(studyList{1})-1
    fileNameTemp = ['~/Documents/Works/Papers/3/sidb-master/data/',studyList{1}{i+1},'/timeSeries.csv'];
    rawData{i} = csvread(fileNameTemp,1,0);
    for j = size(rawData{i},1)
        for k = size(rawData{i},2)
            if rawData{i}(j,k)==0
                rawData{i}(j,k) = nan;
            end
        end
    end
end

%% Four parameters init
lagTime = 24; % [hour]
peakValue = 7; % [gC/m3/hour]
lambda = 0.02; % [-]
beta = 2; % [gC/m3/hour]

%% Equation
for idata=1:length(studyList{1})-1
    F = @(p) RSSExp(rawData{idata}(:,1),rawData{idata}(:,2),p(1),p(2),p(3),p(4));
    finalParam(idata,:) = [lagTime,peakValue,lambda,beta];
    finalRSS(idata) = F(finalParam(idata,:));
    for i=1:100 % Run 1000 times using random x0
        x0 = [randRange(0,50),randRange(0,5000),10^randRange(-10,1),randRange(0,5000)];
        l = [0,0,10^-10,0]; % Lower bound of the parameters
        h = [inf,inf,10^1,inf]; % Upper bound of the parameters
        options = optimoptions('fmincon','Display','none');
        [x, fval, exitflag, output] = fmincon(F,x0,[],[],[],[],l,h,[],options);

        if F(x)<finalRSS(idata)
            finalParam(idata,:) = x;
            finalRSS(idata) = F(finalParam(idata,:));
        end
    end
end

%% Plotting
for idata = 1:length(studyList{1})-1
    for i=1:rawData{idata}(end,1)
        simulated(i) = ExponentialFunc(i,finalParam(idata,1),finalParam(idata,2),finalParam(idata,3),finalParam(idata,4));
    end
    plot(rawData{idata}(end,1),simulated); hold on;
    plot(rawData{idata}(:,1),rawData{idata}(:,2));
end
