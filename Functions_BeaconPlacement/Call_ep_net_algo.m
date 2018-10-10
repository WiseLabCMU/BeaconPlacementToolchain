% Haotian Modifed the definition of this function. Add 'Number' and
% 'BeaconWeight' as input parameter.
% Number: How many beacons we need to choose.
% BeaconWeight: Each beacon has its own weight. Their chosen probability is
% based on their weight.
function [] = Call_ep_net_algo(FloorPlanPath, BeacPlacementName,Number, BeaconWeight)

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));

% User defines a floor plan by placing cursor on corners

% I ignore the following part, because it receive the position of mouse and
% find the cloest beacon.

% F_NewFig=1;
% PlotFloorPlan(FloorPlan_Path,F_NewFig);

%PlotCorners(Corners);
%for m = 1:size(Obstacles,2)
%    obs = Obstacles{m};
%    if(~isempty(obs))
%    fill(obs(:,1),obs(:,2),[0.8 0.8 0.8]);
%    end
%New Comment
%    hold on;scatter(AllCornerObsPos(:,1),AllCornerObsPos(:,2),50,'MarkerEdgeColor','b','MarkerFaceColor',[0 0 0.2],'LineWidth',2);

    %
%end

% xlim([min(Corners(:,1))-0.5 max(Corners(:,1))+0.5]);
% ylim([min(Corners(:,2))-0.5 max(Corners(:,2))+0.5]);
% %ylim([0 10]);
% title('Beacon Placement: Click on corners. Press space when done.');
% set(gca,'FontSize',14);

% [x,y,button] = ginput(1);
% scatter(x,y,100,'rx');hold on;
% DistToCorners = pdist2([x y],AllCornerObsPos);
% [minval,minindx]=min(DistToCorners);
% ClosestCorner = AllCornerObsPos(minindx,:);
% scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;

% set(gca,'FontSize',14);
% 
% CursorPts = ClosestCorner;
% NumPts = 1;

% while button ~=32 % until space key is pressed
%     [x,y,button] = ginput(1);
%     scatter(x,y,100,'rx');hold on;
%     DistToCorners = pdist2([x y],AllCornerObsPos);
%     [minval,minindx]=min(DistToCorners);
%     ClosestCorner = AllCornerObsPos(minindx,:);
%     scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;
%     CursorPts = [CursorPts; ClosestCorner];
% end

% Last point is the Space from keyboard - remove it
% CursorPts = CursorPts(1:end-1,:);
% NumPts = NumPts-1;

% Haotian Modified Part Begin:

% Index: Index for all potential beacon locations
Index = 1:size(AllCornerObsPos,1);
% WeightSum: Total weight of all the beacons.
% WeightSum = 0;
% for i=1:length(BeaconWeight)
%     WeightSum = WeightSum + BeaconWeight(i);
% end
% Compute their possibility.
% for i=1:length(BeaconWeight)
%     Possbility(i) = BeaconWeight(i) / WeightSum;
% end

CursorPts = [];

