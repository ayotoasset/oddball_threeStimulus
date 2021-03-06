function [p, styleHandles, yLims] = ...
    plot_sessionScatterSubplot(normData, chToPlot, normalizationTypes, erpBandType, erpTypes, rows, cols, normType, stim, ch, index, fieldValue, erpComponent, erpDataType, noOfSessions, subjects, handles)

    [~, handles.flags] = init_DefaultSettings(); % use a subfunction    
    if 1 == 1
        debugMatFileName = 'tempScatterSubplot.mat';
        if nargin == 0
            load('debugPath.mat')
            load(fullfile(path.debugMATs, debugMatFileName))
            close all
        else
            if handles.flags.saveDebugMATs == 1
                path = handles.path;
                save('debugPath.mat', 'path')
                save(fullfile(path.debugMATs, debugMatFileName))            
            end
        end
    end

    i = 1;  
    x = 1:1:4;

    % displace the x-axis a bit for better visualization
    x_displ = 0.175;
    x1 = x;
    x2 = x - x_displ;
    x3 = x + x_displ;

    % normData
    % normData.target
    % erpTypes{stim}
    % normData.(erpTypes{stim})
    for session = 1 : noOfSessions
        y1(session,:) = normData.(erpTypes{stim}).dark.(chToPlot){session}.mean;
        y2(session,:) = normData.(erpTypes{stim}).dim.(chToPlot){session}.mean;
        y3(session,:) = normData.(erpTypes{stim}).bright.(chToPlot){session}.mean;

        err1(session,:) = normData.(erpTypes{stim}).dark.(chToPlot){session}.SD;
        err2(session,:) = normData.(erpTypes{stim}).dim.(chToPlot){session}.SD;
        err3(session,:) = normData.(erpTypes{stim}).bright.(chToPlot){session}.SD;    
    end
    
    % Customize the color scale, use the distinguishable_colors from Matlab
    % FileExchange by Tim Holy, http://www.mathworks.com/matlabcentral/fileexchange/29702-generate-maximally-perceptually-distinct-colors
    % See also: http://blogs.mathworks.com/pick/2008/08/15/colors-for-your-multi-line-plots/
    ColorSet = distinguishable_colors(length(y1));
    set(gca, 'ColorOrder', ColorSet);

    % PLOT
    hold on
    %{
    p(1) = errorbar(x1', y1, err1, 'ko');
    p(2) = errorbar(x2, y2, err2, 'r*');
    p(3) = errorbar(x3, y3, err3, 'ro');
    %}
    p(1,:) = plot(x1, y1, 'square');
    p(2,:) = plot(x2, y2, '*');
    p(3,:) = plot(x3, y3, 'o');
    hold off
    

    [noOfCond, noOfSubjects] = size(p);
    for c =  1 : noOfCond
        for s = 1 : noOfSubjects
            set(p(c,s), 'MarkerFaceColor', get(p(c,s), 'Color'));
            legString{s} = subjects{s};
        end
    end       
    
    % Annotations
    
        % number of non-NaN subjects per plot
        yOffset = 1.1;
        yOffset2 = 0.01;
        for ll = 1 : length(x1)
            noOfNotNans = sum(~isnan(y1(ll,:)));
            tx(1,ll) = text(x1(ll), max(y1(ll,:))*yOffset + yOffset2, num2str(noOfNotNans));
        end
           
        for ll = 1 : length(x2)
            noOfNotNans = sum(~isnan(y3(ll,:)));
            tx(2,ll) = text(x2(ll), max(y2(ll,:))*yOffset + yOffset2, num2str(noOfNotNans));
        end
        
        for ll = 1 : length(x3)
            noOfNotNans = sum(~isnan(y2(ll,:)));
            tx(3,ll) = text(x3(ll), max(y3(ll,:))*yOffset + yOffset2, num2str(noOfNotNans));
            
        end
        set(tx, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontAngle', 'Italic')

        % explanations
        if index == 1
            tExpl = text(0.5,0,'Colors correspond to subjects');
        elseif index == 2
            tExpl = text(0.5,0,'Symbols correspond to conditions');
        else
            tExpl = text(0,0,'');
        end


        % title & ylabel
        if rem(index-1,cols) == 0 || index == 1 % for each row
            %normalizationTypes
            %normType
            normString = normalizationTypes{normType};

            if strcmp('absolute', normString)
                if strcmp(erpComponent, 'RT')
                    yLabelString = 'Latency [ms]';
                else
                    yLabelString = '\muV';
                end
            else
                yLabelString = '\Delta';
            end    
            
        elseif (index - (floor(index/cols)*cols)) == 4
            normString = erpComponent;
            yLabelString = ' ';
        elseif (index - (floor(index/cols)*cols)) == 2
            normString = fieldValue;                
            yLabelString = erpBandType;
        elseif (index - (floor(index/cols)*cols)) == 0
            normString = erpDataType;                
            yLabelString = ' ';                
        else                
            normString = ' ';
            yLabelString = ' ';
        end

        if rem(index, length(chToPlot)) ~= 0
            stimString = erpTypes{stim};
        else
            stimString = ' ';
        end
        
        titString = sprintf('%s\n%s\n%s', normString, stimString, chToPlot);            
        styleHandles.tit = title(titString);

        % xlabel
        if (rows - 1)*cols < index
            xLabString = sprintf('%s', 'Session');
        else
            xLabString = ' ';
        end
        styleHandles.xLab = xlabel(xLabString);

        % ylabel
        styleHandles.yLab = ylabel(yLabelString);

        % LEGEND
        if strcmp(erpComponent, 'RT')
            if index == 1
                leg = legend('dark', '10lux', '40lux', 3);
                    %legend('boxoff')
                    set(leg, 'Location', 'NorthWest')
                    set(leg, 'Position', [0.807142193308545 0.911998913043478 0.160780669144981 0.0654891304347826])
            else
                leg = legend(' ', ' ', ' ', 3);
                    legend('hide')
            end

        else
            
            if index == cols
                leg = legend(legString);
                    set(leg, 'Position',[0.908895502645501 0.744701086956522 0.0439814814814815 0.152853260869565])
                    
            elseif (index - (floor(index/cols)*cols)) == 0
                leg = legend('dark', '10lux', '40lux', 3);
                    %legend('boxoff')
                    set(leg, 'Location', 'NorthWest')
                    set(leg, 'Position', [0.9034 0.2538 0.050776 0.04918])
            else
                leg = legend(' ', ' ', ' ', 3);
                    legend('hide')
            end
        end


    % Style
    set(gca, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1)
    set(tExpl, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase, 'FontAngle', 'italic')
    set(styleHandles.tit, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase, 'FontWeight', 'bold')
        set(styleHandles.tit, 'HorizontalAlignment', 'center')
    set(styleHandles.xLab, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase, 'FontWeight', 'bold')
    set(styleHandles.yLab, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase, 'FontWeight', 'bold')
    set(leg, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
        set(leg, 'EdgeColor', [.4 .4 .4])

    % plots
    set(p, 'MarkerSize', handles.style.markerSize)
    
    % get y limits
    yLims = [min(min(([y1 y2 y3]))) max(max(([y1 y2 y3])))];

