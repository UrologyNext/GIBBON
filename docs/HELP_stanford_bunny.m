%% stanford_bunny
% Below is a demonstration of the |stanford_bunny| function

%%
clear; close all; clc;

% Plot settings
fig_color='w'; fig_colordef='white';
fontSize=15;
faceColor='b';
faceAlpha=1;
edgeColor='k';
edgeWidth=1;

%% THE STANFORD BUNNY
% The stanford_bunny function generates patch data (faces and vertices)
% defining a relatively coarse representation of the "Stanford bunny" which
% is a commonly used test model in computer graphics. 
% The surface is not entirely closed as can be seen in the second figure
% below. 
%
% This MATLAB implementation is based on the coarse representation
% downloadable from: 
% http://www.cc.gatech.edu/projects/large_models/bunny.html
% 
% See also:
% http://www.gvu.gatech.edu/people/faculty/greg.turk/bunny/bunny.html 
% http://graphics.stanford.edu/data/3Dscanrep/
%
% Turk G, Levoy M. Zippered polygon meshes from range images.
% Proceedings of the 21st annual conference on Computer graphics and
% interactive techniques - SIGGRAPH  �94 [Internet]. New York, New York,
% USA: ACM Press; 1994;311�8. Available from:
% http://portal.acm.org/citation.cfm?doid=192161.192241

%Obtaining patch data
[F,V]=stanford_bunny;

%%
% Visualisation

hf=figuremax(fig_color,fig_colordef); 
title('The Stanford bunny','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hp=patch('Faces',F,'Vertices',V,'FaceColor','g','FaceAlpha',faceAlpha,'lineWidth',edgeWidth,'edgeColor',edgeColor);
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  axis vis3d; axis off;
camlight('headlight'); lighting flat;

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
