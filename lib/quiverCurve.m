function [varargout]=quiverCurve(varargin)

%% Parse input

switch nargin
    case 1
        Vg=varargin{1};
        dirOpt=1;
        colorOpt='k';
        alphaLevel=1;
    case 2
        Vg=varargin{1};
        dirOpt=varargin{2};
        colorOpt='k';
        alphaLevel=1;
    case 3
        Vg=varargin{1};
        dirOpt=varargin{2};
        colorOpt=varargin{3};        
        alphaLevel=1;
    case 4
        Vg=varargin{1};
        dirOpt=varargin{2};
        colorOpt=varargin{3};
        alphaLevel=varargin{4};
end

%%

if size(Vg,2)==2
    Vg(:,3)=0;
end

switch dirOpt
    case 1 %Forward
        V=Vg(1:end-1,:);
        U=diff(Vg,1,1);        
    case 2 %Backward
        V=Vg(2:end,:);
        U=flipud(diff(flipud(Vg),1,1));        
    case 3 %Central
        V=Vg;
        Uf=[diff(Vg,1,1); nan(1,size(Vg,2))];
        Ub=-[nan(1,size(Vg,2)); flipud(diff(flipud(Vg),1,1))];
        U=Uf;
        U(:,:,2)=Ub;
        U=nanmean(U,3);        
end
D=sqrt(sum(U.^2,2));
a=[min(D(:)) max(D(:))];


[F,V,C]=quiver3Dpatch(V(:,1),V(:,2),V(:,3),U(:,1),U(:,2),U(:,3),[],a);

if isempty(colorOpt) %If empty use colormapping
    h=gpatch(F,V,C,'none',alphaLevel);
else %else use specified which could be 'k'
    h=gpatch(F,V,colorOpt,'none',alphaLevel);
end

varargout{1}=h;

 
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
