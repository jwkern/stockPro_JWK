#This batch of programs will calculate the investment potential of a particular stock 
#symbol using yahoo finance data and resistance and support bands as investment conditions
#
#Written by: Joshua W. Kern
#Date: 01/23/24


#Updates: sequential stock symbols have no resistance and support bands plotted  - NEEDS FIXED!
#
#
#

################################### Import libraries ######################################


#install.packages("tidyverse")
#install.packages("quantmod")
#install.packages("gridExtra")

#library(tidyverse)
#library(quantmod)
#library(gridExtra)



############################# IDENTIFY STOCK SYMBOLS ######################################
file <- '/home/jwkern/R/StockPro/Data/nasdaq100.csv'
dataFrame <- read.csv(file)
tickers <- dataFrame[1:2,2]

totalTrades <- 0
totalPrice <- c(1:length(dataFrame[,1]))
totalRatio <- totalPrice
holdRatio <- totalPrice
ratio <- totalPrice
totalPrice[] <- NA
totalRatio[] <- NA
holdRatio[] <- NA
ratio[] <- NA

limitFrame <- data.frame(Tickers = tickers,
                         ResistanceLimit = c(1:length(tickers)),
                          SupportLimit = c(1:length(tickers)), 
                          Profits = c(1:length(tickers)))

      
totalInvest <- 4000                         #initial investment ($)

invest <- totalInvest/length(tickers)       #initial ind. stock investment ($)


tickersOpen <- c(1:length(tickers))
finalProfits <- c(1:length(tickers))
finalProfits[] <- 0

finalProfitsNYSE <- data.frame(Tickers = tickers, 
                               Profits = finalProfits)
                             
zRange <- (1:length(tickers))

for (z in zRange) {
  tickersOpen[z] <- gsub(" ","",paste(tickers[z],".Open"))
}

  for (z in zRange) {
    tryCatch(
      {
      resistanceLimit <- limitFrame[z,2]
      supportLimit <- limitFrame[z,3]  
      stock_data <- new.env()
      
      dateBeginData <- Sys.Date()-(10*365) #readline(prompt = "Investment Date: ")
      dateBegin <- Sys.Date()-(2*365)#(t-1)*365 + 1)
      dateEnd <- Sys.Date()-((0)*365)    #last date to end analysis
      
    
      getSymbols(tickers[z], src = 'yahoo', env = stock_data, from = dateBeginData, to = dateEnd)
    
      
      ############################# SETUP DATA FRAME ############################################
      dataXTS <- stock_data[[tickers[z]]]
      colnames(dataXTS) <- c("Open","High","Low","Close","Volume","Adjusted")
      
      
      dataFrame <- data.frame(Date=index(dataXTS),
                              Open=dataXTS$Open,
                              Close=dataXTS$Close,
                              High=dataXTS$High, 
                              Low=dataXTS$Low)
      

      
      ########################## RUN PROGRAMS ##################################################
      suppressWarnings({
        #Sys.sleep(1)
        print("Running loadStockData_JWK.r")
        source("~/R/StockPro/loadStockData_JWK.r")
        #Sys.sleep(1)
        print("Running maxStockData_JWK.r")
        source("~/R/StockPro/maxStockData_JWK.r")
        #Sys.sleep(1)
        print("Running analyzeStockData_JWK.r")
        source("~/R/StockPro/analyzeStockData_JWK.r")
        #Sys.sleep(1)
        print("Running plotInvestmentResults_JWK.r")
        source("~/R/StockPro/plotInvestmentResults_JWK.r")
      })
      
      finalProfitsNYSE[z,2] <- finalProfit
        },
      error = function(cond) {
        message(paste("Symbol does not seem to exist:", tickers[z]))
        message("Here's the original error message:")
        message(conditionMessage(cond))
        # Choose a return value in case of error
      },
      warning = function(cond) {
        message(paste("Symbol caused a warning:", tickers[z]))
        message("Here's the original warning message:")
        message(conditionMessage(cond))
        # Choose a return value in case of warning
        NULL
      },
      finally = {
        # NOTE:
        # Here goes everything that should be executed at the end,
        # regardless of success or error.
        # If you want more than one expression to be executed, then you
        # need to wrap them in curly brackets ({...}); otherwise you could
        # just have written 'finally = <expression>' 
        message(paste("Processed symbol:", tickers[z]))
        message("Moving on ....")
      }
    )
  } 
    sumProfit <- sum(finalProfits) + totalInvest
    
    print(paste("Initial Investment: ", totalInvest))
    print(paste("Final Return: ", sumProfit))
    print("----------------------------------------------")
    print(paste("------------- ANALYSIS COMPLETE --------------"))
    print("______________________________________________")


#write.csv(list(finalProfitsNYSE), "/home/jwkern/Downloads/nasdaq100_profits_JWK.csv", row.names=TRUE)


#########################################################################################
######################################### THE END #######################################
#########################################################################################