function [ output_args ] = MakePlateReport( metricsFileName, coordinatesFileName, metricBoundariesFileName, reportTitle, outputDirName )

    %{  
        File formats
        Metrics file:
            
            Sample Metric Score (float)    
        
        
        CoordinatesFile (file optional, must have coordinate for each
        sample if present - if no file put in dummy file name. All coordinates start at 1. Negative, zero values are ignored in plots.)
            Sample X Y Z

        Metric Boundaries (file optional, metrics optional - if no file put in a dummy file name)
            Metric  Min     Max  Plot

    use .matlab-2013a 
    mcc -m -o MakePlateReport -R -singleCompThread MakePlateReport.m


    clear
    metricsFileName='I:\MATLAB\PlateReport\metricsFile.txt';
    coordinatesFileName='I:\MATLAB\PlateReport\coordinatesFile.txt'; 
    metricBoundariesFileName='I:\MATLAB\PlateReport\metricBoundariesFile.txt'; 
    outputDirName='I:\MATLAB\PlateReport\';
    reportTitle='Wicked Cool Report';
    %}
   

    display('Making report')

    letters='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';    
    
   
    %======================================================================
    %Make output directory if it doesn't exist and start report
    
    if exist(outputDirName,'dir')==0
        try
            mkdir(outputDirName);
            display(strcat('Output directory does not exist.  Creating:', outputDirName));
        catch err
            display(strcat('Unable to find or make a directory with the name:', outputDirName));
            display('Please use a different name for the output directory.');
            rethrow(err)
        end
    end
    
    
    outputLogoName=[outputDirName, filesep, 'BTL-logo.png'];
    try
        copyfile('BTL-logo.png',outputLogoName)
    catch
        display('File BTL-logo.png not found. Copy it to the output directory to make reports pretty.')
    end
    
    outFileName=strcat(outputDirName, filesep, 'MetricsReport.html');    
    startBTLSingleCellReport( outFileName , reportTitle)
    htmlLines{1}=['<h1>' reportTitle '</h1>'];
    
    
    %======================================================================
    %Pull in the data
    
    try
        fid=fopen(metricsFileName, 'r');     
        importedData = textscan( fid, '%s %s %f','Delimiter', '\t', 'Headerlines', 1 );    
        sampleNameMetrics=importedData{1};
        metricNameMetrics=importedData{2};
        metricScore=importedData{3};
        
     catch
        error(['Metrics file ' metricsFileName ' not found. Cannot proceed.'])
        return;
    end
    
    try
        fid=fopen(coordinatesFileName, 'r');     
        importedData = textscan( fid, '%s %f %f %f','Delimiter', '\t', 'Headerlines', 1 );    
        sampleNameCoordinates=importedData{1};
        x=importedData{2};
        y=importedData{3};
        z=importedData{4};    
        coordinatesFound=1;
    catch
        warning('Coordinates file not found. Proceeding without heatmaps')
        coordinatesFound=0;
    end
    
    try    
        fid=fopen(metricBoundariesFileName, 'r');     
        importedData = textscan( fid, '%s %f %f %f','Delimiter', '\t', 'Headerlines', 1 );    
        metricNameBoundaries=importedData{1};
        minMetric=importedData{2};
        maxMetric=importedData{3};
        toPlot=importedData{4};
        heatmap=importedData{4};
        boundariesFound=1;
    catch
        warning('Boundaries file not found. Will make some up.')
        boundariesFound=0;
        metricNameBoundaries='None';
        minMetric=0;
        maxMetric=0;
        heatmap=0;
    end
   
 
    %======================================================================
    %Get Unique Sample Names And Metrics from Metrics File
    %Assume metric files is the "truth"
    uniqueMetrics=sort(unique(metricNameMetrics));
    uniqueSamples=sort(unique(sampleNameMetrics));
    
    
   
    
    %======================================================================
    %Make whisker plots for each metric   
    htmlLines{end+1}='<h2>Summary Metrics:</h2>';
     
    htmlLines{end+1}='<table class="table1"> ';
    for i=1:length(uniqueMetrics)
        metricToPlot=uniqueMetrics{i};
        valuesToPlot=metricScore(strcmp(metricNameMetrics, metricToPlot));
        
        if sum(strcmp(metricNameBoundaries, metricToPlot))>0
            b=find(strcmp(metricNameBoundaries, metricToPlot));
            minMetricToPlot=minMetric(b(1)) ; %Just take the first if there are multiple entries (errors)    
            maxMetricToPlot=maxMetric(b(1)) ;
            if length(b)>1
                warning(['Too many boundary entries for ' metricToPlot '. Ignoring extras.'])
            end     
            
            if isempty(b)==1
                warning(['No boundary entries found for ' metricToPlot '.'])
                minMetricToPlot=min(valuesToPlot);
                maxMetricToPlot=max(valuesToPlot);
            end
        else
            minMetricToPlot=min(valuesToPlot);
            maxMetricToPlot=max(valuesToPlot);
        end
           

        [ whiskerPlot ] = getWhiskerPlotServer(metricToPlot, valuesToPlot, minMetricToPlot, maxMetricToPlot );     
    
        
        plotFileName=[outputDirName, filesep, 'Metric_', num2str(i), '.png'];

        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf, 'PaperPosition', [0.1 0.1 16 1.5]); %x_width=10cm y_width=15cm

        print(whiskerPlot, '-dpng' , plotFileName , '-r600'); %png        
         
        htmlLines{end+1}=['<tr><td align="right">' metricToPlot '</td><td align="left">' getHTMLTextForAWhiskerImage( plotFileName, plotFileName, 50, 500) '</td></tr>'];  
        htmlLines{end+1}='<br>';  
    
    end
     htmlLines{end+1}='</table>';
     
    %======================================================================
    %Make heat maps for important metrics 
    if boundariesFound==1
        metricsToPlot=metricNameBoundaries(heatmap==1)
    else
        metricsToPlot=uniqueMetrics;
    end
    
    if length(sampleNameCoordinates)==length(uniqueSamples)
        uniqZ=unique(z(z>0));
        
        %First make a table of the sample layout
        htmlLines{end+1}='<h2>Sample layout:</h2>';        
       
        for j=1:length(uniqZ) 
            
            htmlLines{end+1}=['<h3>Plate:' num2str(uniqZ(j)) '</h3>'];  
            
            for i=1:length(sampleNameCoordinates)
                if x(i)>0 & y(i)>0 & z(i)==uniqZ(j) & uniqZ(j)>0
                  samples{ y(i), x(i)}=sampleNameCoordinates{i};   
                end
            end  
            
             for i=1:size(samples,2)
                columnHeaders{i}=num2str(i);
            end

            for i=1:size(samples,1)
                rowHeaders{i}=letters(i);
            end

            tableText=getHTMLTextForATableSingleCell( columnHeaders, rowHeaders, samples); 
            for i=1:length(tableText)
                htmlLines{end+1}=tableText{i};
            end
        end
     
        for i=1:length(metricsToPlot)
            
            metricDataToPlot=metricScore(strcmp(metricNameMetrics, metricsToPlot{i}));
            metricToPlotSampleNames=sampleNameMetrics(strcmp(metricNameMetrics, metricsToPlot{i}));               
            
            clear metricsDataWithCoordinates;
            
            
            for j=1:length(uniqZ)
                
                clear metricsDataWithCoordinates;
                for k=1:length(sampleNameCoordinates)
                    if x(k)>0 & y(k)>0 & z(k)==uniqZ(j)
                        try
                            metricsDataWithCoordinates(y(k), x(k))=metricDataToPlot(strcmp(metricToPlotSampleNames,sampleNameCoordinates{k})); 
                        catch
                            display('Problem adding value to plot');
                            display('Sample:',sampleNameCoordinates{k});
                            display('Metric:',metricsToPlot{i});
                        end
                    end
                end  
                
                heatPlot=figure();
                colormap(cool)
              
                imagesc(metricsDataWithCoordinates)
                colorbar
                set(gca, 'XTick', 1:length(columnHeaders), 'XTickLabel', columnHeaders)
                set(gca, 'YTick', 1:length(rowHeaders),'YTickLabel', flipud(rowHeaders))

                plotFileName=[outputDirName, filesep, 'Map_', num2str(i), 'Plate', num2str(uniqZ(j)), '.png'];
                print(heatPlot, '-dpng' , plotFileName , '-r500'); %png

                htmlLines{end+1}='<p style="page-break-before: always">';
                htmlLines{end+1}=['<h3>' metricsToPlot{i} '</h3>' ];
                htmlLines{end+1}=['<h4> Plate:' num2str(uniqZ(j))  '</h4>' ];
                htmlLines{end+1}= getHTMLTextForAnImage( plotFileName, 'Heatmap', 0, 0);
            end
            
            
        end
    end 
     
     
    %======================================================================
    %End and print report   
    htmlLines{end+1}='<br><small>Report designed with assistance from the bam.iobio team. <br>End Of Report</small></html>';
    fid=fopen(outFileName, 'a'); 
    for i=1:length(htmlLines)
        fprintf(fid,'%s\n',htmlLines{i});
    end
    
    output_args=0;
    close all
    fclose all

end

