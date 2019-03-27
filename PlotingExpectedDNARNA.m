%% Plot expected result for the next incubation
clear;

%% Random number generator
gramOfSoil = [0.4 0.6 0.8 1];
DNA = [1.9+rand(1)/5,2.875+rand(1)/4,3.75+rand(1)/2,4.5+rand(1)];
RNA = [1.9+rand(1)/5,2.875+rand(1)/4,3.75+rand(1)/2,4.5+rand(1)]/3;
paramDNA = FitLinear(gramOfSoil,DNA);
paramRNA = FitLinear(gramOfSoil,RNA);

%% Plotting
SPlot({gramOfSoil,DNA,'r*'}); hold on;
SPlot({gramOfSoil,RNA,'b*'});
SPlot({gramOfSoil,paramDNA(2)*gramOfSoil+paramDNA(1),'r'});
SPlot({gramOfSoil,paramRNA(2)*gramOfSoil+paramRNA(1),'b'});
xlabel('Grams of soil used (g)');
ylabel('Expected Qubit result (ng/ul)');