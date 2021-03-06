function [ status ] = startBTLSingleCellReport( outFileName , reportTitle)
    %Starts the HTML report by setting up the headers
    
    htmlLines={ '<html> '; ...
    '<head><title>';...
    reportTitle;
    '</title>'; ...
    '<style type="text/css">'; ...
   
    'body {'; ...
    '	font-family: Sans-Serif;'; ...
    '   text-align: justify;'; ...
    '}'; ...
   
    
    'table.table1 {' ;...
    %'  border-collapse: collapse'; ...   
    '}'; ...
    'table.table2 {' ;...
    %'  border-collapse: collapse'; ... 
    '   width: 400px;';...
    '}'; 
    'table th {'; ...
    %'	border-width: 0px;'; ...
    '	padding: 0px;'; ...
   % '	border-style: solid;'; ...
   % '	border-color: gray;'; ...
    '	background-color: rgb( 194 ,  210,  210);'; ...
      '   font-size : 95%;'; ...
    '}'; ...
    'table.table1 td {'; ...
    '	border-width: 0px;'; ...
    '	padding: 1px;'; ...
    '	border-style: solid;'; ...
    '	border-color: gray;'; ...
    '	background-color: white;'; ...
    '}'; ...
    
    'table.table2 td {'; ...
    '	border-width: 1px;'; ...
    '	padding: 2px;'; ...
    '	border-style: solid;'; ...
    '	border-color: gray;'; ...
    '	background-color: white;'; ...
    '   font-size: 60%;'; ...
    '}'; ...
    
    '.crop {'; ...
    'width: 400px;'; ...
   ' height: 50px;'; ...
    'overflow: hidden;'; ...
	'}'; ...
    
    
    '.crop img {'; ...
    '    width: 400px;'; ...
    'height: 50px;'; ...
    '}'; ...

    
    '</style>'; ...
    '</head>'; ...
    '<body>'; };
  
    fid=fopen( outFileName, 'w');  
    
    htmlLines{end+1}=strcat('<img src= ./BTL-logo.png alt=''BTL'' height=100 width=140 >');
    
    for i=1:length(htmlLines)
        fprintf(fid,'%s\n',htmlLines{i});
    end
    
    
end

