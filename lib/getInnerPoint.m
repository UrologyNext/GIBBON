function [varargout]=getInnerPoint(varargin)

%%

switch nargin
    case 2
        F=varargin{1};
        V=varargin{2};
        searchRadius=[];
        voxelSize=[];
        plotOn=0;
    case 3        
        F=varargin{1};
        V=varargin{2};
        searchRadius=varargin{3};
        voxelSize=[];
        plotOn=0;
    case 4            
        F=varargin{1};
        V=varargin{2};
        searchRadius=varargin{3};
        voxelSize=varargin{4};
        plotOn=0;
    case 5
        F=varargin{1};
        V=varargin{2};
        searchRadius=varargin{3};
        voxelSize=varargin{4};
        plotOn=varargin{5};
    otherwise
        error('Wrong number of input arguments');
end

if isa(F,'cell')
    [F,V,C]=joinElementSets(F,V);
else
    C=ones(size(F,1),1);
end

if isempty(voxelSize)
   D=patchEdgeLengths(F,V); 
   voxelSize=mean(D)/2;
end

if isempty(searchRadius)
   searchRadius=voxelSize*3;
end

%% Get an inner point

%Convert patch data to image
[M,G,~]=patch2Im(F,V,C,voxelSize);
L_test=(M==1); %Logic for interior voxels of surface mesh
imOrigin=G.origin; %Image origin can be used to allign image with surface

%Construct search blurring kernel
[x,y,z]=ndgrid(-searchRadius:voxelSize:searchRadius); %kernel coordinates
d=sqrt(x.^2+y.^2+z.^2); %distance metric
k=(d<=searchRadius); %Define kernel based on radius
k=k./sum(k(:)); %Normalize kernel

%Convolve interior image with kernel
ML=convn(double(L_test),k,'same');
ML(M~=1)=NaN; %Set other sites to NaN
[~,indInternal]=nanmax(ML(:)); %Kernel should yield max at "deep" (related to search radius) point
[I_in,J_in,K_in]=ind2sub(size(M),indInternal); %Convert to subscript coordinates

%Derive point coordinates
V_inner=zeros(1,3);
[V_inner(1),V_inner(2),V_inner(3)]=im2cart(I_in,J_in,K_in,voxelSize*ones(1,3));
V_inner=V_inner+imOrigin(ones(size(V_inner,1),1),:);

%% Plotting image, mesh and inner point
if plotOn==1    
    
    fontSize=20;
    markerSize1=50;%round(voxelSize*25);
    faceAlpha1=1;
    faceAlpha2=0.5;
    
    cFigure;    
    hold on;
    
    gpatch(F,V,0.5*ones(1,3),'none',faceAlpha2);
    plotV(V_inner,'k.','MarkerSize',markerSize1);
    
    L_plot=false(size(ML));
    L_plot(:,:,K_in)=1;
    L_plot=L_plot & ~isnan(ML);
    [Fm,Vm,Cm]=ind2patch(L_plot,double(ML),'sk');
    [Vm(:,1),Vm(:,2),Vm(:,3)]=im2cart(Vm(:,2),Vm(:,1),Vm(:,3),voxelSize*ones(1,3));
    Vm=Vm+imOrigin(ones(size(Vm,1),1),:);
    
    gpatch(Fm,Vm,Cm,'k',faceAlpha1);    
    
    L_plot=false(size(ML));
    L_plot(I_in,:,:)=1;
    L_plot=L_plot & ~isnan(ML);
    [Fm,Vm,Cm]=ind2patch(L_plot,ML,'si');
    [Vm(:,1),Vm(:,2),Vm(:,3)]=im2cart(Vm(:,2),Vm(:,1),Vm(:,3),voxelSize*ones(1,3));
    Vm=Vm+imOrigin(ones(size(Vm,1),1),:);
    gpatch(Fm,Vm,Cm,'k',faceAlpha1);    
    
    L_plot=false(size(ML));
    L_plot(:,J_in,:)=1;
    L_plot=L_plot & ~isnan(ML);
    [Fm,Vm,Cm]=ind2patch(L_plot,ML,'sj');
    [Vm(:,1),Vm(:,2),Vm(:,3)]=im2cart(Vm(:,2),Vm(:,1),Vm(:,3),voxelSize*ones(1,3));
    Vm=Vm+imOrigin(ones(size(Vm,1),1),:);
    gpatch(Fm,Vm,Cm,'k',faceAlpha1);    
    
    colormap(gjet(250)); colorbar;     
    axisGeom(gca,fontSize);
    drawnow;    
end

varargout{1}=V_inner;
varargout{2}=M;
varargout{3}=G;
varargout{4}=ML;


 
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
