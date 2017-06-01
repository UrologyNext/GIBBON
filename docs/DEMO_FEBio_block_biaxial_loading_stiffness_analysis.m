%% DEMO_FEBio_block_biaxial_loading_stiffness_analysis
% Below is a demonstration for:
% 1) Building an FEBio model for uniaxial compression
% 2) Running the model
% 3) Importing analysis results

%%

clear; close all; clc;

%%
% Plot settings
fontSize=20;
faceAlpha1=0.8;
faceAlpha2=1;
edgeColor=0.25*ones(1,3);
edgeWidth=1.5;
markerSize=40;
lineWidth=3;

%%
% Control parameters

% path names
defaultFolder = fileparts(fileparts(mfilename('fullpath')));
savePath=fullfile(defaultFolder,'data','temp');

modelNameEnd='tempModel';
modelName=fullfile(savePath,modelNameEnd);

%Specifying dimensions and number of elements
sampleWidth=10;
sampleThickness=10; 
sampleHeight=10;
pointSpacings=2*ones(1,3);
initialArea=sampleWidth*sampleThickness;

numElementsWidth=round(sampleWidth/pointSpacings(1));
numElementsThickness=round(sampleThickness/pointSpacings(2));
numElementsHeight=round(sampleHeight/pointSpacings(3));

boxDim=[sampleWidth sampleThickness sampleHeight]; %Dimensions
boxEl=[numElementsWidth numElementsThickness numElementsHeight]; %Number of elements

stretchLoads=[nan 1.4 0.7]; %Applied stretches, use NaN to leave face free
displacementMagnitudes=(boxDim.*stretchLoads)-boxDim;

%Material parameter set
c1=1e-3; 
m1=3;
k_factor=1e2;

%% CREATING MESHED BOX

%Create box 1
[box1]=hexMeshBox(boxDim,boxEl);
E=box1.E;
V=box1.V;
Fb=box1.Fb;
faceBoundaryMarker=box1.faceBoundaryMarker;

X=V(:,1); Y=V(:,2); Z=V(:,3);
VE=[mean(X(E),2) mean(Y(E),2) mean(Z(E),2)];

elementMaterialIndices=ones(size(E,1),1);

%%

