function [] = MainRayTracing(FloorPlanPath )

F_SaveResToPath = 1;
F_Plot = 0;

GridSize = 0.2;

PlotFloorPlan(FloorPlanPath,F_Plot,1);
GetAllPointsInFloorPlan(FloorPlanPath,GridSize,F_SaveResToPath,[]);
RayTracingAllCornerObs(FloorPlanPath,F_SaveResToPath);
PlotRayTracingAllCorners(FloorPlanPath); %PlotRayTracingRandomPts(FloorPlanPath)
GetAllAmbigPtsInFloorPlan(FloorPlanPath);
[ClustData, ClustCnt]=ClusterPointsInFloorPlan(FloorPlanPath,0);
ShowClustersOfFloorPlan(FloorPlanPath);


end

