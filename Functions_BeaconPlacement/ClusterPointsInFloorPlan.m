function [ClustData, ClustCnt]=ClusterPointsInFloorPlan(FloorPlanPath,F_NewFig)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));

% Status of where or not a point has been assigned to a cluster
F_ClustStat = zeros(size(PtsInFp,1),1);

% As the clustering proceeds, ClustCnt increments and holds the count of
% current cluster
ClustCnt=1;

%PlotFloorPlan(FloorPlanPath,F_NewFig);

while ~all(F_ClustStat) %while any Flag=0 (while not all points clustered), repeat
    IndNotClust = find(~F_ClustStat,1,'first'); % Find first point not yet clustered
    CornerInLosInd = RayTracingInfoPtsInFp{IndNotClust}; %Index of corners in LOS with this point
    
    % IntersectInd will hold indices of all the points in LOS of exactly
    % these corners. Initialize it with points in LOS of first corner
    IntersectInd =RayTracingInfoCornerObs{CornerInLosInd(1)}; %
    for c = 2:size(CornerInLosInd,2) % For all corners in LOS of this point
        IntersectInd=intersect(IntersectInd,RayTracingInfoCornerObs{CornerInLosInd(c)});
        % Find intersection all the points in LOS of all these corners
    end
    
    % Find intersection with all the points NOT in LOS of all these corners
    % Elements in [1:size(AllCornerObsPos,1)]that are not in CornerInLos
    CornerNotInLosInd = setdiff([1:size(AllCornerObsPos,1)],CornerInLosInd); 
    for c = 1:size(CornerNotInLosInd,2) % For all corners not in LOS of this point
    %   Elements in IntersectInd that are not in [LOS of CornerNotInLos(c)]
        IntersectInd=setdiff(IntersectInd,RayTracingInfoCornerObs{CornerNotInLosInd(c)});
    end
    %ClusterNum(IntersectInd) = ClustCnt; %assign cluster number
    F_ClustStat(IntersectInd) = 1;% Flag = 1 indicates point is clustered
    
    %PlotFloorPlan(FloorPlanPath);
    %scatter(AllCornerObsPos(CornerInLos,1),AllCornerObsPos(CornerInLos,2),150,'filled');
    %scatter(PtsInFp(IntersectInd,1),PtsInFp(IntersectInd,2),'*');
    
    % ClustData holds [Number of corners in LOS, Number of points in cluster, ...
    % Indices of corners in LOS, Indices of points in the cluster]
    ClustData{ClustCnt,1} = length(CornerInLosInd);
    ClustData{ClustCnt,2} = length(IntersectInd);
    ClustData{ClustCnt,3} = CornerInLosInd;
    ClustData{ClustCnt,4} = IntersectInd;
    ClustData{ClustCnt,5} = 0; %Flag to indicate if non zero beacons in LOS
    ClustCnt=ClustCnt+1;
end

% Arrange clusters in descreasing order of size
[~,Ind]=sort(cell2mat(ClustData(:,2)),'descend'); %Sort by cluster size
ClustData=ClustData(Ind,:);

save(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'),'ClustData');

end