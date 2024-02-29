# This program reads-in a .csv file as a dataFrame and creates a running average
# of the data in the modelFrame
#
#Written by Joshua W. Kern
#Date: 01/20/24 - read-in stock data and create running avg
#
##########################################################################################
########################## Step 1: Import libraries ######################################
##########################################################################################


#install.packages("tidyverse")
#install.packages("gridExtra")
#install.packages("quantmod")

#library(tidyverse)
#library(gridExtra)
#library(quantmod)








##########################################################################################
########################## Step 2: Load/Setup Data Frames ################################
##########################################################################################
#file <- readline(prompt = "Please type the filename: ")
#file <- gsub(" ","",paste('/home/jwkern/R/StockPro/Data/',file))
#dataFrame <- read.csv(file)
modelFrame <- data.frame(as.Date(dataFrame[,1]),c(1:length(dataFrame[,1])),c(1:length(dataFrame[,1])))
colnames(modelFrame) <- c("Date","AvgRangeSh","AvgRangeLg")



######################### Initialize variables ###########################################


gradRange <- 14                           #number of days to calc. gradient
avgRangeSh <-7                            #number of days to calc. running avg.
avgRangeLg <-100                           #number of days to calc. running avg.

colorSh <- 'red'                          #color for short running avg.
colorLg <- 'blue'                         #color for long running avg.

dataFrame[1] <- as.Date(dataFrame[,1])    #convert dates in data frames 

jRange <- c(200:length(modelFrame[,1]))
######################### Rolling Average (short) ########################################
for (j in jRange){
  modelFrame[j,2] <- sum(dataFrame[(j-avgRangeSh):j,2])/length(dataFrame[(j-avgRangeSh):j,2])
}
#modelFrame[(j-avgRangeSh):j,2] <- NA


######################### Rolling Average (long) #########################################
for (j in jRange){
  modelFrame[j,3] <- sum(dataFrame[(j-avgRangeLg):j,3])/length(dataFrame[(j-avgRangeLg):j,3])
}
#modelFrame[(j-avgRangeLg+1):j,3] <- NA



########################## Residuals #####################################################
modelFrame[4] <- dataFrame[,2] - modelFrame[,2]
modelFrame[5] <- dataFrame[,2] - modelFrame[,3]
modelFrame[6] <- modelFrame[,5] - modelFrame[,4]
colnames(modelFrame)[4] <- "ResidualSh"
colnames(modelFrame)[5] <- "ResidualLg"
colnames(modelFrame)[6] <- "ResidualLgOnly"

stddev <- c(1:length(modelFrame[,1]))
stddev[] <- 0
grad <- stddev
grad[] <- 0
for (j in jRange){
  stddev[j] <- sd(dataFrame[(j-avgRangeLg):j,2])
  grad[j] <- modelFrame[j,2] - modelFrame[(j-gradRange),2]
}

modelFrame[7] <- stddev[]
modelFrame[8] <- grad[]
colnames(modelFrame)[7] <- "Stddev"
colnames(modelFrame)[8] <- "Grad"

modelFrame[9] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[9] <- "Zeros"
modelFrame[,9] <- 0

modelFrame[10] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[10] <- "Owned"

modelFrame[11] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[11] <- "TotalPrice"

modelFrame[12] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[12] <- "TotalRatio"

modelFrame[13] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[13] <- "Resistance"

modelFrame[14] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[14] <- "Support"

modelFrame[15] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[15] <- "Pivot"

modelFrame[16] <- c(1:length(modelFrame[,1]))
colnames(modelFrame)[16] <- "SplineResistance"

num2 <- which(dataFrame[,1] == dateBegin)

#while (num2 == 0) {
#  dateBegin <- dateBegin + 1
#  num2 <- which(dataFrame[,1] == dateBegin)
#  }

num3 <- length(dataFrame[,1])

gradUp <- length(which(modelFrame[num2:num3,8] > 0))
gradDown <- length(which(modelFrame[num2:num3,8] < 0))


gradUpPerc <- gradUp/length(modelFrame[num2:num3,8])*100
gradDownPerc <- gradDown/length(modelFrame[num2:num3,8])*100



##########################################################################################
########################## Step 3: Plot the Data #########################################
##########################################################################################
p1 <- ggplot2::ggplot() + 
  geom_line(data = dataFrame, 
            aes(x = Date, y = Open)
  ) + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = AvgRangeSh),
            color = colorSh
  ) +
  annotate("text",
           label = c("Bin Size:                     ", as.character(avgRangeSh)),
           x = dateBegin + 200,
           y = max(dataFrame[num2:num3,2])-0.1*max(dataFrame[num2:num3,2]),
           color = colorSh
  ) +
  geom_line(data = modelFrame, 
            aes(x = Date, y = AvgRangeLg),
            color = colorLg
  ) +
  annotate("text",
           label = c("Bin Size:                     ", as.character(avgRangeLg)),
           x = dateBegin + 200, 
           y = max(dataFrame[num2:num3,2])-0.2*max(dataFrame[num2:num3,2]), 
           color = colorLg
  ) +
  xlim(dateBegin, dateEnd) +
  ylim(0,max(dataFrame[num2:num3,2])) +
  xlab("Date") + 
  ylab("Stock Value ($)") 


p2 <- ggplot2::ggplot() + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = Stddev)
  ) + 
  annotate("text",
           label = c("Bin Size:                     ", as.character(avgRangeLg)), 
           x = dateBegin + 200, 
           y = (max(stddev) + 2.5), 
           color = colorLg
  ) +
  xlim(dateBegin, dateEnd) +
  ylim(0,max(stddev)+5) +
  xlab("Date") + 
  ylab("Standard Deviation") 


p3 <- ggplot2::ggplot() + 
  geom_line(data = modelFrame, 
            aes(x = Date, y = Grad)
  ) +
  annotate("text",label = c("Bin Size:                     ", as.character(gradRange)), 
           x = dateBegin + 200, 
           y = (max(grad) + 2.5)
  ) +
  annotate("text",label = paste("Gain Days:", as.character(round(gradUpPerc,2)),"%"), 
           x = dateEnd - 150, 
           y = (max(grad) + 2.5),
           color = 'green'
  ) +
  annotate("text",label = paste("Loss Days:", as.character(round(gradDownPerc,2)),"%"), 
           x = dateEnd - 150, 
           y = (max(grad) - 7.5),
           color = 'red'
  ) +
  xlim(dateBegin, dateEnd) +
  ylim(-max(grad) + 2.5, max(grad) + 7.5) +
  xlab("Date") + 
  ylab("Gradient") 




grid.arrange(p1, p2, p3, nrow = 3, ncol = 1)


##########################################################################################
######################################## THE END #########################################
##########################################################################################
