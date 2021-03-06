function [X_mean]=wmean(X,W)

% function [X_mean]=wmean(X,W)
% ------------------------------------------------------------------------
% This function calculates the weighted mean of X using the weights defined
% in the vector W. 
%
% Uses the following formula: X_mean=sum(X.*W)./sum(W);
%
% 12/09/2008
% ------------------------------------------------------------------------

%%

X=X(:);
W=W(:);
X_mean=sum(X.*W)./sum(W);

%% END
 
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
