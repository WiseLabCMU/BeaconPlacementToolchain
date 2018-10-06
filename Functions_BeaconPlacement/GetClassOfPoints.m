function [ Class ] = GetClassOfPoints(PtsInFp_LosBeac,BeaconPos,FloorPlanPath)
% Class description
% 1: Nb>=3
% 2: Nb=2 and different beacons in LOS
% 3: Nb=2 and null set of beacons in LOS
% 4: Nb=2 and ambiguous (same set of beacons)
% 5: Nb=1
% 6: Nb=0

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','AmbPtData.mat'));

Class = -1*ones(size(PtsInFp_LosBeac,1),1);
NumBeaconsInLos = cell2mat(PtsInFp_LosBeac(:,1));
% zero beacons

Class(find(NumBeaconsInLos>=3))=1;
Class(find(NumBeaconsInLos==1))=5;
Class(find(NumBeaconsInLos==0))=6;

IndTwoBeacInLos = find(NumBeaconsInLos==2);
for i = 1:length(IndTwoBeacInLos)
    Ind = IndTwoBeacInLos(i);
    BeacInLos = PtsInFp_LosBeac{Ind,2};
    Point = PtsInFp(Ind,:);
    BeacCombAll = AmbPtData{Ind,1};
    BeacCombInd = find(all(ismember(BeacCombAll,BeacInLos),2));
    ReflPoint = AmbPtData{Ind,2}(BeacCombInd,[2 3]);
    ReflPointInd = AmbPtData{Ind,2}(BeacCombInd,1);
    if(~ReflPointInd) %outside floor plan
        Class(Ind)=3;
    else
        BeacLosReflPt = PtsInFp_LosBeac{ReflPointInd,2};
%         [BeacLosReflPt]
%         [ReflPoint]
%         [ReflPointInd]
%         [BeacInLos]
%         disp(',');
        if(isempty(ismember(BeacLosReflPt,BeacInLos)) || isempty(ismember(BeacLosReflPt,BeacInLos)))
            Class(Ind)=2; %other point has different (none) beacons in LOS 
        else 
            if(all(ismember(BeacLosReflPt,BeacInLos),2) && all(ismember(BeacInLos,BeacLosReflPt),2))
                if(Ind==ReflPointInd)
                    Class(Ind)=2; %ambiguous point is same as this
                else
                    Class(Ind)=4; %ambiguity
                end
            else
                Class(Ind)=2; %other point has diff beacons in LOS
            end
        end
    end
end    

end

