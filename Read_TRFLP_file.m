%% Read text file
clear;

%% Read in file
workingDir = "~/Documents/Works/TRFLP data/Yuchen_fungi_09062018.TXT";
fileID = fopen(workingDir);
skipOneLine = fgets(fileID);
raw = textscan(fileID,'%s %s %f %d %d %d');

%% Data processing
data = cell(1,6);
dummy1 = 1;
dummy2 = 0;
dummy_bool = true;
for i=1:length(raw{1})
    if raw{6}(i)==0
        dummy1 = 1;
        if dummy_bool
            dummy2 = dummy2 + 1;
            dummy_bool = false;
        end
        continue;
    end
    dummy_bool = true;
    data{dummy2}(dummy1,1) = raw{3}(i);
    data{dummy2}(dummy1,2) = raw{4}(i);
    dummy1 = dummy1 + 1;
end

%% Plotting 
for i=1:6
    figure;
    plot(data{i}(:,1),data{i}(:,2),'LineWidth',2); hold on;
%     xlim([50 400]);
    xlim([450 1000]);
    xlabel('Mass','FontSize',22);
    ylabel('Peak height','FontSize',22);
    set(gca,'fontsize',22);
    set(gca,'FontName','Times New Roman');
    set(gca,'XColor','k');
    set(gca,'YColor','k');
    set(gca,'box','off');
end