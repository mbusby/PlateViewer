function [ whiskerPlot ] = getWhiskerPlotServer(metricName, values, minMetric, maxMetric )
        
       %{
       Test values:
       metricName='IQ points are silly 239000234-0';
       values=poissrnd(100,20,1) 
       minMetric=75;
       maxMetric=160;
       
       
       if length(metricName)>20
            warning(['The length of the metric name, ' metricName ' is too long. This may result in an ugly chart.']) 
       end
       
       if length(metricName)<20
            metricName=[repmat(' ', 1, 20-length(metricName)), metricName];
       end
       
%}
       %If min and max are outside boundaries, adjust boundaries
    
       display('Getting whisker plot...')
       
       if min(values)<minMetric
           minMetric=min(values);
       end
       
       if max(values)>maxMetric
           maxMetric=max(values);
       end
     
       
       ys=ones(size(values));
       
       whiskerPlot = figure('Position', [1 1 400 50], 'Visible', 'off');
       
    
      % set(gca, 'PaperSize', [400 50])
       hold on
       axis([minMetric maxMetric 0 2])
       plot([minMetric maxMetric], [1 1], '-', 'Color', [0.8 0.8 0.8])
       plot(values,ys, '+', 'Color', [0.0564    0.4549    0.7180])
       set(gca,'xtick',[minMetric maxMetric])
       set(gca,'ytick',[ ])
       if maxMetric>1000
        set(gca,'xticklabel',[''])
       else
        set(gca,'xticklabel',['  '])
       end
       wiggle=(maxMetric-minMetric)/100;
       
       text(minMetric+wiggle, -0.8, num2str(minMetric), 'HorizontalAlignment', 'left')
       text(maxMetric-wiggle, -0.8, num2str(maxMetric), 'HorizontalAlignment', 'right')
  
    
       box on
    
   %   tightInset = get(gca, 'TightInset');
   %   position(1) = tightInset(1);
   %    position(2) = tightInset(2);
   % position(3) = 1 - tightInset(1) - tightInset(3);
   %  position(4) = 1 - tightInset(2) - tightInset(4);
 

   % position(1)=0.0418
   % position(2)=0.0492 
   % position(3)=0.9517
   % position(4)= 0.9325
    



end

