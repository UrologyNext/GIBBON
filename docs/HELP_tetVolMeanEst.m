%% tetVolMeanEst
% Below is a demonstration of the features of the |tetVolMeanEst| function
%
%%
clear; close all; clc;

%%
% Plot settings
fontSize=15;
faceAlpha1=0.5;
faceAlpha2=1;
edgeColor=0.25*ones(1,3);
edgeWidth=1.5;
patchColor=[1 0.5 0];

%% Estimaging tetrahedral volume based on mean edge length and regular face assumption

% Get a regular tentrahedron
[V,F]=platonic_solid(1,1);

% Calculate true volume
VE=tetVol([1 2 3 4],V)

%Estimated volume for regular tets based on mean edge lengths
[VE_est]=tetVolMeanEst(F,V)


%%
% Plotting model
hf=cFigure;
title('A regular tetrahedron','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;

hp=patch('Faces',F,'Vertices',V);
set(hp,'FaceColor',patchColor,'FaceAlpha',faceAlpha1,'lineWidth',edgeWidth,'edgeColor',edgeColor);
camlight headlight;
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  grid on;

%%
% The two metrics coincide in this case but for irregular meshes they may
% divergerge. 

%% Using |tetVolMeanEst| to set desired mesh volume for tetgen meshing
% For tetrahedral meshing schemes surface geometry is usually provided. For
% instance triangulated surface data. If the desired element volume can be
% specified then in this case |tetVolMeanEst| can be used to estimate the
% desired element volume given the input surface mesh (provided the surface
% mesh is not remeshed). This is highlighted in the following example. 

%%
% Building a geodesic dome surface model
[F,V,~]=geoSphere(2,1);

%%
% Plotting model
hf=cFigure;
title('A triangulated surface model','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;

hp=patch('Faces',F,'Vertices',V);
set(hp,'FaceColor',patchColor,'FaceAlpha',faceAlpha1,'lineWidth',edgeWidth,'edgeColor',edgeColor);
camlight headlight;
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  grid on;

%%
% The triangles are quite regular and can be used to estimate desired tetrahedral element volume
[regionA]=tetVolMeanEst(F,V); %Volume for regular tets

%% 
% Defining input structure

inputStruct.stringOpt='-pq1.2AaYQ';
inputStruct.Faces=F;
inputStruct.Nodes=V;
inputStruct.holePoints=[];
inputStruct.faceBoundaryMarker=ones(size(F,1),1); %Face boundary markers
inputStruct.regionPoints=[0 0 0]; %region points
inputStruct.regionA=regionA;
inputStruct.minRegionMarker=2; %Minimum region marker

%% 
% Mesh model using tetrahedral elements using tetGen 
[meshOutput]=runTetGen(inputStruct); %Run tetGen 

%% 
% Access model element and patch data
F=meshOutput.faces;
V=meshOutput.nodes;
C=meshOutput.faceMaterialID;
E=meshOutput.elements;

%% 
% PLOTTING MODEL 

%Selecting half of the model to see interior
Y=V(:,2); YE=mean(Y(E),2);
L=YE>mean(Y);
[Fs,Cs]=element2patch(E(L,:),C(L));

hf1=cFigure;
subplot(1,2,1);
title('Solid tetrahedral mesh model','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize); hold on;
hps=patch('Faces',F,'Vertices',V,'FaceColor','flat','CData',C,'lineWidth',edgeWidth,'edgeColor',edgeColor);
view(3); axis tight;  axis equal;  grid on;
colormap(autumn); 
camlight headlight;
set(gca,'FontSize',fontSize);
subplot(1,2,2);
title('Cut view of Solid tetrahedral mesh model','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize); hold on;
hps=patch('Faces',Fs,'Vertices',V,'FaceColor','flat','CData',Cs,'lineWidth',edgeWidth,'edgeColor',edgeColor);
view(3); axis tight;  axis equal;  grid on;
colormap(autumn); 
camlight headlight;
set(gca,'FontSize',fontSize);
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
