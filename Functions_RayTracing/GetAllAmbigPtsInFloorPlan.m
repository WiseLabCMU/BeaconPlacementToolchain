function [ RayTracingInfoCornerObs ] = GetAllAmbigPtsInFloorPlan(FloorPlanPath,F_SaveResToPath)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));

PtsInFp_LosBeac = cell(size(PtsInFp,1),1);
for n = 1:size(AllCornerObsPos,1)
    PtsInLos = PtsInFp(RayTracingInfoCornerObs{n},:);
    IndexPtsInLos = find(ismember(PtsInFp,PtsInLos,'rows'));
    %PlotFloorPlan(FloorPlanPath);
    %scatter(PtsInFp(IndexPtsInLos,1),PtsInFp(IndexPtsInLos,2));
    %scatter(BeaconPos(n,1),BeaconPos(n,2),150,'filled');
    for k = 1:length(IndexPtsInLos)
        PtsInFp_LosBeac{IndexPtsInLos(k),1}=[PtsInFp_LosBeac{IndexPtsInLos(k),1} n];
    end
end

% THIS ASSUMES THAT ALL POINTS ARE COVERED BY AT LEAST 2 BEACONS
for k= 1:size(PtsInFp,1)
    Point = PtsInFp(k,:);
    if numel(PtsInFp_LosBeac{k,1})>1
        CornerComb = nchoosek(PtsInFp_LosBeac{k,1},2);
        ReflPointInfo = zeros(size(CornerComb,1),3);
        for n = 1:size(CornerComb,1)
            %k
            %PtsInFp_LosBeac{k,1}
            %CornerComb
            C1 = AllCornerObsPos(CornerComb(n,1),:);
            C2 = AllCornerObsPos(CornerComb(n,2),:);
            Vect_u = C2-C1;
            Vect_n = [-Vect_u(2) Vect_u(1)];
            Vect_v = Point-C1;
            v_n = dot(Vect_v,Vect_n)/dot(Vect_n,Vect_n)*Vect_n;
            v_u = dot(Vect_v,Vect_u)/dot(Vect_u,Vect_u)*Vect_u;
            ReflPointInfo(n,[2 3]) = C1 + v_u - v_n;

            [inFloorPlanPoly,onFloorPlanPoly] = inpolygon(ReflPointInfo(n,2), ReflPointInfo(n,3), FloorPlanPoly(:,1), FloorPlanPoly(:,2));
            InFpStatus = inFloorPlanPoly & ~onFloorPlanPoly;
            if InFpStatus
                DistToAllPts=pdist2(ReflPointInfo(n,[2 3]),PtsInFp);
                [MinVal,MinInd]=min(DistToAllPts);
                ReflPointInfo(n,1) = MinInd;
            end
        end
        AmbPtData{k,1}=CornerComb;
        AmbPtData{k,2}=ReflPointInfo;
    else
        AmbPtData{k,1}=[];
        AmbPtData{k,2}=[];
    end
end


save(fullfile(FloorPlanPath,'RayTracing','AmbPtData.mat'),'AmbPtData');
