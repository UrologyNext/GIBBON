function [varargout]=parLimNat(varargin)

% function [xx,S]=parLimNat(xx_c,[xx_min xx_max],x);
% ------------------------------------------------------------------------
%
%
%
% Kevin Mattheus Moerman
% gibbon.toolbox@gmail.com
% 
% 2015/06/30 Updated for GIBBON, fixed case for limits equal to centre
% 2015/08/31 Fixed behaviour for empty x, changed to varargin
%------------------------------------------------------------------------

%%

xx_c=varargin{1};
xxlim=varargin{2};

switch nargin       
    case 2
        x=[];
    case 3 
        x=varargin{3};
end

%%

if isempty(xx_c)
    xx_c=mean(xxlim);
end

if diff(xxlim)<eps(xx_c)
    error('Limits xxlim are too similar');
end

if xxlim(1)>xx_c
    error('Lower limit should be lower or equal to centre');
end

if xxlim(2)<xx_c
    error('Upper limit should be higher or equal to centre');
end

%%

wn=abs(xx_c-xxlim(1));
L_wn=wn<eps(xx_c);
if L_wn
   warning('Centre should not coincide with lower limit. Transition will not be smooth'); 
end

wp=abs(xxlim(2)-xx_c);
L_wp=wp<eps(xx_c);
if L_wp
   warning('Centre should not coincide with upper limit. Transition will not be smooth'); 
end

%%

nc=6; 

if L_wn
    xtn=xx_c;
else
    xtn=linspace(xx_c-2*wn,xx_c,nc);
end

if L_wp
    xtp=xx_c;
else
    xtp=linspace(xx_c,xx_c+2*wp,nc);
end

xt=[xtn xtp(2:end)];
xtlim=[min(xt(:)) max(xt(:))];

xxt=xt;

Ln=xt<=xx_c;
if L_wn
    xxt(Ln)=0;
else
    xxt(Ln)=erf(1/wn*2*(xt(Ln)-xx_c));
    xxt(Ln)=xxt(Ln)*wn;
end

Lp=xt>xx_c;
if  L_wp
    xxt(Lp)=[];
else
    xxt(Lp)=erf(1/wp*2*(xt(Lp)-xx_c));
    xxt(Lp)=xxt(Lp)*wp;
end
xxt=xxt+xx_c;

%% Construct and evaluate Piecewise Cubic Hermite Interpolating Polynomial 
pp = pchip(xt,xxt); 
if ~isempty(x)
    xx=ppval_extrapVal(pp,x,xtlim,xxlim);
else
    xx=[];
end

%% Create output
varargout{1}=xx; 
switch nargout
    case 2      
        %Create additional output structure
        S.pp=pp;
        S.interplim=xtlim;
        S.extrapVal=xxlim;        
       
        varargout{2}=S;
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
