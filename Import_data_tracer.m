% Import_data_tracer
clear all;
close all;

% read in moisture file
vwc = importdata('/Users/yuchenliu/Documents/CrunchTopeDistribute/Tracer/BradleyHillslopeVWC_try.txt'); %PLEASE CHANGE THE DIRECTORY TO WHERE YOUR OUTPUT FILES ARE STORED -- YUCHEN

% read in and store 'gases' file for crunch CO2 concentrations
numFiles = 12; %MUST INPUT THE NUMBER OF FILES BY HAND (USE 12 TO SEE IF THE CODE IS RUNNING) -- YUCHEN
files = cell(1,numFiles);
for n = 1:numFiles
    fileName = sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/Tracer/gases%d.out',n);
    files{n} = importdata(fileName,' ',3);
end
co2 = zeros(150,numFiles);
%files = {files{1}, files{5:12}, files{2:4}}; %reorder files. THIS LINE MAKE SENSE ONLY WHEN THERE ARE 12 FILES -- YUCHEN
for n = 1:numFiles
    co2(:,n) = files{n}.data(:,2);
end

% read in and store 'Aqueous Rates' files for co2 production
numFiles = 12; %MUST INPUT THE NUMBER OF FILES BY HAND (USE 12 TO SEE IF THE CODE IS RUNNING) -- YUCHEN
files2 = cell(1,numFiles);
for n = 1:numFiles
    fileName2 = sprintf('/Users/yuchenliu/Documents/CrunchTopeDistribute/Tracer/AqRate%d.out',n);
    files2{n} = importdata(fileName2,' ',3);
end
prod = zeros(150,numFiles);
%files2 = {files2{1}, files2{5:12}, files2{2:4}}; %reorder files. THIS LINE MAKE SENSE ONLY WHEN THERE ARE 12 FILES -- YUCHEN
for n = 1:numFiles
    prod(:,n) = files2{n}.data(:,2);
end

% create array of depths in cm
depths = files{1}.data(:,1);
depths = depths*100;

% set color ramp for plotting based on # of timesteps
% colors <- tim.colors(n = 12) %REDUNDENT -- YUCHEN

% plot co2 profiles from crunch w/ colors representing timesteps
figure(1);
subplot(1,1,1);
xlim([10e-12 max(max(co2))]);
ylim([0 155]);
%set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([155 0]) INSTEAD OF ylim([0 155]) ORIGINALLY --YUCHEN
xlabel('CO2 (bars)');
% REWRITE THE PLOTTING CODE BECAUSE YOU HAVE TO PLOT OUT A FIGURE BEFORE ADDING ANOTHER LINE TO IT IN R, BUT YOU DON'T HAVE TO IN MATLAB -- YUCHEN
for n = 1:numFiles %THE ORIGINAL CODE IS SO WEIRD AND REDUNDENT, WE ALREADY KNOW THE DIMENTION OF co2 -- YUCHEN
    plot(co2(:,n),depths); %COLORS AUTO-ASSIGNED -- YUCHEN
    hold on;
end
set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN

% make array of change in time in seconds (12 hrs for first 9, 5 days for last two)
dt(1:9) = 12*60*60; dt(10:11) = 5*60*60*24; %seconds
dx = 1; %cm grid spacing
%D = 0.01;
%D = 0.00005;
D = 0.03; %m2/day
D = D*10000/24/60/60;

p = 0.2; %porosity

% convert bars to ppm
co2 = co2*0.986*10^6;
% empty arrays to store data
dimension = size(co2);
P = zeros(dimension(1),dimension(2)-1);
P_steady = zeros(dimension(1),dimension(2)-1);
dif = zeros(dimension(1),dimension(2)-1);

% dirichlet top boundary (set value), no flux bottom boundary (no gradient)
co2 = [ones(1,numFiles); co2; co2(150,:)];
% convert ppm to moles/cm3

%co2 = (co2/10^6)*(42.3*10^-6); %moles/cm3

% convert co2 to moles/cm3
co2 = co2*(0.00129/44)*10^6;



