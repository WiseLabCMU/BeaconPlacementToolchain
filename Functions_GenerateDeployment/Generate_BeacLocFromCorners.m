function [SelectCornersForBeacLoc] =  Generate_BeacLocFromCorners(Corners,Obstacles)
   
    figure;
    plot(Corners(:,1),Corners(:,2),'color',[0.5 0.5 0.5],'linewidth',2);hold on;
    for m = 1:size(Obstacles,2)
        obs = Obstacles{m};
        if(~isempty(obs))
        fill(obs(:,1),obs(:,2),[0.8 0.8 0.8]);
        end
    end
    LabelSize = 18;
    axis tight;
    axis equal;
    xlabel('x (m)','FontSize',LabelSize);
    ylabel('y (m)','FontSize',LabelSize);
    set(gca,'fontsize',LabelSize);
    grid on;


    AddnBeacType = -1;
    while (AddnBeacType<0 || AddnBeacType>1)
        AddnBeacType = input(['0: Use all corners as potential beacon Loc\n1: User select corners as beacon loc \n: ']);
    end 

    SelectCornersForBeacLoc = Corners(1:end-1,:);
    for ind = 1:size(Obstacles,2)
        SelectCornersForBeacLoc = [SelectCornersForBeacLoc; Obstacles{1,ind}(1:end-1,:)];
    end
            
    switch AddnBeacType
        case 0
           ; % do nothing
        case 1
            % --------- User defined additional placement points
            title('CLick corners to select them as beacon locations. Press space when done.');
            [x,y,button] = ginput(1);
            scatter(x,y,100,'rx');hold on;
            DistToCorners = pdist2([x y],SelectCornersForBeacLoc);
            [minval,minindx]=min(DistToCorners);
            ClosestCorner = SelectCornersForBeacLoc(minindx,:);
            scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;

            set(gca,'FontSize',14);

            % Last point is the Space from keyboard - remove it
            CursorPts = ClosestCorner;
            NumPts = 1;
            BeaconPlaceInd=[minindx];
            while button ~=32 % until space key is pressed
                [x,y,button] = ginput(1);
                scatter(x,y,100,'rx');hold on;
                DistToCorners = pdist2([x y],SelectCornersForBeacLoc);
                [minval,minindx]=min(DistToCorners);
                ClosestCorner = SelectCornersForBeacLoc(minindx,:);
                scatter(ClosestCorner(1),ClosestCorner(2),200,'MarkerEdgeColor',[0.5 0 0],'MarkerFaceColor','r','LineWidth',2);hold on;
                %CursorPts = [CursorPts; ClosestCorner];
                BeaconPlaceInd = [BeaconPlaceInd; minindx];
            end
            BeaconPlaceInd(end) = [];
            SelectCornersForBeacLoc = SelectCornersForBeacLoc(BeaconPlaceInd,:);
            
            %[in,on] = inpolygon(CursorPts(:,1),CursorPts(:,2),FloorPlanPoly(:,1),FloorPlanPoly(:,2));
            %AddnPotentialBeacLoc = CursorPts(find(in),:);

    end
end