% make their possiblity distributed in [0,1].
% for i=2:length(BeaconWeight)
%     Possbility(i) = Possbility(i-1) + Possbility(i);
% end
% ChosenIndex: Index of chosen beacons
x = AllCornerObsPos(:, 1);
y = AllCornerObsPos(:, 2);
ChosenIndex = [];
BeaconNum = length(BeaconWeight);
i=1;
c=fix(sum(clock));
rand('state', c);
% Random sampling: Choose the beacons based on their possibibility.
while i<=Number
    WeightSum = 0;
    for j=1:BeaconNum
        WeightSum = WeightSum + BeaconWeight(j);
    end
    
    for j=1:BeaconNum
        Possibility(j) = BeaconWeight(j) / WeightSum;
    end
    
    for j=2:BeaconNum
        Possibility(j) = Possibility(j-1) + Possibility(j); 
    end

    temp=rand();
    if ((temp <= Possibility(1)))
        ChosenIndex = [ChosenIndex, 1];
        BeaconWeight(1) = 0;
        i = i + 1;
        CurX = x(1);
        CurY = y(1);
        DistArray = [];
        for k = 1: size(x)
            Dist = (CurX - x(k))^2 + (CurY - y(k))^2;
            Dist = log2(Dist);
            Item = [Dist, k];
            DistArray = [DistArray; Item];
        end
        DistArray = sortrows(DistArray,1);
        LargestD = DistArray(size(x),1);
        ReduceNumber =  size(x)/ 10;
        for k = 1: ReduceNumber
            if (DistArray(k+1, 1) < LargestD/5)
                BeaconWeight(DistArray(k+1,2)) = BeaconWeight(DistArray(k+1,2)) * 0.7;
            end
        end
        continue;
    end
    for j=2:length(BeaconWeight)
        if ((temp > Possibility(j-1)) && (temp <= Possibility(j)))
            ChosenIndex = [ChosenIndex, j];
            BeaconWeight(j) = 0;
            i = i+1;
            CurX = x(j);
            CurY = y(j);
            LargestD = 0;
            DistArray = [];
            for k = 1: size(x)
                Dist = (CurX - x(k))^2 + (CurY - y(k))^2;
                Dist = log2(Dist);
                Item = [Dist, k];
                DistArray = [DistArray; Item];
            end
            DistArray = sortrows(DistArray,1);
            ReduceNumber =  size(x)/ 10;
            LargestD = DistArray(size(x),1);
            for k = 1: ReduceNumber
                if (DistArray(k+1, 1) < LargestD/5)
                BeaconWeight(DistArray(k+1,2)) = BeaconWeight(DistArray(k+1,2)) * 0.7;
                end
            end
            break;
        end
    end
end
       

% ChosenIndex = randsrc(1, Number, [Index; Possbility]);
% while (length(unique(ChosenIndex)) < length(ChosenIndex))
%     c=fix(sum(clock));
%     rand('state', c);
%     ChosenIndex = randsrc(1, Number, [Index; Possbility]);
% end
i=1;
%display(ChosenIndex);
% Accroding to ChosenIndex, we find these points.
while i<=Number
    ClosestCorner = AllCornerObsPos(ChosenIndex(i),:);
    CursorPts = [CursorPts; ClosestCorner];
    i = i+1;
end

% Haotian Modified Part End.

%display(CursorPts);
BeaconPos = CursorPts;
[~,BeaconPlaceInd]=ismember(BeaconPos,AllCornerObsPos,'rows');
save(fullfile(FloorPlanPath,BeacPlacementName,'BeaconPlaceInd.mat'),'BeaconPlaceInd');
%save([Output_BeaconPlacement_Path,'Corners.mat'],'Corners');



