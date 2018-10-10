clc; clear; close all;
RootPath = pwd;
save('RootPath.mat','RootPath');

MaxFP = 20;

figure;F_NewFig=0;F_AddnBeac=1;
RepoNames = dir(fullfile(RootPath,'FloorPlanPaths','F*'));
for n = 1:numel(RepoNames)
    DisplayFloorPlanPath = fullfile(RootPath,'FloorPlanPaths',RepoNames(n).name);
    subplot(3,ceil(numel(RepoNames)/3),n);
    PlotFloorPlan(DisplayFloorPlanPath,F_NewFig,F_AddnBeac);                
    title([RepoNames(n).name]);
end



TypeCreateFP = -1;
Flag=0;
while (TypeCreateFP<0 || TypeCreateFP>4)
    TypeCreateFP = input(['0: Exit \n1: User drawn \n2: Random \n3: Read from xls \n4: Pre-defined\nEnter choice: ']);

    switch TypeCreateFP
        case 1 % User drawn
            
            [Corners,Obstacles]=Call_UserDrawnFloorPlan();
            Flag = 1;
            
        case 2 % Random
            NumVertex = -1;
            while (NumVertex<3 || NumVertex>100)
                NumVertex = input(['Enter number of vertices: ']);
            end
            [Corners,Obstacles] = Call_RandomFloorPlan(NumVertex);          
            Flag = 1;
            
        case 3 % Read from xls            

            XlsFilePath = input(['Enter file path: '],'s');
            if(exist(XlsFilePath))
                [Corners,Obstacles] = Call_XlsFloorPlan(XlsFilePath);
                Flag=1;
            else
                disp('File does not exist');
            end
            
        case 4 % Read from predefined floor plans
            [Corners,Obstacles] = Call_PreDefinedFloorPlan();
            if ~isempty(Corners)
                Flag = 1;
            end
    end
    
    if Flag==1
        [SelectCornersForBeacLoc] =  Generate_BeacLocFromCorners(Corners,Obstacles);
        [AddnPotentialBeacLoc] =  Generate_AddnPotentialBeacLoc(Corners,Obstacles);
        
        RangeMax = -1;
        while (RangeMax<0 || RangeMax>100)
            RangeMax = input(['0: Default range (100m)\nEnter max range of beacon : ']);
        end
        if RangeMax<=0 || RangeMax>100
            RangeMax = 100;
        end

        
        NumberFP = -1;
        while (NumberFP<0 || NumberFP>MaxFP)
            NumberFP = input(['Save floor plan as : F']);
        end
        NameFP = ['F',num2str(NumberFP)];
        
        FloorPlan_Path = fullfile(RootPath,'FloorPlanPaths',NameFP);
        if exist(FloorPlan_Path)==7
            rmdir(FloorPlan_Path,'s');
        end
        mkdir(FloorPlan_Path);
        save(fullfile(RootPath,'FloorPlanPaths',NameFP,'RangeMax.mat'),'RangeMax');
        save(fullfile(FloorPlan_Path,'FloorPlanOutline.mat'),'Corners','Obstacles','AddnPotentialBeacLoc','SelectCornersForBeacLoc');
    end
    

end

