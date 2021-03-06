function [Vs]=trisurfsmoothHC(F,V,IND_V,alp,bet,tol,n,disp_on)

%Humphreys Classes Smoothening

% alpha [0..1] influence of original/previous points 0-> full previous, 1-> full original
% beta  [0..1] e.g. > 0.5

if isempty(IND_V)
    [~,IND_V]=patchIND(F,V);
end

L=IND_V>0;
Xp=NaN(size(IND_V));  Yp=NaN(size(IND_V));  Zp=NaN(size(IND_V));

p=V; cc=0; i=1;
while cc==0
    q=p;
    Xp(L)=p(IND_V(L),1); Yp(L)=p(IND_V(L),2); Zp(L)=p(IND_V(L),3);
    p=[nanmean(Xp,2) nanmean(Yp,2) nanmean(Zp,2)]; %Mean of neighbourhood, Laplacian operation
    SSQD_new=nansum((p(:)-q(:)).^2);
    if i>1
        SSQD_ratio=SSQD_new./SSQD_old;
        if disp_on
            disp(['Iteration ',num2str(i),', SSQD ratio: ',num2str(SSQD_ratio)]);
        end
        if abs(1-SSQD_ratio)<=tol
            cc=1; %Convergence tolerance achieved
            if disp_on
                disp('Convergence tolerance on SSQD ratio reached!');
            end
        end
    else
        if disp_on
            disp(['Iteration ',num2str(i),', SSQD initial: ',num2str(SSQD_new)]);
        end
    end
    
    if i>=n
        cc=1;
        if disp_on
            disp('Maximum number of iteration reached!');
        end
    end
    SSQD_old=SSQD_new;
    
    b=p-((alp.*V)+((1-alp).*q)); %Difference at centre vertex
    Xp(L)=b(IND_V(L),1); Yp(L)=b(IND_V(L),2); Zp(L)=b(IND_V(L),3);
    c=[nanmean(Xp,2) nanmean(Yp,2) nanmean(Zp,2)]; %Mean of difference at centre vertex of neighbourhood
    p=p-((bet.*b)+(1-bet).*(c));
    i=i+1;
end

Vs=p;

 
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
