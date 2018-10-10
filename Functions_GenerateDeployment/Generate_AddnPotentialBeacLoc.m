function [AddnPotentialBeacLoc] =  Generate_AddnPotentialBeacLoc(Corners,Obstacles)
   
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
    while (AddnBeacType<0 || AddnBeacType>1000)
        AddnBeacType = input(['0: No addn beacons\n1: User defined addn beacons\n2: Random addn beacons\nEnter choice for additional beacon locations: ']);
    end 

    switch AddnBeacType
        case 0
            AddnPotentialBeacLoc = [];
        case 1
            % --------- User defined additional placement points
            title('Place cursor on additional beacon locations. Press space when done.');
            [x,y,button] = ginput(1);

            if button ==1
                scatter(x,y,80,'filled');hold on;
            end

            CursorPts = [x y];
            NumPts = 1;

            while button ~=32 % until space key is pressed
                [x,y,button] = ginput(1);
                button;
                CursorPts = [CursorPts; [x y]];
                NumPts = NumPts+1;
                scatter(x,y,80,'b*');hold on;
                text(x+0.3,y+0.3,['(',num2str(x,2),',',num2str(y,2),')'],'FontSize',14);

            end

            % Last point is the Space from keyboard - remove it
            CursorPts = CursorPts(1:end-1,:);
            FloorPlanPoly = Corners;
            AllCornerObsPos = Corners(1:end-1,:);
            for ind = 1:size(Obstacles,2)
                FloorPlanPoly = [FloorPlanPoly; nan nan; Obstacles{1,ind}];
            end
            [in,on] = inpolygon(CursorPts(:,1),CursorPts(:,2),FloorPlanPoly(:,1),FloorPlanPoly(:,2));
            AddnPotentialBeacLoc = CursorPts(find(in),:);
        case 2
            
            NumAddBeacLoc = -1;
            while (NumAddBeacLoc<0 || NumAddBeacLoc>100)
                NumAddBeacLoc = input(['Enter number of additional random interior beacon locations: ']);
            end           


            % % First generate 5x the required pts within a bounding box surrounding the
            % % polygon. Then check which points are within the poygon.
            % RandPts = [min(x)+(max(x)-min(x))*rand(5*NumAddBeacLoc) min(y)+(max(y)-min(y))*rand(5*NumAddBeacLoc)];    
            % [in,on] = inpolygon(RandPts(:,1),RandPts(:,2),x,y);
            % RandPtsIn = find(in);
            % AddnPotentialBeacLoc = RandPts(RandPtsIn(1:NumAddBeacLoc),:);
            % %%----------------
            FloorPlanPoly = Corners;
            AllCornerObsPos = Corners(1:end-1,:);
            for ind = 1:size(Obstacles,2)
                FloorPlanPoly = [FloorPlanPoly; nan nan; Obstacles{1,ind}];
                %AllCornerObsPos = [AllCornerObsPos; Obstacles{1,ind}(1:end-1,:)];
            end
            x = Corners(:,1); y = Corners(:,2);
    
            RandPts = [min(x)+(max(x)-min(x))*rand(100*NumAddBeacLoc,1) min(y)+(max(y)-min(y))*rand(100*NumAddBeacLoc,1)];    
            [in,on] = inpolygon(RandPts(:,1),RandPts(:,2),FloorPlanPoly(:,1),FloorPlanPoly(:,2));
            RandPtsIn = find(in);
            AddnPotentialBeacLoc = RandPts(RandPtsIn(1:NumAddBeacLoc),:);
            scatter(AddnPotentialBeacLoc(:,1),AddnPotentialBeacLoc(:,2));

    end
end