% for i = 1:dimension(1)
%     for j = 1:dimension(2)-1
%         P(i,j) = (co2(i,j) - co2(i-1,j))*p/dt(i) - D*(1/(dx^2))*(co2(i,j+2) - 2*co2(i,j+1) + co2(i,j) + co2(i-1,j+2) - 2*co2(i-1,j+1) + co2(i-1,j))*p; %- P(i-1,j)
%     end
% end
% 
% % no diffusion
% for j = 1:dimension(2)-1
%     for i = 1:1:dimension(1)
%         print(i);
%         P(i,j) = (co2(i,j+1) - co2(i,j))/dt;
%     end
% end
% P = P*365*24*60*60/0.001/0.2;

% dirichlet
% zero flux boundary conditions, set outside boundaries equal to inner
% co2 = [co2(1,:); co2; co2(150,:)];

% double check production calculations at boundaries
% (co2(2,2) - co2(2,1))/dt - D*(co2(3,2) - 2*co2(2,2) + co2(1,2))/dx/dx
% (co2(2,2) - co2(2,1))/dt(1) - D*(co2(3,2) - 2*co2(2,2) + co2(1,2))/dx/0.5*365*24*60*60/0.001/0.2
% 
% D*(co2(2,1) - co2(1,1))/0.5*365*24*60*60/0.001/0.2
% 
% for j = 1:1:dimension(2)-1
%     P(1,j) = (co2(2,j+1) - co2(2,j))/dt - D*(co2(3,j) - co2(2,j) + co2(3,j+1) - co2(2,j+1))/dx^2;
%     P(150,j) = (co2(199,j+1) - co2(200,j))/dt - D*(co2(199,j) - co2(200,j) + co2(199,j+1) - co2(200,j+1))/dx^2;
%     for i = 2:1:dimension(1)-1
%         P(i,j) = (co2(i+1,j+1) - co2(i+1,j))/dt - D*(1/(dx^2))*(co2(i+2,j+1) - 2*co2(i+1,j+1) + co2(i,j+1) + co2(i+2, j) - 2*co2(i+1,j) + co2(i,j)); %- P[i-1,j]
%     end
% end

% convert microbial production rates
prod = prod/(0.5*365*24*60*60/0.001/0.2); %change to mol/cm3/s

% correct for water amount in pore space - is this needed??
% for i = 1:dimension(1)
%     prod(i,:) = prod(i,:)*vwc(i,1);
% end

% calulate diffusivity given production and co2 content
for j = 1:dimension(2)-1
%    P(1,j) = (co2(2,j+1) - co2(2,j))/dt - D*(co2(3,j) - co2(2,j) + co2(3,j+1) - co2(2,j+1))/dx^2;
%    P(150,j) = (co2(199,j+1) - co2(200,j))/dt - D*(co2(199,j) - co2(200,j) + co2(199,j+1) - co2(200,j+1))/dx^2;
%%%%%%%%%    dif(1,j) = ((co2(2,j+1) - co2(2,j))/dt(j) - prod(i,j))/(0.5*(1/(0.5))*(co2(3,j+1) - 2*co2(2,j+1) + co2(1,j+1) + co2(3,j) - 2*co2(2,j) + co2(1,j))); %THIS LINE IS NOT RUNNING BECAUSE THERE IS AN i IN THE EQUATION THAT IS NOT SPECIFIED -- YUCHEN
    for i = 1:dimension(1)
        dif(i,j) = ((co2(i+1,j+1) - co2(i+1,j))/dt(j)-prod(i,j))/(0.5*(1/(dx^2))*(co2(i+2,j+1) - 2*co2(i+1,j+1) + co2(i,j+1) + co2(i+2,j) - 2*co2(i+1,j) + co2(i,j)));
    end
end

