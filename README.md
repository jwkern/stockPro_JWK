!WARNING! Update underway from March 7th - March 8th.....non-functional during this time
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
# stockPro_R

___________________________________________________________________________________________________________________________________________________________________
GENERAL DESCRIPTION:
This R program consists of four scripts that load, inspect, and analyze historic stock prices.   
___________________________________________________________________________________________________________________________________________________________________
DATA DESCRIPTION:
The data are imported from the Yahoo! historic stock data repository using the R package, quantmod. It imports as XTS data which is then set up in a typical R data frame. 
The data columns are: 

    Date=index(dataXTS),
    Open=dataXTS$Open,
    Close=dataXTS$Close,
    High=dataXTS$High, 
    Low=dataXTS$Low)


___________________________________________________________________________________________________________________________________________________________________
CODE DESCRIPTION:
The R code stockPro_JWK.r is effectively a batch file that calls the other scripts in a specific order: 1-load the data, 2-calculate the max profit, 3-analyze and calc. resistance
and support bands, then 4-plotting the results. Rolling averages are set at short (7 days) and long (100 days) intervals, price gradients span 14 days, and the resistance and support bands are calculated using the previous days closing values. 



___________________________________________________________________________________________________________________________________________________________________
RUNNING THE CODE:
1) Download the list of stocks to analyze (nasdaq100.csv), and all of the .r files. 

2) In a terminal, cd into the directory that now contains the .csv list and the .r scripts

3) In stockPro_JWK.r, change the file path on line 27 and 96-106 from "/home/jwkern/..." to point to your local directory containing the files 

4) Run the script in R Studio by either:
4.1) Opening the file stockPro_JWK.r script and clicking the "Source" button in the top right corner of the window
   or
4.2) Highlighting all of the code and clicking "Run"
   or
4.3) using the console window command line to type:

            source("~/R/General/stockPro_JWK.r")
   
   P.S. change the source string to the directory path containing the R script on your local machine

___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
