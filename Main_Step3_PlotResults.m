clc; clear; close all;
load RootPath.mat;
rng('default')
figure;F_NewFig=0;F_AddnBeac=1;
RepoNames = dir(fullfile(RootPath,'FloorPlanPaths','F*'));
for n = 1:numel(RepoNames)
    DisplayFloorPlanPath = fullfile(RootPath,'FloorPlanPaths',RepoNames(n).name);
    subplot(3,ceil(numel(RepoNames)/3),n);
    PlotFloorPlan(DisplayFloorPlanPath,F_NewFig,F_AddnBeac);                
    title([RepoNames(n).name]);
end

SelectFP = -1; Flag=0;
while (SelectFP==0 || ~Flag)
    SelectFP = input(['Select floor plan : F']);
    Flag = exist(fullfile(RootPath,'FloorPlanPaths',['F',num2str(SelectFP)]));
end

if Flag~=0 % floor plan selected
    FloorPlanPath = fullfile(RootPath,'FloorPlanPaths',['F',num2str(SelectFP)]);
end


PlotComparisonOfMultiplePlacements(FloorPlanPath);
figure(2); 
saveas(gcf,fullfile(FloorPlanPath,['F',num2str(SelectFP),'_Placements.jpg']));
saveas(gcf,fullfile(FloorPlanPath,['F',num2str(SelectFP),'_Placements.pdf']));
saveas(gcf,fullfile(FloorPlanPath,['F',num2str(SelectFP),'_Placements.fig']));

figure(3); 
saveas(gcf,fullfile(FloorPlanPath,['F',num2str(SelectFP),'_Performance.jpg']));
saveas(gcf,fullfile(FloorPlanPath,['F',num2str(SelectFP),'_Performance.pdf']));
saveas(gcf,fullfile(FloorPlanPath,['F',num2str(SelectFP),'_Performance.fig']));


