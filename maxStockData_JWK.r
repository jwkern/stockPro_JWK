# This uses the output from loadStockData_JWK.R to choose when the stock 
# has increased in the past to give the maximum investment ratio
#
#Written by Joshua W. Kern
#Date: 01/20/24 - gives max investment ratio
#
##########################################################################################
########################## Step 1: Import libraries ######################################
##########################################################################################


#install.packages("tidyverse")
#install.packages("gridExtra")

#library(tidyverse)
#library(gridExtra)



##########################################################################################
########################## Step 2: Data Analysis #########################################
##########################################################################################

######################### Total Profit Estimate ##########################################
index <- which(dataFrame[,1] == dateBegin)


totalPrice <- c(1:length(dataFrame[,1]))
totalRatio <- totalPrice
ratio <- totalPrice
totalPrice[] <- NA
totalRatio[] <- NA
ratio[] <- NA




iRange <- c(index:(length(dataFrame[,1])-1))

ansKey <- c(1:length(modelFrame[,1]))
ansKey[] <- 'n'

for (i in iRange) {
  totalPrice[iRange[1]] <- invest
  totalRatio[iRange[1]] <- 1.0
  totalRatio[iRange[1]-1] <- 1.0
  holdRatio[iRange[1]] <- 1.0
  ratio[iRange[1]] <- 1.0

  ratio[i] <- dataFrame[i,2]/dataFrame[(i-1),2]
  #totalRatio <- totalRatio*ratio[i+1]
  #totalPrice[i+1] <- totalPrice[i]*dataFrame[i+1,2]/dataFrame[i,2]
  #print(ratio[i+1])
  #print(totalPrice[i+1])
  if (ratio[i] > 1.0) totalRatio[i] <- totalRatio[i-1]*ratio[i] else totalRatio[i] <- totalRatio[i-1]
  if (ratio[i] > 1.0) totalPrice[i] <- totalPrice[i-1]*ratio[i] else totalPrice[i] <- totalPrice[i-1]
  if (ratio[i] > 1.0) ans <- 'y' else ans <- 'n'
  ans <- as.character(ans)
  ansKey[i] <- ans
  #print(totalRatio[i])
  
}






##########################################################################################
########################## Step 3: Data visualization ####################################
##########################################################################################
test <- c(1:length(ansKey))
test[] <- 0
#for (j in c(2:length(ansKey))) {
#  if(ansKey[j] == "y") test[j] <- 1
#}




num2 <- which(dataFrame[,1] == dateBegin)
num3 <- length(dataFrame[,1])

totalDays <- num3 - num2
total <- 0
total2 <- 0

for (j in c(num2:num3)) {
  #print(j)
  if(grad[j] > 0) total <- total + 1
  if(grad[j] < 0) total2 <- total2 + 1
}
totalPosDays <- total
totalNegDays <- total2

totalPosDaysPerc <- totalPosDays/totalDays*100
totalNegDaysPerc <- totalNegDays/totalDays*100

#print("------------------------------------------")
#print(paste("Total Days: ", totalDays))
#print(paste("Days w/ Gains: ", round(totalPosDaysPerc,2), "%"))
#print(paste("Days w/ Losses: ", round(totalNegDaysPerc,2),"%"))

for (i in c(2:length(ansKey))) {
  if(ansKey[i] == "n" & ansKey[i-1] == "y") test[i] <- 1
  #if(ansKey[i] == "y" & ansKey[i-1] == "n") test[i-1] <- 1
}
ansKey[which(test[] == '1')] <- "y"
##################### Plot where stock is owned ##########################################
modelFrame[9] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[9] <- "Zeros"
modelFrame[,9] <- 0


test <- dataFrame[,2]
test[which(ansKey[] == 'n')] <- NA

modelFrame[10] <- test[]
colnames(modelFrame)[10] <- "Owned"

#totalPrice[1:index] <- invest
modelFrame[11] <- totalPrice[]
colnames(modelFrame)[11] <- "TotalPrice"

modelFrame[12] <- totalRatio[]
colnames(modelFrame)[12] <- "TotalRatio"

maxProfitRatio <- totalRatio[length(totalRatio)-1]



p1 <- ggplot2::ggplot() + 
  geom_line(data = dataFrame, 
            aes(x = Date, y = Open)
  ) + 
  #geom_line(data = modelFrame, 
  #          aes(x = Date, y = AvgRange50),
  #          color = 'blue'
  #) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = Owned),
            color = 'red'
  ) +
  #annotate("text",label = c("Bin Size:                     ", as.character(avgRange50)), x = as.Date("2020-08-15"), y = 350, color = 'blue'
  #) +
  xlim(dateBegin, dateEnd) +
  ylim(0,max(dataFrame[num2:num3,2])) +
  xlab("Date") + 
  ylab("Stock Value ($)") 


p2 <- ggplot2::ggplot() + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = TotalPrice)
  ) + 
  xlim(dateBegin, dateEnd) +
  ylim(min(totalPrice),max(totalPrice)) +
  xlab("Date") + 
  ylab("Total Investment ($)") 

p3 <- ggplot2::ggplot() + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = TotalRatio),
            color = 'red'
  ) + 
  xlim(dateBegin, dateEnd) +
  ylim(min(holdRatio) - 0.35,(max(totalRatio) + max(holdRatio))/1.5) +
  xlab("Date") + 
  ylab("Ratio")

grid.arrange(p1, p2, p3, nrow = 3)


##########################################################################################
########################## THE END #######################################################
##########################################################################################



