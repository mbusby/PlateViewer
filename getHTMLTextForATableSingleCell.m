function [ htmlText ] = getHTMLTextForATableSingleCell( columnHeaders, rowHeaders, data )
    %{
    This gets the html text for a table
    <table border="1">
  <tr>
    <th>Month</th>
    <th>Savings</th>
  </tr>
  <tr>
    <td>January</td>
    <td>$100</td>
  </tr>
</table> 
%}
    %Check that the row and column headers are correct
  
    if(size(data,1)~=length(rowHeaders) || size(data,2)~=length(columnHeaders))
        htmlText='ERROR: the number of column and row headers is not the same as the data'
        display('ERROR: the number of column and row headers is not the same as the data');
        display(['data is ' num2str(size(data,1)) 'long and ' num2str(size(data,2)) 'wide']);
        display(['There are ' num2str(length(columnHeaders)) 'column headers and  ' num2str(length(rowHeaders)) 'row headers']);
        
        return;
    end
   
    htmlText{1,1}='<table class="table2" ><tr><td>-</td>';
   
    for i=1:length(columnHeaders)
        htmlText{end+1,1}=strcat('<th>',columnHeaders{i},'</th>');
    end
   
    htmlText{end+1,1}='</tr>';  
    
    for i=1:length(rowHeaders)
        
        htmlText{end+1,1}=strcat('<tr><th>', rowHeaders{i}, '</th>');
        for j=1:size(data,2)
            if strcmp(class(data(i,j)),'double')==1
                htmlText{end+1,1}=strcat('<td>', num2str(data(i,j)), '</td>');      
            else
                try
                    htmlText{end+1,1}=strcat('<td>', data{i,j}, '</td>');
                catch
                    htmlText{end+1,1}=strcat('<td>', data(i,j), '</td>');
                end
            end
        end
        htmlText{end+1,1}='</tr>';
    end
       
    
    htmlText{end+1}='</table>';
   
end

