function Call_BeaconPlacement_enet(FloorPlanPath, BeacPlacementName)

if strcmp(BeacPlacementName,'D2')==1
    COMPARE_METRIC = 'U';
else
    COMPARE_METRIC = 'D';
end

load(fullfile(FloorPlanPath,'FloorPlanOutline.mat'));
load(fullfile(FloorPlanPath,'RayTracing','FloorPlanPtsInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingInfo.mat'));
load(fullfile(FloorPlanPath,'RayTracing','RayTracingClusters.mat'));

flag = 1;
BeaconWeight = ones(size(AllCornerObsPos,1), 1);

% Using bisection method
% Set the lower bound and higher bound for bisection
% method. Change their value to minimize the possible range
% of near-optimal solution.
LowNumber = 1;
HighNumber = size(AllCornerObsPos, 1);
while (LowNumber < HighNumber)
    display(LowNumber);
    display(HighNumber);
    % Number: the number of beacon location we choose
    Number = fix((LowNumber + HighNumber) / 2);
    % Reset all the weight of beacon locations.
    BeaconWeight = ones(size(AllCornerObsPos,1), 1);
    % flag: if flag = 1, we did not find the available
    % solution; if flag = 0, we find the available solution
    % with current number of beacon locations.
    flag = 1;

    % Iteration: Theorem 4.10. We repeat this process until
    % we find an available solution or the iteration time
    % is more than the threshold.
    for Interation=1:2*Number*log2(size(AllCornerObsPos, 1)/Number)

        % Call_UserDefinedBeaconPlacement is your original
        % function. I add 'Number' and 'BeaconWeight' as
        % parameter.
        Call_ep_net_algo(FloorPlanPath, BeacPlacementName,Number, BeaconWeight);
        
                


        % ComputeAndPlotCoverageClassAndDOP is also your
        % original function. I add "1" as parameter. "1"
        % means we are trying to find the solution with
        % such number of beacons. "0" means we have
        % alreadly find the solution with such number of
        % beacons and we just want to get them.
        % For the return value:
        % flag: whether we find an available solution
        % NonCoverBeacon: If we didn't find an available
        % solution, it contains the beacon locations which
        % can see the subregion not unique localized.
        [flag, NonCoverBeacon] = ComputeClass_enet(FloorPlanPath,BeacPlacementName,'CDF',1);

        % Double the weight these beacon locations.
        for i=1:length(NonCoverBeacon)
            BeaconWeight(NonCoverBeacon(i)) = BeaconWeight(NonCoverBeacon(i)) * 2;
        end

        % If we find the available solution, get of this
        % loop.
        if (flag == 0)
            break;
        end
    end

    % If we find the available solution, we modify the high
    % bound. It means we can find an available solution with
    % 'HighNumber' beacons.
    if (flag == 0)
        HighNumber = Number;
        continue;
    end
    % If we did not find the available solution, we modify
    % the low bound. It means we cannot find the available
    % solution with 'LowNumber' beacons.
    if (flag == 1)
        LowNumber = Number + 1;
        continue;
    end
end

% After the above process, we will get the minimum
% 'HighNumber' which is the number of beacons we can choose
% to unique localized the whole region.
Number = HighNumber;

% Then we repeat the random sampling process to find that
% available solution, whose size is 'Number'.
flag = 1;
BeaconWeight = ones(size(AllCornerObsPos,1), 1);
while (flag == 1)
    Call_ep_net_algo(FloorPlanPath, BeacPlacementName, Number, BeaconWeight);
    [flag, NonCoverBeacon] = ComputeClass_enet(FloorPlanPath,BeacPlacementName,'CDF',0);
    for i=1:length(NonCoverBeacon)
        BeaconWeight(NonCoverBeacon(i)) = BeaconWeight(NonCoverBeacon(i)) * 2;
    end
    %display(BeaconWeight);
end
% Haotian Modified Part End Here.

%PlotComparisonOfMultiplePlacements(FloorPlanPath);
                
end

