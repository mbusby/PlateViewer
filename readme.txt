Purpose:

The purpose of this report is to take any data that is run in a plate (or other spatial) format and display the values on a grid.

It is in Matlab (yeah, yeah...) but you should be able to run the compiled tool without a license if you so choose as long as you have the matlab runtime complier installed.  

It is in beta so it may have bugs.

This is a general reporting tool. There are two required input files: a coordinates file and a metrics file.  

The metrics file has the sample, the metric as it will be displayed in the report, and then the value of the metric for that sample. The coordinate file has the position of the sample on the plate. The sample name serves as a key between the two files. The name, therefore, has to be exactly the same and is case sensitive.
This is a beta version and the program is not fully debugged.
Known bugs:
If the metrics file contains extra lines at the bottom the program will crash.
% at then end of data will make it crash. Format as number and save without the %.
To run:
set up environment to call the Matlab runtime compiler:
e.g at the Broad:
use .matlab_2013a_mcr
Run the command in this format,
MakePlateReport metricsFileName  coordinatesFileName  metricBoundariesFileName  reportTitle  outputDirName 

For example:
cd PlateReportingTool/current
use .matlab_2013a_mcr
./MakePlateReport ../DemoData/metricsFile.txt ../DemoData/coordinatesFile.txt ../DemoData/metricBoundariesFile.txt 'Test Report' ../DemoData/testReport

There are some demo files here to use.


FILE FORMATS
 Metrics file:
  A tab delimited file with three columns and a header line.    
The columns are Sample (string), Metric (string), Score (number – do not include %!)
For example:

Sample	Metric	 Value 
B2_SM-AFTD9_Link41	Total Reads	               293,522
B2_SM-AFTDA_Link11	Total Reads	               449,417
B2_SM-AFTDB_Link60	Total Reads	               682,553
B2_SM-AFTDL_Link36	Total Reads	           1,086,100
B2_SM-AFTDM_Link35	Total Reads	               282,978
B2_SM-AFTDN_Link76	Total Reads	               726,656
B2_SM-AFTDX_Link22	Total Reads	               281,881
B2_SM-AFTDY_Link43	Total Reads	               858,213
Etc.
        
        
 CoordinatesFile
This has the x-y location of the well in the plate. All coordinates start at 1. The well in the upper left hand corner of the first plate is 1 1 1 
Negative and zero values are ignored in plots            Sample X Y Z
Sample	X	Y	Z
B2_SM-AFTD9_Link41	1	1	1
B2_SM-AFTDA_Link11	1	2	1
B2_SM-AFTDB_Link60	1	3	1
B2_SM-AFTDL_Link36	1	4	1
B2_SM-AFTDM_Link35	1	5	1
B2_SM-AFTDN_Link76	1	6	1
B2_SM-AFTDX_Link22	1	7	1
B2_SM-AFTDY_Link43	1	8	1
Etc.

Metric Boundaries (file optional - if no file put in a dummy file name)
Has the metric, the minimum value on the plot, the maximum value on the plot, and whether or not to plot the metric on a heatmap. If there is no file, min and max values are taken from the data and all metrics in the metrics file are plotted on the heatmap.
Metric	MinValue	MaxValue	Whether to plot (0=No,1=yes)
Total Reads	0	1000000	1
% rRNA	0	1	0


This is the output from the Matlab compiler.

MATLAB Compiler

1. Prerequisites for Deployment 

. Verify the MATLAB Compiler Runtime (MCR) is installed and ensure you    
  have installed version 8.1 (R2013a).   

. If the MCR is not installed, do the following:
  (1) enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MCR Installer.

  (2) run the MCR Installer.

Or download the Linux 64-bit version of the MCR for R2013a 
from the MathWorks Web site by navigating to

   http://www.mathworks.com/products/compiler/mcr/index.html
   
   
For more information about the MCR and the MCR Installer, see 
Distribution to End Users in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.    


2. Files to Deploy and Package

Files to package for Standalone 
================================
-MakePlateReport 
-run_MakePlateReport.sh (shell script for temporarily setting environment variables and 
                         executing the application)
   -to run the shell script, type
   
       ./run_MakePlateReport.sh <mcr_directory> <argument_list>
       
    at Linux or Mac command prompt. <mcr_directory> is the directory 
    where version 8.1 of MCR is installed or the directory where 
    MATLAB is installed on the machine. <argument_list> is all the 
    arguments you want to pass to your application. For example, 

    If you have version 8.1 of the MCR installed in 
    /mathworks/home/application/v81, run the shell script as:
    
       ./run_MakePlateReport.sh /mathworks/home/application/v81
       
    If you have MATLAB installed in /mathworks/devel/application/matlab, 
    run the shell script as:
    
       ./run_MakePlateReport.sh /mathworks/devel/application/matlab
-MCRInstaller.zip
   -if end users are unable to download the MCR using the above  
    link, include it when building your component by clicking 
    the "Add MCR" link in the Deployment Tool
-This readme file 

3. Definitions

For information on deployment terminology, go to 
http://www.mathworks.com/help. Select MATLAB Compiler >   
Getting Started > About Application Deployment > 
Application Deployment Terms in the MathWorks Documentation 
Center.


4. Appendix 

A. Linux x86-64 systems:
   On the target machine, add the MCR directory to the environment variable 
   LD_LIBRARY_PATH by issuing the following commands:

        NOTE: <mcr_root> is the directory where MCR is installed
              on the target machine.         

            setenv LD_LIBRARY_PATH
                $LD_LIBRARY_PATH:
                <mcr_root>/v81/runtime/glnxa64:
                <mcr_root>/v81/bin/glnxa64:
                <mcr_root>/v81/sys/os/glnxa64:
                <mcr_root>/v81/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:
                <mcr_root>/v81/sys/java/jre/glnxa64/jre/lib/amd64/server:
                <mcr_root>/v81/sys/java/jre/glnxa64/jre/lib/amd64 
            setenv XAPPLRESDIR <mcr_root>/v81/X11/app-defaults

   For more detail information about setting MCR paths, see Distribution to End Users in 
   the MATLAB Compiler documentation in the MathWorks Documentation Center.


     
        NOTE: To make these changes persistent after logout on Linux 
              or Mac machines, modify the .cshrc file to include this  
              setenv command.
        NOTE: The environment variable syntax utilizes forward 
              slashes (/), delimited by colons (:).  
        NOTE: When deploying standalone applications, it is possible 
              to run the shell script file run_MakePlateReport.sh 
              instead of setting environment variables. See 
              section 2 "Files to Deploy and Package".    






