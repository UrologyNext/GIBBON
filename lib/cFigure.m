function [h]=cFigure(varargin)

% function [h]=cFigure(figStruct)
% ------------------------------------------------------------------------
% Creates a custom figure using the input structure figStruct. The cFigure
% function provides easy control of background color, the color
% definitions, the figure window size (e.g. near maximal), and enables
% figure property cloning. It also allows users to create hidden figures
% which can be made visible for instance using the mfv command. 
% 
% The content of figStruct may follow all properties of a normal figure 
% i.e. such that figStruct=figure. Which could lead to (amonst other
% properties):
%
% figStruct=figure
% 
%   Figure (1) with properties:
% 
%       Number: 10
%         Name: ''
%        Color: [0.9400 0.9400 0.9400]
%     Position: [680 558 560 420]
%        Units: 'pixels'
%        
% figStruct used to be a handle in which case its use in this function
% involves the set command e.g.: set(h,'outerPosition',[a b c d]); 
% For newer MATLAB versions however the cFigure function uses a different
% but equivalent syntax i.e.:
% h.outerPosition=[a b c d];
% 
% Some additional fields can be added that are not normally part of the
% figure property set: ColorDef and ScreenOffset. 
% ColorDef sets the color definition which is either 'white' or 'black'.
% This allows the user to select a dark background and appropriately set
% the colorscheme for it e.g. for a black background:
%         figStruct.ColorDef='black';
%         figStruct.Color='k';
% Where the Color property sets the figure background color while the
% ColorDef property sets the colorscheme used (of axes etc.).
% By default cFigure creates figures that are the full screensize but
% reduced 10% away from the edges. The spacing between the figure window
% and the screen edges is set by the figStruct.ScreenOffset property. The
% units are pixels. 
% 
% See also: figure, set, get, colordef, mfv, scf
%
% Kevin Mattheus Moerman
% gibbon.toolbox@gmail.com
% 
% 2014/11/25
%------------------------------------------------------------------------

%% Parse input and set defaults

switch nargin
    case 0
        %Create defaults
        figStruct.Visible='on';
        figStruct.ColorDef='white';
        figStruct.Color='w';
        screenSizeGroot = get(groot,'ScreenSize');
        figStruct.ScreenOffset=round(max(screenSizeGroot)*0.1); %i.e. figures are spaced around 10% of the sreensize from the edges
    case 1
        %Use custom
        figStruct=varargin{1};
        
        %Use defaults where nothing is provided
        if ~isfield(figStruct,'Visible');
            figStruct.Visible='on';
        end
        
        if ~isfield(figStruct,'ColorDef');
            figStruct.ColorDef='white';
        end
        
        if ~isfield(figStruct,'Color');
            figStruct.Color='w';
        end
        
        if ~isfield(figStruct,'ScreenOffset');
            screenSizeGroot = get(groot,'ScreenSize');
            figStruct.ScreenOffset=round(max(screenSizeGroot)*0.1); %i.e. figures are spaced around 10% of the sreensize from the edges
        end
end

%% Create a hidden figure

h = figure('Visible', 'off'); %create an invisible figure

%% Setcolor definition and associated defaults

h=colordef(h,figStruct.ColorDef); %Update figure handle
figStruct=rmfield(figStruct,'ColorDef'); %Remove field from structure array

%% Set figure size

if isfield(figStruct,'ScreenOffset');
    screenSizeGroot = get(groot,'ScreenSize');
    screenSizeGroot=screenSizeGroot(3:4); % width, height
    figSizeEdgeOffset=figStruct.ScreenOffset; % Figure offset from border
    figSize=screenSizeGroot-figSizeEdgeOffset; % width, height
    try %new
        h.units='pixels';
        h.outerPosition=[(screenSizeGroot(1)-figSize(1))/2 (screenSizeGroot(2)-figSize(2))/2 figSize(1) figSize(2)]; % left bottom width height
    catch %old        
        set(h,'units','pixels');
        set(h,'outerPosition',[(screenSizeGroot(1)-figSize(1))/2 (screenSizeGroot(2)-figSize(2))/2 figSize(1) figSize(2)]); % left bottom width height
    end
    figStruct=rmfield(figStruct,'ScreenOffset'); %Remove field from structure array   
end

%% Parse remainint figure properties

% Note: This is where figure becomes visible if figStruct.Visible='on'

fieldSet = fieldnames(figStruct); % Cell containing all structure field names
for q=1:1:numel(fieldSet)
    try %new
        fieldNameCurrent=fieldSet{q};
        h.(fieldNameCurrent)=figStruct.(fieldNameCurrent);
    catch %old
        try  
            set(h,fieldNameCurrent,figStruct.(fieldNameCurrent));
        catch errorMsg
            rethrow(errorMsg); %likely false option
        end        
    end
end