% Plotting boundary surfaces
hf=cFigure;
title('Model surfaces','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;
patch('Faces',Fb,'Vertices',V,'FaceColor','flat','CData',faceBoundaryMarker,'FaceAlpha',faceAlpha2,'lineWidth',edgeWidth,'edgeColor',edgeColor);

colormap(gjet(6)); icolorbar;
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  grid on;
drawnow;

%% DEFINE BC's

%Define supported node sets
logicFace=faceBoundaryMarker==1;
Fr=Fb(logicFace,:);
bcSupportList_X=unique(Fr(:));

logicFace=faceBoundaryMarker==3;
Fr=Fb(logicFace,:);
bcSupportList_Y=unique(Fr(:));

logicFace=faceBoundaryMarker==5;
Fr=Fb(logicFace,:);
bcSupportList_Z=unique(Fr(:));

%Prescribed displacement nodes
logicPrescribe=faceBoundaryMarker==6;
Fr=Fb(logicPrescribe,:);
bcPrescribeList_Z=unique(Fr(:));
bcPrescribeMagnitudes_Z=displacementMagnitudes(ones(1,numel(bcPrescribeList_Z)),3);

logicPrescribe=faceBoundaryMarker==4;
Fr=Fb(logicPrescribe,:);
bcPrescribeList_Y=unique(Fr(:));
bcPrescribeMagnitudes_Y=displacementMagnitudes(ones(1,numel(bcPrescribeList_Y)),2);

logicPrescribe=faceBoundaryMarker==2;
Fr=Fb(logicPrescribe,:);
bcPrescribeList_X=unique(Fr(:));
bcPrescribeMagnitudes_X=displacementMagnitudes(ones(1,numel(bcPrescribeList_X)),1);


%%
% Visualize BC's
hf=cFigure;
title('Complete model','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;

patch('Faces',Fb,'Vertices',V,'FaceColor','flat','CData',faceBoundaryMarker,'FaceAlpha',faceAlpha2,'lineWidth',edgeWidth,'edgeColor',edgeColor);
plotV(V(bcSupportList_X,:),'r.','MarkerSize',markerSize);
plotV(V(bcSupportList_Y,:),'g.','MarkerSize',markerSize);
plotV(V(bcSupportList_Z,:),'b.','MarkerSize',markerSize);
plotV(V(bcPrescribeList_Z,:),'k.','MarkerSize',markerSize);
plotV(V(bcPrescribeList_Y,:),'k+','MarkerSize',markerSize); 
plotV(V(bcPrescribeList_X,:),'k*','MarkerSize',markerSize); 
set(gca,'FontSize',fontSize);

colormap(gjet(6)); icolorbar; 
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  grid on;
drawnow; 

%% CONSTRUCTING FEB MODEL

FEB_struct.febio_spec.version='2.0';
FEB_struct.Module.Type='solid';

% Defining file names
FEB_struct.run_filename=[modelName,'.feb']; %FEB file name
FEB_struct.run_logname=[modelName,'.txt']; %FEBio log file name

%Geometry section
FEB_struct.Geometry.Nodes=V;
FEB_struct.Geometry.Elements={E}; %The element sets
FEB_struct.Geometry.ElementType={'hex8'}; %The element types
FEB_struct.Geometry.ElementMat={elementMaterialIndices};
FEB_struct.Geometry.ElementsPartName={'Block'};

%Material section
k=c1*k_factor;

%Material section
FEB_struct.Materials{1}.Type='Ogden';
FEB_struct.Materials{1}.Name='Block_material';
FEB_struct.Materials{1}.Properties={'c1','m1','c2','m2','k'};
FEB_struct.Materials{1}.Values={c1,m1,c1,-m1,k};

%Step specific control sections
FEB_struct.Control.AnalysisType='static';
FEB_struct.Control.Properties={'time_steps','step_size',...
    'max_refs','max_ups',...
    'dtol','etol','rtol','lstol'};
numSteps=20;
FEB_struct.Control.Values={numSteps,1/numSteps,25,5,0.001,0.01,0,0.9};
FEB_struct.Control.TimeStepperProperties={'dtmin','dtmax','max_retries','opt_iter','aggressiveness'};
FEB_struct.Control.TimeStepperValues={(1/(100*numSteps)),1/numSteps,5,10,1};

%Defining node sets
FEB_struct.Geometry.NodeSet{1}.Set=bcSupportList_X;
FEB_struct.Geometry.NodeSet{1}.Name='bcSupportList_X';
FEB_struct.Geometry.NodeSet{2}.Set=bcSupportList_Y;
FEB_struct.Geometry.NodeSet{2}.Name='bcSupportList_Y';
FEB_struct.Geometry.NodeSet{3}.Set=bcSupportList_Z;
FEB_struct.Geometry.NodeSet{3}.Name='bcSupportList_Z';


%Adding BC information
FEB_struct.Boundary.Fix{1}.bc='x';
FEB_struct.Boundary.Fix{1}.SetName=FEB_struct.Geometry.NodeSet{1}.Name;
FEB_struct.Boundary.Fix{2}.bc='y';
FEB_struct.Boundary.Fix{2}.SetName=FEB_struct.Geometry.NodeSet{2}.Name;
FEB_struct.Boundary.Fix{3}.bc='z';
FEB_struct.Boundary.Fix{3}.SetName=FEB_struct.Geometry.NodeSet{3}.Name;

%Prescribed BC's
indBC=1;
if ~any(isnan(bcPrescribeMagnitudes_X(:)))
    FEB_struct.Boundary.Prescribe{indBC}.Set=bcPrescribeList_X;
    FEB_struct.Boundary.Prescribe{indBC}.bc='x';
    FEB_struct.Boundary.Prescribe{indBC}.lc=1;
    FEB_struct.Boundary.Prescribe{indBC}.nodeScale=bcPrescribeMagnitudes_X;
    FEB_struct.Boundary.Prescribe{indBC}.Type='relative';
    indBC=indBC+1;
end

if ~any(isnan(bcPrescribeMagnitudes_Y(:)))    
    FEB_struct.Boundary.Prescribe{indBC}.Set=bcPrescribeList_Y;
    FEB_struct.Boundary.Prescribe{indBC}.bc='y';
    FEB_struct.Boundary.Prescribe{indBC}.lc=1;
    FEB_struct.Boundary.Prescribe{indBC}.nodeScale=bcPrescribeMagnitudes_Y;
    FEB_struct.Boundary.Prescribe{indBC}.Type='relative';
    indBC=indBC+1;
end

if ~any(isnan(bcPrescribeMagnitudes_Z(:)))    
    FEB_struct.Boundary.Prescribe{indBC}.Set=bcPrescribeList_Z;
    FEB_struct.Boundary.Prescribe{indBC}.bc='z';
    FEB_struct.Boundary.Prescribe{indBC}.lc=1;
    FEB_struct.Boundary.Prescribe{indBC}.nodeScale=bcPrescribeMagnitudes_Z;
    FEB_struct.Boundary.Prescribe{indBC}.Type='relative';
end

%Load curves
FEB_struct.LoadData.LoadCurves.id=1;
FEB_struct.LoadData.LoadCurves.type={'linear'};
FEB_struct.LoadData.LoadCurves.loadPoints={[0 0;1 1;]};

%Adding output requests
FEB_struct.Output.VarTypes={'displacement','stress','relative volume'};

%Specify log file output
run_disp_output_name=[modelNameEnd,'_node_out.txt'];
run_force_output_name=[modelNameEnd,'_force_out.txt'];
run_stiffness_output_name=[modelNameEnd,'_stiffness_out.txt'];
FEB_struct.run_output_names={run_disp_output_name,run_force_output_name,run_stiffness_output_name};
FEB_struct.output_types={'node_data','node_data','element_data'};
FEB_struct.data_types={'ux;uy;uz','Rx;Ry;Rz','cxxxx;cxxyy;cyyyy;cxxzz;cyyzz;czzzz;cxxxy;cyyxy;czzxy;cxyxy;cxxyz;cyyyz;czzyz;cxyyz;cyzyz;cxxxz;cyyxz;czzxz;cxyxz;cyzxz;cxzxz'};

%% SAVING .FEB FILE

FEB_struct.disp_opt=0; %Display waitbars
febStruct2febFile(FEB_struct);

%% RUNNING FEBIO JOB

FEBioRunStruct.run_filename=FEB_struct.run_filename;
FEBioRunStruct.run_logname=FEB_struct.run_logname;
FEBioRunStruct.disp_on=1;
FEBioRunStruct.disp_log_on=1;
FEBioRunStruct.runMode='internal';%'internal';
FEBioRunStruct.t_check=0.25; %Time for checking log file (dont set too small)
FEBioRunStruct.maxtpi=1e99; %Max analysis time
FEBioRunStruct.maxLogCheckTime=3; %Max log file checking time

[runFlag]=runMonitorFEBio(FEBioRunStruct);%START FEBio NOW!!!!!!!!

%%
if runFlag==1 %i.e. a succesful run
    %% IMPORTING NODAL DISPLACEMENT RESULTS
    % Importing nodal displacements from a log file
    [~, N_disp_mat,~]=importFEBio_logfile(fullfile(savePath,FEB_struct.run_output_names{1})); %Nodal displacements    
    
    %% IMPORTING NODAL FORCES
    % Importing nodal forces from a log file
    [time_mat, N_force_mat,~]=importFEBio_logfile(fullfile(savePath,FEB_struct.run_output_names{2})); %Nodal forces
    time_mat=[0; time_mat(:)]; %Time
    
    %% IMPORTING ELEMENT STIFFNESS MATRICES
    % Importing element stiffness tensors from a log file
    [~,stiffness_mat,~]=importFEBio_logfile(fullfile(savePath,FEB_struct.run_output_names{3})); %Nodal forces
    
    stiffness_mat=stiffness_mat(:,2:end,end); %Final stiffness state
    
    stiffness_mat_voigt=stiffness_mat(:,[1  2  4  11 16 7;...
                                         2  3  5  12 17 8;...
                                         4  5  6  13 18 9;...
                                         11 12 13 15 20 14;...
                                         16 17 18 20 21 19;...
                                         7  8  9  14 19 10]);
    stiffness_mat_voigt=reshape(stiffness_mat_voigt',6,6,size(stiffness_mat_voigt,1));
    stiffness_mat_voigt=reshape(mat2cell(stiffness_mat_voigt,6,6,...
        ones(size(stiffness_mat_voigt,3),1)),[size(stiffness_mat,1),1]);
    
    stiffness_mat_kelvin=stiffness_mat_voigt; 
    for q=1:1:numel(stiffness_mat_voigt)
        cVoigt=stiffness_mat_voigt{q};
        c=voigtUnMap(cVoigt);
        cKelvin=kelvinMap(c);
        stiffness_mat_kelvin{q}=cKelvin;
        
    end
    
    %%
    
    viewFourthOrderTensor(c); %Visualize tensor C
        
    %% Plotting the deformed model
    
    N_disp_mat=N_disp_mat(:,2:end,:);
    sizImport=size(N_disp_mat);
    sizImport(3)=sizImport(3)+1;
    N_disp_mat_n=zeros(sizImport);
    N_disp_mat_n(:,:,2:end)=N_disp_mat;
    N_disp_mat=N_disp_mat_n;
    DN=N_disp_mat(:,:,end);
    DN_magnitude=sqrt(sum(DN(:,3).^2,2));
    V_def=V+DN;
    [CF]=vertexToFaceMeasure(Fb,DN_magnitude);
    
    %%
    hf=cFigure;
    xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize); hold on;
    
    hp=gpatch(Fb,V_def,CF,'k',1);
    gpatch(Fb,V,0.5*ones(1,3),'k',0.25);
    
    view(3); axis tight;  axis equal;  grid on; box on;
    colormap(gjet(250)); colorbar;
    caxis([0 max(DN_magnitude)]);
    axis([min(V_def(:,1)) max(V_def(:,1)) min(V_def(:,2)) max(V_def(:,2)) min(V(:,3)) max(V(:,3))]);
    view(130,25);
    camlight headlight;
    set(gca,'FontSize',fontSize);
    drawnow;
    
    animStruct.Time=time_mat;
    
    for qt=1:1:size(N_disp_mat,3)
        
        DN=N_disp_mat(:,:,qt);
        DN_magnitude=sqrt(sum(DN(:,3).^2,2));
        V_def=V+DN;
        [CF]=vertexToFaceMeasure(Fb,DN_magnitude);
        
        %Set entries in animation structure
        animStruct.Handles{qt}=[hp hp]; %Handles of objects to animate
        animStruct.Props{qt}={'Vertices','CData'}; %Properties of objects to animate
        animStruct.Set{qt}={V_def,CF}; %Property values for to set in order to animate
    end
        
    anim8(hf,animStruct);
    drawnow;
    
end

%% 
%
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>