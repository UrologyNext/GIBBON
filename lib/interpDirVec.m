function [varargout]=interpDirVec(interpStruct,Vf,P_I)

% function [Vf_I,interpFun]=interpDirVec(interpStruct,Vf,P_I)
% ------------------------------------------------------------------------
% This function interpolates a direction vector field. Direction vectors
% are here defined as vectors indicating for instance a fibre direction
% such that for a vector 'v' actually defines the same fibre direction as
% the vector '-v'. Hence for interpolation special care must be taken to
% treat this property. 
% Firstly structure tensors are composed of the form V=v'*v. This tensor
% field is then interpolated (in 6 steps due to symmetry). The 1st
% principal eigenvectors of the interpolated tensors then forms the
% interpolated direction vector set. 
% The input is the a variable here called interpStruct. If interpStruct is
% a structure array it and may contain: 
% interpStruct.Points 
% interpStruct.Method (default is 'linear' if not provided)
% interpStruct.ExtrapolationMethod (default is 'none' if not provided)
% If however interpStruct is of the scatteredInterpolant class it will in
% addition contain:
% interpStruct.Values
% If interpStruct is not of the scatteredInterpolant class such a
% representation will be constructed.  
% The inputs are the position vectors interpStruct.Points (coordinates of
% vector origins), the direction or fibre direction vectors Vf, the
% position vectors P_I defining the interpolation coordinates,
% interpStruct.Method defining an interpolation method (default is
% 'linear') for the scatteredInterpolant function
% ('linear','natural','nearest'), and similarly
% interpStruct.ExtrapolationMethod defining the extrapolation method
% (default is 'none'). 
% 
% See also: scatteredInterpolant
%
% Kevin Mattheus Moerman
% gibbon.toolbox@gmail.com
% 
% 2014/12/10
%------------------------------------------------------------------------

%% Parse input

isInterpFun= isa(interpStruct,'scatteredInterpolant');

if ~isInterpFun
    if ~isfield(interpStruct,'Method')
        interpStruct.Method='linear';    
    end
    if ~isfield(interpStruct,'ExtrapolationMethod')
        interpStruct.ExtrapolationMethod='none';
    end
end

%%

%Create structure tensors through diadic product in nx6 form (A= v'*v)
A=[Vf.^2 Vf(:,2).*Vf(:,3) Vf(:,1).*Vf(:,3) Vf(:,1).*Vf(:,2)];

%Initialise fitted values
A_fit=zeros(size(P_I,1),6); 

if isInterpFun
    %Use interpStruct as interpFun
    interpFun=interpStruct;
    interpFun.Values=A(:,1); %Update values in interpolation structure
else
    %Initialize interpolation function on first scalar entry
    interpFun=scatteredInterpolant(interpStruct.Points,A(:,1),interpStruct.Method,interpStruct.ExtrapolationMethod);
end

%Interpolate for each of the 6 entries
for q=1:1:6
    if q>1
        interpFun.Values=A(:,q); %Update values in interpolation structure
    end
    A_fit(:,q)=interpFun(P_I); %Interpolate
end

%Create nx9 tensor representation
A_fit_tensor_array=[A_fit(:,1) A_fit(:,6) A_fit(:,5) A_fit(:,6) A_fit(:,2) A_fit(:,4) A_fit(:,5) A_fit(:,4) A_fit(:,3)];

%Convert to mxn cell array containing the 3x3 tensors
[A_fit_tensor_cell]=tensorArray2tensorCell(A_fit_tensor_array,[size(A_fit,1) 1]);

%Eigen decomposition on each cell entry
[Av,Ad]=cellEig(A_fit_tensor_cell);
% [Av,Ad]=cellfun(@eig,A_fit_tensor_cell,'UniformOutput',0);

%Find index of maximum eigenvalue
[~,indMax]=cellfun(@(x) max(diag(x)),Ad,'UniformOutput',0);
indMax=cell2mat(indMax);

%Get matching eigenvectors
Av_max=zeros(size(Ad,1),3);
for q=1:1:size(Ad,1)
    Av_max(q,:)=Av{q}(:,indMax(q));
end

%% Check result

% OLD CODE 
% %Compute trace (should sum to 1)
% Ad_sum_cell=cellfun(@trace,Ad,'UniformOutput',0);
% Ad_sum=cell2mat(Ad_sum_cell);
% logicReplace=(Ad_sum<(1-1e-3));
% Av_max(logicReplace,:)=nan(nnz(logicReplace),3);

Vf_I=Av_max;
[Vf_I]=vecnormalize(Vf_I);

% Invalid vectors have zero magnitude after normalisation (tested as <0.5 here)
H=sqrt(sum(Vf_I.^2,2)); 
logicReplace=(H<0.5);
Vf_I(logicReplace,:)=nan(nnz(logicReplace),3); %Replace invalid vectors witn NaNs

%% Create output

switch nargout
    case 1 
        varargout{1}=Vf_I; 
    case 2
        varargout{1}=Vf_I;
        interpFun.Values=zeros(size(interpFun.Values)); %Set to zeros
        varargout{2}=interpFun; 
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
