function handle=extbar(loc,bar,label)
%extbar Display color bar (color scale).
%   mybar('vert',bar,label) appends a vertical color scale to the current
%   axis. mybar('horiz',bar,label) appends a horizontal color scale.
%   label is a string to label the axis.
%   bar is a vector of values to put in the bar.
%
%   mybar(H) places the colorbar in the axes H. The colorbar will
%   be horizontal if the axes H width > height (in pixels).
%
%   mybar without arguments either adds a new vertical color scale
%   or updates an existing colorbar.
%
%   H = mybar(...) returns a handle to the colorbar axis.

%   Clay M. Thompson 10-9-92
%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 5.18 $  $Date: 1996/10/22 15:10:46 $

%   modified COLORBAR to add label D. Rudnick 9-5-97
%   modified to be extbar D. Rudnick Oct 8, 1997.

%   If called with COLORBAR(H) or for an existing colorbar, don't change
%   the NextPlot property.
changeNextPlot = 1;
bar=bar(:)';

if nargin<1, loc = 'vert'; end
ax = [];
if nargin==1,
    if ishandle(loc)
        ax = loc;
        if ~strcmp(get(ax,'type'),'axes'),
            error('Requires axes handle.');
        end
        units = get(ax,'units'); set(ax,'units','pixels');
        rect = get(ax,'position'); set(ax,'units',units)
        if rect(3) > rect(4), loc = 'horiz'; else loc = 'vert'; end
        changeNextPlot = 0;
    end
end

% Determine color limits using caxis.

t=caxis;
h = gca;

if nargin==0,
    % Search for existing colorbar
    ch = get(gcf,'children'); ax = [];
    for i=1:length(ch),
        d = get(ch(i),'userdata');
        if prod(size(d))==1 & isequal(d,h), 
            ax = ch(i); 
            pos = get(ch(i),'Position');
            if pos(3)<pos(4), loc = 'vert'; else loc = 'horiz'; end
            changeNextPlot = 0;
            break; 
        end
    end
end

origNextPlot = get(gcf,'NextPlot');
if strcmp(origNextPlot,'replacechildren') | strcmp(origNextPlot,'replace'),
    set(gcf,'NextPlot','add')
end

if loc(1)=='v', % Append vertical scale to right of current plot
    
    if isempty(ax),
        units = get(h,'units'); set(h,'units','normalized')
        pos = get(h,'Position'); 
        [az,el] = view;
        stripe = 0.03; edge = 0.02; 
        if all([az,el]==[0 90]), space = 0.05; else space = .1; end
        set(h,'Position',[pos(1) pos(2) pos(3)*(1-stripe-edge-space) pos(4)])
        rect = [pos(1)+(1-stripe-edge)*pos(3) pos(2) stripe*pos(3) pos(4)];
        
        % Create axes for stripe
        ax = axes('Position', rect);
        set(h,'units',units)
    else
        axes(ax);
    end
    
    % Create color stripe
    contourf([0 1],bar,[bar; bar]',bar);
    set(ax,'YAxisLocation','right')
    set(ax,'xtick',[])
    ylabel(label);	%my addition to get label
    
else, % Append horizontal scale to top of current plot
    
    if isempty(ax),
        units = get(h,'units'); set(h,'units','normalized')
        pos = get(h,'Position');
        stripe = 0.03; space = 0.1;
        set(h,'Position',...
            [pos(1) pos(2)+(stripe+space)*pos(4) pos(3) (1-stripe-space)*pos(4)])
        rect = [pos(1) pos(2) pos(3) stripe*pos(4)];
        
        % Create axes for stripe
        ax = axes('Position', rect);
        set(h,'units',units)
    else
        axes(ax);
    end
    
    % Create color stripe
    contourf(bar,[0 1],[bar; bar],bar);
    set(ax,'ytick',[])
    xlabel(label);	%my addition to get label
    
end
set(ax,'layer','top','CLim',t);
set(ax,'userdata',h)
set(gcf,'CurrentAxes',h)
if changeNextPlot
    set(gcf,'Nextplot','ReplaceChildren')
end

if nargout>0, handle = ax; end