% % Haotian Modifed the definition of this function. Add 'Number' and
% % 'BeaconWeight' as input parameter.
% % Number: How many beacons we need to choose.
% % BeaconWeight: Each beacon has its own weight. Their chosen probability is
% % based on their weight.
% function [] = Call_ep_net_algo(FloorPlanPath, BeacPlacementName,Number, BeaconWeight)
% 
% load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
% load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
% load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
% load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));
% 
% % User defines a floor plan by placing cursor on corners
% 
% % I ignore the following part, because it receive the position of mouse and
% % find the cloest beacon.
% 
% % F_NewFig=1;
% % PlotFloorPlan(FloorPlan_Path,F_NewFig);
% 
% %PlotCorners(Corners);
% %for m = 1:size(Obstacles,2)
% %    obs = Obstacles{m};
% %    if(~isempty(obs))
% %    fill(obs(:,1),obs(:,2),[0.8 0.8 0.8]);
% %    end
% %New Comment
% %    hold on;scatter(AllCornerObsPos(:,1),AllCornerObsPos(:,2),50,'MarkerEdgeColor','b','MarkerFaceColor',[0 0 0.2],'LineWidth',2);
% 
%     %
% %end
% 
% % xlim([min(Corners(:,1))-0.5 max(Corners(:,1))+0.5]);
% % ylim([min(Corners(:,2))-0.5 max(Corners(:,2))+0.5]);
% % %ylim([0 10]);
% % title('Beacon Placement: Click on corners. Press space when done.');
% % set(gca,'FontSize',14);
% 
% % [x,y,button] = ginput(1);
% % scatter(x,y,100,'rx');hold on;
% % DistToCorners = pdist2([x y],AllCornerObsPos);
% % [minval,minindx]=min(DistToCorners);
% % ClosestCorner = AllCornerObsPos(minindx,:);
% % scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;
% 
% % set(gca,'FontSize',14);
% % 
% % CursorPts = ClosestCorner;
% % NumPts = 1;
% 
% % while button ~=32 % until space key is pressed
% %     [x,y,button] = ginput(1);
% %     scatter(x,y,100,'rx');hold on;
% %     DistToCorners = pdist2([x y],AllCornerObsPos);
% %     [minval,minindx]=min(DistToCorners);
% %     ClosestCorner = AllCornerObsPos(minindx,:);
% %     scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;
% %     CursorPts = [CursorPts; ClosestCorner];
% % end
% 
% % Last point is the Space from keyboard - remove it
% % CursorPts = CursorPts(1:end-1,:);
% % NumPts = NumPts-1;
% 
% % Haotian Modified Part Begin:
% 
% % Index: Index for all potential beacon locations
% Index = 1:size(AllCornerObsPos,1);
% % WeightSum: Total weight of all the beacons.
% % WeightSum = 0;
% % for i=1:length(BeaconWeight)
% %     WeightSum = WeightSum + BeaconWeight(i);
% % end
% % Compute their possibility.
% % for i=1:length(BeaconWeight)
% %     Possbility(i) = BeaconWeight(i) / WeightSum;
% % end
% 
% CursorPts = [];
% 
% % make their possiblity distributed in [0,1].
% % for i=2:length(BeaconWeight)
% %     Possbility(i) = Possbility(i-1) + Possbility(i);
% % end
% % ChosenIndex: Index of chosen beacons
% ChosenIndex = [];
% BeaconNum = length(BeaconWeight);
% i=1;
% c=fix(sum(clock));
% rand('state', c);
% % Random sampling: Choose the beacons based on their possibibility.
% while i<=Number
%     WeightSum = 0;
%     for j=1:BeaconNum
%         WeightSum = WeightSum + BeaconWeight(j);
%     end
%     
%     for j=1:BeaconNum
%         Possibility(j) = BeaconWeight(j) / WeightSum;
%     end
%     
%     for j=2:BeaconNum
%         Possibility(j) = Possibility(j-1) + Possibility(j); 
%     end
% 
%     temp=rand();
%     if ((temp <= Possibility(1)))
%         ChosenIndex = [ChosenIndex, 1];
%         BeaconWeight(1) = 0;
%         i = i + 1;
%         continue;
%     end
%     for j=2:length(BeaconWeight)
%         if ((temp > Possibility(j-1)) && (temp <= Possibility(j)))
%             ChosenIndex = [ChosenIndex, j];
%             BeaconWeight(j) = 0;
%             i = i+1;
%             break;
%         end
%     end
% end
%        
% 
% % ChosenIndex = randsrc(1, Number, [Index; Possbility]);
% % while (length(unique(ChosenIndex)) < length(ChosenIndex))
% %     c=fix(sum(clock));
% %     rand('state', c);
% %     ChosenIndex = randsrc(1, Number, [Index; Possbility]);
% % end
% i=1;
% %display(ChosenIndex);
% % Accroding to ChosenIndex, we find these points.
% while i<=Number
%     ClosestCorner = AllCornerObsPos(ChosenIndex(i),:);
%     CursorPts = [CursorPts; ClosestCorner];
%     i = i+1;
% end
% 
% % Haotian Modified Part End.
% 
% %display(CursorPts);
% BeaconPos = CursorPts;
% [~,BeaconPlaceInd]=ismember(BeaconPos,AllCornerObsPos,'rows');
% save(fullfile(FloorPlanPath,BeacPlacementName,'BeaconPlaceInd.mat'),'BeaconPlaceInd');
% %save([Output_BeaconPlacement_Path,'Corners.mat'],'Corners');
% 