% calculate production given co2 and diffusivity (transient)
for j = 1:dimension(2)-1
%    P(1,j) = (co2(2,j+1) - co2(2,j))/dt - D*(co2(3,j) - co2(2,j) + co2(3,j+1) - co2(2,j+1))/dx^2;
%    P(150,j) = (co2(199,j+1) - co2(200,j))/dt - D*(co2(199,j) - co2(200,j) + co2(199,j+1) - co2(200,j+1))/dx^2;
%    P(1,j) = (co2(2,j+1) - co2(2,j))/dt(j) - D*0.5*(1/(0.5))*(co2(3,j+1) - 2*co2(2,j+1) + co2(1,j+1) + co2(3,j) - 2*co2(2,j) + co2(1,j));
    for i = 1:dimension(1)
        P(i,j) = (co2(i+1,j+1) - co2(i+1,j))/dt(j) - D*0.5*(1/(dx^2))*(co2(i+2,j+1) - 2*co2(i+1,j+1) + co2(i,j+1) + co2(i+2,j) - 2*co2(i+1,j) + co2(i,j)); %- P(i-1,j)
    end
end

% calculate production given co2 and diffusivity (steady-state)
for j = 1:dimension(2)-1
    P_steady(1,j) = D*(1/(0.5))*(co2(3,j) - 2*co2(2,j) + co2(1,j));
    for i = 1:dimension(1)
        P_steady(i,j) = D*(1/(dx^2))*(co2(i+2,j) - 2*co2(i+1,j) + co2(i,j)); %- P(i-1,j)
    end
end

% convert to mol/kg/yr w/ porosity correction
%P = P*365*24*60*60/0.001; %/0.2
%P_steady = P_steady*365*24*60*60/0.001; %/0.2

% normalize to actual soil moisture - is this needed?
% for i = 1:dimension(1)
%     P(i,:) = P(i,:)/vwc(i,1);
%     P_steady(i,:) = P_steady(i,:)/vwc(i,1);
% end
 
figure(2);
subplot(1,2,1);
ylim([1 155]);
%set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([155 1]) INSTEAD OF ylim([1 155]) ORIGINALLY -- YUCHEN
xlim([min(min(P)) max(max(P))]);
title({'Production D=',D});
for i = 1:dimension(2)-1
    plot(P(:,i),depths);
    hold on;
end
set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN

subplot(1,2,2);
ylim([1 155]);
%set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([155 1]) INSTEAD OF ylim([1 155]) ORIGINALLY -- YUCHEN
xlim([-1 max(max(P_steady))]);
title({'Production D=',D});
for i = 1:dimension(2)-1
    plot(P_steady(:,i),depths);
    hold on;
end
set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN

figure(3);
subplot(1,1,1);
ylim([1 155]);
%set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([155 1]) INSTEAD OF ylim([1 155]) ORIGINALLY -- YUCHEN
for i = 1:dimension(2)-1
    plot(dif(:,i),depths);
    hold on;
end
set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN

figure(4);
subplot(1,1,1);
ylim([1 150]);
%set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([150 1]) INSTEAD OF ylim([1 150]) ORIGINALLY -- YUCHEN
%xlim([min(min(prod)) max(max(prod))]);
for i = 1:dimension(2)
    plot(prod(:,i),depths);
    hold on;
end
set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN

% colors <- tim.colors(n = 150) %REDUNDENT -- YUCHEN
time = [0.5 1.0 1.5 2 2.5 3 3.5 4 4.5 5 20 25];
figure(5);
subplot(1,1,1);
ylim([0 27]);
for i = 1:dimension(1)
    plot(time,prod(i,:));
    hold on;
end

figure(6);
subplot(1,1,1);
ylim([1 400]);
%set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN
%xlim([min(min(prod)) max(max(prod))]);
title('Microbe Uptake');
temp = zeros(dimension(1),dimension(2)-1);
for i = 1:dimension(2)-1
    temp(:,i) = prod(:,i)-P(:,i);
    plot(temp(:,i),depths);
    hold on;
end
set(gca,'ydir','reverse'); %DON'T KNOW IF Y AXIS SHOULD BE REVERSED BECAUSE ylim([400 1]) INSTEAD OF ylim([1 400]) ORIGINALLY -- YUCHEN