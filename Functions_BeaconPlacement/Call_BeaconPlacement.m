function Call_BeaconPlacement(FloorPlanPath, BeacPlacementName)

if strcmp(BeacPlacementName,'D2')==1
    COMPARE_METRIC = 'U';
else
    COMPARE_METRIC = 'D';
end
% Results are stored in StoreClassDOPAll
% If N beacons are placed, size(StoreClassDOPAll) = [N,4]
% Description of columns are
% Index of beacon placed, BeaconPlaceInd(end);
% Class of all points in FP
% DOP of all points in FP
% DOP_UL of all points in FP

%COMPARE_METRIC = 'D';
DOP_MAX = Inf;
PercentArea = 1;%0.9%0.9;

%load RootPath.mat; load CurrentFloorPlan.mat;
%FloorPlan_Path = fullfile(RootPath,'FloorPlanPaths',CurrentFloorPlan);

%disp('Generating visibility information for corners');
%MainRayTracing(FloorPlan_Path );

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));

F_NewFig=1;

BeaconPlaceInd=[];
F_CriteriaSatistied=0;
while (~F_CriteriaSatistied) % repeat while not all clusters localized
    IndClust = 1; % The first cluster that is not yet localized - clusters are sorted by size
    CornerInLosInd = ClustData{IndClust,3}; % Corners in LOS of the cluster
    CornerInLos = AllCornerObsPos(CornerInLosInd,:); % Coordinates of corner
    
    %     % Plot the floor plan with the points in the largest cluster and the beacons in LOS
    %     PlotFloorPlan(FloorPlan_Path);
    %     for c=1:size(ClustData,1)
    %         Pts=PtsInFp(ClustData{c,4},:);
    %         scatter(Pts(:,1),Pts(:,2),'c');
    %     end
    %     Pts=PtsInFp(ClustData{IndClust,4},:);
    %     scatter(Pts(:,1),Pts(:,2),'r');
    %     scatter(CornerInLos(:,1),CornerInLos(:,2),150,'filled');
    
    
    % Check number of beacons in LOS of cluster since different action to
    % be taken for 0 beacons and non-zero beacons
    
    if(ClustData{IndClust,5}==0) % the cluster is not covered by any beacons yet
        % Find interbeacon ranges
        if COMPARE_METRIC =='D'
            InterBeacRange = pdist2(CornerInLos,CornerInLos);
            SumDist = sum(InterBeacRange);
            [~,MaxInd] = max(SumDist); % beacon with maximum distance from other beacons of the cluster
            SelectedBeaconInd = CornerInLosInd(MaxInd);
        else % COMPARE_METRIC=='U'
            Coverage=[];
            for m=1:length(CornerInLosInd)
                PtsInLosOfBeac = RayTracingInfoCornerObs{CornerInLosInd(m)};
                Coverage(m) = length(PtsInLosOfBeac);
            end
            [~,maxCoverageInd] = max(Coverage);
            SelectedBeaconInd = CornerInLosInd(maxCoverageInd);
        end
        
    else % at least one beacon already present
        for i = 1:size(CornerInLosInd,1)
            PotentialBeacLoc = setdiff(CornerInLosInd,BeaconPlaceInd)';
            %Corners in LOS except where beacons already placed
            StoreDOP=[]; StoreDOP_UL=[];
            
            % For each configuration, get the coverage class and the DOP of
            % points
            for config = 1:length(PotentialBeacLoc)
                BeaconInd = [BeaconPlaceInd; PotentialBeacLoc(config)];
                % for every potential beacon location
                % add it to the placed beacons and check the coverage/dop etc
                BeaconPos = AllCornerObsPos(BeaconInd,:);
                BeaconCoverage = RayTracingInfoCornerObs(BeaconInd);
                PtsInFp_LosBeac = cell(size(PtsInFp,1),2);
                for nB = 1:length(BeaconInd)
                    PtsInLos = PtsInFp(BeaconCoverage{nB},:);
                    IndexPtsInLos = find(ismember(PtsInFp,PtsInLos,'rows'));
                    for k = 1:length(IndexPtsInLos)
                        PtsInFp_LosBeac{IndexPtsInLos(k),2}=[PtsInFp_LosBeac{IndexPtsInLos(k),2} BeaconInd(nB)];
                    end
                end
                
                for k = 1:size(PtsInFp,1)
                    PtsInFp_LosBeac{k,1}=size(PtsInFp_LosBeac{k,2},2);
                end
                
                ClassTemp=GetClassOfPoints(PtsInFp_LosBeac,BeaconPos,FloorPlanPath);
                StoreClass(:,config) = ClassTemp;
                %PlotCoverageClass( BeaconPos,ClassTemp,FloorPlan_Path,F_color );
                
                if COMPARE_METRIC=='D'
                    [DOP,DOP_UL]=GetDopOfPoints(PtsInFp_LosBeac,ClassTemp,FloorPlanPath);
                    F_color=1;
                    %PlotDOPforBeaconPlacement(BeaconPos,DOP_UL,FloorPlan_Path);
                    StoreDOP(:,config) = DOP; StoreDOP_UL(:,config) = DOP_UL;
                end
                
            end
            
            if(COMPARE_METRIC == 'U')
                SizeUL=[];
                for w=1:size(StoreClass,2)
                    SizeUL(w) = length(find(StoreClass(:,w)<=3));
                    %SizeUL(w)=length(find(~isnan(StoreDOP_UL(:,w))));
                end
                [MaxULSize,~] = max(SizeUL);
                MaxULSizeInd = find(SizeUL==MaxULSize); %All indices that have max value
                if(length(MaxULSizeInd)>1) %More than one have same UL area
                    Coverage=[];
                    for m=1:length(MaxULSizeInd)
                        %m
                        %MaxULSizeInd(m)
                        %PotentialBeacLoc(MaxULSizeInd(m))
                        %RayTracingInfoCornerObs{PotentialBeacLoc(MaxULSizeInd(m))}
                        PtsInLosOfBeac = RayTracingInfoCornerObs{PotentialBeacLoc(MaxULSizeInd(m))};
                        Coverage(m) = length(PtsInLosOfBeac);
                    end
                    [~,maxCoverageInd] = max(Coverage);
                    SelectedBeaconInd = PotentialBeacLoc(MaxULSizeInd(maxCoverageInd));
                else
                    SelectedBeaconInd = PotentialBeacLoc(MaxULSizeInd);
                end
                
            else % COMPARE_METRIC == 'D'
                F_plot = 0;
                Area=CompareAndPlotCdfDop(StoreDOP_UL,F_plot);
                [~,maxAreaInd] = max(sum(Area));
                SelectedBeaconInd = PotentialBeacLoc(maxAreaInd);
            end
        end
    end
    BeaconPlaceInd = [BeaconPlaceInd; SelectedBeaconInd];
    
    %PlotFloorPlan(FloorPlan_Path);
    
    %scatter(AllCornerObsPos(SelectedBeaconInd,1),...
    %    AllCornerObsPos(SelectedBeaconInd,2),150,'filled');
    
    BeaconPos = AllCornerObsPos(BeaconPlaceInd,:);
    BeaconCoverage = RayTracingInfoCornerObs(BeaconPlaceInd);
    PtsInFp_LosBeac = cell(size(PtsInFp,1),2);
    for nB = 1:size(BeaconPlaceInd,1)
        PtsInLos = PtsInFp(BeaconCoverage{nB},:);
        IndexPtsInLos = find(ismember(PtsInFp,PtsInLos,'rows'));
        for k = 1:length(IndexPtsInLos)
            PtsInFp_LosBeac{IndexPtsInLos(k),2}=[PtsInFp_LosBeac{IndexPtsInLos(k),2} BeaconPlaceInd(nB)];
        end
    end
    
    for k = 1:size(PtsInFp,1)
        PtsInFp_LosBeac{k,1}=size(PtsInFp_LosBeac{k,2},2);
    end
    
    Class=GetClassOfPoints(PtsInFp_LosBeac,BeaconPos,FloorPlanPath);
    %F_color=1;
    %figure;subplot(1,2,1);
    %PlotCoverageClass( BeaconPos,Class,FloorPlan_Path,F_color,0 );
    %title([num2str(length(BeaconPlaceInd)),' Beacon placed']);
    [DOP,DOP_UL]=GetDopOfPoints(PtsInFp_LosBeac,Class,FloorPlanPath);
    %subplot(1,2,2);PlotDOPforBeaconPlacement(BeaconPos,DOP_UL,FloorPlan_Path,0);
    %title([num2str(length(BeaconPlaceInd)),' Beacon placed']);
    
    % For each cluster
    RemoveFromClustInd = [];
    
    %PlotFloorPlan(FloorPlan_Path);
    for c = 1:size(ClustData,1)
        % If new beacon placed is in LOS, make F_NonZeroBeacForClust=1
        CornerInLosInd = ClustData{c,3};
        if ismember(SelectedBeaconInd,CornerInLosInd)
            ClustData{c,5}= 1;
        end
        
        % Check UL status of all points
        IndPtsInCluster = ClustData{c,4};
        ClassOfPts = Class(IndPtsInCluster);
        DopULOfPts = DOP_UL(IndPtsInCluster);
        % If objective is to uniquely localize, status of a cluster is
        % determined by whether or not it is uniquely localized
        
        if COMPARE_METRIC =='U'
            UniqueLocalStat = ClassOfPts<=3; % If class less than 3, localized
        else
            UniqueLocalStat = ClassOfPts<=3; % If class less than 3, localized
            %UniqueLocalStat = DopULOfPts<DOP_MAX;
        end
        
        if(all(UniqueLocalStat)) % all localized - this cluster can be removed
            RemoveFromClustInd = [RemoveFromClustInd c];
            Q=ClustData{c,4};
            %hold on; scatter(PtsInFp(Q,1),PtsInFp(Q,2));
            %title('These points got localized');
        elseif ~any(UniqueLocalStat) % none localized - do nothing
            ;
        else % some localized, some not
            IndLoc = find(UniqueLocalStat);
            Q=ClustData{c,4};
            %hold on; scatter(PtsInFp(Q(IndLoc),1),PtsInFp(Q(IndLoc),2));
            %title('These points got localized');
            
            % cluster to be split and replaced by the points in the cluster not localized
            IndNotLoc = find(~UniqueLocalStat);
            ClustData{c,4}=IndPtsInCluster(IndNotLoc);
            ClustData{c,2}=length(IndPtsInCluster(IndNotLoc));
            
        end
    end
    ClustData(RemoveFromClustInd,:)=[]; % Remove points that are localized
    % Arrange clusters in descreasing order of size
    [~,Ind]=sort(cell2mat(ClustData(:,2)),'descend'); %Sort by cluster size
    ClustData=ClustData(Ind,:);
    
    
    if(isempty(ClustData))
        F_CriteriaSatistied=1;
    end
    %     if COMPARE_METRIC == 'D'
    %         D = sort(DOP_UL,'ascend');
    %         if D(round(PercentArea*size(D,1)))<DOP_MAX
    %             F_CriteriaSatistied=1;
    %         end
    %     else
    %         if(isempty(ClustData))
    %             F_CriteriaSatistied=1;
    %         end
    %     end
    
    Class=GetClassOfPoints(PtsInFp_LosBeac,BeaconPos,FloorPlanPath);
    [DOP,DOP_UL]=GetDopOfPoints(PtsInFp_LosBeac,Class,FloorPlanPath);
    
    StoreClassDOPAll{length(BeaconPlaceInd),1} = BeaconPlaceInd(end);
    StoreClassDOPAll{length(BeaconPlaceInd),2} = Class;
    StoreClassDOPAll{length(BeaconPlaceInd),3} = DOP;
    StoreClassDOPAll{length(BeaconPlaceInd),4} = DOP_UL;
    
