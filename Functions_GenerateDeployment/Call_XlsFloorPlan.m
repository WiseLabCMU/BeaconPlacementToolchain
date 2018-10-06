function [Corners, Obstacles] = Call_XlsFloorPlan(XlsFilePath)
% User defines a floor plan by placing cursor on corners

% load RootPath.mat;
% figure;
% FloorPlanPath = fullfile(RootPath,'FloorPlanPaths',NameFP);

Corners = xlsread(XlsFilePath);
x = Corners(:,1); y = Corners(:,2);
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
% 
% % First generate 5x the required pts within a bounding box surrounding the
% % polygon. Then check which points are within the poygon.
% RandPts = [min(x)+(max(x)-min(x))*rand(5*NumAddBeacLoc) min(y)+(max(y)-min(y))*rand(5*NumAddBeacLoc)];    
% [in,on] = inpolygon(RandPts(:,1),RandPts(:,2),x,y);
% RandPtsIn = find(in);
% AddnPotentialBeacLoc = RandPts(RandPtsIn(1:NumAddBeacLoc),:);
% %%----------------
% 
% save(fullfile(FloorPlanPath,'AddnPotentialBeacLoc.mat'),'AddnPotentialBeacLoc');
% 
% F_NewFig=1;
% PlotFloorPlan(FloorPlanPath,F_NewFig);
% hold on; scatter(AddnPotentialBeacLoc(:,1),AddnPotentialBeacLoc(:,2));

%disp('Generating visibility information for corners');
%MainRayTracing(FloorPlan_Path );







%disp('Floor plan saved');
