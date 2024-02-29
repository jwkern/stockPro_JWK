# This uses the output from loadStockData_JWK.R to analyze the stock data 
# and determine the resistance and support bands 
#
#Written by Joshua W. Kern
#Date: 01/22/24 - analyzes the stocks
#
##########################################################################################
########################## Step 1: Import libraries ######################################
##########################################################################################


#install.packages("tidyverse")
#install.packages("gridExtra")

#library(tidyverse)
#library(gridExtra)



##########################################################################################
########################## Step 2: Load/Setup Arrays #####################################
##########################################################################################

resistance <- modelFrame[,13]
support <- modelFrame[,14]
pivot <- modelFrame[,15]

resistance[] <- dataFrame[,2]
support[] <- dataFrame[,2]
pivot[] <- dataFrame[,2]




invest <- as.double(invest)
dateBegin <- dateBegin                    #first date to begin analysis; should remain the same
dateEnd <- dateEnd                        #last date to end analysis; should remain the same



ansKey <- c(1:length(modelFrame[,1]))
ansKey[] <- 'n'


totalTrades <- 0
totalPrice <- c(1:length(dataFrame[,1]))
totalRatio <- totalPrice
holdRatio <- totalPrice
ratio <- totalPrice
totalPrice[] <- NA
totalRatio[] <- NA
holdRatio[] <- NA
ratio[] <- NA



index <- which(dataFrame[,1] == dateBegin)
###################################################################
############################# Step 3: Analyze Stocks #####################################
##########################################################################################
iRange <- c((index):(length(modelFrame[,1])))

totalPrice[iRange[1]] <- invest
totalRatio[iRange[1]] <- 1.0
totalRatio[iRange[1]-1] <- 1.0
holdRatio[iRange[1]] <- 1.0
ratio[iRange[1]] <- 1.0

#big loop
for (i in iRange){
  pivot[(i-1)] <- (dataFrame[(i-1),4] + dataFrame[(i-1),5] + dataFrame[(i-1),3])/3
  resistance[(i-1)] <- resistanceLimit*((2*pivot[(i-1)]) - dataFrame[(i-1),5])
  support[(i-1)] <- supportLimit*((2*pivot[(i-1)]) - dataFrame[(i-1),4])
  ratio[i] <- dataFrame[i,2]/dataFrame[(i-1),2]
  
  modelFrame[(i-1),13] <- resistance[(i-1)]
  modelFrame[(i-1),14] <- support[(i-1)]
  modelFrame[(i-1),15] <- pivot[(i-1)]
 
  ######################## Resistance and Support Smoothing (Pending) ###################
  #n <- (i-1)
  #dat <- data.frame(
  #  x = iRange[1]:n,
  #  y = modelFrame[iRange[1]:(i-1),13]
  #)
  
  #splineResistance <- data.frame(
  #  x = iRange[1]:n,
  #  y = predict(loess(y~x, dat, span = 0.1)),
  #  method = "loess()"
  #)

  
  #n <- (i-1)
  #dat <- data.frame(
  #  x = iRange[1]:n,
  #  y = modelFrame[iRange[1]:(i-1),14]
  #)
  
  #splineSupport <- data.frame(
  #  x = iRange[1]:n,
  #  y = predict(loess(y~x, dat, span = 0.1)),
  #  method = "loess()"
  #)
    #for(var in c(1:100)){
    # splineResistance <- smooth(modelFrame[index:(i-1),13], endrule = "Tukey", do.ends = TRUE)
  #  splineResistance[] <- splineResistance[]
  #}
  #modelFrame[(i-1),13] <- splineResistance[(i-1),2] 
  #for(var in c(1:100)){
    #splineSupport <- smooth(modelFrame[index:(i-1),14], endrule = "Tukey", do.ends = TRUE)
    #splineSupport[] <- splineSupport[]
  #}
  #modelFrame[(i-1),14] <- splineSupport[(i-1),2]
  
  #######################################################################################
  ############################## INVESTMENT CONDITIONS ##################################
  #######################################################################################
  
  if(dataFrame[(i),2] < (modelFrame[(i-1),14])) ans <- "y" else ans <- ans
  if(dataFrame[(i),2] > (modelFrame[(i-1),13])) ans <- "n" else ans <- ans
  
  
  
  #######################################################################################
  #######################################################################################
  ans <- as.character(ans)
  #print(paste("Original Open: ", dataFrame[iRange[1],2]))
  #print(paste("Current open: ", round(dataFrame[i,2],2)))
  #print(paste("Previous open: ", round(dataFrame[(i-1),2],2)))
  
  if(ans == "y" && ansKey[i-1] == "y"){
    totalRatio[i] <- totalRatio[i-1]*ratio[i] 
    #print("1")
  } else{
    
  }
  
  if(ans == "y" && ansKey[i-1] == "n"){
    totalRatio[i] <- totalRatio[i-1] 
    totalTrades <- totalTrades + 1
    #print("2")
  } else{
    
  }
  
  if(ans == "n" && ansKey[i-1] == "y"){
    totalRatio[i] <- totalRatio[i-1]*ratio[i] 
    totalTrades <- totalTrades + 1
    #print("3")
  } else{
    
  }
  
  if(ans == "n" && ansKey[i-1] == "n"){
    totalRatio[i] <- totalRatio[i-1]
    #print("4")
  } else{
    
  }
  
  if(ans == "y") ansKey[i] <- 'y' else ansKey[i] <- 'n'
  #if(ans == "y") 
  #print(paste("Current Ratio: ", round(ratio[i],3)))
  #print(paste("Owned (y/n): ", ansKey[i]))
  
  totalPrice[i] <- invest*totalRatio[i]
  finalPrice <- totalPrice[i]
  finalRatio <- totalRatio[i]
  holdRatio[i] <- dataFrame[i,2]/dataFrame[iRange[1],2]
  #print(paste("Hold Ratio: ", round(holdRatio[i],3)))
  #print(paste("Total Ratio: ", round(totalRatio[i],3)))
  #print(paste("Total Price: $",round(totalPrice[i],2)))
  
  p1 <- ggplot2::ggplot() + 
    geom_line(data = dataFrame, 
              aes(x = Date, y = Open)
    ) + 
    geom_line(data = modelFrame, 
              aes(x = Date, y = Resistance),
              color = colorSh
    ) +
    annotate("text",
             label = "Resistance",
             x = dateBegin + 20,
             y = max(dataFrame[num2:num3,2])-0.1*max(dataFrame[num2:num3,2]),
             color = colorSh
    ) +
    geom_line(data = modelFrame, 
              aes(x = Date, y = Support),
              color = colorLg
    ) +
    geom_line(data = modelFrame, 
              aes(x = Date, y = Pivot),
              color = 'yellow'
    ) +
    annotate("text",
             label = "Support",
             x = dateBegin + 20, 
             y = max(dataFrame[num2:num3,2])-0.15*max(dataFrame[num2:num3,2]), 
             color = colorLg
    ) +
    annotate("text",
             label = tickers[z],
             x = Sys.Date()-10, 
             y = max(dataFrame[num2:num3,2])-0*max(dataFrame[num2:num3,2]), 
             color = colorLg
    ) +
    xlim(dateBegin, dateEnd) +
    ylim(0,max(dataFrame[num2:num3,2])) +
    xlab("Date") + 
    ylab("Stock Value ($)") 
  
  #grid.arrange(p1, nrow = 1, ncol = 1)
  
  #Sys.sleep(1)
  #print(" ")
}

