function [F,V]=regionTriMesh2D(varargin)

% function [F,V]=regionTriMesh2D(regionCell,pointSpacing,resampleCurveOpt,plotOn)
% ------------------------------------------------------------------------
% This function creates a 2D triangulation for the region specified in the
% variable regionCell. The mesh aims to obtain a point spacing as defined
% by the input pointSpacing.
% The function output contains the triangular faces in F, the vertices in V
% and the per triangle region indices in regionInd. By setting plotOn to 0
% or 1 plotting can be switched on or off.
%
% More on the specification of the region:
% The input variable regionCell is a cell array containing all the boundary
% curves, e.g. for a two curve region 1 we would have something like
% regionSpec{1}={V1,V2} where V1 and V2 are the boundary curves. Multiple
% curves may be given here. The first curve should form the outer boundary
% of the entire region, the curves that follow should define holes inside
% this boundary and the space inside them is therefore not meshed.
%
% Kevin Mattheus Moerman
%
% 2013/14/08
% 2017/18/04 Added varargin style with defaults for missing parameters
% 2017/18/04 Fixed bug which caused accidental removal of interior points
% for multiregion meshes or meshes containing holes.
%------------------------------------------------------------------------

%%

switch nargin
    case 1
        regionCell=varargin{1};
        pointSpacing=[];
        resampleCurveOpt=0;
        plotOn=0;
    case 2
        regionCell=varargin{1};
        pointSpacing=varargin{2};
        resampleCurveOpt=0;
        plotOn=0;
    case 3
        regionCell=varargin{1};
        pointSpacing=varargin{2};
        resampleCurveOpt=varargin{3};
        plotOn=0;
    case 4
        regionCell=varargin{1};
        pointSpacing=varargin{2};
        resampleCurveOpt=varargin{3};
        plotOn=varargin{4};
end

if isempty(pointSpacing)
    %If pointSpacing is empty it will be based on the point spacing of the
    %input curves
    pointSpacingCurves=zeros(1,numel(regionCell));
    for q=1:1:numel(regionCell)
        V_now=regionCell{q};
        pointSpacingCurves(q)=mean(sqrt(sum(diff(V_now,1,1).^2,2)));        
    end    
    pointSpacing=mean(pointSpacingCurves);
end

%% CONTROL PARAMETERS
interpMethod='linear';
closeLoopOpt=1;
minConnectivity=4; %Minimum connectivity for points

%% PLOT SETTINGS
if plotOn==1
    fontSize=20;
    faceAlpha=1;
    markerSize=20;
    c=gjet(4);
    faceColor=c(4,:);
end

%% Get region curves and define constraints for Delaunay tesselation

V=[]; %Curve points
VSS=[]; %Curve points
C=[]; %Constraints
nss=0; %Number of points parameter for constraint index correction
for qCurve=1:1:numel(regionCell)
    %Get curve
    Vs=regionCell{qCurve};
    
    %Resample curve evenly based on point spacing
    np=ceil(max(pathLength(Vs))./pointSpacing); %Calculate required number of points for curve
    [Vss]=evenlySampleCurve(Vs,np,interpMethod,closeLoopOpt);
    
    %Create refined set for distance based edge point removal
    [Vss_split]=evenlySampleCurve(Vs,np*2,interpMethod,closeLoopOpt);
    
    %Resample curve
    if resampleCurveOpt==1
        Vs=Vss;
    end
    
    %Collect curve points
    V=[V;Vs]; %Original or interpolated set
    
    VSS=[VSS;Vss_split]; %Interpolated set
    
    %Create curve constrains
    ns= size(Vs,1);
    Cs=[(1:ns)' [2:ns 1]'];
    C=[C;Cs+nss];
    nss=nss+ns;
end

%% DEFINE INTERNAL MESH SEED POINTS

methodOpt=2;

%region extrema
maxVi=max(V(:,[1 2]),[],1);
minVi=min(V(:,[1 2]),[],1);

