function [PtsInFp] = GetAllPointsInFloorPlan(FloorPlanPath,GridSize,F_SaveResToPath,AddnPotentialBeacLoc)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
% load(fullfile(FloorPlanDataPath,'Corners.mat'));
% load(fullfile(FloorPlanDataPath,'Obstacles.mat'));
% load(fullfile(FloorPlanDataPath,'AddnPotentialBeacLoc.mat'));

% all the points inside the Area defined by the Corners and excluding the points
%inside the obstacle Corners.
    
    xMin = min(Corners(:,1))-GridSize/2;
    xMax = max(Corners(:,1))+GridSize/2;
    yMin = min(Corners(:,2))-GridSize/2;
    yMax = max(Corners(:,2))+GridSize/2;

    [AllPtsInGridX,AllPtsInGridY]=meshgrid(xMin:GridSize:xMax,yMin:GridSize:yMax);
    
    AllPtsInGrid = [reshape(AllPtsInGridX,size(AllPtsInGridX,1)*size(AllPtsInGridX,2),1)...
    reshape(AllPtsInGridY,size(AllPtsInGridY,1)*size(AllPtsInGridY,2),1)];
    
    FloorPlanPoly = Corners;
    AllCornerObsPos = Corners(1:end-1,:);
    for ind = 1:size(Obstacles,2)
        FloorPlanPoly = [FloorPlanPoly; nan nan; Obstacles{1,ind}];
        AllCornerObsPos = [AllCornerObsPos; Obstacles{1,ind}(1:end-1,:)];
    end
    
    if(~isempty(AddnPotentialBeacLoc)) % If there are additional points for which ray tracing is to be done
        AllCornerObsPos = [AllCornerObsPos; AddnPotentialBeacLoc];
    end
    
    [inFloorPlanPoly,onFloorPlanPoly] = inpolygon(AllPtsInGrid(:,1), AllPtsInGrid(:,2), FloorPlanPoly(:,1), FloorPlanPoly(:,2));
    PtsInFpStatus = inFloorPlanPoly & ~onFloorPlanPoly;

    PtsInFp = AllPtsInGrid(PtsInFpStatus,:);
    
    if F_SaveResToPath==1
        save(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'),'PtsInFp','AllCornerObsPos','FloorPlanPoly','GridSize');
    end

end
                

    
    