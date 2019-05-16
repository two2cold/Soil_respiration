%% Apply an exponential decrease to soil moisture
clear;

%% Calculation
peakValue = 2; 
peakPosition = 0.6; 
intercept = 0;
RespRatePeak = @(WHC) -peakValue/peakPosition^2 * WHC^2 + 2*peakPosition*peakValue/peakPosition^2 * WHC + intercept;
precip = RandExp(60,20);
respList = zeros(1,length(precip));
b = -0.1;
for i=1:length(precip)
    for j=i:length(precip)
        respList(j) = respList(j) + RespRatePeak(precip(i))*exp(b*(j-i));
    end
end

%% Plotting
yyaxis left
bar(precip); hold on;
xlabel('Day in a year');
ylabel('Normalized precipitation');
yyaxis right
plot(respList,'LineWidth',2);
ylabel('Respiration rate');
set(gca,'fontsize',18);
set(gca, 'FontName', 'Times New Roman');
set(gca,'XColor','k');
set(gca,'YColor','k');
set(gca,'box','off');