test <- c(1:length(ansKey))
test[] <- 0
total <- 0
total2 <- 0

for (j in c(2:length(ansKey))) {
  if(ansKey[j] == "n" & ansKey[j-1] == "y") test[j] <- 1
}
ansKey[which(test[] == '1')] <- "y"
for (j in c(2:length(ansKey))) {
  if(ansKey[j] == "y" & grad[j] > 0) total <- total + 1
  if(ansKey[j] == "y" & ansKey[j-1] == "n") total <- total - 1
  if(ansKey[j] == "y" & grad[j] < 0) total2 <- total2 + 1
  if(ansKey[j] == "n" & ansKey[j-1] == "y") total2 <- total2 + 1
}
total <- total/totalPosDays*100
total2 <- total2/totalNegDays*100

finalProfit <- finalPrice - invest
value <- dataFrame[num3,2]/dataFrame[num2,2]


#print(" ")
#print("----------------------------------------------")

print(paste("----------------", tickers[z], "SUMMARY ----------------"))

#print("----------------------------------------------")
#print(paste("Maximum Ratio: ", round(maxProfitRatio,2)))

print(paste("Hold Ratio: ", round(value,3)))
#print("----------------------------------------------")

print(paste("Total Trades: ", totalTrades))
print("----------------------------------------------")

#print(paste("Total Gain Efficiency: ", round(total,2), "%"))
#print(paste("Total Loss Efficiency: ", round(total2,2), "%"))

print(paste("Total Ratio: ", round(finalRatio,3)))
print(paste("Total Profit: $", round(finalProfit,2)))
print("----------------------------------------------")

#print("----------------------------------------------")
#print(" ")


finalProfits[z] <- round(finalProfit,2)





##########################################################################################
########################## Step 4: Plot the Data #########################################
##########################################################################################
p1 <- ggplot2::ggplot() + 
  geom_line(data = dataFrame, 
            aes(x = Date, y = Open)
  ) + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = Resistance),
            color = colorSh
  ) +
  annotate("text",
           label = "Resistance",
           x = dateBegin + 20,
           y = max(dataFrame[num2:num3,2])-0.1*max(dataFrame[num2:num3,2]),
           color = colorSh
  ) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = Support),
            color = colorLg
  ) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = Pivot),
            color = 'yellow'
  ) +
  annotate("text",
           label = "Support",
           x = dateBegin + 20, 
           y = max(dataFrame[num2:num3,2])-0.15*max(dataFrame[num2:num3,2]), 
           color = colorLg
  ) +
  annotate("text",
           label = tickers[z],
           x = Sys.Date()-10, 
           y = max(dataFrame[num2:num3,2])-0*max(dataFrame[num2:num3,2]), 
           color = colorLg
  ) +
  xlim(dateBegin, dateEnd) +
  ylim(0,max(dataFrame[num2:num3,2])) +
  xlab("Date") + 
  ylab("Stock Value ($)") 

grid.arrange(p1, nrow = 1, ncol = 1)

#ggplot(modelFrame, aes(Date,Resistance)) + geom_point() + geom_smooth()


##########################################################################################
######################################## THE END #########################################
##########################################################################################