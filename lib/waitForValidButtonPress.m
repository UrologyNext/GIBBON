function [k,c,b]=waitForValidButtonPress

% function [k]=waitForValidButtonPress
% ------------------------------------------------------------------------
% This function is based on the sub-function WFBP found in the |ginput|
% function. It is equivalent to the |waitforbuttonpress| function with the
% exection that that ^C is reserved to end the function as usual. 
%
%
% Kevin Mattheus Moerman
% kevinmoerman@hotmail.com
% 03/10/2014
%------------------------------------------------------------------------

% Disabling ^C for edit menu so the only ^C is for interrupting the function.
fig = gcf;
waserr=0;
try    
    
    h=findall(fig,'type','uimenu','accel','C');
    set(h,'accel','');
    keyDown = waitforbuttonpress;
    current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
    if~isempty(current_char) && (keyDown == 1)           % If the character was generated by the
        if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
            waserr = 1;                             % so that it errors out.
        end
    end   
catch
    waserr = 1;
end
set(h,'accel','C');                                 % Set back the accelerator for edit menu.
drawnow;

if(waserr == 1)
    error('MATLAB:waitForValidButtonPress:Interrupted', 'Interrupted');
end

k = keyDown;
c = get(fig,'CurrentCharacter');
b = abs(get(fig,'CurrentCharacter'));
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
