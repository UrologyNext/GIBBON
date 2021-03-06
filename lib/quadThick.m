function [varargout]=quadThick(varargin)


%%

switch nargin
    case 2
        Fq=varargin{1};
        Vq=varargin{2};
        dirSet=1;
        layerThickness=mean(patchEdgeLengths(Fq,Vq));
        numSteps=1;
    case 3
        Fq=varargin{1};
        Vq=varargin{2};
        dirSet=varargin{3};
        layerThickness=mean(patchEdgeLengths(Fq,Vq));
        numSteps=1;
    case 4
        Fq=varargin{1};
        Vq=varargin{2};
        dirSet=varargin{3};
        layerThickness=varargin{4};
        numSteps=1;
    case 5
        Fq=varargin{1};
        Vq=varargin{2};
        dirSet=varargin{3};
        layerThickness=varargin{4};
        numSteps=varargin{5};
end

%%

if size(dirSet,2)==3 %single vector or vector set for offsetting
    if size(dirSet,1)==1 %If one vector is given copy for all points
        Nv=dirSet(ones(size(Vq,1),1),:);
    else %assume vectors are provided for all points
        if size(dirSet,1)~=size(Vq,1)
            error('Number of normals should match number of points');
        end
    end
else
    %Get vertex normals
    [~,~,Nv]=patchNormal(Fq,Vq);
    
    %Flip if desired
    Nv=Nv.*dirSet;
end

%Thicken inwards
Vq2=Vq+layerThickness.*Nv;

%Get coordinates
X=linspacen(Vq(:,1),Vq2(:,1),numSteps+1);
Y=linspacen(Vq(:,2),Vq2(:,2),numSteps+1);
Z=linspacen(Vq(:,3),Vq2(:,3),numSteps+1);

%Collect node set
V=[X(:) Y(:) Z(:)];

%Create element matrix
E=repmat(Fq,[numSteps,2]);
E_add=0:size(Vq,1):size(Vq,1)*(numSteps-1); 
E_add=E_add(ones(size(Fq,1),1),:);
E_add=E_add(:);
E_add=E_add(:,ones(4,1));
E_add=[E_add E_add+size(Vq,1)];
E=E+E_add;

%Create boundary face set
Fq1=E(1:size(Fq,1),1:4);
Fq2=E(1+(end-size(Fq,1)):end,5:end);

%Collect output
varargout{1}=E;
varargout{2}=V;
varargout{3}=Fq1;
varargout{4}=Fq2;
 
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
