%% box_indices
% Below is a demonstration of the features of the |box_indices| function
%

%% Syntax
% |[IND]=box_indices(siz);|

%% Description 
% The |box_indices| function returns the indices of the outer boundary
% elements of an array (which can be thought of as defining a box), i.e.
% the indices of the first and last row, columsn, slice, etc.. 

%% Examples

%%
clear; close all; clc;

%% 
% Plot settings
fig_color='w'; fig_colordef='white'; 
faceAlpha1=1;
faceAlpha2=0.65;
edgeColor1='none';
edgeColor2='none';

%% Example: |box_indices| for 2D arrays

siz=[25 25];
M=ones(siz);
[indBox]=box_indices(size(M));
M(indBox)=0; %setting edge indices to 0 for visualization

%%
% Plotting results
figuremax(fig_color,fig_colordef);
title('Black pixels denote edge or box entries'); hold on; 
imagesc(M);
axis equal; axis tight; axis vis3d; grid off;  
colormap gray; caxis([0 1]); colorbar;
drawnow;

%% Example: |box_indices| for 3D arrays

siz=[25 25 25];
M=ones(siz);
[indBox]=box_indices(size(M));
M(indBox)=0; %setting edge indices to 0 for visualization

%%
% Plotting results. Visualization shows 3 mutally orthogonal slices but
% black voxels are actually all around the 3D matrix. 

% Creating patch data for voxel display
logicPlot=false(size(M));
logicPlot(:,:,round(size(M,3)/2))=1; 
logicPlot(:,round(size(M,2)/2),:)=1; 
logicPlot(round(size(M,1)/2),:,:)=1; 
[F,V,C]=ind2patch(logicPlot,M,'v'); 

% [F2,V2,C2]=ind2patch(M==0,M,'vb'); 

figuremax(fig_color,fig_colordef);
title('Black voxels denote edge or box entries'); hold on; 
xlabel('J - columns');ylabel('I - rows'); zlabel('K - slices'); hold on;

patch('Faces',F,'Vertices',V,'FaceColor','flat','CData',C,'EdgeColor','g','FaceAlpha',1);
% patch('Faces',F2,'Vertices',V2,'FaceColor','flat','CData',C2,'EdgeColor','k','FaceAlpha',0.1);

axis equal; view(3); axis tight; axis vis3d; grid off;  box on; 
colormap gray; caxis([0 1]); colorbar;
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
