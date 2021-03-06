%% element2HexLattice
% Below is a demonstration of the features of the |element2HexLattice| function

%%
clear; close all; clc;

%% Syntax
% |[Es,Vs,Cs]=element2HexLattice(E,V,cPar);|

%% Description 
% This function converts an element description (elements and vertices i.e
% nodes into a lattice structure. The lattice structure is returned as a
% hexahederal mesh. 

%% Examples 
% 

%%
% Plot settings
cMap=gjet(4); 
fontSize=15; 

%% Example 1 Creating a lattice structure on hexahedral meshes

%%
% Creating example geometry. 
[V,~]=platonic_solid(2,1); %Vertices of cube
E=1:8; %Element description of the 8-node cube (hexahedral element)
C=(1:size(E,1))'; %color (e.g. material) labels for all elements
[F,~]=element2patch(E,C); %Patch data for plotting

%%
% Create lattice structure
controlParameter.growSteps=0; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
controlParameter.latticeSide=[]; %Empty outputs both, 1=side 1 the edge lattice, 2=side 2 the dual lattice to the edge lattice
[Es,Vs,Cs]=element2HexLattice(E,V,controlParameter); %Get lattice structure

%%
% Visualizing input mesh and lattic structures

% Create patch Data for visualization
[Fs,CsF]=element2patch(Es,Cs); %Patch data for plotting
[Fs1,CsF1]=element2patch(Es(Cs==1,:),Cs(Cs==1,:)); %Patch data for plotting
[Fs2,CsF2]=element2patch(Es(Cs==2,:),Cs(Cs==2,:)); %Patch data for plotting

cFigure;
hs=subplot(2,2,1); 
title('The input mesh','fontSize',fontSize)
hold on;
gpatch(F,V,0.5*ones(1,3),'k',0.5);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(2,2,2); 
title('The two complementary lattice structures','fontSize',fontSize)
hold on;
gpatch(Fs,Vs,CsF);
colormap(cMap); 
cLim=caxis;
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(2,2,3); 
title('Lattice side 1','fontSize',fontSize)
hold on;
gpatch(Fs1,Vs,CsF1);
colormap(cMap); 
caxis(cLim);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(2,2,4); 
title('Lattice side 2','fontSize',fontSize)
hold on;
gpatch(Fs2,Vs,CsF2);
colormap(cMap); 
caxis(cLim);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

drawnow;

%% Example 2 Creating a lattice structure on tetrahedral meshes

%%
% Creating example geometry. 

[V,~]=platonic_solid(1,1); %Vertices of tetrahedron
E=1:4; %Element description of the 4-node tetrahedron
C=(1:size(E,1))'; %color (e.g. material) labels for all elements
[F,~]=element2patch(E,C); %Patch data for plotting

%%
% Create lattice structure
controlParameter.growSteps=0; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
controlParameter.latticeSide=[]; %Empty outputs both, 1=side 1 the edge lattice, 2=side 2 the dual lattice to the edge lattice
[Es,Vs,Cs]=element2HexLattice(E,V,controlParameter); %Get lattice structure

%%
% Visualizing input mesh and lattic structures

% Create patch Data for visualization
[Fs,CsF]=element2patch(Es,Cs); %Patch data for plotting
[Fs1,CsF1]=element2patch(Es(Cs==1,:),Cs(Cs==1,:)); %Patch data for plotting
[Fs2,CsF2]=element2patch(Es(Cs==2,:),Cs(Cs==2,:)); %Patch data for plotting

cFigure;
hs=subplot(2,2,1); 
title('The input mesh','fontSize',fontSize)
hold on;
gpatch(F,V,0.5*ones(1,3),'k',0.5);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(2,2,2); 
title('The two complementary lattice structures','fontSize',fontSize)
hold on;
gpatch(Fs,Vs,CsF);
colormap(cMap); 
cLim=caxis;
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(2,2,3); 
title('Lattice side 1','fontSize',fontSize)
hold on;
gpatch(Fs1,Vs,CsF1);
colormap(cMap); 
caxis(cLim);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(2,2,4); 
title('Lattice side 2','fontSize',fontSize)
hold on;
gpatch(Fs2,Vs,CsF2);
colormap(cMap); 
caxis(cLim);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

drawnow;

%% Example 3 Changing lattice structure thickness

%%
% Creating example geometry. 

[V,~]=platonic_solid(1,1); %Vertices of tetrahedron
E=1:4; %Element description of the 4-node tetrahedron
C=(1:size(E,1))'; %color (e.g. material) labels for all elements
[F,~]=element2patch(E,C); %Patch data for plotting

%%
% Create lattice structure
controlParameter.latticeSide=[]; %Empty outputs both, 1=side 1 the edge lattice, 2=side 2 the dual lattice to the edge lattice

%%
% lattice structure for 0 growth steps
controlParameter.growSteps=0; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
[Es_0,Vs_0,Cs_0]=element2HexLattice(E,V,controlParameter); %Get lattice structure

controlParameter.growSteps=1; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
[Es_1,Vs_1,Cs_1]=element2HexLattice(E,V,controlParameter); %Get lattice structure

controlParameter.growSteps=-1; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
[Es_n1,Vs_n1,Cs_n1]=element2HexLattice(E,V,controlParameter); %Get lattice structure

%%
% Visualizing input mesh and lattic structures

% Create patch Data for visualization
[Fs_0,CsF_0]=element2patch(Es_0,Cs_0); %Patch data for plotting
[Fs_1,CsF_1]=element2patch(Es_1,Cs_1); %Patch data for plotting
[Fs_n1,CsF_n1]=element2patch(Es_n1,Cs_n1); %Patch data for plotting

cFigure;
subplot(1,3,1); 
title('The two complementary lattice structures','fontSize',fontSize)
hold on;
gpatch(Fs_0,Vs_0,CsF_0);
colormap(cMap); 
cLim=caxis;
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(1,3,2); 
title('The two complementary lattice structures','fontSize',fontSize)
hold on;
gpatch(Fs_1,Vs_1,CsF_1);
colormap(cMap); 
cLim=caxis;
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(1,3,3); 
title('The two complementary lattice structures','fontSize',fontSize)
hold on;
gpatch(Fs_n1,Vs_n1,CsF_n1);
colormap(cMap); 
cLim=caxis;
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

drawnow;

%% Example 4 Lattices on multiple elements, adjusting lattice type

%%
% Creating example geometry. 
[V,~]=platonic_solid(2,1); %Vertices of cube
E=1:8; %Element description of the 8-node cube (hexahedral element)
[E,V,C]=subHex(E,V); %Subdevide into 8 sub-cubes
[E,V,C]=hex2tet(E,V,C,1); %Convert to tetrahedral elements

[F,~]=element2patch(E,C); %Patch data for plotting

%%
% Create lattice structure
controlParameter.growSteps=-1; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
controlParameter.latticeSide=1; %Empty outputs both, 1=side 1 the edge lattice, 2=side 2 the dual lattice to the edge lattice
[Es,Vs,Cs]=element2HexLattice(E,V,controlParameter); %Get lattice structure

%%
% Visualizing input mesh and lattic structures

% Create patch Data for visualization
[Fs,CsF]=element2patch(Es,Cs); %Patch data for plotting

cFigure;
hs=subplot(1,2,1); 
title('The input mesh','fontSize',fontSize)
hold on;
gpatch(F,V,0.5*ones(1,3),'k',0.5);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(1,2,2); 
title('Lattice side 1','fontSize',fontSize)
hold on;
gpatch(Fs,Vs,CsF);
colormap(cMap); 
caxis(cLim);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

drawnow;


%%
% Create lattice structure
controlParameter.growSteps=1; %0 is normal, positive or negative integers increase or decrease the edge lattice thickness respectively
controlParameter.latticeSide=2; %Empty outputs both, 1=side 1 the edge lattice, 2=side 2 the dual lattice to the edge lattice
[Es,Vs,Cs]=element2HexLattice(E,V,controlParameter); %Get lattice structure

%%
% Visualizing input mesh and lattic structures

% Create patch Data for visualization
[Fs,CsF]=element2patch(Es,Cs); %Patch data for plotting

cFigure;
hs=subplot(1,2,1); 
title('The input mesh','fontSize',fontSize)
hold on;
gpatch(F,V,0.5*ones(1,3),'k',0.5);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

subplot(1,2,2); 
title('Lattice side 1','fontSize',fontSize)
hold on;
gpatch(Fs,Vs,CsF);
colormap(cMap); 
caxis(cLim);
axisGeom(gca,fontSize); 
camlight headlight; lighting flat;

drawnow;

%%
% 
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>
 
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