end


%F_color=1;
% Class = StoreClassDOPAll{end,2};
% DOP = StoreClassDOPAll{end,3};
% DOP_UL = StoreClassDOPAll{end,4};
% figure;subplot(1,2,1);
% PlotCoverageClass( BeaconPos,Class,FloorPlan_Path,F_color,0 );
% title(['Final Coverage (Mode: ',COMPARE_METRIC,')']);
% subplot(1,2,2);PlotDOPforBeaconPlacement(BeaconPos,DOP_UL,FloorPlan_Path,0);
% title(['Final GDOP ']);


%ResultFolderName = 'BeacPlcmntResults';
%if ~exist(fullfile(FloorPlan_Path,ResultFolderName))
%  mkdir(fullfile(FloorPlan_Path,ResultFolderName));
%end
% if ~exist(fullfile(FloorPlan_Path,'BeacPlacement_U'))
%   mkdir(fullfile(FloorPlan_Path,'BeacPlacement_U'));
% end
% if ~exist(fullfile(FloorPlan_Path,'BeacPlacement_D'))
%   mkdir(fullfile(FloorPlan_Path,'BeacPlacement_D'));
% end
% ResultPath = fullfile(FloorPlan_Path,ResultFolderName);

ResultPath = fullfile(FloorPlanPath,BeacPlacementName);

save(fullfile(ResultPath,'BeaconPlaceInd.mat'),'BeaconPlaceInd');
save(fullfile(ResultPath,'StoreClassDOPAll.mat'),'StoreClassDOPAll');
FinalPlacementAndQuality = StoreClassDOPAll(end,:);
FinalPlacementAndQuality(1) = {cell2mat(StoreClassDOPAll(:,1))}; %Store the ind of all beacons
save(fullfile(ResultPath,'FinalPlacementAndQuality.mat'),'FinalPlacementAndQuality');

end


% for TriangulationColor=1:3;
%     [beaconPosPhaseWise,points_Cluster_all]=RunBeaconPlacement(TriangulationColor,...
%         Output_DesignFloorPlan_Path,...
%     [Output_BeaconPlacement_Path,'Color',num2str(TriangulationColor),'/']);
%     ComputeCoverageClass([Output_BeaconPlacement_Path,'Color',num2str(TriangulationColor),'/']);
% end
