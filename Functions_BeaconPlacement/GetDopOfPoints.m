function [ DOP,DOP_UL ] = GetDopOfPoints(PtsInFp_LosBeac,Class,FloorPlanPath)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','AmbPtData.mat'));

DOP = -1*ones(size(PtsInFp_LosBeac,1),1);
NumBeaconsInLos = cell2mat(PtsInFp_LosBeac(:,1));
% zero beacons

DOP(find(NumBeaconsInLos<2))=nan;

IndTwoBeacInLos = find(NumBeaconsInLos>=2);
for i = 1:length(IndTwoBeacInLos)
    Ind = IndTwoBeacInLos(i);
    BeacInLos = PtsInFp_LosBeac{Ind,2};
    BeacInLosPos = AllCornerObsPos(BeacInLos,:);
    Point = PtsInFp(Ind,:);
    
    Nb = size(BeacInLos,2);
    X=Point(1); Y=Point(2);
    ang_val = [];
    for n = 1:Nb
        ang_val(n) = mod(atan2(BeacInLosPos(n,2)-Y,BeacInLosPos(n,1)-X),2*pi);
    end
    
    SumAijSq=0;
    for n = 1:Nb-1
        for m = n+1:Nb
            SumAijSq = SumAijSq+(abs(sin(ang_val(n)-ang_val(m)))).^2;
        end
    end
    DOP(Ind) = sqrt(Nb/SumAijSq);
end   

DOP_UL = DOP;
IndAmbig = find(Class==4);
DOP_UL(IndAmbig) = nan;



end

