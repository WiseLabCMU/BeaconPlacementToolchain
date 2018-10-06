function [ ] = ShowClustersOfFloorPlan( FloorPlanPath )

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));

F_NewFig=1;
PlotFloorPlan(FloorPlanPath,F_NewFig,1);

for i = 1:size(ClustData,1)
    Pts=PtsInFp(ClustData{i,4},:);
    scatter(Pts(:,1),Pts(:,2));
    text(Pts(1,1),Pts(1,2),num2str(i));
end

title('Partition of floor plan based on ray-tracing');


end

