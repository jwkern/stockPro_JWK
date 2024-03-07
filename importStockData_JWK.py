# This short script outputs the stock data for a user-specified length of time
#(e.g. 1d, 5d, 1mo, 3mo, 6mo, 1y, 2y, 5y, 10y, ytd, and max)
#
#Written by Joshua W. Kern
#Date: 03/07/24
#


import yfinance as yahooFinance
import csv


###########################Import ticker list##################################
tickerData = open('/home/jwkern/Downloads/nasdaq100.csv')
tickerData=csv.reader(tickerData)
rows=[]
for row in tickerData:
    rows.append(row)

tickerList=[]

for i in range(1,len(rows)):
    tickerList.append(rows[i][1])


##########################3## Get the data ####################################
ticker = tickerList[0]
stock = yahooFinance.Ticker(ticker)
stock.history(period="6mo").to_csv(f"stockData_{ticker}.csv")
