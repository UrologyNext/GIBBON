function [varargout]=patchBoundary(F,V)

%Get non-unique edges
E1=F';
E2=F(:,[2:end 1])';
E=[E1(:) E2(:)];

%Get boundary indices
[indBoundary]=tesBoundary(E,V);

%Boundary edges
Eb=E(indBoundary,:);

%Output
varargout{1}=Eb; %Boundary edges
varargout{2}=E; %All edges
varargout{3}=indBoundary; %Indices for boundary edges
 
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
