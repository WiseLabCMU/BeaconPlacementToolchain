function [Corners,Obstacles] = Call_RandomFloorPlan(NumVertex)
% User defines a floor plan by placing cursor on corners

% load RootPath.mat;
% figure;
% FloorPlanPath = fullfile(RootPath,'FloorPlanPaths',NameFP);
% xlim([0 10]); ylim([0 10]);

[x, y, dt] = simple_polygon(NumVertex);

Corners = [x*5 y*5];
Obstacles = [];

% if exist(FloorPlanPath)
%     rmdir(FloorPlan_Path,'s');
% end
% 
% mkdir(FloorPlanPath);
% 
% save(fullfile(FloorPlanPath,'Corners.mat'),'Corners');
% save(fullfile(FloorPlanPath,'Obstacles.mat'),'Obstacles');
% 
% AddnPotentialBeacLoc = PlaceAddnBeac(FloorPlan_Path);
% 
% save(fullfile(FloorPlanPath,'AddnPotentialBeacLoc.mat'),'AddnPotentialBeacLoc');
% 
% F_NewFig=1;
% PlotFloorPlan(FloorPlanPath,F_NewFig);
% hold on; scatter(AddnPotentialBeacLoc(:,1),AddnPotentialBeacLoc(:,2));
