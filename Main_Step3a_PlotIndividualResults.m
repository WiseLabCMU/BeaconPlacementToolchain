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

BeacPlacementType = -1;
while (BeacPlacementType<0 || BeacPlacementType>5)
    BeacPlacementType = input(['1: Custom Placement \n2: UL algorithm \n3: GDOP algorithm \n4: e-net algorithm \n5: Submod algorithm\nEnter choice: ']);
end

PlotIndividualPlacement(FloorPlanPath,BeacPlacementType)
saveas(gcf,fullfile(FloorPlanPath,['D',num2str(BeacPlacementType)],'Placement.jpg'));
saveas(gcf,fullfile(FloorPlanPath,['D',num2str(BeacPlacementType)],'Placement.fig'));
saveas(gcf,fullfile(FloorPlanPath,['D',num2str(BeacPlacementType)],'Placement.pdf'));