switch methodOpt
    case 1 %Approximate regular triangles but more symmetric
        %Mesh point spacing for aproximately equilateral triangular mesh
        pointSpacingXY=[pointSpacing pointSpacing.*0.5.*sqrt(3)];
        
        maxV=maxVi+pointSpacingXY;
        minV=minVi-pointSpacingXY;
        
        %Region "Field Of View" size
        FOV=abs(maxV-minV);
        
        %Calculate number of points in each direction
        FOV_dev=FOV./pointSpacingXY;
        
        npXY=round(FOV_dev);
        
        %Get mesh of seed points
        xRange=linspace(minV(1),maxV(1),npXY(1));
        yRange=linspace(minV(2),maxV(2),npXY(2));
        [X,Y]=meshgrid(xRange,yRange);
        
        %Offset mesh in X direction to obtain aproximate equilateral triangular mesh
        X(1:2:end,:)=X(1:2:end,:)+(pointSpacing/2);
        
    case 2 %Close to regular triangles but possibly assymetric
        [~,Vt]=triMeshEquilateral(minVi,maxVi,pointSpacing);
        X=Vt(:,1); Y=Vt(:,2);
end

X=X(:);
Y=Y(:);

%% Remove edge points

[D,~]=minDist([X Y],VSS);
L=D>(pointSpacing*0.5*sqrt(3))/2;

X=X(L);
Y=Y(L);

%%
%Adding seed points to list
V_add=[X(:) Y(:)];

V=[V;V_add]; %Total point set of curves and seeds
numPointsIni=size(V,1);

%% DERIVE CONSTRAINED DELAUNAY TESSELATION

%Initial Delaunay triangulation
DT = delaunayTriangulation(V(:,1),V(:,2),C);
V=DT.Points;
F=DT.ConnectivityList;

%% PLOTTING
    
%Remove poorly connected points associated with poor triangles
[~,IND_V]=tesIND(F,V,0); % [~,IND_V]=patchIND(F,V);

connectivityCount=sum(IND_V>0,2);
logicPoorConnectivity=connectivityCount<=minConnectivity;
logicConstraints=false(size(logicPoorConnectivity));
logicConstraints(C(:))=1;
logicRemoveList=logicPoorConnectivity & ~logicConstraints;
logicKeepList=~logicRemoveList;
V=V(logicKeepList,:); %Remove points
numPoints=size(V,1);

%Fix constraints list
indNew=(1:numPoints)';
indFix=zeros(numPointsIni,1);
indFix(logicKeepList)=indNew;
C=indFix(C);

%Redo Delaunary triangulation
DT = delaunayTriangulation(V(:,1),V(:,2),C);
V=DT.Points;
F=DT.ConnectivityList;

%Remove faces not inside region
L = isInterior(DT);
F=F(L,:);

%Removing unused points
indUni=unique(F(:));
indNew=nan(size(V,1),1);
indNew(indUni)=(1:numel(indUni))';
F=indNew(F);
V=V(indUni,:);

numPointsPost=size(V,1);

if numPoints==numPointsPost
    warning('No points removed in contrained Delaunay triangulation. Possibly due to large pointSpacing with respect to curve size. Meshing skipped!');
    F=[];
    V=[];
else
    
    %% CONSTRAINED SMOOTHENING OF THE MESH
    
    TR = triangulation(F,V);
    boundEdges = freeBoundary(TR);
    boundaryInd=unique(boundEdges(:));
    
    smoothPar.LambdaSmooth=0.5;
    smoothPar.n=250;
    smoothPar.Tolerance=0.01;
    smoothPar.RigidConstraints=boundaryInd;
    [V]=tesSmooth(F,V,[],smoothPar);
    
    %% PLOTTING
    if plotOn==1
        cFigure;
        title('The meshed model','FontSize',fontSize);
        xlabel('X','FontSize',fontSize);ylabel('Y','FontSize',fontSize);zlabel('Z','FontSize',fontSize);
        hold on;
        gpatch(F,V,faceColor,'k',faceAlpha);
        plotV(V(boundaryInd',:),'b.','MarkerSize',markerSize);        
        axis equal; view(2); axis tight;  set(gca,'FontSize',fontSize); grid on;
        drawnow;
    end
    
end
 
%% 
% ********** _license boilerplate_ **********
% 
% Copyright 2017 Kevin Mattheus Moerman
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%   http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
