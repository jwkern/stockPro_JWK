# This short script outputs the stock data for a user-specified length of time
#(e.g. 1d, 5d, 1mo, 3mo, 6mo, 1y, 2y, 5y, 10y, ytd, and max)
#
#Written by Joshua W. Kern
#Date: 03/07/24
#

######################### Just do the thing ##############################
import yfinance as yahooFinance

ticker = "META"
stock = yahooFinance.Ticker(ticker)
stock.history(period="6mo").to_csv(f"stockData_{ticker}.csv")
