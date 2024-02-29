# This uses the output from investStockData_JWK.R to plot when the stock 
# was owned, the investment, and investment ratio
#
#Written by Joshua W. Kern
#Date: 01/22/24 - plots the owned stocks and their results
#
##########################################################################################
########################## Step 1: Import libraries ######################################
##########################################################################################


#install.packages("tidyverse")
#install.packages("gridExtra")

#library(tidyverse)
#library(gridExtra)


##########################################################################################
########################## Step 2: Data visualization ####################################
##########################################################################################


##################### Plot where stock is owned ##########################################
test <- dataFrame[,2]
test[which(ansKey[] == 'n')] <- NA



modelFrame[10] <- test[]
#colnames(modelFrame)[10] <- "Owned"

#totalPrice[1:index] <- invest
modelFrame[11] <- totalPrice[]
#colnames(modelFrame)[11] <- "TotalPrice"

modelFrame[12] <- totalRatio[]
#colnames(modelFrame)[12] <- "TotalRatio"




p1 <- ggplot2::ggplot() + 
  geom_line(data = dataFrame, 
            aes(x = Date, y = Open)
  ) + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = Owned),
            color = 'green'
  ) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = Support),
            color = colorLg
  ) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = Resistance),
            color = colorSh
  ) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = Pivot),
            color = 'yellow'
  ) +
  annotate("text",label = tickers[z], x = as.Date("2023-12-01"), y = max(dataFrame[num2:num3,2]), color = 'blue'
  ) +
  xlim(dateBegin, dateEnd) +
  ylim(min(dataFrame[num2:num3,2]),max(dataFrame[num2:num3,2])) +
  xlab("Date") + 
  ylab("Stock Value ($)") 


p2 <- ggplot2::ggplot() + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = TotalPrice)
  ) + 
  xlim(dateBegin, dateEnd) +
  ylim(min(totalPrice[num2:num3]),max(totalPrice[num2:num3])) +
  xlab("Date") + 
  ylab("Total Investment ($)") 




p3 <- ggplot2::ggplot() + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = TotalRatio),
            color = 'red'
  ) + 
  geom_line(data = dataFrame, 
            aes(x = Date, y = holdRatio),
  ) +
  xlim(dateBegin, dateEnd) +
  ylim(min(holdRatio) - 0.35,(max(totalRatio) + max(holdRatio))/1.5) +
  xlab("Date") + 
  ylab("Ratio")

grid.arrange(p1, p2, p3, nrow = 3)



#write.csv(list(dataFrame,modelFrame), "/home/jwkern/Downloads/TGTX_JWK.csv", row.names=TRUE)



##########################################################################################
###################################### THE END ###########################################
##########################################################################################