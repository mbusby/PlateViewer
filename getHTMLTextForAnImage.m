function [ htmlText ] = getHTMLTextForAnImage( fileName, altText, height, width)
    %{
    This gets the html text to insert an image
   
%}
    if height==0
        height=450;
        width=600;
    end
        
    [pathstr, name, ext]= fileparts(fileName);
    
    htmlText=strcat('<img src= ''./',name, ext, ''' alt=''',altText,''' height="', num2str(height), '" width="', num2str(width), '" border="2" </h4>');
   
end

