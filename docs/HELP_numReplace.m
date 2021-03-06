%% numReplace
% Below is a demonstration of the features of the |numReplace| function

%%
clear; close all; clc;

%% REPLACING NUMBERS IN ARRAYS
%%
% An example array
A=[0,-6,3,0,0;-1,-4,-7,-9,-9;-4,-7,11,-5,12;10,-7,5,-7,13;0,11,-2,-6,2;12,4,2,-5,NaN]

%%
% Defining the input array for entries (NaN's allows) that need to be replaced
a=[2 -5 nan 0]
%%
% Defining the numbers (NaN's allows) to take their place
b=[991 992 993 994]; %Numbers to take their place

%%
% Replacing the numbers using |numReplace|
B=numReplace(A,a,b)

%% NOTES ON PERFORMANCE FOR NON-INTEGERS
% The |numReplace| function employs the |ismember| function. Hence it is
% suitable for all number cases where ismember is able to detect
% membership. Numerical precission difficulties may arise for non-integer
% entires. Consider the below: 

logicMember=ismember(pi,pi+eps(pi))
logicMember=ismember(pi,pi+eps(pi)/10)

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
