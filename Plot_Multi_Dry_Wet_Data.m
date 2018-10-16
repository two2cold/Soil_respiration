%% Plotting the multi-dry-wet data
clear;

%% Read in data
workingDir = "~/Documents/CrunchTopeDistribute/BCtop 01042018/Multiple_Dry_Wet_cycle/Record.txt";
fileID = fopen(workingDir);
skipOneLine = fgets(fileID);
raw = textscan(fileID,'%f %f %f %f %f %f %f %f %f %f');

%% Plotting
plot(raw{1},raw{3}); hold on;
plot(raw{1},raw{4});